//
//  SmalltalkMethod.m
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "SmalltalkMethod.h"

@implementation SmalltalkMethod

- (id)initWithSelector:(NSString *)selector bytecode:(NSData *)bytecode literals:(NSArray *)literals
{
    self = [super init];
    if (self) {
        _selector = [selector copy];
        _literals = [literals copy];
        _bytecode = [bytecode copy];
    }
    return self;
}

@end
