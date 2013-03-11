//
//  MasterViewController.h
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface XMasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
