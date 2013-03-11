//
//  STSocketServer.h
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

@class STSocketResponseHandler;

@interface STSocketServer : NSObject
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

+ (STSocketServer *)sharedServer;

- (void)start;
- (void)stop;

- (void)closeHandler:(STSocketResponseHandler *)handler;

@end

extern NSString * const HTTPServerNotificationStateChanged;
