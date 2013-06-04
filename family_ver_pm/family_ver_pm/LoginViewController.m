//
//  LoginViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-4-3.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "LoginViewController.h"
#import "LoadingView.h"
#import "GrayTextField.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"
#import "SBKeycahin.h"
#import "SBToolKit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        autoLogin = YES;
        
        self.userNameField = [[GrayTextField alloc] initWithFrame:CGRectMake(47, 85, 226, 55)];
        self.userNameField.placeholder = @"请输入您的手机号码";
        self.userNameField.text = @"13433930911";//@"15013296747";
        [self.view addSubview:self.userNameField];
        
        self.passwordField = [[GrayTextField alloc] initWithFrame:CGRectMake(47, 160, 226, 55)];
        self.passwordField.placeholder = @"请输入密码";
        self.passwordField.text = @"1726919634";//@"123456abc";
        self.passwordField.secureTextEntry = YES;
        [self.view addSubview:self.passwordField];
        
        //config bottomBar
        self.loginViewBottomBar = [[LoginViewBottomBar alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - LOGIN_BOTTOMBAR_SIZE.height, LOGIN_BOTTOMBAR_SIZE.width, LOGIN_BOTTOMBAR_SIZE.height)];
        [self.view addSubview:self.loginViewBottomBar];
        [self.loginViewBottomBar.helpButton addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
        [self.loginViewBottomBar.registButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
        //config button
        [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self.autoLoginButton addTarget:self action:@selector(setAutoLogin) forControlEvents:UIControlEventTouchUpInside];
        //config loadingView
//        LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
//        [self.view addSubview:loadingView];
//        [loadingView loadAnimation];
    }
    return self;
}

- (void)login
{
    [SVProgressHUD showWithStatus:@"稍等哈" maskType:SVProgressHUDMaskTypeClear];
    //保存用户名
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:KEY_USERNAME];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_LOGIN]) {
//        //保存密码
//        if ([SBKeycahin searchItemForUserName:self.userNameField.text]) {
//            [SBKeycahin updatePassWord:self.passwordField.text ForUserName:self.userNameField.text];
//        } else {
//            [SBKeycahin addPassword:self.passwordField.text withUerName:self.userNameField.text];
//        }
        [SBToolKit savePassword:self.passwordField.text];
    }
    
    //调用登陆接口
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:COMMON_LOGIN_API parameters:[NSDictionary dictionaryWithObject:LOGIN forKey:AC] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[self.userNameField.text dataUsingEncoding:NSUTF8StringEncoding] name:USERNAME];
        [formData appendPartWithFormData:[self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding] name:PASSWORD];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d", 1] dataUsingEncoding:NSUTF8StringEncoding] name:ISCOOKIE];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
        NSString *m_auth;
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            m_auth = (NSString *)[[resultDict objectForKey:DATA] objectForKey:M_AUTH];
            NSLog(@"get m_auth : %@", m_auth);
            
            //取得m_auth后保存
            if (YES) {//([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_LOGIN] == YES) {
//                NSMutableString *authName = [NSMutableString stringWithString:self.userNameField.text];
//                [authName appendString:KEY_AUTH];
//                if ([SBKeycahin searchItemForUserName:authName] == NO) {
//                    [SBKeycahin addPassword:m_auth withUerName:authName];
//                } else {
//                    [SBKeycahin updatePassWord:m_auth ForUserName:authName];
//                }
                [SBToolKit saveMAuth:m_auth];
            }
            
            //保存UID
            [[NSUserDefaults standardUserDefaults] setObject:[[resultDict objectForKey:DATA] objectForKey:UID] forKey:UID];
            
            //保存是否自动登陆
            [[NSUserDefaults standardUserDefaults] setBool:autoLogin forKey:AUTO_LOGIN];
            
            //显示mainViewController
            MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self.navigationController pushViewController:mainViewController animated:YES];
        } else {
            NSLog(@"获取 m_auth 失败:%@", resultDict);
            [SVProgressHUD showErrorWithStatus:@"网络异常！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"login request fail : %@", error);
    }];
    [operation start];
}

- (void)setAutoLogin
{
    autoLogin = !autoLogin;
    if (autoLogin) {
        self.checkImage.image = [UIImage imageNamed:@"checked.png"];
    } else {
        self.checkImage.image = [UIImage imageNamed:@"notChecked.png"];
    }
}

- (void)help
{
    
}

- (void)regist
{
    RegisterViewController *registViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:registViewController animated:YES completion:^{
        }];
    } else {
        [self presentModalViewController:registViewController animated:YES];
        //[self.navigationController pushViewController:registViewController animated:YES];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
