//
//  LoginViewController.m
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MenuViewController.h"
#import "SVProgressHUD.h"   
#import "PDKeychainBindings.h"
#import "GuideViewController.h"
#import "SinaWeibo.h"
#import "ChangePwViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "ZoneWaterFallView.h"
#import "KGModal.h"
#import "WaterFallViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
- (IBAction)weiboLogin:(id)sender
{
    [AppDelegate instance].sinaweibo.delegate = self;
    [[AppDelegate instance].sinaweibo logIn];
}
- (IBAction)showGuidAction:(UIButton *)sender
{
    GuideViewController *con = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
    if (sender) {
        con.father = self;
    }
    con.selector = @selector(overSlideBtnPressed:);
    [self.navigationController  pushViewController:con animated:YES];
}

- (IBAction)BtnPressedSelect:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (_cookieBtn.selected) {
        [[PDKeychainBindings sharedKeychainBindings] setObject:_userField.text forKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] setObject:_pwdField.text forKey:PASSWORD];
        _autoLoginSelectedImg.hidden = NO;
    }
    else{
        [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:PASSWORD];
        _autoLoginSelectedImg.hidden = YES;
    }
    [ConciseKit setUserDefaultsWithObject:$bool(_cookieBtn.selected) forKey:IS_COOKIE];


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
    // Do any additional setup after loading the view from its nib.
    _cookieBtn.selected = [[ConciseKit userDefaultsObjectForKey:IS_COOKIE] boolValue];
    if (_cookieBtn.selected) {
        _userField.text = SAVED_USERNAME;
        _pwdField.text = SAVED_PASSWORD;
        _autoLoginSelectedImg.hidden = NO;
        //[self performSelector:@selector(loginBtnPressed:) withObject:nil afterDelay:1.0f];
    }
   
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - my method(s)

- (IBAction)findMyPwBtnPressed:(id)sender {
    ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
    con.aboutPwd = inputPhoneForLostPwd;
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)signInBtnPressed:(UIButton *)sender {
    
    SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self.navigationController pushViewController:con animated:YES];
}
- (void)storeUserInfo:(NSDictionary *)dataDict
{
    [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];

    [[AppDelegate instance] uploadToken:MY_DEVICE_TOKEN];
    
    [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:M_AUTH] forKey:M_AUTH];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ConciseKit setUserDefaultsWithObject:_userField.text forKey:USER_NAME];
    
    [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
    [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:AVATER] forKey:AVATAR_URL];
    [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIPSTATUS] forKey:VIPSTATUS];
}
- (IBAction)loginBtnPressed:(id)sender {
//#if TARGET_IPHONE_SIMULATOR
//    _userField.text = _userField.text.length != 0 ? _userField.text : @"18620050490";//@"15013296747 18620050490";
//    _pwdField.text = _pwdField.text.length != 0 ? _pwdField.text : @"123456";
//#endif

    if (_userField.text.length == 0 || _pwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户名或者密码为空T_T"];
        return;
    }
    [self BtnPressedSelect:nil];
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
    if (_cookieBtn.selected) {
        [[PDKeychainBindings sharedKeychainBindings] setObject:_userField.text forKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] setObject:_pwdField.text forKey:PASSWORD];
    }
    NSString *url = $str(@"%@login", POST_API);
    NSString *cookie = _cookieBtn.selected ? ONE : ZERO;
    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_userField.text, USER_NAME, _pwdField.text, PASSWORD, cookie, IS_COOKIE, nil];
    //    [[MyHttpClient sharedInstance] commandWithPathAndParams:@"/dapi/do.php?" params:[NSDictionary dictionaryWithObject:@"login" forKey:@"ac"] addData:^(id<AFMultipartFormData> formData) {
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSDictionary *dataDict = [dict objectForKey:WEB_DATA];
        if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {
            [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误T_T"];
            return;
        }
        if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [self storeUserInfo:dataDict];
        if ([IS_FIRST_SHOW boolValue]) {

            [self showGuidAction:nil];
        }
        else{
            [self.navigationController dismissModalViewControllerAnimated:YES];
            [[AppDelegate instance]setUpRootView];

        }
        

    } failure:^(NSError *error) {
        ;
    }];

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
- (void)thirdPartyLogin:(NSMutableDictionary *)para
{
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = $str(@"%@login", POST_API);

    //    [[MyHttpClient sharedInstance] commandWithPathAndParams:@"/dapi/do.php?" params:[NSDictionary dictionaryWithObject:@"login" forKey:@"ac"] addData:^(id<AFMultipartFormData> formData) {
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        
    } onCompletion:^(NSDictionary *dict) {
        if ([[[dict objectForKey:WEB_DATA] objectForKey:WEB_RETURN] intValue] == -2) {//未绑定，进入绑定界面
            [SVProgressHUD dismiss];
            SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
            con.sinaUid = [AppDelegate instance].sinaweibo.userID;
            con.sinaToken = [AppDelegate instance].sinaweibo.accessToken;
            con.thirdParty = YES;
            [self.navigationController pushViewController:con animated:YES];
            return;
        }

        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSDictionary *dataDict = [dict objectForKey:WEB_DATA];
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [self storeUserInfo:dataDict];
        if ([IS_FIRST_SHOW boolValue]) {
            
            [self showGuidAction:nil];
        }
        else{
            [self.navigationController dismissModalViewControllerAnimated:YES];
            [[AppDelegate instance]setUpRootView];
        }
    } failure:^(NSError *error) {
        ;
    }];

}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.userID forKey:SINA_UID];
    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.accessToken forKey:SINA_TOKEN];
    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:sinaweibo.userID, @"sina_uid", @"weibo", @"logintype", nil];
    [self thirdPartyLogin:para];
//    SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
//    con.thirdParty = YES;
//    con.header.headerTitle.text = @"绑定";
//    [self.navigationController pushViewController:con animated:YES];
}
@end
