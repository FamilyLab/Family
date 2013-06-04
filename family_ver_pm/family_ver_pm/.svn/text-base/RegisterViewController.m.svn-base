//
//  RegisterViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-4-3.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "RegisterViewController.h"
#import "GrayTextField.h"
#import "RegisterViewBottomBar.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SVProgressHUD.h"
#import "SBToolKit.h"
#import "BlocksKit.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //textField
    self.userNameField = [[GrayTextField alloc] initWithFrame:CGRectMake(47, 85, 226, 55)];
    self.userNameField.placeholder = @"用户名(手机号)";
    self.userNameField.delegate = self;
    [self.view addSubview:self.userNameField];
    
    self.passwordField = [[GrayTextField alloc] initWithFrame:CGRectMake(47, 150, 226, 55)];
    self.passwordField.placeholder = @"密码";
    self.passwordField.delegate = self;
    [self.view addSubview:self.passwordField];
    
    self.confirmPasswordField = [[GrayTextField alloc] initWithFrame:CGRectMake(47, 215, 226, 55)];
    self.confirmPasswordField.placeholder = @"确认密码";
    self.confirmPasswordField.delegate = self;
    [self.view addSubview:self.confirmPasswordField];
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getCodeBtn.frame = CGRectMake(47, 280, 80, 55);
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"background_green.png"] forState:UIControlStateNormal];
    getCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    getCodeBtn.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    getCodeBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [getCodeBtn addTarget:self action:@selector(requestConfirmCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCodeBtn];
    
    self.confirmCodeField = [[GrayTextField alloc] initWithFrame:CGRectMake(getCodeBtn.frame.origin.x + getCodeBtn.frame.size.width + 10, getCodeBtn.frame.origin.y, 226 - getCodeBtn.frame.size.width - 10, getCodeBtn.frame.size.height)];   
    self.confirmCodeField.placeholder = @"验证码";
    self.confirmCodeField.delegate = self;
    [self.view addSubview:self.confirmCodeField];
    
    //config bottombar
    self.bottomBar = [[RegisterViewBottomBar alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - REGISTER_BOTTOMBAR_SIZE.height, REGISTER_BOTTOMBAR_SIZE.width, REGISTER_BOTTOMBAR_SIZE.height)];
    [self.view addSubview:self.bottomBar];
    [self.bottomBar.backButton addTarget:self action:@selector(backToLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar.confirmButton addTarget:self action:@selector(confirmToRegist) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswordField resignFirstResponder];
    [self.confirmCodeField resignFirstResponder];
}

//获取验证码
- (void)requestConfirmCode
{
    if (self.userNameField.text == nil) {
        [SVProgressHUD showErrorWithStatus:@"输入用户名吧~"];
        return;
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"/dapi/do.php?ac=register&op=getseccode" parameters:[NSDictionary dictionaryWithObject:self.userNameField.text forKey:USERNAME]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([[resultDict objectForKey:ERROR] intValue] == 0) {
            self.confirmCode = [[resultDict objectForKey:DATA] objectForKey:@"seccode"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                message:[resultDict objectForKey:MSG]
                                                               delegate:self
                                                      cancelButtonTitle:@"知道啦"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                message:[resultDict objectForKey:MSG]
                                                               delegate:self
                                                      cancelButtonTitle:@"知道啦"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
    
    [operation start];
}

//

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int interval = DEVICE_SIZE.height - KEYBOARD_HEIGHT - (textField.frame.origin.y + textField.frame.size.height);
    if (interval < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, interval - 10, DEVICE_SIZE.width, DEVICE_SIZE.height);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y < 0) {
        [UIView animateWithDuration:0.2 animations:^{
           self.view.frame = CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height); 
        }];
    }
}



//button event
- (void)backToLoginView
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)confirmToRegist
{
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次输入的密码不同！输入两次相同的密码吧" delegate:self cancelButtonTitle:@"这就去改" otherButtonTitles:nil];
        [alerView show];
        return;
    }
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/dapi/do.php?ac=register" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[self.userNameField.text dataUsingEncoding:NSUTF8StringEncoding] name:USERNAME];
        [formData appendPartWithFormData:[self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding] name:PASSWORD];
        [formData appendPartWithFormData:[self.confirmCodeField.text dataUsingEncoding:NSUTF8StringEncoding] name:SECCODE];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([[resultDict objectForKey:ERROR] intValue] == 0 && [[[resultDict objectForKey:DATA] objectForKey:RETURN] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatusNoAutoDismiss:@"注册成功！"];
            
            //保存数据
            [SBToolKit saveMAuth:[[resultDict objectForKey:DATA] objectForKey:M_AUTH]];
            [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:USERNAME];
            
            NSString *uid = [NSString stringWithFormat:@"%d", [[[resultDict objectForKey:DATA] objectForKey:UID] intValue]];
            
            [self performBlock:^(id sender) {
                [SVProgressHUD dismiss];
            } afterDelay:2.0f];
        } else {
            [SVProgressHUD showErrorWithStatusNoAutoDismiss:[resultDict objectForKey:MSG]];
            [self performBlock:^(id sender) {
                [SVProgressHUD dismiss];
            } afterDelay:2.0f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
    
    [operation start];
}

@end
