//
//  BaseViewController.m
//  Family
//
//  Created by Aevitx on 13-1-17.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "UIViewWithShadow.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (IBAction)backAction:(id)sender
{
    if (self.navigationController) 
        [self.navigationController popViewControllerAnimated:YES];
    else
        REMOVEDETAIL;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // register as observer for theme status
        [self regitserAsObserver];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initViews];
    [self configureViews];
    UIViewWithShadow* verticalLineView = [[UIViewWithShadow alloc] initWithFrame:CGRectMake(-40, 0, 40 , contentView.frame.size.height)] ;
    [verticalLineView setBackgroundColor:[UIColor clearColor]];
    [verticalLineView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [verticalLineView setClipsToBounds:NO];
    [contentView addSubview:verticalLineView];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: verticalLineView];

    UIViewWithShadow *otherShadow = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    otherShadow.frame = CGRectMake(contentView.frame.origin.x+contentView.frame.size.width-40, 0, 40, contentView.frame.size.height);
    [contentView addSubview:otherShadow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self unregisterAsObserver];
}

#pragma mark - Theme Methods

//#warning                                                      \
//You'd better alloc the views, associated with theme changing, \
//in 'initViews' first, then set them in 'configureViews'.

- (void)initViews {
    // may do nothing, implement by the subclass
}

//主题改变后，子类里的这个方法负责做相应的改变
- (void)configureViews {
    
}

- (void)regitserAsObserver {
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureViews) name:THEME_CHANGE object:nil];
}

- (void)unregisterAsObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
     
     

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
