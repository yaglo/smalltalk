//
//  SmalltalkClass.h
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmalltalkMethod.h"

@interface SmalltalkClass : NSObject
{
@public
    NSString *_name;
    Class _objc_class;

    id _superclass;

    NSArray *_instanceVariableNames;
    NSMutableDictionary *_instanceMethods;

    NSArray *_classVariableNames;
    NSDictionary *_classVariables;
    NSDictionary *_classMethods;

    NSMutableDictionary *_classRespondsCache;
    NSMutableDictionary *_instancesRespondCache;
}

// Private

- (void)smalltalk_addInstanceMethod:(SmalltalkMethod *)method;
- (void)smalltalk_addClassMethod:(SmalltalkMethod *)method;

+ (id)smalltalk_classWithName:(NSString *)name superclass:(id)superclass;
- (BOOL)smalltalk_isCachedInstancesRespondToSelector:(SEL)aSelector;
- (BOOL)smalltalk_cachedInstancesRespondToSelector:(SEL)aSelector;
- (void)smalltalk_setCacheInstancesRespond:(BOOL)respond toSelector:(SEL)aSelector;
- (void)smalltalk_clearInstancesRespondCache;

@end
