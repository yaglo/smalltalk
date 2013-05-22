//
//  KernelObjects.h
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 5/23/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Runtime.h"

@interface _Object : NSObject
@end

@interface UndefinedObject : NSObject
@end

@interface Magnitude : _Object
@end

@interface Number : Magnitude
@end

@interface Integer : Magnitude
+ $c:(int)value;
- (int)$c;
@end

@interface Float : Magnitude
@end

@interface Collection : _Object
@end

@interface SequenceableCollection : Collection
@end

@interface String : SequenceableCollection
+ (String *)$oc:(NSString *)string;
- (NSString *)$oc;
@end

@interface NSObject (SmalltalkConversion)
- (_Object *)asSmalltalkObject;
@end

@interface NSNumber (SmalltalkConversion)
- (Number *)asSmalltalkObject;
@end

@interface NSString (SmalltalkConversion)
- (String *)asSmalltalkObject;
@end
