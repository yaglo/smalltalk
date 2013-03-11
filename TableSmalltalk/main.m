//
//  main.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>



#import "SmalltalkClass.h"
#import "SmalltalkVM.h"


void InitializeAppDelegateClass()
{
    SmalltalkVM *vm = [SmalltalkVM sharedVM];

    SmalltalkClass *AppDelegate = [SmalltalkClass smalltalk_classWithName:@"AppDelegate" superclass:vm.rootClass];
    AppDelegate->_instanceVariableNames = @[ @"window" ];
    
    // - window
    //     ^window
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       00         pushRcvr: 0      (window)
    // 01       7C         returnTop
    
    byte_t window_b[] = { 0x00, 0x7C };
    SmalltalkMethod *window = [[SmalltalkMethod alloc] initWithSelector:@"window"
                                                               bytecode:[NSData dataWithBytes:window_b length:2]
                                                               literals:nil];
    [AppDelegate smalltalk_addInstanceMethod:window];

    // - setWindow: aWindow
    //     window := aWindow
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       10         pushTemp: 0     (aWindow)
    // 01       60         popIntoRcvr: 0  (window)
    // 02       78         returnSelf

    byte_t setWindow_b[] = { 0x10, 0x60, 0x78 };
    SmalltalkMethod *setWindow = [[SmalltalkMethod alloc] initWithSelector:@"setWindow:"
                                                                  bytecode:[NSData dataWithBytes:setWindow_b length:3]
                                                                  literals:nil];
    [AppDelegate smalltalk_addInstanceMethod:setWindow];

    // - application: application didFinishLaunchingWithOptions: launchOptions
    //
    // if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //     UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    //     UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    //     splitViewController.delegate = (id)navigationController.topViewController;
    // }
    // return YES;
    //
    // 0 = rootViewController
    // 1 = window
    // 2 = lastObject
    // 3 = viewControllers
    // 4 = setDelegate:
    // 5 = topViewController
    // 6 = userInterfaceIdiom
    // 7 = currentDevice
    // 8 = UIDevice
    // 9 = STSocketServer
    // 10 = sharedServer
    // 11 = start
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       48         pushLit: UIDevice          8
    // 01       D7         send: currentDevice        7
    // 02       D6         send: userInterfaceIdiom   6
    // 03       76         pushConstant: 1
    // 04       B6         send: =
    // 05       AC 0D      jumpFalse: 20
    // 07       70         self
    // 08       D1         send: window               1
    // 09       D0         send: rootViewController   0
    // 10       69         popIntoTemp: 1
    // 11       11         pushTemp: 1
    // 12       D3         send: viewControllers      3
    // 13       D2         send: lastObject           2
    // 14       6A         popIntoTemp: 2
    // 15       11         pushTemp: 1
    // 16       12         pushTemp: 2
    // 17       D5         send: topViewController    5
    // 18       E4         send: setDelegate:         4
    // 19       87         pop
    // 20       49         pushLit: STSocketServer    9
    // 21       DA         send: sharedServer         10
    // 22       DB         send: start                11
    // 23       87         pop
    // 24       78         returnSelf
        
    byte_t didfinish_b[] = { 0x48, 0xD7, 0xD6, 0x76, 0xB6, 0xAC, 0x0D, 0x70, 0xD1, 0xD0,
        0x69, 0x11, 0xD3, 0xD2, 0x6A, 0x11, 0x12, 0xD5, 0xE4, 0x87, 0x49, 0xDA, 0xDB, 0x87, 0x78 };
    NSArray *literals = @[ @"rootViewController", @"window", @"lastObject", @"viewControllers", @"setDelegate:", @"topViewController", @"userInterfaceIdiom", @"currentDevice", @"UIDevice", @"STSocketServer", @"sharedServer", @"start" ];
    SmalltalkMethod *didfinish = [[SmalltalkMethod alloc] initWithSelector:@"application:didFinishLaunchingWithOptions:"
                                                                  bytecode:[NSData dataWithBytes:didfinish_b length:25]
                                                                  literals:literals];
    [AppDelegate smalltalk_addInstanceMethod:didfinish];
}

void InitializeMasterViewControllerClass()
{
    SmalltalkClass *MasterViewController = [SmalltalkClass smalltalk_classWithName:@"MasterViewController" superclass:[UIViewController class]];
    MasterViewController->_instanceVariableNames = @[ @"detailViewController", @"objects" ];

    // - detailViewController
    //     ^detailViewController
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       00         pushRcvr: 0
    // 01       7C         returnTop
    
    byte_t detailViewController_b[] = { 0x00, 0x7C };
    SmalltalkMethod *detailViewController = [[SmalltalkMethod alloc]
                                             initWithSelector:@"detailViewController"
                                             bytecode:[NSData dataWithBytes:detailViewController_b length:2]
                                             literals:nil];
    [MasterViewController smalltalk_addInstanceMethod:detailViewController];
    
    // - setDetailViewController: aDetailViewController
    //     detailViewController := aDetailViewController
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       10         pushTemp: 0
    // 01       60         popIntoRcvr: 0
    // 02       78         returnSelf
    
    byte_t setDetailViewController_b[] = { 0x10, 0x60, 0x78 };
    SmalltalkMethod *setDetailViewController = [[SmalltalkMethod alloc]
                                                initWithSelector:@"setDetailViewController:"
                                                bytecode:[NSData dataWithBytes:setDetailViewController_b length:3]
                                                literals:nil];
    [MasterViewController smalltalk_addInstanceMethod:setDetailViewController];

    // - numberOfSectionsInTableView: tableView
    //     ^1
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       76         pushConstant: 1
    // 01       7C         returnTop
    
    byte_t numberOfSectionsInTableView_b[] = { 0x76, 0x7C };
    SmalltalkMethod *numberOfSectionsInTableView = [[SmalltalkMethod alloc]
                                             initWithSelector:@"numberOfSectionsInTableView:"
                                             bytecode:[NSData dataWithBytes:numberOfSectionsInTableView_b length:2]
                                             literals:nil];
    [MasterViewController smalltalk_addInstanceMethod:numberOfSectionsInTableView];

    // - tableView: tableView numberOfRowsInSection: section
    //     ^objects count
    //
    // 0 = count
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       01         pushRcvr: 1
    // 01       D0         send: count                0
    // 02       7C         returnTop

    byte_t tableView_numberOfRowsInSection_b[] = { 0x01, 0xD0, 0x7C };
    SmalltalkMethod *tableView_numberOfRowsInSection = [[SmalltalkMethod alloc]
                                                    initWithSelector:@"tableView:numberOfRowsInSection:"
                                                    bytecode:[NSData dataWithBytes:tableView_numberOfRowsInSection_b length:3]
                                                    literals: @[ @"count" ]];
    [MasterViewController smalltalk_addInstanceMethod:tableView_numberOfRowsInSection];

    // tableView: tableView cellForRowAtIndexPath: indexPath
    //     | cell object |
    //     cell := tableView dequeueReusableCellWithIdentifier: 'Cell' forIndexPath: indexPath.
    //
    //     object := objects objectAtIndex: indexPath row.
    //     cell textLabel setText: object description.
    //     ^cell
    //
    // Temp:
    // 0 = tableView
    // 1 = indexPath
    // 2 = cell
    // 3 = object
    //
    // Literal:
    // 0 = dequeueReusableCellWithIdentifier:forIndexPath:
    // 1 = 'Cell'
    // 2 = objectAtIndex:
    // 3 = row
    // 4 = setText:
    // 5 = textLabel
    // 6 = description
    // 7 = setBackgroundColor:
    // 8 = contentView
    // 9 = redColor
    // 10 = UIColor
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       10         pushTemp: 0
    // 01       21         pushConstant: 'Cell'       1
    // 02       11         pushTemp: 1
    // 03       F0         send: dequeue...           0
    // 04       6A         popIntoTemp: 2
    // 05       01         pushRcvr: 1
    // 06       11         pushTemp: 1
    // 07       D3         send: row                  3
    // 08       E2         send: objectAtIndex:       2
    // 09       6B         popIntoTemp: 3
    // 10       12         pushTemp: 2
    // 11       D5         send: textLabel            5
    // 12       13         pushTemp: 3
    // 13       D6         send: description          6
    // 14       E4         send: setText              4
    // 15       87         pop
    // 16       12         pushTemp: 2
    // 17       D8         send: contentView          8
    // 18       4A         pushLit: UIColor           10
    // 19       D9         send: redColor             9
    // 20       E7         send: setBackgroundColor:  7
    // 21       87         pop
    // 22       12         pushTemp: 2
    // 23       7C         returnTop

    byte_t cellForRow_b[] = { 0x10, 0x21, 0x11, 0xF0, 0x6A, 0x01, 0x11, 0xD3, 0xE2, 0x6B, 0x12, 0xD5, 0x13, 0xD6, 0xE4, 0x87, 0x12, 0xD8, 0x4A, 0xD9, 0xE7, 0x87, 0x12, 0x7C };
    SmalltalkMethod *cellForRow = [[SmalltalkMethod alloc]
                                   initWithSelector:@"tableView:cellForRowAtIndexPath:"
                                   bytecode:[NSData dataWithBytes:cellForRow_b length:24]
                                   literals: @[@"dequeueReusableCellWithIdentifier:forIndexPath:", @"Cell", @"objectAtIndex:", @"row", @"setText:", @"textLabel", @"description", @"setBackgroundColor:", @"contentView", @"redColor", @"UIColor"]];
    [MasterViewController smalltalk_addInstanceMethod:cellForRow];

    // viewDidLoad
    //     | addButton |
    //     super viewDidLoad.
    //
    //     "Do any additional setup after loading the view, typically from a nib"
    //     self navigationItem setLeftBarButtonItem: self editButtonItem.
    //
    //     addButton := UIBarButtonItem alloc initWithBarButtonSystemItem: 4 target: self action: #'insertNewObject:'.
    //     self navigationItem setRightBarButtonItem: addButton.
    //     self setDetailViewController: self splitViewController viewControllers lastObject topViewController
    //
    // Temp:
    //
    // Literal:
    // 0 = viewDidLoad
    // 1 = setLeftBarButtonItem:
    // 2 = navigationItem
    // 3 = editButtonItem
    // 4 = initWithBarButtonSystemItem:target:action:
    // 5 = alloc
    // 6 = UIBarButtonItem
    // 7 = 4
    // 8 = #insertNewObject:
    // 9 = setRightBarButtonItem:
    // 10 = setDetailViewController:
    // 11 = topViewController
    // 12 = lastObject
    // 13 = viewControllers
    // 14 = splitViewController
    //
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       70         self
    // 01       85 00      superSend: viewDidLoad     0
    // 03       87         pop
    // 04       70         self
    // 05       D2         send: navigationItem       2
    // 06       70         self
    // 07       D3         send: editButtonItem       3
    // 08       E1         send: setLeftBarButtonItem:1
    // 09       87         pop
    // 10       46         pushLit: UIBarButtonItem   6
    // 11       D5         send: alloc                5
    // 12       27         pushConstant: 4
    // 13       70         self
    // 14       28         pushConstant: #insertNewObject:  8
    // 15       83 64      send: initWithBarButtonSystemItem:target:action:     4
    // 17       68         popIntoTemp: 0
    // 18       70         self
    // 19       D2         send: navigationItem       2
    // 20       10         pushTemp: 0
    // 21       E9         send: setRightBarButtonItem:   9
    // 22       87         pop
    // 23       70         self
    // 24       70         self
    // 25       DE         send: splitViewController  14
    // 26       DD         send: viewControllers      13
    // 27       DC         send: lastObject           12
    // 28       DB         send: topViewController    11
    // 29       EA         send: setDetailViewController:   10
    // 30       87         pop
    // 31       78         returnSelf

//    
//    byte_t viewDidLoad_b[] = { 0x70, 0x85, 0x00, 0x87, 0x70, 0xD2, 0x70, 0xD3, 0xE1, 0x87, 0x46, 0xD5, 0x27, 0x70, 0x28, 0x83, 0x64, 0x68, 0x70, 0xD2, 0x10, 0xE9, 0x87, 0x70, 0x70, 0xDE, 0xDD, 0xDC, 0xDB, 0xEA, 0x87, 0x78 };
//    SmalltalkMethod *viewDidLoad = [[SmalltalkMethod alloc]
//                                   initWithSelector:@"viewDidLoad"
//                                   bytecode:[NSData dataWithBytes:viewDidLoad_b length:32]
//                                   literals: @[@"viewDidLoad", @"setLeftBarButtonItem:", @"navigationItem", @"editButtonItem", @"initWithBarButtonSystemItem:target:action:", @"alloc", @"UIBarButtonItem", @"4", @"#insertNewObject:", @"setRightBarButtonItem:", @"setDetailViewController:", @"topViewController", @"lastObject", @"viewControllers", @"splitViewController"]];
//
//    [MasterViewController smalltalk_addInstanceMethod:viewDidLoad];
}

int main(int argc, char *argv[])
{
    @autoreleasepool {
        SmalltalkVM *vm = [SmalltalkVM sharedVM];
        [vm initializeVM];
        
        InitializeAppDelegateClass();
        InitializeMasterViewControllerClass();

        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
