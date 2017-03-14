//
//  runtime.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 5/23/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "Runtime.h"

#import <objc/runtime.h>

#import "KernelObjects.h"

#import "SmalltalkClass.h"
#import "SmalltalkMethod.h"
#import "SmalltalkMethodContext.h"
#import "SmalltalkVM.h"

Class lst_classes_to_box[256];
uint32_t lst_classes_to_box_count = 0;

const int ls_classVersion = 0xC0FFFEEE;

__attribute__((constructor))
void
lst_classes_to_box_initialize()
{
#define lst_add_class_to_box(name) do { NSLog(@"Adding %@ to boxing list", lst_classes_to_box[lst_classes_to_box_count++] = objc_getClass(#name)); } while (0);
    lst_add_class_to_box(__NSCFBoolean);
    lst_add_class_to_box(__NSCFNumber);
    lst_add_class_to_box(NSNumber);
    lst_add_class_to_box(NSValue);
    
    lst_add_class_to_box(__NSCFString);
    lst_add_class_to_box(__NSCFConstantString);
    lst_add_class_to_box(NSMutableString);
    lst_add_class_to_box(NSString);
    
    lst_add_class_to_box(__NSCFDictionary);
    lst_add_class_to_box(NSMutableDictionary);
    lst_add_class_to_box(NSDictionary);
    
    lst_add_class_to_box(__NSCFArray);
    lst_add_class_to_box(__NSArrayM);
    lst_add_class_to_box(NSMutableArray);
    lst_add_class_to_box(NSArray);
    
    lst_add_class_to_box(__NSCFData);
    lst_add_class_to_box(NSMutableData);
    lst_add_class_to_box(NSData);
    
    lst_add_class_to_box(__NSCFSet);
    lst_add_class_to_box(NSMutableSet);
    lst_add_class_to_box(NSSet);
    
    lst_add_class_to_box(__NSCFDate);
    lst_add_class_to_box(NSDate);
    
#undef lst_add_class_to_box
}

Boolean
lst_class_needs_boxing (Class class)
{
    //    if (!class)
    //        return true;
    
    for (int i = 0; i < lst_classes_to_box_count; i++)
        if (lst_classes_to_box[i] == class)
            return true;
    
    return false;
}

Boolean
lst_isBinarySelector (const char *sel)
{
    return !(sel[0] == '_' || (sel[0] >= 'a' && sel[0] <= 'z'));
}

int
lst_argumentCount (const char *sel)
{
    int argc = 0;
    for (int i = 0; ; i++) {
        char c = sel[i];
        if (c == '\0') break;
        else if (c == ':') argc++;
    }
    return argc;
}

SmalltalkMethod *
lst_getMethod (id self, SEL _cmd)
{
    SmalltalkVM *vm = [SmalltalkVM sharedVM];
    SmalltalkClass *class = vm->_globalVariables[@(object_getClassName(self))];
    return class->_instanceMethods[NSStringFromSelector(_cmd)];
}

Boolean
lst_argumentsNeedBoxing (NSMutableArray *arguments)
{
    for (id object in arguments) {
        if (lst_class_needs_boxing(object_getClass(object)))
            return true;
    }
    return false;
}

Boolean
lst_argumentsNeedUnboxing (NSMutableArray *arguments)
{
    for (id object in arguments) {
        if (lst_class_needs_boxing(object_getClass(object)))
            return true;
    }
    return false;
}

void
lst_boxArguments (NSMutableArray *arguments)
{
    int i = 0;
    for (id object in arguments) {
        if (!object)
            arguments[i] = $nil;
        else if (lst_class_needs_boxing(object_getClass(object))) {
            NSLog(@"Boxing %@", object);
            arguments[i] = [object asSmalltalkObject];
        }
        i++;
    }
}

id
lst_msgReceive (id self, SEL _cmd, ...)
{
//    NSLog(@"lst_msgReceive: %@ %@", self, NSStringFromSelector(_cmd));
    
    const char *sel = sel_getName(_cmd);
    int argc = lst_isBinarySelector(sel) ? 1 : lst_argumentCount(sel);
    SmalltalkMethod *method = lst_getMethod(self, _cmd);
    
    SmalltalkVM *vm = [SmalltalkVM sharedVM];
    SmalltalkMethodContext *context = [[SmalltalkMethodContext alloc] init];
    context.receiver = self;
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    
    va_list arglist;
    va_start(arglist, _cmd);
    for (int i = 0; i < argc; i++) {
        id argument = va_arg(arglist, id);

        // temporary hack, will implement it with BridgeSupport
        if ((_cmd == @selector(tableView:titleForHeaderInSection:)
             || _cmd == @selector(tableView:numberOfRowsInSection:))&& i == 1)
            [arguments addObject: [Integer $c: (int)argument]];
        else
            [arguments addObject: argument ? argument : $nil];
    }
    va_end(arglist);
    
    if (lst_argumentsNeedBoxing(arguments)) {
        lst_boxArguments(arguments);
    }
    

    context.temporaryVariables = arguments;
    
    [vm pushContext:context];
    id value = [vm executeMethod:method];
    [vm popContext];
    
    [context release];

    if ([value isKindOfClass:[Integer class]]) {
        value = (id)[(Integer *)value $c];
    }
    else if ([value isKindOfClass:[String class]]) {
        value = [value $oc];
    }

    return value;
}

char
lst_getMethodReturnType (id self, SEL _cmd)
{
    char classReturnType[256], instanceReturnType[256];
    char returnType[256];
    Method classMethod = class_getClassMethod([self class], _cmd);
    Method instanceMethod = class_getInstanceMethod([self class], _cmd);
    method_getReturnType(classMethod, classReturnType, 256);
    method_getReturnType(instanceMethod, instanceReturnType, 256);
    
    if (classReturnType[0] == '\0') {
        returnType[0] = instanceReturnType[0];
    }
    else {
        returnType[0] = classReturnType[0];
    }
    
    return returnType[0];
}

Boolean
lst_typeNeedsBoxing (char type)
{
    return type != '@';
}

Boolean
lst_typeIsVoid (char type)
{
    return type == 'v';
}
//
//id
//lst_msgSendNaive (id self, SEL _cmd, NSArray *arguments)
//{
//    const char *sel = sel_getName(_cmd);
//    int argc = lst_isBinarySelector(sel) ? 1 : lst_argumentCount(sel);
//    
//    NSPointerArray *arr = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsObjectPersonality];
//    
//    
//    
//    if (lst_argumentsNeedUnboxing(arguments)) {
//        lst_unboxArguments(arguments);
//    }
//}
