//
//  BaseTableViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIViewWithShadow.h"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController
@synthesize header;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.backgroundColor = [UIColor clearColor];
    UIViewWithShadow* verticalLineView = [[UIViewWithShadow alloc] initWithFrame:CGRectMake(-40, 0, 40 , self.view.frame.size.height)] ;
    [verticalLineView setBackgroundColor:[UIColor clearColor]];
    [verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [verticalLineView setClipsToBounds:NO];
    [self.view addSubview:verticalLineView];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
