//
//  SmalltalkSocketServer.h
//  Smalltalk
//
//  Created by Stanislav Yaglo on 05.03.13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	SERVER_STATE_IDLE,
	SERVER_STATE_STARTING,
	SERVER_STATE_RUNNING,
	SERVER_STATE_STOPPING
} STSocketServerState;

@class SmalltalkSocketResponseHandler;

@interface SmalltalkSocketServer : NSObject
{
	NSError *lastError;
	NSFileHandle *listeningHandle;
	CFSocketRef socket;
	STSocketServerState state;
	CFMutableDictionaryRef incomingRequests;
	NSMutableSet *responseHandlers;
}

@property (nonatomic, readonly, retain) NSError *lastError;
@property (readonly, assign) STSocketServerState state;

+ (SmalltalkSocketServer *)sharedServer;

- (void)start;
- (void)stop;

- (void)closeHandler:(SmalltalkSocketResponseHandler *)handler;

@end

extern NSString * const HTTPServerNotificationStateChanged;
