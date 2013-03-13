//
//  STSocketResponseHandler.m
//  Smalltalk
//
//  Created by Stanislav Yaglo on 05.03.13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "STSocketResponseHandler.h"
#import "STSocketServer.h"

#import "SmalltalkClass.h"
#import "SmalltalkMethod.h"
#import "SmalltalkVM.h"

@interface NSURL (SYBasicKeyValueParsing)
- (NSDictionary *)sy_keysAndValuesOfString:(NSString *)string;
- (NSDictionary *)sy_keysAndValuesOfFragment;
- (NSDictionary *)sy_keysAndValuesOfQuery;
@end

@implementation NSURL (SYBasicKeyValueParsing)

//- (NSDictionary *)sy_keysAndValuesOfString:(NSString *)string
//{
//	if (!string) return nil;
//    
//	NSMutableDictionary *result = [NSMutableDictionary dictionary];
//    
//	for (NSString *pair in [string componentsSeparatedByString:@"&"]) {
//		NSArray *keyAndValue = [pair componentsSeparatedByString:@"="];
//
//		if ([keyAndValue count] == 2) {
//			NSString *value = [keyAndValue objectAtIndex:1];
//			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//			[result setObject:value forKey:[keyAndValue objectAtIndex:0]];
//		}
//	}
//	return [[result copy] autorelease];
//}

// Returns a dictionary of a string in format key=value&key=value
- (NSDictionary *)sy_keysAndValuesOfString:(NSString *)string
{
	if ([string length] == 0)
		return nil;

	NSCharacterSet *ampEqualSet = [NSCharacterSet characterSetWithCharactersInString:@"&="];
	NSArray *pairs = [string componentsSeparatedByCharactersInSet:ampEqualSet];

	__block NSMutableArray *keys = [[NSMutableArray alloc] init];
	__block NSMutableArray *objects = [[NSMutableArray alloc] init];
	[pairs enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop __unused) {
		obj = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		obj = [obj stringByReplacingOccurrencesOfString:@"+" withString:@" "];

		if (idx % 2 == 0)
			[keys addObject:obj];
		else
			[objects addObject:obj];
	}];
	if ([keys count] > [objects count])
		[keys removeLastObject];

	return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)sy_keysAndValuesOfFragment
{
	return [self sy_keysAndValuesOfString:[self fragment]];
}

- (NSDictionary *)sy_keysAndValuesOfQuery
{
    return [self sy_keysAndValuesOfString:[self query]];
}

@end

@implementation STSocketResponseHandler

static NSMutableArray *registeredHandlers = nil;

//
// priority
//
// The priority determines which request handlers are given the option to
// handle a request first. The highest number goes first, with the base class
// (STSocketResponseHandler) implementing a 501 error response at priority 0
// (the lowest priorty).
//
// Even if subclasses have a 0 priority, they will always receive precedence
// over the base class, since the base class' implementation is intended as
// an error condition only.
//
// returns the priority.
//
+ (NSUInteger)priority
{
	return 0;
}

//
// load
//
// Implementing the load method and invoking
// [STSocketResponseHandler registerHandler:self] causes STSocketResponseHandler
// to register this class in the list of registered HTTP response handlers.
//
+ (void)load
{
	[STSocketResponseHandler registerHandler:self];
}

//
// registerHandler:
//
// Inserts the STSocketResponseHandler class into the priority list.
//
+ (void)registerHandler:(Class)handlerClass
{
	if (registeredHandlers == nil)
	{
		registeredHandlers = [[NSMutableArray alloc] init];
	}
	
	NSUInteger i;
	NSUInteger count = [registeredHandlers count];
	for (i = 0; i < count; i++)
	{
		if ([handlerClass priority] >= [[registeredHandlers objectAtIndex:i] priority])
		{
			break;
		}
	}
	[registeredHandlers insertObject:handlerClass atIndex:i];
}

//
// canHandleRequest:method:url:headerFields:
//
// Class method to determine if the response handler class can handle
// a given request.
//
// Parameters:
//    aRequest - the request
//    requestMethod - the request method
//    requestURL - the request URL
//    requestHeaderFields - the request headers
//
// returns YES (if the handler can handle the request), NO (otherwise)
//
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
                  method:(NSString *)requestMethod
                     url:(NSURL *)requestURL
            headerFields:(NSDictionary *)requestHeaderFields
{
	return YES;
}

//
// handlerClassForRequest:method:url:headerFields:
//
// Important method to edit for your application.
//
// This method determines (from the HTTP request message, URL and headers)
// which
//
// Parameters:
//    aRequest - the CFHTTPMessageRef, with data at least as far as the end
//		of the headers
//    requestMethod - the request method (GET, POST, PUT, DELETE etc)
//    requestURL - the URL (likely only contains a path)
//    requestHeaderFields - the parsed header fields
//
// returns the class to handle the request, or nil if no handler exists.
//
+ (Class)handlerClassForRequest:(CFHTTPMessageRef)aRequest method:(NSString *)requestMethod url:(NSURL *)requestURL headerFields:(NSDictionary *)requestHeaderFields
{
	for (Class handlerClass in registeredHandlers) {
		if ([handlerClass canHandleRequest:aRequest method:requestMethod url:requestURL headerFields:requestHeaderFields]) {
			return handlerClass;
		}
	}
	return nil;
}

//
// handleRequest:fileHandle:server:
//
// This method parses the request method and header components, invokes
//	+[handlerClassForRequest:method:url:headerFields:] to determine a handler
// class (if any) and creates the handler.
//
// Parameters:
//    aRequest - the CFHTTPMessageRef request requiring a response
//    requestFileHandle - the file handle for the incoming request (still
//		open and possibly receiving data) and for the outgoing response
//    aServer - the server that is invoking us
//
// returns the initialized handler (if one can handle the request) or nil
//	(if no valid handler exists).
//
+ (STSocketResponseHandler *)handlerForRequest:(CFHTTPMessageRef)aRequest
                                fileHandle:(NSFileHandle *)requestFileHandle
                                    server:(STSocketServer *)aServer
{
	NSDictionary *requestHeaderFields =
    [(NSDictionary *)CFHTTPMessageCopyAllHeaderFields(aRequest)
     autorelease];
	NSURL *requestURL =
    [(NSURL *)CFHTTPMessageCopyRequestURL(aRequest) autorelease];
	NSString *method =
    [(NSString *)CFHTTPMessageCopyRequestMethod(aRequest)
     autorelease];
    
	Class classForRequest =
    [self handlerClassForRequest:aRequest
                          method:method
                             url:requestURL
                    headerFields:requestHeaderFields];
	
	STSocketResponseHandler *handler =
    [[[classForRequest alloc]
      initWithRequest:aRequest
      method:method
      url:requestURL
      headerFields:requestHeaderFields
      fileHandle:requestFileHandle
      server:aServer]
     autorelease];
	
	return handler;
}

//
// initWithRequest:method:url:headerFields:fileHandle:server:
//
// Init method for the handler. This method is mostly just a value copy operation
// so that the parts of the request don't need to be reparsed.
//
// Parameters:
//    aRequest - the CFHTTPMessageRef
//    method - the request method
//    requestURL - the URL
//    requestHeaderFields - the CFHTTPMessageRef header fields
//    requestFileHandle - the incoming request file handle, also used for
//		the outgoing response.
//    aServer - the server that spawned us
//
// returns the initialized object
//
- (id)initWithRequest:(CFHTTPMessageRef)aRequest
               method:(NSString *)method
                  url:(NSURL *)requestURL
         headerFields:(NSDictionary *)requestHeaderFields
           fileHandle:(NSFileHandle *)requestFileHandle
               server:(STSocketServer *)aServer
{
	self = [super init];
	if (self != nil)
	{
		request = (CFHTTPMessageRef)[(id)aRequest retain];
		requestMethod = [method retain];
		url = [requestURL retain];
		headerFields = [requestHeaderFields retain];
		fileHandle = [requestFileHandle retain];
		server = [aServer retain];
        
		[[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(receiveIncomingDataNotification:)
         name:NSFileHandleDataAvailableNotification
         object:fileHandle];
        
		[fileHandle waitForDataInBackgroundAndNotify];
	}
	return self;
}

//
// startResponse
//
// Begin sending a response over the fileHandle. Trivial cases can
// synchronously return a response but everything else should spawn a thread
// or otherwise asynchronously start returning the response data.
//
// THIS IS THE PRIMARY METHOD FOR SUBCLASSES TO OVERRIDE. YOU DO NOT NEED
// TO INVOKE SUPER FOR THIS METHOD.
//
// This method should only be invoked from STSocketServer (it needs to add the
// object to its responseHandlers before this method is invoked).
//
// [server closeHandler:self] should be invoked when done sending data.
//
- (void)startResponse
{
	CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	
	NSString *responseString =
		@"<form action=\"replace\">"
		@"Class: <input type=\"text\" name=\"class\" value=\"{class}\"/> "
		@"Method: <input type=\"text\" name=\"method\" value=\"{method}\"/><br>"
		@"<textarea name=\"code\" cols=\"120\" rows=\"40\">{code}</textarea><br>"
		@"<input type=\"submit\"></form>";

	NSDictionary *parameters = [url sy_keysAndValuesOfQuery];

	if (parameters) {
		responseString = [responseString stringByReplacingOccurrencesOfString:@"{class}" withString:[parameters objectForKey:@"class"]];
		responseString = [responseString stringByReplacingOccurrencesOfString:@"{method}" withString:[parameters objectForKey:@"method"]];
		responseString = [responseString stringByReplacingOccurrencesOfString:@"{code}" withString:[parameters objectForKey:@"code"]];

		if ([parameters count] == 3) {
			SmalltalkVM *vm = [SmalltalkVM sharedVM];

			NSString *code = [parameters objectForKey:@"code"];
			NSArray *parts = [code componentsSeparatedByString:@"!!"];

			NSString *bytecodePart = [[parts objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			NSString *literalsPart = [[parts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

			NSMutableData *bytecodeData = [[NSMutableData alloc] init];

			for (NSString *line in [bytecodePart componentsSeparatedByString:@"\n"]) {
				unsigned int byte = 0;
				byte_t bytes[1];

				NSArray *lineParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				NSString *bytecode = [lineParts objectAtIndex:2];
				NSScanner *scanner = [[NSScanner alloc] initWithString:bytecode];
				[scanner scanHexInt:&byte];

				bytes[0] = byte;
				[bytecodeData appendBytes:bytes length:1];
			}

			NSMutableArray *literals = [[NSMutableArray alloc] init];
			
			for (NSString *line in [literalsPart componentsSeparatedByString:@"\n"]) {
				NSArray *lineParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

				NSString *literal = [[lineParts objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
				[literals addObject:literal];
			}

			SmalltalkClass *class = [vm->_globalVariables objectForKey:[parameters objectForKey:@"class"]];
			SmalltalkMethod *method = [[SmalltalkMethod alloc]
									   initWithSelector:[parameters objectForKey:@"method"]
									   bytecode:bytecodeData
									   literals:literals];

			[class smalltalk_addInstanceMethod:method];

			NSLog(@"Replaced method %@ of class %@", [parameters objectForKey:@"method"], [parameters objectForKey:@"class"]);
		}
	}

	CFHTTPMessageSetBody(response, (CFDataRef)[responseString dataUsingEncoding:NSUTF8StringEncoding]);

	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);
	@try {
		[fileHandle writeData:(NSData *)headerData];
	}
	@catch (NSException *exception) {
		// Ignore the exception, it normally just means the client
		// closed the connection from the other end.
	}
	@finally {
		CFRelease(headerData);
		CFRelease(response);
		[server closeHandler:self];
	}
}

//
// endResponse
//
// Closes the outgoing file handle.
//
// You should not invoke this method directly. It should only be invoked from
// STSocketServer (it needs to remove the object from its responseHandlers before
// this method is invoked). To close a reponse handler, use
// [server closeHandler:responseHandler].
//
// Subclasses should stop any other activity when this method is invoked and
// invoke super to close the file handle.
//
// If the connection is persistent, you must set fileHandle to nil (without
// closing the file) to prevent the connection getting closed by this method.
//
- (void)endResponse
{
	if (fileHandle)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSFileHandleDataAvailableNotification
         object:fileHandle];
		[fileHandle closeFile];
		[fileHandle release];
		fileHandle = nil;
	}
	
	[server release];
	server = nil;
}

//
// receiveIncomingDataNotification:
//
// Continues to receive incoming data for the connection. Remember that the
// first data past the end of the headers may already have been read into
// the request.
//
// Override this method to read the complete HTTP Request Body. This is a
// complicated process if you want to handle both Content-Length and all common
// Transfer-Encodings, so I haven't implemented it.
//
// If you want to handle persistent connections, you would need careful handling
// to determine the end of the request, seek the fileHandle so it points
// to the byte immediately after then end of this request, and then send an
// NSFileHandleConnectionAcceptedNotification notification with the fileHandle
// as the NSFileHandleNotificationFileHandleItem in the userInfo dictionary
// back to the server to handle the fileHandle as a new incoming request again
// (before setting fileHandle to nil so the connection won't get closed when this
// handler ends).
//
// Parameters:
//    notification - notification that more data is available
//
- (void)receiveIncomingDataNotification:(NSNotification *)notification
{
	NSFileHandle *incomingFileHandle = [notification object];
	NSData *data = [incomingFileHandle availableData];
    
	if ([data length] == 0)
	{
		[server closeHandler:self];
	}
    
	//
	// This is a default implementation and simply ignores all data.
	// If you need the HTTP body, you need to override this method to continue
	// accumulating data. Don't forget that new data may need to be combined
	// with any HTTP body data that may have already been received in the
	// "request" body.
	//
	
	[incomingFileHandle waitForDataInBackgroundAndNotify];
}

//
// dealloc
//
// Stops the response if still running.
//
- (void)dealloc
{
	if (server)
	{
		[self endResponse];
	}
	
	[(id)request release];
	request = nil;
    
	[requestMethod release];
	requestMethod = nil;
    
	[url release];
	url = nil;
    
	[headerFields release];
	headerFields = nil;
    
	[super dealloc];
}

@end
