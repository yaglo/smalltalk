//
//  SmalltalkSocketServer.m
//  Smalltalk
//
//  Created by Stanislav Yaglo on 05.03.13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "SmalltalkSocketServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif
#import "SmalltalkSocketResponseHandler.h"

#define HTTP_SERVER_PORT 8081

NSString * const STSocketServerNotificationStateChanged = @"ServerNotificationStateChanged";

//
// Internal methods and properties:
//	The "lastError" and "state" are only writable by the server itself.
//
@interface SmalltalkSocketServer ()
@property (nonatomic, readwrite, retain) NSError *lastError;
@property (readwrite, assign) STSocketServerState state;
@end

@implementation SmalltalkSocketServer

@synthesize lastError;
@synthesize state;

+ (SmalltalkSocketServer *)sharedServer
{
    static id sharedServer = nil;
    if (!sharedServer)
        sharedServer = [[SmalltalkSocketServer alloc] init];
    return sharedServer;
}

//
// init
//
// Set the initial state and allocate the responseHandlers and incomingRequests
// collections.
//
// returns the initialized server object.
//
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.state = SERVER_STATE_IDLE;
		responseHandlers = [[NSMutableSet alloc] init];
		incomingRequests =
        CFDictionaryCreateMutable(
                                  kCFAllocatorDefault,
                                  0,
                                  &kCFTypeDictionaryKeyCallBacks,
                                  &kCFTypeDictionaryValueCallBacks);
	}
	return self;
}

//
// setLastError:
//
// Custom setter method. Stops the server and
//
// Parameters:
//    anError - the new error value (nil to clear)
//
- (void)setLastError:(NSError *)anError
{
	[anError retain];
	[lastError release];
	lastError = anError;
	
	if (lastError == nil)
	{
		return;
	}
	
	[self stop];
	
	self.state = SERVER_STATE_IDLE;
	NSLog(@"STSocketServer error: %@", self.lastError);
}

//
// errorWithName:
//
// Stops the server and sets the last error to "errorName", localized using the
// STSocketServerErrors.strings file (if present).
//
// Parameters:
//    errorName - the description used for the error
//
- (void)errorWithName:(NSString *)errorName
{
	self.lastError = [NSError
                      errorWithDomain:@"STSocketServerError"
                      code:0
                      userInfo:
                      [NSDictionary dictionaryWithObject:
                       NSLocalizedStringFromTable(
                                                  errorName,
                                                  @"",
                                                  @"STSocketServerErrors")
                                                  forKey:NSLocalizedDescriptionKey]];
}

//
// setState:
//
// Changes the server state and posts a notification (if the state changes).
//
// Parameters:
//    newState - the new state for the server
//
- (void)setState:(STSocketServerState)newState
{
	if (state == newState)
	{
		return;
	}
    
	state = newState;
	
	[[NSNotificationCenter defaultCenter]
     postNotificationName:STSocketServerNotificationStateChanged
     object:self];
}

//
// start
//
// Creates the socket and starts listening for connections on it.
//
- (void)start
{
	self.lastError = nil;
	self.state = SERVER_STATE_STARTING;
    
	socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM,
                            IPPROTO_TCP, 0, NULL, NULL);
	if (!socket)
	{
		[self errorWithName:@"Unable to create socket."];
		return;
	}
    
	int reuse = true;
	int fileDescriptor = CFSocketGetNative(socket);
	if (setsockopt(fileDescriptor, SOL_SOCKET, SO_REUSEADDR,
                   (void *)&reuse, sizeof(int)) != 0)
	{
		[self errorWithName:@"Unable to set socket options."];
		return;
	}
	
	struct sockaddr_in address;
	memset(&address, 0, sizeof(address));
	address.sin_len = sizeof(address);
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(HTTP_SERVER_PORT);
	CFDataRef addressData =
    CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));
	[(id)addressData autorelease];
	
	if (CFSocketSetAddress(socket, addressData) != kCFSocketSuccess)
	{
		[self errorWithName:@"Unable to bind socket to address."];
		return;
	}
    
	listeningHandle = [[NSFileHandle alloc]
                       initWithFileDescriptor:fileDescriptor
                       closeOnDealloc:YES];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(receiveIncomingConnectionNotification:)
     name:NSFileHandleConnectionAcceptedNotification
     object:nil];
	[listeningHandle acceptConnectionInBackgroundAndNotify];
	
	self.state = SERVER_STATE_RUNNING;
}

//
// stopReceivingForFileHandle:close:
//
// If a file handle is accumulating the header for a new connection, this
// method will close the handle, stop listening to it and release the
// accumulated memory.
//
// Parameters:
//    incomingFileHandle - the file handle for the incoming request
//    closeFileHandle - if YES, the file handle will be closed, if no it is
//		assumed that an STSocketResponseHandler will close it when done.
//
- (void)stopReceivingForFileHandle:(NSFileHandle *)incomingFileHandle
                             close:(BOOL)closeFileHandle
{
	if (closeFileHandle)
	{
		[incomingFileHandle closeFile];
	}
	
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NSFileHandleDataAvailableNotification
     object:incomingFileHandle];
	CFDictionaryRemoveValue(incomingRequests, incomingFileHandle);
}

//
// stop
//
// Stops the server.
//
- (void)stop
{
	self.state = SERVER_STATE_STOPPING;
    
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NSFileHandleConnectionAcceptedNotification
     object:nil];
    
	[responseHandlers removeAllObjects];
    
	[listeningHandle closeFile];
	[listeningHandle release];
	listeningHandle = nil;
	
	for (NSFileHandle *incomingFileHandle in
         [[(NSDictionary *)incomingRequests copy] autorelease])
	{
		[self stopReceivingForFileHandle:incomingFileHandle close:YES];
	}
	
	if (socket)
	{
		CFSocketInvalidate(socket);
		CFRelease(socket);
		socket = nil;
	}
    
	self.state = SERVER_STATE_IDLE;
}

//
// receiveIncomingConnectionNotification:
//
// Receive the notification for a new incoming request. This method starts
// receiving data from the incoming request's file handle and creates a
// new CFHTTPMessageRef to store the incoming data..
//
// Parameters:
//    notification - the new connection notification
//
- (void)receiveIncomingConnectionNotification:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSFileHandle *incomingFileHandle =
    [userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
    
    if(incomingFileHandle)
	{
		CFDictionaryAddValue(
                             incomingRequests,
                             incomingFileHandle,
                             [(id)CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE) autorelease]);
		
		[[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(receiveIncomingDataNotification:)
         name:NSFileHandleDataAvailableNotification
         object:incomingFileHandle];
		
        [incomingFileHandle waitForDataInBackgroundAndNotify];
    }
    
	[listeningHandle acceptConnectionInBackgroundAndNotify];
}

//
// receiveIncomingDataNotification:
//
// Receive new data for an incoming connection.
//
// Once enough data is received to fully parse the HTTP headers,
// a STSocketResponseHandler will be spawned to generate a response.
//
// Parameters:
//    notification - data received notification
//
- (void)receiveIncomingDataNotification:(NSNotification *)notification
{
	NSFileHandle *incomingFileHandle = [notification object];
	NSData *data = [incomingFileHandle availableData];
	
	if ([data length] == 0)
	{
		[self stopReceivingForFileHandle:incomingFileHandle close:NO];
		return;
	}
    
	CFHTTPMessageRef incomingRequest =
    (CFHTTPMessageRef)CFDictionaryGetValue(incomingRequests, incomingFileHandle);
	if (!incomingRequest)
	{
		[self stopReceivingForFileHandle:incomingFileHandle close:YES];
		return;
	}
	
	if (!CFHTTPMessageAppendBytes(
                                  incomingRequest,
                                  [data bytes],
                                  [data length]))
	{
		[self stopReceivingForFileHandle:incomingFileHandle close:YES];
		return;
	}
    
	if(CFHTTPMessageIsHeaderComplete(incomingRequest))
	{
		SmalltalkSocketResponseHandler *handler =
        [SmalltalkSocketResponseHandler
         handlerForRequest:incomingRequest
         fileHandle:incomingFileHandle
         server:self];
		
		[responseHandlers addObject:handler];
		[self stopReceivingForFileHandle:incomingFileHandle close:NO];
        
		[handler startResponse];	
		return;
	}
    
	[incomingFileHandle waitForDataInBackgroundAndNotify];
}

//
// closeHandler:
//
// Shuts down a response handler and removes it from the set of handlers.
//
// Parameters:
//    aHandler - the handler to shut down.
//
- (void)closeHandler:(SmalltalkSocketResponseHandler *)aHandler
{
	[aHandler endResponse];
	[responseHandlers removeObject:aHandler];
}

@end
