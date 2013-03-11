//
//  SmalltalkMethod.h
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmalltalkMethod : NSObject
{
@public
    NSString *_selector;
    NSData *_bytecode;
    NSArray *_literals;
}

- (id)initWithSelector:(NSString *)selector bytecode:(NSData *)bytecode literals:(NSArray *)literals;

@end
