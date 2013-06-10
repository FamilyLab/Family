//
//  BaseViewController.m
//  Family
//
//  Created by Aevitx on 13-1-17.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "AppDelegate.h"
#import "SignInViewController.h"
#import "MoreViewController.h"
#import "MyTabBarController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    
    if ([self isKindOfClass:[TableController class]]) {
        TableController *tabCon = (TableController*)self;
        tabCon._tableView.touchDelegate = self;
    }
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[TouchTableView class]]) {
            TouchTableView *table = (TouchTableView*)obj;
            table.touchDelegate = self;
            break;
        }
    }
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.delegate = self;
//    hud.labelText = @"加载中...";
//    [self.view addSubview:hud];
//    self.mbHud = hud;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (![UIApplication sharedApplication].statusBarHidden) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
    
//    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyTabBarController class]]) {
//        MyTabBarController *tabBarCon = (MyTabBarController*)myTabBarController;
//        if ([tabBarCon.viewControllers containsObject:self]) {
//            [tabBarCon hidePostMenu];
//        }
//    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureViews) name:THEME_CHANGE object:nil];
}

- (void)unregisterAsObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//登录接口（普通登录＋第三方登录接口）
- (void)uploadRequestToLoginWithPara:(NSMutableDictionary*)para loginType:(LoginType)loginType {
    NSString *url = $str(@"%@login", POST_API);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        
    } onCompletion:^(NSDictionary *dict) {
        NSDictionary *dataDict = [dict objectForKey:DATA];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            if (loginType == commonLoginType) {//普通登录后返回的结果
                if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {
                    [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误T_T"];
                    return;
                }
                if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                    return;
                }
            } else if (loginType == sinaLoginType) {//第三方登录后返回的结果
                if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {//未绑定，进入绑定界面
                    SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
                    con.topViewType = loginOrSignIn;
                    con.aboutType = sinaSignInType;
                    SinaWeibo *sinaweibo = [self sinaweibo];
                    con.sinaUid = sinaweibo.userID;
                    con.sinaToken = sinaweibo.accessToken;
                    
                    NSString *dateString = nil;
                    if (sinaweibo.expirationDate) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
                        dateString = [dateFormatter stringFromDate:sinaweibo.expirationDate];
                    }
                    con.sinaExpiresInDateStr = dateString;
                    
                    [self.navigationController pushViewController:con animated:YES];
                    return;
                }
                if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                    return;
                }
            }
            return ;
        }
        if (loginType == sinaLoginType) {//新浪登录成功后
            [self storeAuthData];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        
        NSString *avatarStr = [[dataDict objectForKey:AVATAR] stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
        avatarStr = [avatarStr stringByReplacingOccurrencesOfString:@"middle" withString:@"big"];
        
        [[NSUserDefaults standardUserDefaults] setBool:[[dataDict objectForKey:HAS_BIND_SINA_WEIBO] boolValue] forKey:HAS_BIND_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] setBool:[[dataDict objectForKey:HAS_BIND_SINA_WEIBO] boolValue] forKey:SHARE_TO_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
        [ConciseKit setUserDefaultsWithObject:avatarStr forKey:AVATAR_URL];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIP_STATUS] forKey:VIP_STATUS];
        //        [ConciseKit setUserDefaultsWithObject:@"默认空间" forKey:LAST_ZONE_NAME];
        
        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:USER_NAME] forKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:M_AUTH] forKey:M_AUTH];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate uploadToken:MY_DEVICE_TOKEN];
        [[AppDelegate app] loading:NO];//加载今日话题
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SEND_REQUEST object:nil];
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
    }];
}


//绑定微博接口
- (void)uploadRequestToBindSinaWeibo
//- (void)uploadRequestToSinaWeibo:(SinaWeibo *)sinaweibo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    //    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [SVProgressHUD showWithStatus:@"绑定中..."];
    NSString *url = $str(@"%@bindweibo", POST_API);
    
    NSString *dateString = nil;
    if (sinaweibo.expirationDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        dateString = [dateFormatter stringFromDate:sinaweibo.expirationDate];
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"sina", TYPE, sinaweibo.userID, ID, sinaweibo.accessToken, @"token", MY_M_AUTH, M_AUTH, dateString, @"sina_expires_in", nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_BIND_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SHARE_TO_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([self isKindOfClass:NSClassFromString(@"MoreViewController")]) {
            MoreViewController *con = (MoreViewController*)self;
            [con._tableView reloadData];
        }
        
        [self storeAuthData];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SINA_AUTH_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate = self;
    return delegate.sinaweibo;
}


#pragma mark - touch event 事件
- (MLNavigationController *)firstAvailableNavigationController
{
    if ([self.navigationController isKindOfClass:[MLNavigationController class]])
    {
        return (MLNavigationController *)self.navigationController;
    }
    //    if ([[self viewController].navigationController isKindOfClass:[MLNavigationController class]])
    //    {
    //        return (MLNavigationController *)[self viewController].navigationController;
    //    }
    return nil;
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.firstAvailableNavigationController touchesBegan:touches withEvent:event];
    tableView.scrollEnabled = NO;
}

- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self.firstAvailableNavigationController touchesMoved:touches withEvent:event];
}

- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [self.firstAvailableNavigationController touchesEnded:touches withEvent:event];
    tableView.scrollEnabled = YES;
}

- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [self.firstAvailableNavigationController touchesCancelled:touches withEvent:event];
    tableView.scrollEnabled = YES;
}


@end

