//
//  AppDelegate.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "weixinSDK/WXApi.h"
#import "MLNavigationController.h"

@class MyTabBarController;
@class SinaWeibo;
@class TopicView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MyTabBarController *tabBarCon;
//@property (strong, nonatomic) MLNavigationController *navCon;
@property (strong, nonatomic) UINavigationController *navCon;
@property (readonly, nonatomic) SinaWeibo *sinaweibo;

@property (nonatomic, assign) BOOL isAppInBackground;

@property (nonatomic, assign) BOOL isFirstShow;
@property (nonatomic, assign) BOOL isLogout;

@property (nonatomic, copy) NSString *sendToWeixinContent;

+ (AppDelegate*)app;

- (void)logoutFamily;
- (void)pushAController:(UIViewController*)_con;
- (void)popAController;
- (void)uploadToken:(NSString*)deviceToken;
//- (void)sendRequestForTopic:(id)sender;
- (void)buildLoginConWithTopicView:(TopicView*)aView;
- (void)loading:(BOOL)_hasLogin;

@end


@interface UIWindow (Extensions)
- (UIViewController *)topMostController;
@end