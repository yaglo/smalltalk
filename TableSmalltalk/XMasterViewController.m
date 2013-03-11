//
//  MasterViewController.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "XMasterViewController.h"

#import "DetailViewController.h"

@implementation XMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

@end
