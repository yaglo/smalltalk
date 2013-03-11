//
//  SmalltalkVM.h
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SmalltalkClass;
@class SmalltalkMethod;

typedef uint8_t byte_t;

@interface SmalltalkVM : NSObject
{
@public
    NSMutableDictionary *_globalVariables;
    NSMutableArray *_stack;
    NSMutableArray *_methodContextStack;
}

@property (strong, nonatomic) SmalltalkClass *rootClass;

+ (id)sharedVM;
- (void)initializeVM;

- (id)executeMethod:(SmalltalkMethod *)method;
- (id)popContext;
- (void)pushContext:(id)context;

@end
