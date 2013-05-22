//
//  SmalltalkMethodContext.h
//  SmalltalkCompiler
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmalltalkMethodContext : NSObject

@property (strong, nonatomic) id sender;
@property (strong, nonatomic) id receiver;
@property (strong, nonatomic) NSString *selector;
@property (strong, nonatomic) NSArray *arguments;
@property (strong, nonatomic) NSMutableArray *temporaryVariables;

@end
