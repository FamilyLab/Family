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
#import "SVProgressHUD.h"
#import "PDKeychainBindings.h"

//#define COUNT_TIME_NUM  300

@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize topViewType;
@synthesize phoneField, firstPwdField, checkCodeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _aboutType = commonType;
//        countTime = COUNT_TIME_NUM;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self addBottomView];
//    [_showPwBtn setImage:[UIImage imageNamed:@"showpw_a.png"] forState:UIControlStateNormal];
//    [_showPwBtn setImage:[UIImage imageNamed:@"showpw_b.png"] forState:UIControlStateSelected];
    if (_aboutType == commonType) {
        [_selectView removeFromSuperview];
        _inputView.frame = CGRectMake(0, 75, 320, 140);
        
        CGRect checkFrame = _checkView.frame;
        checkFrame.origin.y += 10;
        _checkView.frame = checkFrame;
        
        CGRect pwFrame = _passwordView.frame;
        pwFrame.origin.y += 20;
        _passwordView.frame = pwFrame;
    } else {
        [_bindTypeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_signInTypeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        _selectView.frame = CGRectMake(0, 55, 320, 80);
        _inputView.frame = CGRectMake(0, 138, 320, 120);
    }
    [phoneField becomeFirstResponder];
    
    BottomView *forPhone = [self buildBottomView];
    [phoneField setInputAccessoryView:forPhone];
    
    BottomView *forCheckCode = [self buildBottomView];
    [checkCodeField setInputAccessoryView:forCheckCode];
    
    BottomView *forPw = [self buildBottomView];
    [firstPwdField setInputAccessoryView:forPw];
//    self.phoneStr = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (IBAction)bindOrSignInBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
#define SELECTED_STR     @"checked.png"
#define NOT_SELECTED_STR @"notChecked.png"
    if (sender == _signInTypeBtn) {//没有Family帐号
        _bindImgView.image = [UIImage imageNamed:NOT_SELECTED_STR];
        _signInImgView.image = [UIImage imageNamed:SELECTED_STR];
        _checkView.hidden = NO;
//        _checkView.frame = CGRectMake(0, 45, 320, 35);
        _passwordView.frame = CGRectMake(0, 88, 320, 35);
        _aboutType = sinaSignInType;
        _tipLabel.text = @"       为了让你的家人更加容易找到你，请填写你的电话号码，设置密码，未来你也可以使用电话号码登陆。";
    } else if (sender == _bindTypeBtn) {//已有Family帐号
        _bindImgView.image = [UIImage imageNamed:SELECTED_STR];
        _signInImgView.image = [UIImage imageNamed:NOT_SELECTED_STR];
        _checkView.hidden = YES;
        _passwordView.frame = CGRectMake(0, 45, 320, 35);
        _aboutType = sinaBindType;
        _tipLabel.text = @"       请填写你的Family账号和密码，完成和新浪微博的绑定。";
    }
}

- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = loginOrSignIn;
    [topView leftBg];
    NSString *tipStr = _aboutType == commonType ? @"注册" : @"绑定";
    [topView leftText:tipStr];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (BottomView*)buildBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"login_ok", nil];
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:nil
                                       andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    return aView;
}

- (void)addBottomView {
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"login_ok", nil];
//    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
//                                                          type:notAboutTheme
//                                                     buttonNum:[normalImages count]
//                                               andNormalImages:normalImages
//                                             andSelectedImages:nil
//                                            andBackgroundImage:@"login_bg"];
//    aView.delegate = self;
    BottomView *aView = [self buildBottomView];
    [self.view addSubview:aView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case 1:
        {
            [self okBtnPressed:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)okBtnPressed:(id)sender {
//    if (![firstPwdField.text isEqualToString:secondPwdField.text]) {
//        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致T_T"];
//        return;
//    }
    if (phoneField.text.length == 0 || firstPwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    if (!self.checkView.hidden && checkCodeField.text.length == 0) {//checkCodeField为验证码的文本框
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    if (_aboutType == sinaBindType) {//已有Family帐号，绑定
        [SVProgressHUD showWithStatus:@"绑定中..." maskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD changeDistance:-60];
        NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:phoneField.text, USER_NAME, firstPwdField.text, PASSWORD, ONE, IS_COOKIE, self.sinaUid, @"sina_uid", self.sinaToken, @"sina_token", nil];
        [self uploadRequestToLoginWithPara:para loginType:commonLoginType];
        return;
    }
    [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@register", POST_API);
    NSMutableDictionary *para = nil;
    if (_aboutType == sinaSignInType) {//没有Family帐号，新浪微博注册
        para = $dict(phoneField.text, USER_NAME, firstPwdField.text, PASSWORD, checkCodeField.text, SEC_CODE, self.sinaUid, @"sina_uid", self.sinaToken, @"sina_token", self.sinaExpiresInDateStr, @"sina_expires_in");
    } else if (_aboutType == commonType) {//没有Family帐号，普通注册
        para = $dict(phoneField.text, USER_NAME, firstPwdField.text, PASSWORD, checkCodeField.text, SEC_CODE);
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        if ([[[dict objectForKey:DATA] objectForKey:WEB_RETURN] intValue] == -2) {
            [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误T_T"];
            [SVProgressHUD changeDistance:-60];
            return;
        }
        if (_aboutType == sinaSignInType) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_BIND_SINA_WEIBO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SHARE_TO_SINA_WEIBO];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self storeAuthData];
        }
        NSDictionary *dataDict = [dict objectForKey:DATA];
        [SVProgressHUD showSuccessWithStatus:@"注册成功^_^"];
        [SVProgressHUD changeDistance:-60];
        
        NSString *avatarStr = [[dataDict objectForKey:AVATAR] stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
        avatarStr = [avatarStr stringByReplacingOccurrencesOfString:@"middle" withString:@"big"];
        
//        [ConciseKit setUserDefaultsWithObject:phoneField.text forKey:USER_NAME];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
        [ConciseKit setUserDefaultsWithObject:avatarStr forKey:AVATAR_URL];
        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIP_STATUS] forKey:VIP_STATUS];
        
        [[PDKeychainBindings sharedKeychainBindings] setObject:phoneField.text forKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:M_AUTH] forKey:M_AUTH];
        [[PDKeychainBindings sharedKeychainBindings] setObject:firstPwdField.text forKey:PASSWORD];
        
        SignInMyInfoViewController *con = [[SignInMyInfoViewController alloc] initWithNibName:@"SignInMyInfoViewController" bundle:nil];
        con.topViewType = self.topViewType;
        [self.navigationController pushViewController:con animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_aboutType == sinaSignInType && textField != phoneField) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = -50;
            self.view.frame = viewFrame;
        }];
    }
}

- (IBAction)bgBtnPressed:(id)sender {
    [self resignKeyboardInView:self.view];
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y < 0) {
        viewFrame.origin.y = 0;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.frame = viewFrame;
                         }];
    }
}

- (void)resignKeyboardInView:(UIView *)view   {
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyboardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

- (IBAction)showPwdBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    NSString *checkImgStr = sender.selected ? @"checked.png" : @"notChecked.png";
    _checkImgView.image = [UIImage imageNamed:checkImgStr];
    firstPwdField.secureTextEntry = !sender.selected;
//    secondPwdField.secureTextEntry = !sender.selected;
    
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        firstPwdField.secureTextEntry = NO;
//        secondPwdField.secureTextEntry = NO;
//        [sender setTitle:@"隐藏密码" forState:UIControlStateNormal];
//    } else {
//        firstPwdField.secureTextEntry = YES;
//        secondPwdField.secureTextEntry = YES;
//        [sender setTitle:@"显示密码" forState:UIControlStateNormal];
//    }
}

//- (void)startToCountTimeToGetCheckCodeWithBtn:(UIButton*)button {
//    if (timer) {
//        [timer invalidate];
//        timer = nil;
//    }
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
//                                              block:^(NSTimeInterval time) {
//                                                  [self changeForTimerWithBtn:button];
//                                              } repeats:YES];
//}
//
//- (void)changeForTimerWithBtn:(UIButton*)button {
//    countTime--;
//    [button setTitle:[NSString stringWithFormat:@"获取验证码(%d)", countTime] forState:UIControlStateNormal];
//    if (countTime <= 0) {
////        button.userInteractionEnabled = YES;
//        [button setBackgroundImage:[UIImage imageNamed:@"long_green_bg.png"] forState:UIControlStateNormal];
//        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        countTime = COUNT_TIME_NUM;
//        [timer invalidate];
//        timer = nil;
//    }
//}

- (IBAction)getCheckCodeBtnPressed:(UIButton*)sender {
    if (phoneField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请先输入手机号码T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
//    if (countTime < COUNT_TIME_NUM ) {
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"验证码已发送，请等待接收手机短信。%d秒后才能再次获取验证码", countTime]];
//        return;
//    }
    [SVProgressHUD showWithStatus:@"获取验证码中..." maskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD changeDistance:-60];
    [checkCodeField becomeFirstResponder];
    NSString *url = $str(@"%@register&op=getseccode", POST_API);
    NSMutableDictionary *para = $dict(phoneField.text, USER_NAME);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
//        [sender setBackgroundImage:[UIImage imageNamed:@"input_bg.png"] forState:UIControlStateNormal];
//        [sender setTitle:[NSString stringWithFormat:@"获取验证码(%d)", countTime] forState:UIControlStateNormal];
//        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
////        sender.userInteractionEnabled = NO;
//        [self startToCountTimeToGetCheckCodeWithBtn:sender];
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"申请成功" message:[dict objectForKey:WEB_MSG]];
        [alert setCancelButtonWithTitle:@"确定" handler:^{
            return ;
        }];
        [alert show];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}



@end
