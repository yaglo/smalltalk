/*
 * AppController.j
 * Smalltalk
 *
 * Created by Stanislav Yaglo on March 13, 2013.
 * Copyright 2013 Stanislav Yaglo. All Rights Reserved. 
 */

@import <Foundation/CPObject.j>

@implementation AppController : CPObject {
    CPWindow window;

    CPTableView packagesTableView;
    CPTableView classesTableView;
    CPTableView categoriesTableView;
    CPTableView methodsTableView;
    CPArray packages;
    CPArray classes;
    CPArray categories;
    CPArray methods;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    [CPMenu setMenuBarVisible:YES];

    packages = [[CPArray alloc] init];
    [packages addObject:@"Smalltalk"];
    [packages addObject:@"AppKit"];
    [packages addObject:@"Foundation"];
    [packages addObject:@"SampleApplication"];

    classes = [[CPArray alloc] init];
    [classes addObject:@"AppDelegate"];
    [classes addObject:@"MasterViewController"];

    categories = [[CPArray alloc] init];
    [categories addObject:@"-- all --"];
    [categories addObject:@"properties"];
    [categories addObject:@"table view data source"];
    [categories addObject:@"table view delegate"];
    [categories addObject:@"view controller lifecycle"];

    methods = [[CPArray alloc] init];
    [methods addObject:@"viewDidLoad"];

    var window = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [window contentView];

    [contentView setBackgroundColor: [CPColor colorWithHexString:@"F1F1F1"]];
    
    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(
        -1,
        -1,
        CGRectGetWidth([contentView bounds]) / 4 + 1,
        CGRectGetHeight([contentView bounds]) / 3)];

    [scrollView setBorderType:CPLineBorder];
    [scrollView setHasHorizontalScroller:NO];
    tableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setTag:0];
    //[tableView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    
    var theColumn = [[CPTableColumn alloc] initWithIdentifier:@"packagesColumn"];
    [[theColumn headerView] setStringValue:@"Packages"];
    [theColumn setMinWidth:CGRectGetWidth([contentView bounds]) / 4 - 20];
    [tableView addTableColumn:theColumn];
    [scrollView setDocumentView:tableView];
    
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [contentView addSubview:scrollView];
    
    [tableView selectRowIndexes:[[CPIndexSet alloc] initWithIndex:3] byExtendingSelection:NO];

    packagesTableView = tableView;

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(
        CGRectGetWidth([contentView bounds]) / 4 - 1,
        -1, CGRectGetWidth([contentView bounds]) / 4,
        CGRectGetHeight([contentView bounds]) / 3 - 40)];

    [scrollView setBorderType:CPLineBorder];
    [scrollView setHasHorizontalScroller:NO];
    tableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setTag:1];
    //[tableView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    theColumn = [[CPTableColumn alloc] initWithIdentifier:@"classesColumn"];
    [[theColumn headerView] setStringValue:@"Classes"];
    [theColumn setMinWidth:CGRectGetWidth([contentView bounds]) / 4 - 20];
    [tableView addTableColumn:theColumn];
    [scrollView setDocumentView:tableView];

    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [contentView addSubview:scrollView];

    [tableView selectRowIndexes:[[CPIndexSet alloc] initWithIndex:1] byExtendingSelection:NO];

    classesTableView = tableView;

    var segmentedWidth = CGRectGetWidth([contentView bounds]) / 4 - 16;
    var segmented = [[CPSegmentedControl alloc] initWithFrame:CGRectMake(
        CGRectGetWidth([contentView bounds]) / 4 + 8,
        CGRectGetHeight([contentView bounds]) / 3 - 33,
        segmentedWidth, 24)];

    [segmented setSegmentCount:3];
    [segmented setLabel:@"instance" forSegment:0];
    [segmented setSelected:YES forSegment:0];
    [segmented setWidth:(segmentedWidth - 30) / 2 forSegment:0];
    [segmented setLabel:@"?" forSegment:1];
    [segmented setWidth:30 forSegment:1];
    [segmented setLabel:@"class" forSegment:2];
    [segmented setWidth:(segmentedWidth - 30) / 2 forSegment:2];
    [contentView addSubview:segmented];

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(
        CGRectGetWidth([contentView bounds]) / 2 - 1,
        -1,
        CGRectGetWidth([contentView bounds]) / 4 + 1,
        CGRectGetHeight([contentView bounds]) / 3)];

    [scrollView setBorderType:CPLineBorder];
    [scrollView setHasHorizontalScroller:NO];
    tableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setTag:2];
    //[tableView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    theColumn = [[CPTableColumn alloc] initWithIdentifier:@"categoriesColumn"];
    [[theColumn headerView] setStringValue:@"Categories"];
    [theColumn setMinWidth:CGRectGetWidth([contentView bounds]) / 4 - 20];
    [tableView addTableColumn:theColumn];
    [scrollView setDocumentView:tableView];

    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [contentView addSubview:scrollView];

    [tableView selectRowIndexes:[[CPIndexSet alloc] initWithIndex:4] byExtendingSelection:NO];
    
    categoriesTableView = tableView;

    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(
        CGRectGetWidth([contentView bounds]) / 2 + CGRectGetWidth([contentView bounds]) / 4 - 1,
        -1,
        CGRectGetWidth([contentView bounds]) / 4 + 1,
        CGRectGetHeight([contentView bounds]) / 3)];

    [scrollView setBorderType:CPLineBorder];
    [scrollView setHasHorizontalScroller:NO];
    tableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
    [tableView setUsesAlternatingRowBackgroundColors:YES];
    [tableView setTag:3];
    //[tableView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];

    theColumn = [[CPTableColumn alloc] initWithIdentifier:@"methodsColumn"];
    [[theColumn headerView] setStringValue:@"Methods"];
    [theColumn setMinWidth:CGRectGetWidth([contentView bounds]) / 4 - 20];
    [tableView addTableColumn:theColumn];
    [scrollView setDocumentView:tableView];

    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [contentView addSubview:scrollView];

    [tableView selectRowIndexes:[[CPIndexSet alloc] initWithIndex:0] byExtendingSelection:NO];

    categoriesTableView = tableView;

    var codeView = [[CPWebView alloc] initWithFrame:CGRectMake(
        -1,
        CGRectGetHeight([contentView bounds]) / 3 - 1,
        CGRectGetWidth([contentView bounds]) + 2,
        CGRectGetHeight([contentView bounds]) - CGRectGetHeight([contentView bounds]) / 3)];

    [codeView setMainFrameURL:@"http://localhost/~stam/Smalltalk/code.html"];
    [contentView addSubview:codeView];

    [window orderFront:self];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
    switch ([aTableView tag]) {
        case 0: return [packages count];
        case 1: return [classes count];
        case 2: return [categories count];
        case 3: return [methods count];
    }
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aTableColumn row:(int)rowIndex
{
    switch ([aTableView tag]) {
        case 0: return [packages objectAtIndex:rowIndex];
        case 1: return [classes objectAtIndex:rowIndex];
        case 2: return [categories objectAtIndex:rowIndex];
        case 3: return [methods objectAtIndex:rowIndex];
    }
        return 
}

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
}

@end
