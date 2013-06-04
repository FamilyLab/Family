//
//  AppDelegate.m
//  family_ver_pm
//
//  Created by pandara on 13-3-18.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DCIntrospect.h"
#import "LoginViewController.h"
#import "SBKeycahin.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "SBToolKit.h"
#import "ConciseKit.h"
#import "BootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[UINavigationController alloc] init];
    
    self.loadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    [self.navController pushViewController:self.loadingViewController animated:YES];
    
    self.navController.navigationBarHidden = YES;
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_LOGIN]) {//auto login
        [self performSelector:@selector(autoLogin) withObject:self afterDelay:LOADING_ANIMATION_COUNT * LOADING_ANIMATION_DUR];
        NSLog(@"auto login at appdelegate");
    } else {
        [self performSelector:@selector(login) withObject:self afterDelay:LOADING_ANIMATION_COUNT * LOADING_ANIMATION_DUR];
        NSLog(@"not to auto login at appdelegate");
    }
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    return YES;
}

- (void)login
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"notTheFirstTime"]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.loadingViewController.navigationController pushViewController:loginViewController animated:YES];
    } else {
        BootViewController *bootviewController = [[BootViewController alloc] initWithNibName:@"BootViewController" bundle:nil];
        [self.loadingViewController.navigationController pushViewController:bootviewController animated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notTheFirstTime"];
    }
}

- (void)autoLogin
{
    //验证m_auth
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
//    NSMutableString *authName = [NSMutableString stringWithString:userName];
//    [authName appendString:KEY_AUTH];
//    NSString *m_auth = [SBKeycahin getPassWordForName:authName];
    NSString *m_auth = [SBToolKit getMAuth];
    NSLog(@"m_auth gotten in AppDelegate::autoLogin%@", m_auth);
    NSLog(@"password gotten in AppDelegate::autoLogin%@", [SBKeycahin getPassWordForName:userName]);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:AUTH_VERIFY_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:CKMAUTH, AC, m_auth, M_AUTH, nil]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"sent %lld of %lld bytes in autologin", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
        
        //取验证标志
        int returnFlag = [(NSNumber *)[[resultDict objectForKey:DATA] objectForKey:RETURN] intValue];
        if (returnFlag == 1) {
            MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self.loadingViewController.navigationController pushViewController:mainViewController animated:YES];
            NSLog(@"m_auth is valid");
        } else {
            //重新登陆取得m_auth
            NSLog(@"m_auth is invalid and start to reget m_auth");
            NSString *password = [SBToolKit getPassword];
            
            NSMutableURLRequest *regetAuthRequest = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                                          path:COMMON_LOGIN_API
                                                                                    parameters:[NSDictionary dictionaryWithObject:LOGIN forKey:AC]
                                                                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFormData:[userName dataUsingEncoding:NSUTF8StringEncoding] name:KEY_USERNAME];
                [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding] name:KEY_PASSWORD];
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d", 1] dataUsingEncoding:NSUTF8StringEncoding] name:KEY_ISCOOKIE];
            }];
            
            AFHTTPRequestOperation *regetAuthOperation = [[AFHTTPRequestOperation alloc] initWithRequest:regetAuthRequest];
            
            [regetAuthOperation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                NSLog(@"sent %lld of %lld bytes in reget m_auth", totalBytesWritten, totalBytesExpectedToWrite);
            }];
            
            [regetAuthOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
                NSString *m_auth;
                //取得m_auth
                if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
                    NSLog(@"relogin successfully at appdelegate");
                    m_auth = (NSString *)[[resultDict objectForKey:DATA] objectForKey:M_AUTH];
                    
                    //更新keychain
                    [SBKeycahin updatePassWord:m_auth ForUserName:userName];
                    [[NSUserDefaults standardUserDefaults] setObject:[[resultDict objectForKey:DATA] objectForKey:UID] forKey:UID];
                    
                    MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                    [self.loadingViewController.navigationController pushViewController:mainViewController animated:YES];
                } else {
                    NSLog(@"reget m_auth returning error%@", resultDict);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"reget m_auth request fail");
                [SVProgressHUD showErrorWithStatus:@"网络异常！"];
            }];
            
            [regetAuthOperation start];
        };
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"verify mauth error!");
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.loadingViewController.navigationController pushViewController:loginViewController animated:YES];
        [SVProgressHUD showErrorWithStatus:@"无网络连接.."];
    }];
    [operation start];
}

-(void)logoutFromFamily
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_LOGIN];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [ConciseKit removeUserDafualtForKey:NAME];
//    [ConciseKit removeUserDafualtForKey:UID];
//    [ConciseKit removeUserDafualtForKey:AVATAR];
//    [ConciseKit removeUserDafualtForKey:AVATAR_URL];
//    
//    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:USER_NAME];
//    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:PASSWORD];
//    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:M_AUTH];
//    
//    [[JMImageCache sharedCache] removeAllObjects];
//    
//    [self loading:NO];
    [SBToolKit deletePassword];
    [SBToolKit deleteMAuth];
    [SBToolKit deleteUID];
    [SBToolKit deleteUserName];
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.loadingViewController.navigationController pushViewController:loginViewController animated:YES];
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
}

@end
