//
//  SmalltalkSocketResponseHandler.h
//  Smalltalk
//
//  Created by Stanislav Yaglo on 05.03.13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmalltalkSocketServer.h"

@interface SmalltalkSocketResponseHandler : NSObject
{
	CFHTTPMessageRef request;
	NSString *requestMethod;
	NSDictionary *headerFields;
	NSFileHandle *fileHandle;
	SmalltalkSocketServer *server;
	NSURL *url;
}

+ (NSUInteger)priority;
+ (void)registerHandler:(Class)handlerClass;

+ (SmalltalkSocketResponseHandler *)handlerForRequest:(CFHTTPMessageRef)aRequest
                                    fileHandle:(NSFileHandle *)requestFileHandle
                                        server:(SmalltalkSocketServer *)aServer;

- (id)initWithRequest:(CFHTTPMessageRef)aRequest
               method:(NSString *)method
                  url:(NSURL *)requestURL
         headerFields:(NSDictionary *)requestHeaderFields
           fileHandle:(NSFileHandle *)requestFileHandle
               server:(SmalltalkSocketServer *)aServer;
- (void)startResponse;
- (void)endResponse;

@end
