//
//  AppDelegate.m
//  RandomApp
//
//  Created by Stanislav Yaglo on 3/13/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark - NSNibAwaking

- (void)awakeFromNib
{
    NSCalendarDate *now;
    now = [NSCalendarDate calendarDate];
    [_textField setObjectValue: now];
}

#pragma mark - actions

- (void)generate:(id)sender
{
    // Generate a number between 1 and 100 inclusive
    int generated;
    generated = (random() % 100) + 1;

    NSLog(@"generated = %d", generated);

    // Ask the text field to change what it is displaying
    [_textField setIntegerValue:generated];
}

- (void)seed:(id)sender
{
    // Seed the random number generator with the time
    srandom((unsigned int)time(NULL));
    [_textField setStringValue:@"Generator seeded"];
}

@end
