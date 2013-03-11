//
//  SmalltalkObject.h
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/6/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SmalltalkClass.h"

@interface SmalltalkObject : NSObject
{
@public
    SmalltalkClass *_class;
    NSMutableArray *_instanceVariables;
}

- (void)smalltalk_setClass:(SmalltalkClass *)class;

@end
