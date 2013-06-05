//
//  PostBaseViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "PostBaseViewController.h"
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import "MyHttpClient.h"
#import "UIViewWithShadow.h"
#import "PostBaseView.h"
#import "DetailBaseViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
@interface PostBaseViewController ()

@end

@implementation PostBaseViewController
- (IBAction)backAction:(id)sender
{
    if ([self respondsToSelector:@selector(presentingViewController)]) {
        if (self.presentingViewController)
            [self dismissModalViewControllerAnimated:YES];
        else{
            REMOVEDETAIL;
        }

    }
    else{
            [self dismissModalViewControllerAnimated:YES];
            REMOVEDETAIL;
    }

}
- (IBAction)selectFamily:(UIButton *)sender
{

    
    DetailBaseViewController *con = [[DetailBaseViewController alloc]initWithNibName:@"DetailBaseViewController" bundle:nil];
    con.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:con animated:YES];
    con.view.superview.frame = CGRectMake(0, 0, 480, 768);//it's important to do this after
    con.view.superview.center = CGPointMake(1024/2, 768/2);
}

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
	// Do any additional setup after loading the view.
  
    self.postView.parent = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
