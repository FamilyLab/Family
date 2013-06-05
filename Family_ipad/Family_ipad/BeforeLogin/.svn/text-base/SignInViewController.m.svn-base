//
//  SignInViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInMyInfoViewController.h"
#import "MyHttpClient.h"
#import "AppDelegate.h"
#define  SIGNINFRAEM  CGRectMake(44, 124, 403, 248)
#define  BINDFRAEM  CGRectMake(44, 200, 403, 248)

@interface SignInViewController ()

@end

@implementation SignInViewController
#pragma mark - my method(s)
- (IBAction)bindOrSignInBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
#define SELECTED_STR     @"checked.png"
#define NOT_SELECTED_STR @"notChecked.png"
    if (sender == _signInTypeBtn) {//没有Family帐号
        _bindImgView.image = [UIImage imageNamed:NOT_SELECTED_STR];
        _signInImgView.image = [UIImage imageNamed:SELECTED_STR];
        _secureCodeView.hidden = NO;
        //        _checkView.frame = CGRectMake(0, 45, 320, 35);
        _tipLabel.text = @"       为了让你的家人更加容易找到你，请填写你的电话号码，设置密码，未来你也可以使用电话号码登陆。";
    } else if (sender == _bindTypeBtn) {//已有Family帐号
        _bindImgView.image = [UIImage imageNamed:SELECTED_STR];
        _signInImgView.image = [UIImage imageNamed:NOT_SELECTED_STR];
        _secureCodeView.hidden = YES;
        _tipLabel.text = @"       请填写你的Family账号和密码，完成和新浪微博的绑定。";
    }
}
///// 手机号码的有效性判断
//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (IBAction)getSecureCode:(id)sender
{
    if (![self isMobileNumber:_username.text]) {
        [SVProgressHUD showErrorWithStatus:@"电话号码无效..."];
        return;
    }
    [SVProgressHUD showWithStatus:@"获取验证码..."];
    NSString *url = $str(@"%@register&op=getseccode&username=%@", POST_API,_username.text);
    [[MyHttpClient sharedInstance]commandWithPath:url onCompletion:^(NSDictionary *dict) {
        
    } failure:^(NSError *error) {
        ;
    }];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _thirdParty = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_thirdParty) {
        _selectView.hidden = YES;
        _inputView.frame = SIGNINFRAEM;
    }else{
        _selectView.hidden = NO;
        _inputView.frame = BINDFRAEM;
    }

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)



-(void)loginAction:(NSMutableDictionary *)dict
{
    NSString *url = $str(@"%@login", POST_API);
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:dict addData:^(id<AFMultipartFormData> formData) {
        
    } onCompletion:^(NSDictionary *dict) {
        NSDictionary *dataDict = [dict objectForKey:WEB_DATA];

        if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {
            [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误T_T"];
            return;
        }
        if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];
        
        [[AppDelegate instance] uploadToken:MY_DEVICE_TOKEN];
        
        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:M_AUTH] forKey:M_AUTH];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:USER_NAME] forKey:USER_NAME];
        
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:AVATER] forKey:AVATAR_URL];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIPSTATUS] forKey:VIPSTATUS];
        [self.navigationController dismissModalViewControllerAnimated:YES];
        [[AppDelegate instance]setUpRootView];
        
            
    }failure:^(NSError *error) {
        ;
    } ];

}

- (void)okBtnPressed:(id)sender {
    if (DEBUGMOD==1) {
        SignInMyInfoViewController *con = [[SignInMyInfoViewController alloc] initWithNibName:@"SignInMyInfoViewController" bundle:nil];
        [self.navigationController pushViewController:con animated:YES];
    }
    else{
        if (_username.text.length == 0 || _password.text.length == 0 ||_secureCode.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"信息填写不完整T_T"];
            return;
        }
        if (_secureCodeView.hidden==YES) {
            [SVProgressHUD showWithStatus:@"绑定中..." maskType:SVProgressHUDMaskTypeGradient];
            NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:_username.text, USER_NAME, _password.text, PASSWORD, ONE, IS_COOKIE, self.sinaUid, @"sina_uid", self.sinaToken, @"sina_token", nil];
            [self loginAction:para];
            return;
        }
        [SVProgressHUD showWithStatus:@"注册中..."];
        NSString *url = $str(@"%@register", POST_API);
        NSMutableDictionary *para = $mdict(_username.text,USER_NAME,_password.text,PASSWORD,_secureCode.text,SECCODE,nil);
        if (_thirdParty) {
            [para setObject:[[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_UID] forKey:SINA_UID];
            [para setObject:[[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_TOKEN] forKey:SINA_TOKEN];
            
        }
        [[MyHttpClient sharedInstance]commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            NSDictionary *dataDict = [dict objectForKey:WEB_DATA];
            
            
            NSDictionary *data = [dict objectForKey:WEB_DATA];
            [[PDKeychainBindings sharedKeychainBindings] setObject:[data objectForKey:M_AUTH] forKey:M_AUTH];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];
            [ConciseKit setUserDefaultsWithObject:_username.text forKey:USER_NAME];
            
            [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
            [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIPSTATUS] forKey:VIPSTATUS];
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            SignInMyInfoViewController *con = [[SignInMyInfoViewController alloc] initWithNibName:@"SignInMyInfoViewController" bundle:nil];
            [self.navigationController pushViewController:con animated:YES];
        } failure:^(NSError *error) {
            ;
        } ];

    }
}



@end
