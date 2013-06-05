//
//  AppDelegate.h
//  Family_ipad
//
//  Created by walt.chan on 12-12-30.
//  Copyright (c) 2012年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKMacros.h"
#import "SinaWeibo.h"
#define kAppKey             @"3005439488"
#define kAppSecret          @"5de4cc0d5fda710c482989ac7250750c"
#define kAppRedirectURI     @"http://www.familyday.com.cn"
#define REMOVEDETAIL   [[AppDelegate instance].rootViewController.stackScrollViewController removeThirdView]

@class RootViewController;
@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate, SinaWeiboRequestDelegate>

+ (AppDelegate *) instance;
- (void)logout;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (nonatomic, assign) BOOL isAppInBackground;

@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
- (void)showLoginView;
- (void)setUpRootView;
- (void)uploadToken:(NSString*)deviceToken;
@end
