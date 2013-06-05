//
//  GuideViewController.m
//  atFaXian
//  用户指引视图控制器
//  Created by Huang Minamiyama on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuideViewController.h"
#import "CKMacros.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "ConciseKit.h"
#import "web_config.h"
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
@interface GuideViewController ()

@end

@implementation GuideViewController
@synthesize father, selector;
- (IBAction)dismissAction:(id)sender
{
    if (father) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.navigationController) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        [[AppDelegate instance]setUpRootView];

    }
    else
        [self dismissModalViewControllerAnimated:YES];

}

/**
 移除用户指引视图
 @param 发送消息的对象
 @return 无
 */
- (void)overSlideBtnPressed:(id)sender {
    if (father != nil) {
        if ([father respondsToSelector:selector]) {
            [father performSelector:selector withObject:nil afterDelay:0.02f];
            [self dismissModalViewControllerAnimated:NO];
            return;
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle 
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
    _scrollview.contentSize = CGSizeMake(self.view.frame.size.width*4, self.view.frame.size.height);
    _scrollview.backgroundColor = mwbgColor();
    [ConciseKit setUserDefaultsWithObject:$bool(NO) forKey:FIRST_SHOW_MARK];


}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
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
