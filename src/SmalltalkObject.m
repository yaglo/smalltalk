//
//  SmalltalkObject.m
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/6/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

static const BOOL kUseMethodCache = YES;

#import <objc/runtime.h>

#import "SmalltalkObject.h"

@implementation SmalltalkObject

- (id)init
{
    self = [super init];
    if (self) {
        _instanceVariables = [[NSMutableArray alloc] initWithObjects:
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null],
                              [NSNull null], [NSNull null], [NSNull null], [NSNull null], nil];
    }
    return self;
}

+ (id)smalltalk_allocWithClass:(SmalltalkClass *)class NS_RETURNS_RETAINED
{
    SmalltalkObject *object = [SmalltalkObject alloc];
    object->_class = class;
//    object->_instanceVariables = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaquePersonality | NSPointerFunctionsOpaqueMemory];
    return object;
}

- (void)smalltalk_setClass:(SmalltalkClass *)class
{
    object_setClass(self, class->_objc_class);
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    // Check if there is a Smalltalk method to respond to it
    // if ([self->_isA->_instanceMethods objectForKey:@"respondsToSelector:"])
    //     execute Smalltalk method for -respondsToSelector:

    if (kUseMethodCache && [self->_class smalltalk_isCachedInstancesRespondToSelector:aSelector]) {
        return [self->_class smalltalk_cachedInstancesRespondToSelector:aSelector];
    }

    SmalltalkClass *class = self->_class;
    while (class) {
        if ([class isKindOfClass:[SmalltalkClass class]]) {
            if ([class->_instanceMethods objectForKey:NSStringFromSelector(aSelector)]) {
                if (kUseMethodCache) {
                    [class smalltalk_setCacheInstancesRespond:YES toSelector:aSelector];
                }
                return YES;
            }
        }
        else {
            BOOL respond = [*(Class *)class instancesRespondToSelector:aSelector];
            if (kUseMethodCache) {
                [self->_class smalltalk_setCacheInstancesRespond:respond toSelector:aSelector];
            }
            return respond;
        }
        class = class->_superclass;
    }

    if (kUseMethodCache) {
        [self->_class smalltalk_setCacheInstancesRespond:NO toSelector:aSelector];
    }

    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    int a = 1;
    NSLog(@"%d", a);
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    int a = 1;
    NSLog(@"%d", a);
}

@end
