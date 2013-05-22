//
//  main.m
//  RandomApp
//
//  Created by Stanislav Yaglo on 3/13/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SmalltalkSocketServer.h"
#import "SmalltalkVM.h"

int main(int argc, char *argv[])
{
    [[SmalltalkVM sharedVM] initializeVM];
    [[SmalltalkSocketServer sharedServer] start];

    return NSApplicationMain(argc, (const char **)argv);
}
