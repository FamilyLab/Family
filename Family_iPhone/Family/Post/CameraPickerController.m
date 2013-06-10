//
//  CameraPickerController.m
//  Family
//
//  Created by Aevitx on 13-6-4.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CameraPickerController.h"
#import "MyTabBarController.h"

@interface CameraPickerController ()

@end

@implementation CameraPickerController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer < 5.0) {
        UINavigationController *nav = (UINavigationController*)self.parentViewController;
        MyTabBarController *tabBarCon = (MyTabBarController*)[nav.viewControllers objectAtIndex:0];
        [tabBarCon hideCameraBottomBar];
    } else {
        UINavigationController *nav = (UINavigationController*)self.presentingViewController;
        MyTabBarController *tabBarCon = (MyTabBarController*)[nav.viewControllers objectAtIndex:0];
        [tabBarCon hideCameraBottomBar];
    }
//    if (_overlayViewCon.bottomBar) {
//        _overlayViewCon.bottomBar.hidden = YES;
//    }
}

@end
