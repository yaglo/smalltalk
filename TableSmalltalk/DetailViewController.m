//
//  DetailViewController.m
//  TableSmalltalk
//
//  Created by Stanislav Yaglo on 3/9/13.
//  Copyright (c) 2013 Stanislav Yaglo. All rights reserved.
//

#import "DetailViewController.h"
#import "SmalltalkClass.h"
#import "SmalltalkVM.h"
#import "KernelObjects.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
    self.codeTextView.delegate = self;
    self.codeTextView.text =
    @"00  10  pushTemp: 0\n"
    @"01  20  pushConstant: 'Cell'       0\n"
    @"02  11  pushTemp: 1\n"
    @"03  F1  send: dequeue...           1\n"
    @"04  6A  popIntoTemp: 2\n"
    @"05  12  pushTemp: 2\n"
    @"06  D6  send: textLabel            6\n"
    @"07  22  pushConstant: 'Row '       2\n"
    @"08  11  pushTemp: 1\n"
    @"09  D3  send: row                  3\n"
    @"10  D4  send: asString             4\n"
    @"11  E5  send: ,                    5\n"
    @"12  E7  send: setText:             7\n"
    @"13  87  pop\n"
    @"14  12  pushTemp: 2\n"
    @"15  D8  send: contentView          8\n"
    @"16  49  pushLit: UIColor           9\n"
    @"17  DA  send: redColor             10\n"
    @"18  EB  send: setBackgroundColor:  11\n"
    @"19  87  pop\n"
    @"20  12  pushTemp: 2\n"
    @"21  7C  returnTop\n"
    @"!!\n"
    @"00  Cell\n"
    @"01  dequeueReusableCellWithIdentifier:forIndexPath:\n"
    @"02  'Row '\n"
    @"03  row\n"
    @"04  asString\n"
    @"05  ,\n"
    @"06  textLabel\n"
    @"07  setText:\n"
    @"08  contentView\n"
    @"09  UIColor\n"
    @"10  whiteColor\n"
    @"11  setBackgroundColor:\n";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSString *code = [self.codeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSArray *parts = [code componentsSeparatedByString:@"!!"];
        
        NSString *bytecodePart = [[parts objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *literalsPart = [[parts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableData *bytecodeData = [[NSMutableData alloc] init];
        
        for (NSString *line in [bytecodePart componentsSeparatedByString:@"\n"]) {
            unsigned int byte = 0;
            byte_t bytes[1];
            
            NSArray *lineParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *bytecode = [lineParts objectAtIndex:2];
            NSScanner *scanner = [[NSScanner alloc] initWithString:bytecode];
            [scanner scanHexInt:&byte];
            
            bytes[0] = byte;
            [bytecodeData appendBytes:bytes length:1];
        }
        
        NSMutableArray *literals = [[NSMutableArray alloc] init];
        
        for (NSString *line in [literalsPart componentsSeparatedByString:@"\n"]) {
//            NSArray *lineParts = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
//            NSString *literal = [[lineParts objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *literal = [line substringWithRange:NSMakeRange(4, [line length] - 4)];
            
            if ([[literal substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"'"]) {
                literal = (id)[String $oc:[literal substringWithRange:NSMakeRange(1, [literal length] - 2)]];
            }
            [literals addObject:literal];
        }
        
        SmalltalkVM *vm = [SmalltalkVM sharedVM];
        SmalltalkClass *class = [vm->_globalVariables objectForKey:@"MasterViewController"];
        SmalltalkMethod *method = [[SmalltalkMethod alloc]
                                   initWithSelector:@"tableView:cellForRowAtIndexPath:"
                                   bytecode:bytecodeData
                                   literals:literals];
        
        [class smalltalk_addInstanceMethod:method];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
