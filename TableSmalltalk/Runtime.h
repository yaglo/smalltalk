//
//  runtime.h
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 5/23/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern id $nil;

extern id $0;
extern id $1;
extern id $2;

extern const int ls_classVersion;

id lst_msgReceive (id self, SEL _cmd, ...);
