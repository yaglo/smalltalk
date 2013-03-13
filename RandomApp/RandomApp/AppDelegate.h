//
//  AppDelegate.h
//  RandomApp
//
//  Created by Stanislav Yaglo on 3/13/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSWindow *window;

- (IBAction)generate:(id)sender;
- (IBAction)seed:(id)sender;

@end
