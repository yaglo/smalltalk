//
//  SmalltalkClass.m
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <objc/runtime.h>

#import "KernelObjects.h"
#import "SmalltalkClass.h"
#import "SmalltalkMethodContext.h"
#import "SmalltalkObject.h"
#import "SmalltalkVM.h"

@implementation SmalltalkClass

+ (id)smalltalk_classWithName:(NSString *)name superclass:(id)superclass
{
    SmalltalkClass *class = [[SmalltalkClass allocWithZone:NSDefaultMallocZone()] init];
    if (class) {
        class->_name = name;

        class->_superclass = superclass;

        class->_instanceVariableNames = [[NSArray alloc] init];
        class->_instanceMethods = [[NSMutableDictionary alloc] init];

        class->_classVariableNames = [[NSArray alloc] init];
        class->_classVariables = [[NSDictionary alloc] init];
        class->_classMethods = [[NSDictionary alloc] init];

        class->_classRespondsCache = [[NSMutableDictionary alloc] init];
        class->_instancesRespondCache = [[NSMutableDictionary alloc] init];

        [self smalltalk_registerClassInRuntime:class];

        SmalltalkVM *vm = [SmalltalkVM sharedVM];
        [vm->_globalVariables setObject:class forKey:name];

//        IMP methodSignatureForSelector = imp_implementationWithBlock(^(id _self, SEL selector){
//            NSLog(@"methodSignature %@", NSStringFromSelector(selector));
//            
//            if ([NSStringFromSelector(selector) isEqualToString:@"initialize"]) {
//                NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
//                return signature;
//            }
//            
//            return [NSMethodSignature signatureWithObjCTypes:""];
//        });
//        class_replaceMethod(class->_objc_class, @selector(methodSignatureForSelector:), methodSignatureForSelector, ":");
//
//        IMP doesNotRecognizeSelector = imp_implementationWithBlock(^(id _self, SEL selector){
//            NSLog(@"%@", NSStringFromSelector(selector));
//        });
//        class_replaceMethod(class->_objc_class, @selector(doesNotRecognizeSelector:), doesNotRecognizeSelector, ":");
//
//        IMP forwardInvocation = imp_implementationWithBlock(^(id _self, NSInvocation *invocation){
//            NSLog(@"%@", invocation);
//        });
//        class_replaceMethod(class->_objc_class, @selector(forwardInvocation:), forwardInvocation, ":");
//
    }
    return class;
}

- (void)smalltalk_addInstanceMethod:(SmalltalkMethod *)method
{
//    [_instanceMethods setObject:method forKey:method->_selector];
//    class_replaceMethod(_objc_class, NSSelectorFromString(method->_selector), NULL, "@:");
//    return;

    NSLog(@"%@", method->_selector);
    [_instanceMethods setObject:method forKey:method->_selector];

    NSMutableString *types = [NSMutableString stringWithString:@"@:"];
    NSUInteger argNum = [[method->_selector componentsSeparatedByString:@":"] count] - 1;
    for (int i = 0; i < argNum; i++) {
         [types appendString:@"@"];
    }
    
    NSLog(@"%@", types);

    IMP imp = lst_msgReceive;
    class_replaceMethod(_objc_class, NSSelectorFromString(method->_selector), imp, [types cStringUsingEncoding:NSASCIIStringEncoding]);
}

- (void)smalltalk_addClassMethod:(SmalltalkMethod *)method
{
    
}

+ (void)smalltalk_registerClassInRuntime:(SmalltalkClass *)class
{
    const char *name = [class->_name cStringUsingEncoding:NSASCIIStringEncoding];

    Class superclass = class->_superclass;
    if ([class->_superclass isKindOfClass:[SmalltalkClass class]])
        superclass = ((SmalltalkClass *)class->_superclass)->_objc_class;

    class->_objc_class = objc_allocateClassPair(superclass, name, 0);
    class_setVersion(class->_objc_class, ls_classVersion);
    objc_registerClassPair(class->_objc_class);
}

- (BOOL)smalltalk_isCachedInstancesRespondToSelector:(SEL)aSelector
{
    return [_instancesRespondCache objectForKey:NSStringFromSelector(aSelector)] != nil;
}

- (BOOL)smalltalk_cachedInstancesRespondToSelector:(SEL)aSelector
{
    return [[_instancesRespondCache objectForKey:NSStringFromSelector(aSelector)] boolValue];
}

- (void)smalltalk_setCacheInstancesRespond:(BOOL)respond toSelector:(SEL)aSelector
{
    [_instancesRespondCache setValue:[NSNumber numberWithBool:respond] forKey:NSStringFromSelector(aSelector)];
}

- (void)smalltalk_clearInstancesRespondCache
{
    _instancesRespondCache = [[NSMutableDictionary alloc] init];
}








- (BOOL)respondsToSelector:(SEL)aSelector
{
    int a = 1;
    NSLog(@"%d", a);
    return YES;
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
