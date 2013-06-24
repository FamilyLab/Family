//
//  AppDelegate.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "AppDelegate.h"

#import "MyTabBarController.h"
#import "DCIntrospect.h"
#import "FeedViewController.h"
#import "LoginViewController.h"
#import "PDKeychainBindings.h"
#import "JMImageCache.h"
//#import "SDWebImageManager.h"
//#import "SDImageCache.h"
#import "TopicViewController.h"
#import "PlistManager.h"
#import "GuideViewController.h"
#import "SinaWeibo.h"
#import "MyHttpClient.h"
#import "DialogueViewController.h"
#import "FeedDetailViewController.h"
#import "MessageViewController.h"
#import "FamilyListViewController.h"
#import "MobClick.h"
#import "TopicView.h"
#import "LoadingView.h"

@implementation AppDelegate
@synthesize tabBarCon = _tabBarCon;
@synthesize navCon = _navCon;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ConciseKit removeUserDafualtForKey:@"isFirstShow"];
//    [ConciseKit removeUserDafualtForKey:LAST_TOPIC_ID];
    _isFirstShow = YES;
    _isLogout = NO;
    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:BATCH channelId:nil];
    [MobClick checkUpdate:@"有新版本啦" cancelButtonTitle:@"跳过" otherButtonTitles:@"去更新"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    _isAppInBackground = NO;
    [PlistManager deletePlist:PLIST_FEED_TOP_DATA];
    [PlistManager deletePlist:PLIST_FEED_COMMENT];
    
    if (!MY_AUTO_LOGIN) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [PlistManager deletePlist:PLIST_FAMILY_LIST];
    [PlistManager deletePlist:PLIST_ZONE_LIST];
    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NEED_Clear_Head_Cache];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:NEED_Clear_Head_Cache]) {
    [[JMImageCache sharedCache] removeAllObjects];
    if ([ConciseKit userDefaultsObjectForKey:AVATAR]) {
        [ConciseKit removeUserDafualtForKey:AVATAR];
    }
    
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] clearDisk];
    
    if (!MY_NOT_FIRST_SHOW) {//第一次装好app
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WANT_SHOW_TODAY_TOPIC];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_QQ_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_WEIXIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ConciseKit setUserDefaultsWithObject:@"默认空间" forKey:LAST_ZONE_NAME];
        [self setDefaultSpaceImage];
    }
    if (!MY_AUTO_LOGIN) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.tabBarCon = [[MyTabBarController alloc] init];
    
//    self.navCon = [[UINavigationController alloc] initWithRootViewController:_tabBarCon];
    self.navCon = [[MLNavigationController alloc] initWithRootViewController:_tabBarCon];
    self.tabBarCon.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = self.navCon;
    
    [self.window makeKeyAndVisible];
    
    
    //新浪微博
    _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:SINA_AUTH_DATA];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    //注册推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    //这里处理应用程序如果没有启动,但是是通过通知消息打开的,此时可以获取到消息.
    if (MY_HAS_LOGIN && launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self operateForPushWithDict:userInfo isAppNotStart:YES];
    }
    
    //向微信注册
    [WXApi registerApp:WeiXin_APP_ID];
    
    [self loading:MY_HAS_LOGIN];
    if (!MY_HAS_LOGIN) {
        [self buildLoginConWithTopicView:nil];
    }
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    return YES;
}

+ (AppDelegate*) app {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)loading:(BOOL)_hasLogin {
    if (!MY_NOT_FIRST_SHOW) {//首次安装
        LoginViewController *loginCon = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCon];
        nav.navigationBarHidden = YES;
        [self.navCon presentModalViewController:nav animated:NO];
        
        GuideViewController *guideCon = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        UINavigationController *adNav = [[UINavigationController alloc] initWithRootViewController:guideCon];
        adNav.navigationBarHidden = YES;
        [nav presentModalViewController:adNav animated:NO];
//        [self.navCon presentModalViewController:adNav animated:NO];
    } else if (MY_WANT_SHOW_TODAY_TOPIC && MY_HAS_LOGIN) {
        [self performBlock:^(id sender) {
            [self sendRequestForTopic:nil];
        } afterDelay:0.3f];
//        if (!MY_HAS_LOGIN) {
//            //            if (_isLogout) {
//            //                [self buildLoginConWithTopicView:nil];
//            //                _isLogout = NO;
//            //            }
//        } else {
//        }
        
//        TopicViewController *con = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
//        con.isFromMoreCon = NO;
//        UINavigationController *adNav = [[UINavigationController alloc] initWithRootViewController:con];
//        adNav.navigationBarHidden = YES;
//        [self.navCon presentModalViewController:adNav animated:NO];
    }
}

- (void)buildLoginConWithTopicView:(TopicView*)aView {
    if (!aView) {
        aView = [[[NSBundle mainBundle] loadNibNamed:@"TopicView" owner:self options:nil] objectAtIndex:0];
        aView.isFromMoreCon = NO;
    }
    LoginViewController *loginCon = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCon];
    nav.navigationBarHidden = YES;
    [self.navCon presentModalViewController:nav animated:NO];
    if (MY_HAS_LOGIN) {
        [loginCon.view addSubview:aView];
        [aView sendRequest:nil];
    }
    if (_isLogout) {
        _isLogout = NO;
    }
}

//今日话题
- (void)sendRequestForTopic:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=topic&page=%d&perpage=%d", BASE_URL, 1, 1];
    TopicView *aView = [[[NSBundle mainBundle] loadNibNamed:@"TopicView" owner:self options:nil] objectAtIndex:0];
    aView.isFromMoreCon = NO;
    aView.hidden = YES;
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *topicId = [[dict objectForKey:WEB_DATA] objectForKey:TOPIC_ID];
        if (!MY_LAST_TOPIC_ID || ![MY_LAST_TOPIC_ID isEqualToString:topicId]) {
            [ConciseKit setUserDefaultsWithObject:topicId forKey:LAST_TOPIC_ID];
            [_tabBarCon.view addSubview:aView];
            aView.topicId = topicId;
            aView.topicTitleStr = [[dict objectForKey:WEB_DATA] objectForKey:SUBJECT];
            aView.topicImgUrlStr = [[dict objectForKey:WEB_DATA] objectForKey:PIC];
            aView.topicDescribeStr = [[dict objectForKey:WEB_DATA] objectForKey:MESSAGE];
            aView.joinType = [[[dict objectForKey:WEB_DATA] objectForKey:JOIN_TYPE] objectAtIndex:0];
            [aView fillData];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

//sina weibo
//- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
//{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (void)logoutFamily {
    [self uploadToken:@""];
    
    [PlistManager deletePlist:PLIST_FAMILY_LIST];
    [PlistManager deletePlist:PLIST_ZONE_LIST];
    
    [self.tabBarCon selecteFirstIndexForLogout];
//    [ConciseKit setUserDefaultsWithObject:NO forKey:HAS_LOGIN];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ConciseKit removeUserDafualtForKey:UID];
    [ConciseKit removeUserDafualtForKey:NAME];
    [ConciseKit removeUserDafualtForKey:AVATAR];
    [ConciseKit removeUserDafualtForKey:AVATAR_URL];
    [ConciseKit setUserDefaultsWithObject:@"默认空间" forKey:LAST_ZONE_NAME];
    [ConciseKit removeUserDafualtForKey:VIP_STATUS];
    [ConciseKit removeUserDafualtForKey:LAST_TOPIC_ID];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WANT_SHOW_TODAY_TOPIC];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_WEIXIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setDefaultSpaceImage];
    
    
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:M_AUTH];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:USER_NAME];
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:PASSWORD];
    
    //sina weibo
//    [self.sinaweibo logOut];
    
    [[JMImageCache sharedCache] removeAllObjects];//NEED_CLEAR_CACHE
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CLEAR_ALL_DATA object:nil];
    [ThemeManager sharedThemeManager].theme = DEFAULT_THEME;
    
    _isLogout = YES;
//    [self loading:NO];
    [self buildLoginConWithTopicView:nil];
}

- (void)setDefaultSpaceImage {
    [Common saveImgToUserDefaultWithImgNameStr:@"default_space_0" andImgType:@"jpg" saveKey:SPACE_IMAGE compressQuality:1.0f];
//    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default_space_0" ofType:@"jpg"]];
//    NSData *spaceImgData = UIImageJPEGRepresentation(image, 1.0);
//    NSData *encodeSpaceImgData = [NSKeyedArchiver archivedDataWithRootObject:spaceImgData];
//    [ConciseKit setUserDefaultsWithObject:encodeSpaceImgData forKey:SPACE_IMAGE];
}

- (void)pushAController:(UIViewController*)_con {
    [self.navCon pushViewController:_con animated:YES];
}

- (void)popAController {
    [self.navCon popViewControllerAnimated:YES];
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
    [self.sinaweibo applicationDidBecomeActive];
    _isAppInBackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *tokenStr = [NSString stringWithFormat:@"%@", deviceToken];
//    NSLog(@"devToken=%@", deviceToken);
    if (MY_HAS_LOGIN && MY_DEVICE_TOKEN && ![tokenStr isEqualToString:MY_DEVICE_TOKEN]) {
        [self uploadToken:tokenStr];
    }
    [[PDKeychainBindings sharedKeychainBindings] setObject:tokenStr forKey:DEVICE_TOKEN];
//    UITextView *tokenTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 70, 80, 30)];
//    tokenTextView.editable = NO;
//    tokenTextView.text = [NSString stringWithFormat:@"%@", deviceToken];
//    tokenTextView.backgroundColor = [UIColor lightGrayColor];
//    [self.tabBarCon.view addSubview:tokenTextView];
    
    //    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //	NSString *results = [NSString stringWithFormat:@"Badge: %@, Alert:%@, Sound: %@",
    //						 (rntypes & UIRemoteNotificationTypeBadge) ? @"Yes" : @"No",
    //						 (rntypes & UIRemoteNotificationTypeAlert) ? @"Yes" : @"No",
    //						 (rntypes & UIRemoteNotificationTypeSound) ? @"Yes" : @"No"];
    //    NSLog(@"results:%@", results);
    
//    if (MY_HAS_LOGIN && ![tokenStr isEqualToString:MY_DEVICE_TOKEN]) {
//        [self uploadToken:tokenStr];
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

//点击某条远程通知时调用的委托 如果界面处于打开状态,那么此委托会直接响应
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //    [self PMD_uesPushMessage:userInfo];
    //把icon上的标记数字设置为0
    //    application.applicationIconBadgeNumber = 0;
    [self operateForPushWithDict:userInfo isAppNotStart:NO];
}

- (void)operateForPushWithDict:(NSDictionary*)userInfo isAppNotStart:(BOOL)isAppNotStart {
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badge > 0) {
        badge--;
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
//    NSLog(@"didReceive:%@", userInfo);
//    NSString *pushBodyStr = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
//    NSLog(@"接收通知：%@", pushBodyStr);
    
    NSString *pushIdType = emptystr([userInfo objectForKey:FEED_ID_TYPE]);
    if (![pushIdType hasSuffix:@"id"]) {
        pushIdType = $str(@"%@id", pushIdType);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];
    
    if (isAppNotStart || _isAppInBackground) {
        UIButton *msgBtn = (UIButton*)[self.tabBarCon.tabBarView viewWithTag:kTagBottomButton + 3];
        for (id obj in [self.tabBarCon.tabBarView subviews]) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = obj;
                if (btn.tag == msgBtn.tag)
                    btn.selected = YES;
                else
                    btn.selected = NO;
            }
        }
        [self.tabBarCon userPressedTheBottomButton:self.tabBarCon.tabBarView andButton:msgBtn];
    }
    if (![pushIdType isEqualToString:PUSH_PM]) {
        MessageViewController *msgCon = (MessageViewController*)[[self.tabBarCon viewControllers] objectAtIndex:2];
        msgCon.isFromPushForNotice = YES;
        [msgCon sendRequestToNotice:msgCon._secondTableView];
    }
    
    if ([pushIdType isEqualToString:PUSH_PM]) {
        if (isAppNotStart || _isAppInBackground) {//APP未启动或在后台时
            _isAppInBackground = NO;
            DialogueViewController *con = [[DialogueViewController alloc] initWithNibName:@"DialogueViewController" bundle:nil];
            con.toUserId = [NSString stringWithFormat:@"%d", [emptystr([userInfo objectForKey:UID]) intValue]];
            con.hidesBottomBarWhenPushed = YES;
//            [self.navCon pushViewController:con animated:NO];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
            nav.navigationBarHidden = YES;
            nav.hidesBottomBarWhenPushed = YES;
            UINavigationController *topNav = (UINavigationController*)[self.window topMostController];
            [topNav presentModalViewController:nav animated:YES];
//            [self.navCon presentModalViewController:nav animated:YES];
        } else {
            MessageViewController *msgCon = (MessageViewController*)[[self.tabBarCon viewControllers] objectAtIndex:2];
            msgCon.isFromPushForPM = YES;
            [msgCon sendRequestToDialogue:msgCon._tableView];
            [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_FOR_DIALOG_DETAIL object:userInfo];
        }
    } else if ([pushIdType isEqualToString:PUSH_FEED_FRIEND] || [pushIdType isEqualToString:@"feedfriendid"]) {
        if (isAppNotStart || _isAppInBackground) {//APP未启动或在后台时。“XXX通过了你的好友请求”这类
            _isAppInBackground = NO;
        }
    } else if ([pushIdType isEqualToString:PUSH_FRIEND] || [pushIdType isEqualToString:@"friendid"]) {
        if (isAppNotStart || _isAppInBackground) {//APP未启动或在后台时。“XXX请求加我为好友”这类
            _isAppInBackground = NO;
            FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
            con.conType = askForMyFamilyListType;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
            nav.navigationBarHidden = YES;
            nav.hidesBottomBarWhenPushed = YES;
            UINavigationController *topNav = (UINavigationController*)[self.window topMostController];
            [topNav presentModalViewController:nav animated:YES];
//            [self.navCon presentModalViewController:nav animated:YES];
        }
    } else {
        if (isAppNotStart || _isAppInBackground) {//APP未启动或在后台时
            _isAppInBackground = NO;
            FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
            con.hidesBottomBarWhenPushed = YES;
            NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
//            NSString *idTypeStr = [[userInfo objectForKey:FEED_ID_TYPE] stringByReplacingOccurrencesOfString:@"id" withString:@""];
            [idDict setObject:pushIdType forKey:FEED_ID_TYPE];
            [idDict setObject:[NSString stringWithFormat:@"%d", [emptystr([userInfo objectForKey:ID]) intValue]] forKey:FEED_ID];
            [idDict setObject:[NSString stringWithFormat:@"%d", [emptystr([userInfo objectForKey:ID]) intValue]] forKey:FEED_COMMENT_ID];
            [idDict setObject:[NSString stringWithFormat:@"%d", [emptystr([userInfo objectForKey:UID]) intValue]] forKey:UID];

            [con.idArray addObject:idDict];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
            nav.navigationBarHidden = YES;
            nav.hidesBottomBarWhenPushed = YES;
            UINavigationController *topNav = (UINavigationController*)[self.window topMostController];
            [topNav presentModalViewController:nav animated:YES];
//            [self.navCon presentModalViewController:nav animated:YES];
        }
    }
}

- (void)uploadToken:(NSString*)deviceToken {
#if TARGET_OS_IPHONE
    NSString *tokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    tokenStr = [tokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *url = @"http://www.familyday.com.cn/capi/token.php";
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:MY_UID, UID, tokenStr, @"token", nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
//        NSLog(@"token dict:%@", dict);
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
    }];
#endif
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[NSString stringWithFormat:@"%@", url] rangeOfString:kAppKey].length > 0) {
        return [self.sinaweibo handleOpenURL:url];
    } else if ([[NSString stringWithFormat:@"%@", url] rangeOfString:WeiXin_APP_ID].length > 0) {
        return [WXApi handleOpenURL:url delegate:self];
    } else
        return NO;
}

//IOS6+
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[NSString stringWithFormat:@"%@", url] rangeOfString:kAppKey].length > 0) {
        return [self.sinaweibo handleOpenURL:url];
    } else if ([[NSString stringWithFormat:@"%@", url] rangeOfString:WeiXin_APP_ID].length > 0) {
        return [WXApi handleOpenURL:url delegate:self];
    } else
        return NO;
}

#pragma mark - 微信
- (void) viewContent:(WXMediaMessage *) msg
{
    //显示微信传过来的内容
//    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n\n", msg.title, msg.description];
//    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)doAuth
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送文本消息后， 返回本App
}

-(void) onSentMediaMessage:(BOOL) bSent
{
    // 通过微信发送媒体消息后， 返回本App
}

-(void) onSentAuthRequest:(NSString *) userName accessToken:(NSString *) token expireDate:(NSDate *) expireDate errorMsg:(NSString *) errMsg
{
    
}

-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        [MobClick event:@"weixin"];
    } else if([resp isKindOfClass:[SendAuthResp class]]) {
        
    }
}

@end


@implementation UIWindow (Extensions)

- (UIViewController*)topMostController {
    UIViewController *topController = [self rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

@end