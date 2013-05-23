//
//  main.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import <objc/message.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>


#import "KernelObjects.h"
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
    // 9 = SmalltalkSocketServer
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
    NSArray *literals = @[ @"rootViewController", @"window", @"lastObject", @"viewControllers", @"setDelegate:", @"topViewController", @"userInterfaceIdiom", @"currentDevice", @"UIDevice", @"SmalltalkSocketServer", @"sharedServer", @"start" ];
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
    //     ^20
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       20         pushConstant: 10
    // 01       7C         returnTop
    
    byte_t numberOfSectionsInTableView_b[] = { 0x20, 0x7C };
    SmalltalkMethod *numberOfSectionsInTableView = [[SmalltalkMethod alloc]
                                             initWithSelector:@"numberOfSectionsInTableView:"
                                             bytecode:[NSData dataWithBytes:numberOfSectionsInTableView_b length:2]
                                             literals:@[[Integer $c:20]]];
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
    
    
    // - tableView: tableView numberOfRowsInSection: section
    //     ^10
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       20         pushConstant: 10
    // 01       7C         returnTop
    
    byte_t tableView_numberOfRowsInSection_b2[] = { 0x20, 0x7C };
    SmalltalkMethod *tableView_numberOfRowsInSection2 = [[SmalltalkMethod alloc]
                                                        initWithSelector:@"tableView:numberOfRowsInSection:"
                                                        bytecode:[NSData dataWithBytes:tableView_numberOfRowsInSection_b2 length:2]
                                                         literals: @[[Integer $c:10]]];
    [MasterViewController smalltalk_addInstanceMethod:tableView_numberOfRowsInSection2];


    
    // tableView: tableView cellForRowAtIndexPath: indexPath
    //     | cell |
    //     cell := tableView dequeueReusableCellWithIdentifier: 'Cell' forIndexPath: indexPath.
    //     cell textLabel setText: 'Row ', indexPath row asString.
    //     cell contentView setBackgroundColor: UIColor redColor.
    //     ^cell
    //
    //
    // Index    Bytecode   Assembly                   Literal
    //
    // 00       10         pushTemp: 0
    // 01       20         pushConstant: 'Cell'       0
    // 02       11         pushTemp: 1
    // 03       F1         send: dequeue...           1
    // 04       6A         popIntoTemp: 2
    
    // 05       12         pushTemp: 2
    // 06       D6         send: textLabel            6

    // 07       22         pushConstant: 'Row '       2
    // 08       11         pushTemp: 1
    // 09       D3         send: row                  3
    // 10       D4         send: asString             4
    // 11       E5         send: ,                    5

    // 12       E7         send: setText:             7
    // 13       87         pop

    // 14       12         pushTemp: 2
    // 15       D8         send: contentView          8

    // 16       49         pushLit: UIColor           9
    // 17       DA         send: redColor             10

    // 18       EB         send: setBackgroundColor:  11
    // 19       87         pop
    
    // 20       12         pushTemp: 2
    // 21       7C         returnTop
    
    // Temp:
    // 0 = tableView
    // 1 = indexPath
    // 2 = cell
    //
    // Literals:
    // 0 = 'Cell'
    // 1 = dequeueReusableCellWithIdentifier:forIndexPath:
    // 2 = 'Row '
    // 3 = row
    // 4 = asString
    // 5 = ,
    // 6 = textLabel
    // 7 = setText:
    // 8 = contentView
    // 9 = UIColor
    // 10 = grayColor
    // 11 = setBackgroundColor:
    
    
    byte_t cellForRow_b2[] = { 0x10, 0x20, 0x11, 0xF1, 0x6A, 0x12, 0xD6, 0x22, 0x11, 0xD3, 0xD4, 0xE5, 0xE7, 0x87, 0x12, 0xD8, 0x49, 0xDA, 0xEB, 0x87, 0x12, 0x7C };
    SmalltalkMethod *cellForRow2 = [[SmalltalkMethod alloc]
                                   initWithSelector:@"tableView:cellForRowAtIndexPath:"
                                   bytecode:[NSData dataWithBytes:cellForRow_b2 length:22]
                                    literals: @[@"Cell", @"dequeueReusableCellWithIdentifier:forIndexPath:", [String $oc:@"Row "], @"row", @"asString", @",", @"textLabel", @"setText:", @"contentView", @"UIColor", @"grayColor", @"setBackgroundColor:"]];
    [MasterViewController smalltalk_addInstanceMethod:cellForRow2];

    
    
    
    
    
    
    
    
    
    
    // tableView: tableView titleForHeaderInSection: section
    //     ^ 'Section ', section asString
    //
//    25 <21> pushConstant: 'Section '
//    26 <11> pushTemp: 1
//    27 <D2> send: asString
//    28 <E0> send: ,
//    29 <7C> returnTop
    
    byte_t titleForHeader_b[] = { 0x21, 0x11, 0xD2, 0xE0, 0x7C };
    SmalltalkMethod *titleForHeader = [[SmalltalkMethod alloc]
                                       initWithSelector:@"tableView:titleForHeaderInSection:"
                                       bytecode:[NSData dataWithBytes:titleForHeader_b length:5]
                                       literals:@[@",", [String $oc:@"Section "], @"asString"]];
    [MasterViewController smalltalk_addInstanceMethod:titleForHeader];

    // viewDidLoad
    //     | addButton |
    //     super viewDidLoad.
    //
    //     "Do any additional setup after loading the view, typically from a nib"
    //     self navigationItem setLeftBarButtonItem: self editButtonItem.
    //
    //     addButton := UIBarButtonItem alloc initWithBarButtonSystemItem: 4 target: self action: #insertNewObject:.
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






@interface CompiledAppDelegate : NSObject
@end

@implementation CompiledAppDelegate {
    id window;
}

/*
 window
     ^window
 */
- window {
    return window;
}

/*
 setWindow: aWindow
     window := aWindow
 */

- setWindow: aWindow {
    window = aWindow;
    return self;
}

/*
 application: application didFinishLaunchingWithOptions: launchOptions
     UIDevice currentDevice userInterfaceIdiom = UIUserInterfaceIdiomPad
         ifTrue: [| splitViewController navigationController |
                  splitViewController := self window rootViewController.
                  navigationController := splitViewController viewControllers lastObject.
                  splitViewController setDelegate: navigationController topViewController].
     ^true
 */

- (BOOL)application: application didFinishLaunchingWithOptions: launchOptions {
    Class literal_0 = NSClassFromString(@"UIDevice");
    id t_id_0 = objc_msgSend(literal_0, @selector(currentDevice));
    int t_int_0 = (int)objc_msgSend(t_id_0, @selector(userInterfaceIdiom));
    BOOL t_bool_0 = t_int_0 == UIUserInterfaceIdiomPad;
    
    if (!t_bool_0) goto l_0;
    
    {
        id splitViewController;
        id navigationController;
        
        t_id_0 = objc_msgSend(self, @selector(window));
        t_id_0 = objc_msgSend(t_id_0, @selector(rootViewController));
        splitViewController = t_id_0;
        t_id_0 = objc_msgSend(splitViewController, @selector(viewControllers));
        t_id_0 = objc_msgSend(t_id_0, @selector(lastObject));
        navigationController = t_id_0;
        id t_id_0 = objc_msgSend(navigationController, @selector(topViewController));
        (void)objc_msgSend(splitViewController, @selector(setDelegate:), t_id_0);
    }
    
l_0:
    return YES;
}

@end





@interface XMasterViewController : UIViewController
@end

@implementation XMasterViewController {
    id detailViewController;
    id objects;
}

/*
 detailViewController
     ^detailViewController
 */
- detailViewController {
    return detailViewController;
}

/*
 setDetailViewController: aDetailViewController
     detailViewController := aDetailViewController
 */

- setDetailViewController: aDetailViewController {
    detailViewController = aDetailViewController;
    return self;
}

/*
 numberOfSectionsInTableView: tableView
     ^1
 */

- (int)numberOfSectionsInTableView: tableView {
    return 1;
}


/*
 tableView: tableView numberOfRowsInSection: section
     ^objects count
*/

- (int)tableView: tableView numberOfRowsInSection:(int)section
{
    int t_int_0 = (int)objc_msgSend(objects, @selector(count));
    return t_int_0;
}


// viewDidLoad
//     | addButton |
//     super viewDidLoad.
//
//     objects := NSMutableArray new.
//
//     "Do any additional setup after loading the view, typically from a nib"
//     self navigationItem setLeftBarButtonItem: self editButtonItem.
//
//     addButton := UIBarButtonItem alloc initWithBarButtonSystemItem: 4 target: self action: #'insertNewObject:'.
//     self navigationItem setRightBarButtonItem: addButton.
//     self setDetailViewController: self splitViewController viewControllers lastObject topViewController

- (void)viewDidLoad
{
    SmalltalkVM *vm = [SmalltalkVM sharedVM];

    id addButton;
    id literal_0 = [vm->_globalVariables objectForKey:@"NSMutableArray"];
    id literal_1 = [vm->_globalVariables objectForKey:@"UIBarButtonItem"];

    id t_id_0, t_id_1;

    t_id_0 = objc_msgSend(literal_0, @selector(new));
    objects = t_id_0;

    t_id_0 = objc_msgSend(self, @selector(editButtonItem));
    t_id_1 = objc_msgSend(self, @selector(navigationItem));
    (void)objc_msgSend(t_id_1, @selector(setLeftBarButtonItem:), t_id_0);

    t_id_0 = objc_msgSend(literal_1, @selector(alloc));
    t_id_0 = objc_msgSend(t_id_0, @selector(initWithBarButtonSystemItem:target:action:), 4, self, @selector(insertNewObject:));
    addButton = t_id_0;
    t_id_0 = objc_msgSend(self, @selector(navigationItem));
    (void)objc_msgSend(t_id_0, @selector(setRightBarButtonItem:), addButton);
    t_id_0 = objc_msgSend(self, @selector(splitViewController));
    t_id_0 = objc_msgSend(self, @selector(viewControllers));
    t_id_0 = objc_msgSend(self, @selector(lastObject));
    t_id_0 = objc_msgSend(self, @selector(topViewController));
    objc_msgSend(self, @selector(setDetailViewController:), t_id_0);
}



/*
 application: application didFinishLaunchingWithOptions: launchOptions
 UIDevice currentDevice userInterfaceIdiom = UIUserInterfaceIdiomPad
 ifTrue: [| splitViewController navigationController |
 splitViewController := self window rootViewController.
 navigationController := splitViewController viewControllers lastObject.
 splitViewController setDelegate: navigationController topViewController].
 ^true
 */

- (BOOL)application: application didFinishLaunchingWithOptions: launchOptions {
    Class literal_0 = NSClassFromString(@"UIDevice");
    id t_id_0 = objc_msgSend(literal_0, @selector(currentDevice));
    int t_int_0 = (int)objc_msgSend(t_id_0, @selector(userInterfaceIdiom));
    BOOL t_bool_0 = t_int_0 == 4;
    
    if (!t_bool_0) goto l_0;
    
    {
        id splitViewController;
        id navigationController;
        
        t_id_0 = objc_msgSend(self, @selector(window));
        t_id_0 = objc_msgSend(t_id_0, @selector(rootViewController));
        splitViewController = t_id_0;
        t_id_0 = objc_msgSend(splitViewController, @selector(viewControllers));
        t_id_0 = objc_msgSend(t_id_0, @selector(lastObject));
        navigationController = t_id_0;
        id t_id_0 = objc_msgSend(navigationController, @selector(topViewController));
        (void)objc_msgSend(splitViewController, @selector(setDelegate:), t_id_0);
    }
    
l_0:
    return YES;
}

@end








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
