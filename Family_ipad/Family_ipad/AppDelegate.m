//
//  AppDelegate.m
//  Family_ipad
//
//  Created by walt.chan on 12-12-30.
//  Copyright (c) 2012年 walt.chan. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoadingViewController.h"
#import "DCIntrospect.h"
#import "PDKeychainBindings.h"
#import "web_config.h"
#import "JMImageCache.h"
#import "MyHttpClient.h"
#import "MenuViewController.h"
#import "DetailViewController.h"
#import "StackScrollViewController.h"
#import "ApplyFamilyViewController.h"
#import "LoadingView.h"
#import "MobClick.h"
#import "ZoneWaterFallView.h"
#import "KGModal.h"
#define umengAppKey @"5151df2256240bba2a004e89"
@implementation AppDelegate
- (void)setUpRootView
{
//    if ([[ConciseKit userDefaultsObjectForKey: TOPIC_MARK] boolValue])
//        [self.rootViewController loadTodayTopic];
//    else
        [self.rootViewController setUpUI];
}
- (void)store:(NSString *)username
     password:(NSString *)password
       m_auth:(NSString *)m_auth
{
    
}
- (void)clearKeyChain
{
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:USER_NAME];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:PASSWORD];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:SINA_UID];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:SINA_TOKEN];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:QQ_UID];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:M_AUTH];
}
- (void)clearConciskit
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
- (void)logout
{
    [self uploadToken:@""];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_LOGIN];

    [[NSUserDefaults standardUserDefaults] synchronize];
    [ConciseKit removeUserDafualtForKey:UID];
    [ConciseKit removeUserDafualtForKey:NAME];
    [ConciseKit removeUserDafualtForKey:AVATER];
    [ConciseKit removeUserDafualtForKey:AVATAR_URL];
    [self clearConciskit];
    [ConciseKit setUserDefaultsWithObject:$bool(NO) forKey:FIRST_SHOW_MARK];
    [ConciseKit setUserDefaultsWithObject:$bool(YES) forKey:TOPIC_MARK];
    [ConciseKit setUserDefaultsWithObject:$bool(1) forKey:IS_COOKIE];

    [self clearKeyChain];
    [self showLoginView];
}
- (void)showLoginView {
    LoadingViewController *con = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    UINavigationController *adNav = [[UINavigationController alloc] initWithRootViewController:con];
    adNav.navigationBarHidden = YES;
    [self.rootViewController presentModalViewController:adNav animated:NO];
}
+ (AppDelegate *) instance
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];

}
- (void)handlePushNotification:(NSDictionary *)dict
{
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _isAppInBackground = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //clear avatar cache
    [[JMImageCache sharedCache] removeAllObjects];
    if ([ConciseKit userDefaultsObjectForKey:AVATER]) {
        [ConciseKit removeUserDafualtForKey:AVATER];
    }
    if (IS_FIRST_SHOW == nil) {
        [ConciseKit setUserDefaultsWithObject:$bool(YES) forKey:FIRST_SHOW_MARK];
        [ConciseKit setUserDefaultsWithObject:$bool(1) forKey:TOPIC_MARK];
        [ConciseKit setUserDefaultsWithObject:$bool(1) forKey:IS_COOKIE];

    }
    if (!MY_AUTO_LOGIN) {
        [ConciseKit setUserDefaultsWithObject:$bool(0) forKey:HAS_LOGIN];

    }
    _rootViewController  = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    _navigationController = [[UINavigationController alloc]initWithRootViewController:_rootViewController];
    _navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    [MobClick startWithAppkey:umengAppKey reportPolicy:SENDWIFIONLY channelId:nil];
    [MobClick checkUpdate:@"有新版本啦" cancelButtonTitle:@"跳过" otherButtonTitles:@"去更新"];
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    //注册推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    //这里处理应用程序如果没有启动,但是是通过通知消息打开的,此时可以获取到消息.
    if (MY_HAS_LOGIN && launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleNotification:userInfo isAppNotStart:YES];

    }
    if (!MY_HAS_LOGIN) {
//        ZoneWaterFallView *view = [[ZoneWaterFallView alloc]initWithFrame:CGRectMake(0, 0, 1024-100, 768)];
//        view.contentType = TODAY_TOPIC;
//        [view loadDataSource:[NSNumber numberWithInt:TODAY_TOPIC]];
//        ((KGModal *)[KGModal sharedInstance]).afterClose = YES;
//        [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];
        [self showLoginView];
    }
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
}

#endif
- (void)handleNotification:(NSDictionary *)userInfo
              isAppNotStart:(BOOL)isAppNotStart
{
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badge > 0) {
        badge--;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    NSLog(@"didReceive:%@", userInfo);
    NSString *pushBodyStr = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    NSLog(@"接收通知：%@", pushBodyStr);
    //NSString *pushIdType = [userInfo objectForKey:@"idtype"];

    if ([$safe([userInfo objectForKey:FEED_ID_TYPE])isEqualToString:PM_ID]) {
        [_rootViewController.menuViewController menuButtonAction:_rootViewController.menuViewController.messageButton];
    }
    else if ([$safe([userInfo objectForKey:FEED_ID_TYPE])isEqualToString:FRIEND]){
        [_rootViewController.menuViewController menuButtonAction:_rootViewController.menuViewController.moreButton];
        ApplyFamilyViewController *detailViewController = [[ApplyFamilyViewController alloc] initWithNibName:@"ApplyFamilyViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:nil isStackStartView:FALSE];
    }
    else{
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        detailViewController.idType = emptystr([userInfo objectForKey:FEED_ID_TYPE]);
        detailViewController.feedId = [NSString stringWithFormat:@"%d", [[userInfo objectForKey:ID_] intValue]] ;
        detailViewController.userId =  [NSString stringWithFormat:@"%d", [[userInfo objectForKey:UID] intValue]];
        detailViewController.feedCommentId = [NSString stringWithFormat:@"%d", [[userInfo objectForKey:UID] intValue]];
        //detailViewController.indexRow = indexPath.row;
        REMOVEDETAIL;
        
        [self.rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:nil isStackStartView:FALSE];
    }
}
- (void)uploadToken:(NSString*)deviceToken
{
    
    BOOL deviceIsPad = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone);
    if (deviceIsPad) {
        NSString *url = @"http://www.familyday.com.cn/capi/token2.php";
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:MY_UID, UID, deviceToken, @"token", nil];
        if (para) {
            [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            } onCompletion:^(NSDictionary *dict) {
                
            } failure:^(NSError *error) {
                NSLog(@"error:%@", [error description]);
            }];
        }
    }
    
 
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *tokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"devToken=%@", tokenStr);

    tokenStr = [tokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (MY_HAS_LOGIN && MY_DEVICE_TOKEN && ![tokenStr isEqualToString:MY_DEVICE_TOKEN]) {
        [self uploadToken:tokenStr];
    }
    [[PDKeychainBindings sharedKeychainBindings] setObject:tokenStr forKey:DEVICE_TOKEN];




}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
    NSLog(@"Error in registration. Error: %@", error);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_isAppInBackground) {
        [self handleNotification:userInfo isAppNotStart:NO];

    }
   
    
    //    [SVProgressHUD showSuccessWithStatus:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]];
    //    NSLog(@"远程通知");
    
    //    // 取得 APNs 标准信息内容
    //    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    //
    //    // 取得自定义字段内容
    //    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    //    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _isAppInBackground = YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (![[ConciseKit userDefaultsObjectForKey:IS_COOKIE] boolValue]) {
        [self logout];
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.userID forKey:SINA_UID];
    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.accessToken forKey:SINA_TOKEN];
   
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
   
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
   
}

@end
