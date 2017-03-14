//
//  ObjCAppDelegate.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 14/03/2017.
//  Copyright © 2017 Stanislav Yaglo. All rights reserved.
//

#import "ObjCAppDelegate.h"

@implementation ObjCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
         UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
         UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
         splitViewController.delegate = (id)navigationController.topViewController;
     }
     return YES;
}

@end
