//
//  KernelObjects.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 5/23/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "KernelObjects.h"
#import <objc/runtime.h>

id $nil;

id $0;
id $1;
id $2;

@implementation _Object

//- (void)doesNotRecognizeSelector:(SEL)aSelector
//{
//    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"MessageNotUnderstood: %@>>%s", [self class], sel_getName(aSelector) ] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil] show];
//}

@end

@implementation UndefinedObject

+ (void)load
{
    $nil = [[self alloc] init];
}

+ (id)new
{
    return $nil;
}

- (id)copy
{
    return $nil;
}

- (NSString *)description
{
    return @"nil";
}

@end

@implementation Magnitude
@end

@implementation Number
@end

@implementation Integer
{
    int _intValue;
}

+ (void)load
{
    $0 = [self $c:0];
    $1 = [self $c:1];
    $2 = [self $c:2];
}

+ $c:(int)value
{
    Integer *object = [Integer new];
    object->_intValue = value;
    return object;
}

- (int)$c
{
    return _intValue;
}

- asString
{
    return [String $oc:[NSString stringWithFormat:@"%d", _intValue]];
}

@end

@implementation Float
@end

@implementation Collection
@end

@implementation SequenceableCollection
@end

@implementation String
{
    NSMutableString *_string;
}

+ (void)load
{
    // __comma__: => ,
    class_addMethod(self,
                    NSSelectorFromString(@","),
                    method_getImplementation(class_getInstanceMethod(self, @selector(__comma__:))),
                    "@@:@");
}

+ (String *)$oc:(NSString *)string
{
    String *object = [String new];
    object->_string = [string mutableCopy];
    return [object autorelease];
}

- (NSString *)$oc
{
    return _string;
}

- (void)dealloc
{
    [_string release];
    [super dealloc];
}

- (String *)__comma__: (String *)aString
{
    return [String $oc:[[self $oc] stringByAppendingString:[aString $oc]]];
}

@end

@implementation NSObject (SmalltalkConversion)

- (_Object *)asSmalltalkObject
{
    return (_Object *)self;
}

@end

@implementation NSNumber (SmalltalkConversion)

- (Number *)asSmalltalkObject
{
    const char *type = [self objCType];
    NSLog(@"NSNumber with type: %s", type);
    return nil;
}

@end

@implementation NSString (SmalltalkConversion)

- (String *)asSmalltalkObject
{
    return [String $oc:self];
}

@end
