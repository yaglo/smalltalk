//
//  SmalltalkVM.m
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>

#import "KernelObjects.h"
#import "Runtime.h"

#import "SmalltalkClass.h"
#import "SmalltalkMethod.h"
#import "SmalltalkMethodContext.h"
#import "SmalltalkObject.h"
#import "SmalltalkVM.h"

#import "STSocketServer.h"

@implementation SmalltalkVM

- (id)init
{
    self = [super init];
    if (self) {
        _globalVariables = [[NSMutableDictionary alloc] init];
        _stack = [[NSMutableArray alloc] init];
        _methodContextStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initializeVM
{
    [self initializeObjectiveCClasses];
    
    _rootClass = [SmalltalkClass smalltalk_classWithName:@"$Object" superclass:[NSObject class]];
    [self initializeTranscript];
}

+ (id)sharedVM
{
    static id shared = nil;
    if (!shared)
        shared = [[SmalltalkVM alloc] init];
    return shared;
}

- (id)popObject
{
    id object = [_stack lastObject];
    [_stack removeLastObject];
    if (object == $nil)
        return nil;
    return object;
}

- (void)pushObject:(id)object
{
    if (object == nil)
        object = $nil;
    [_stack addObject:object];
}

- (id)popContext
{
    id context = [_methodContextStack lastObject];
    [_methodContextStack removeLastObject];
    return context;
}

- (void)pushContext:(id)context
{
    [_methodContextStack addObject:context];
}

- (SmalltalkMethodContext *)activeContext
{
    return [_methodContextStack lastObject];
}

char GetReturnType(id receiver, SEL selector)
{
    
    char classReturnType[256], instanceReturnType[256];
    char returnType[256];
    Method classMethod = class_getClassMethod([receiver class], selector);
    Method instanceMethod = class_getInstanceMethod([receiver class], selector);
    method_getReturnType(classMethod, classReturnType, 256);
    method_getReturnType(instanceMethod, instanceReturnType, 256);
    
    if (classReturnType[0] == '\0') {
        returnType[0] = instanceReturnType[0];
    }
    else {
        returnType[0] = classReturnType[0];
    }
    
    if ([NSStringFromSelector(selector) isEqualToString:@"count"]) {
        returnType[0] = 'i';
    }
    
    return returnType[0];
}

- (id)executeMethod:(SmalltalkMethod *)method
{
    @synchronized(self) {
//    NSLog(@"Executing method: %@", method->_selector);
//    NSLog(@"Bytecode: %@", method->_bytecode);

    const byte_t *bytes = [method->_bytecode bytes];
    int index = 0;
    
    while (index < [method->_bytecode length]) {
        byte_t byte = bytes[index++];
//        NSLog(@"%04d <%03d>", index, byte);
        
        // 0-15       0000iiii    Push Receiver Variable #iiii
        if (byte < 16) {
            int n = byte;
            SmalltalkObject *object = [[self activeContext] receiver];
            [self pushObject:[object->_instanceVariables objectAtIndex:n]];
        }
        // 16-31      0001iiii    Push Temporary Location #iiii
        else if (byte >= 16 && byte < 32) {
            int n = byte - 16;
            SmalltalkMethodContext *context = [self activeContext];
//            NSLog(@"pushTemp: %d (%@)", n, [context.temporaryVariables objectAtIndex:n]);
            [self pushObject:[context.temporaryVariables objectAtIndex:n]];
        }
        // 32-63      001iiiii    Push Literal Constant #iiiii
        else if (byte >= 32 && byte < 64) {
            int n = byte - 32;
            [self pushObject:[method->_literals objectAtIndex:n]];
        }
        // 64-95      010iiiii    Push Literal Variable #iiiii
        else if (byte >= 64 && byte < 96) {
            int n = byte - 64;
            id name = [method->_literals objectAtIndex:n];
            id object = [_globalVariables objectForKey:name];
//            NSLog(@"%@ >> %@", name, object);
            [self pushObject:object];
        }
        // 96-103     01100iii    Pop and Store Receiver Variable #iii
        else if (byte >= 96 && byte < 104) {
            int n = byte - 96;
            SmalltalkMethodContext *context = [self activeContext];
            id object = [self popObject];
            SmalltalkObject *receiver = context.receiver;
            
            if (!receiver->_instanceVariables) {
                receiver->_instanceVariables = [[NSMutableArray alloc] init];
            }
            [receiver->_instanceVariables setObject:object atIndexedSubscript:n];
        }
        // 104-111    01101iii    Pop and Store Temporary Location #iii
        else if (byte >= 104 && byte < 112) {
            int n = byte - 104;
            SmalltalkMethodContext *context = [self activeContext];
            
            id object = [self popObject];
            
            context.temporaryVariables[n] = object ? object : $nil;
        }
        // 112        01110000    Push receiver
        else if (byte == 112) {
            [self pushObject:[self activeContext].receiver];
        }
        // 118        01110110    Push 1
        else if (byte == 118) {
            [self pushObject: $1];
        }
        // 120        01111000    Return receiver
        else if (byte == 120) {
            return [[self activeContext] receiver];
        }
        // 121        01111001    Return true
        else if (byte == 121) {
            return [NSNumber numberWithBool:YES];
        }
        // 124        01111100    Return Stack Top From Message
        else if (byte == 124) {
            return [self popObject];
        }
        // 131	10000011 jjjkkkkk	Send Literal Selector #kkkkk With jjj Arguments
        else if (byte == 133) {
            byte_t jk = bytes[index++];
            byte_t j = (0xE0 & jk) >> 5;
            byte_t k = 0x1F & jk;
            
            SEL selector = NSSelectorFromString([method->_literals objectAtIndex:k]);
            id receiver = [self popObject];
            
            id value;
            
            switch (j) {
                case 1:
                {
                    id argument = [self popObject];
                    value = objc_msgSend(receiver, selector, argument);
                }
                    break;
                case 2:
                {
                    id argument2 = [self popObject];
                    id argument1 = [self popObject];
                    
                    value = objc_msgSend(receiver, selector, argument1, argument2);
                }
                    break;
                case 3:
                {
                    id argument3 = [self popObject];
                    id argument2 = [self popObject];
                    id argument1 = [self popObject];
                    
                    value = objc_msgSend(receiver, selector, argument1, argument2, argument3);
                }
                    break;
                default:
                    value = objc_msgSend(receiver, selector, selector);
                    break;
            }
            
            char returnType = GetReturnType(receiver, selector);
            
                if (returnType == '@') {
                    [self pushObject:value];
                }
                else if (returnType == 'i') {
                    [self pushObject:[NSNumber numberWithInt:(int)value]];
                }
                else {
                    [self pushObject:value];
                    @throw @"Unknown return type";
                }
        }
        // 133	10000101 jjjkkkkk	Send Literal Selector #kkkkk To Superclass With jjj Arguments
        else if (byte == 133) {
            byte_t jk = bytes[index++];
            byte_t j = (0xE0 & jk) >> 5;
            byte_t k = 0x1F & jk;

            SEL selector = NSSelectorFromString([method->_literals objectAtIndex:k]);
            id receiver = [self popObject];
            
            struct objc_super superInfo = {
                receiver,
                [receiver superclass]
            };
            id value;
            
            switch (j) {
                case 1:
                {
                    id argument = [self popObject];
                    value = objc_msgSendSuper(&superInfo, selector, argument);
                }
                    break;
                case 2:
                {
                    id argument2 = [self popObject];
                    id argument1 = [self popObject];

                    value = objc_msgSendSuper(&superInfo, selector, argument1, argument2);
                }
                    break;
                case 3:
                {
                    id argument3 = [self popObject];
                    id argument2 = [self popObject];
                    id argument1 = [self popObject];
                    
                    value = objc_msgSendSuper(&superInfo, selector, argument1, argument2, argument3);
                }
                    break;
                default:
                    value = objc_msgSendSuper(&superInfo, selector);
                    break;
            }
            
            char returnType = GetReturnType(receiver, selector);
            
            if ([[method->_literals objectAtIndex:k] isEqualToString:@"viewDidLoad"]) {
                [self pushObject:receiver];
            }
            else {
                if (returnType == '@') {
                    [self pushObject:value];
                }
                else if (returnType == 'i') {
                    [self pushObject:[Integer $c:(int)value]];
                }
                else {
                    [self pushObject:value];
                    @throw @"Unknown return type";
                }
            }
        }
        // 135        10000111    Pop Stack Top
        else if (byte == 135) {
            (void)[self popObject];
        }
        // 138    unused        NSLog stack top
        else if (byte == 138) {
            NSLog(@"%@", [self popObject]);
        }
        // 172-175    101011ii jjjjjjjj    Pop and Jump On False ii *256+jjjjjjjj
        else if (byte >= 172 && byte < 176) {
            int i = byte - 172;
            int j = bytes[index++];
            int newIndex = index + i * 256 + j;
            NSNumber *condition = [self popObject];
            if (![condition boolValue]) {
                NSLog(@"Jumping to %04d", newIndex);
                index = newIndex - 1;
            }
        }
        // 182        10110110    Send Arithmetic Message 7 (=)
        else if (byte == 182) {
            id obj1 = [self popObject];
            id obj2 = [self popObject];
            [self pushObject:[NSNumber numberWithBool:[obj1 isEqual:obj2]]];
        }
        // 208-223    1101iiii    Send Literal Selector #iiii With No Arguments
        else if (byte >= 208 && byte < 224) {
            int n = byte - 208;
            SEL selector = NSSelectorFromString([method->_literals objectAtIndex:n]);

            id receiver = [self popObject];
            id value = objc_msgSend(receiver, selector);

            char returnType = GetReturnType(receiver, selector);
            
            if (returnType == '@') {
                [self pushObject:value];
            }
            else if (returnType == 'i') {
                [self pushObject:[Integer $c:(int)value]];
            }
            else if (returnType == 'v') {
                [self pushObject:receiver];
            }
            else {
                [self pushObject:value];
//                @throw @"Unknown return type";
            }
        }
        // 224-239    1110iiii    Send Literal Selector #iiii With 1 Argument
        else if (byte >= 224 && byte < 240) {
            int n = byte - 224;
            NSString *stringSelector = [method->_literals objectAtIndex:n];
            SEL selector = NSSelectorFromString(stringSelector);
            id argument = [self popObject];
            id receiver = [self popObject];
            
            id value = objc_msgSend(receiver, selector, argument);

            char returnType = GetReturnType(receiver, selector);
            
            if (returnType == '@') {
                if ([value isKindOfClass:[String class]])
                    [self pushObject:[value $oc]];
                else
                    [self pushObject:value];
            }
            else if (returnType == 'i') {
                [self pushObject:[Integer $c:(int)value]];
            }
            else if (returnType == 'v') {
                [self pushObject:receiver];
            }
            else {
                [self pushObject:value];
                @throw @"Unknown return type";
            }
        }
        // 240-255    1111iiii    Send Literal Selector #iiii With 2 Arguments
        else if (byte >= 240 && byte < 256) {
            int n = byte - 240;
            SEL selector = NSSelectorFromString([method->_literals objectAtIndex:n]);
            id argument2 = [self popObject];
            id argument1 = [self popObject];
            id receiver = [self popObject];
            id value = objc_msgSend(receiver, selector, argument1, argument2);
            
            char returnType = GetReturnType(receiver, selector);
            
            if (returnType == '@') {
                [self pushObject:value];
            }
            else if (returnType == 'i') {
                [self pushObject:[NSNumber numberWithInt:(int)value]];
            }
            else {
                [self pushObject:value];
                @throw @"Unknown return type";
            }
        }
        else {
            NSLog(@"Unknown bytecode: %d", byte);
        }
    };
    return nil;
    }
}

- (void)initializeObjectiveCClasses
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

//    for (int i = 0; i < numClasses; i++) {
//        [_globalVariables setObject:classes[i] forKey:[NSString stringWithUTF8String:class_getName(classes[i])]];
//    }
    
    [_globalVariables setObject:[UIDevice class] forKey:@"UIDevice"];
    [_globalVariables setObject:[UIColor class] forKey:@"UIColor"];
    [_globalVariables setObject:[STSocketServer class] forKey:@"STSocketServer"];

    free(classes);
}

- (void)initializeTranscript
{
    SmalltalkClass *Transcript = [SmalltalkClass smalltalk_classWithName:@"Transcript"
                                                              superclass:[_globalVariables objectForKey:@"$Object"]];
    
    // 00 <8A> NSLog top
    // 01 <78> returnSelf
    
    byte_t showBytecode[] = { 0x8a, 0x78 };
    
    SmalltalkMethod *logTop = [[SmalltalkMethod alloc]
                               initWithSelector:@"logTop"
                               bytecode:[NSData dataWithBytes:showBytecode length:2]
                               literals:nil];
    
    [Transcript smalltalk_addInstanceMethod:logTop];
    
    id transcript = [[SmalltalkObject alloc] init];
    [transcript smalltalk_setClass:Transcript];
    [_globalVariables setObject:transcript forKey:@"Transcript"];
}

@end
