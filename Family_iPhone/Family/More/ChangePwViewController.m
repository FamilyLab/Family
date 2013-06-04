//
//  ChangePwViewController.m
//  Family
//
//  Created by Aevitx on 13-3-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ChangePwViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"

@interface ChangePwViewController ()

@end

@implementation ChangePwViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _aboutPwd = changePwd;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (_aboutPwd) {
        case changePwd:
        {
            for (UIView *sub in self.view.subviews) {
                sub.hidden = NO;
            }
            
            [_currPwdOrPhoneField setInputAccessoryView:[self buildBottomView]];
            [_theNewPwdField setInputAccessoryView:[self buildBottomView]];
            [_confirmPwdField setInputAccessoryView:[self buildBottomView]];
            [_doneBtn removeFromSuperview];
            _doneBtn = nil;
            break;
        }
        case inputPhoneForLostPwd:
        {
            int index = 0;
            int allSubNum = [self.view.subviews count];
            for (UIView *sub in self.view.subviews) {
                if (index > 2 && index < allSubNum - 1) {
                    [sub removeFromSuperview];
                } else {
                    sub.hidden = NO;
                }
                index++;
            }
            _currPwdOrPhoneField.placeholder = @"第一步，请输入您的手机号码";
            _currPwdOrPhoneField.secureTextEntry = NO;
            _currPwdOrPhoneField.keyboardType = UIKeyboardTypeNumberPad;
            _doneBtn.frame = (CGRect){.origin.x = _doneBtn.frame.origin.x, .origin.y = _currPwdOrPhoneField.frame.origin.y + 70, .size = _doneBtn.frame.size};
            [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
            
            [_currPwdOrPhoneField becomeFirstResponder];
            [_currPwdOrPhoneField setInputAccessoryView:[self buildBottomView]];
            [_doneBtn removeFromSuperview];
            _doneBtn = nil;
            break;
        }
        case resetPwdForLostPwd:
        {
            _currPwdOrPhoneField.secureTextEntry = NO;
            _currPwdOrPhoneField.placeholder = @"第二步，请输入收到的验证码";
            [_doneBtn setTitle:@"提交" forState:UIControlStateNormal];
            
            _currPwdOrPhoneField.keyboardType = UIKeyboardTypeNumberPad;
            [_currPwdOrPhoneField setInputAccessoryView:[self buildBottomView]];
            [_theNewPwdField setInputAccessoryView:[self buildBottomView]];
            [_confirmPwdField setInputAccessoryView:[self buildBottomView]];
            [_doneBtn removeFromSuperview];
            _doneBtn = nil;
            break;
        }
        default:
            break;
    }
    [self addTopView];
    [self addBottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    if (_aboutPwd == changePwd) {
        topView.topViewType = notLoginOrSignIn;
    } else {
        topView.topViewType = loginOrSignIn;
    }
    [topView leftBg];
    NSString *tipStr = _aboutPwd == changePwd ? @"修改密码" : @"找回密码";
    [topView leftText:tipStr];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (BottomView*)buildBottomView {
    NSArray *normalImages;
    if (_aboutPwd == inputPhoneForLostPwd) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"nextStep", nil];
    } else {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"login_ok", nil];
    }
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    bottomView.delegate = self;
    return bottomView;
}

- (void)addBottomView {
    BottomView *bottomView = [self buildBottomView];
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            [self doneBtnPressed:nil];
            break;
        }
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_aboutPwd != inputPhoneForLostPwd){
        CGFloat theY = textField == _currPwdOrPhoneField ? 0 : (textField == _theNewPwdField ? 50 : textField == _confirmPwdField ? 86 : 0);
        [UIView animateWithDuration:0.3f animations:^{
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = -theY;
            self.view.frame = viewFrame;
        }];
    }
}

- (IBAction)bgBtnPressed:(id)sender {
    [Common resignKeyboardInView:self.view];
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y < 0) {
        viewFrame.origin.y = 0;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.frame = viewFrame;
                         }];
    }
}

- (IBAction)showPwdBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    NSString *checkImgStr = sender.selected ? @"checked.png" : @"notChecked.png";
    _checkImgView.image = [UIImage imageNamed:checkImgStr];
    if (_aboutPwd != changePwd) {
        _currPwdOrPhoneField.secureTextEntry = NO;
    } else {
        _currPwdOrPhoneField.secureTextEntry = !sender.selected;
    }
    _theNewPwdField.secureTextEntry = !sender.selected;
    _confirmPwdField.secureTextEntry = !sender.selected;
}

- (IBAction)doneBtnPressed:(id)sender {
    if (_aboutPwd == changePwd) {
        [self changePwBtnPressed:sender];
    } else if (_aboutPwd == inputPhoneForLostPwd) {
        [self inputPhoeBtnPressed:sender];
    } else if (_aboutPwd == resetPwdForLostPwd) {
        [self resetPwBtnPressed:sender];
    }
}

//找回密码，第一步，输入手机号码
- (IBAction)inputPhoeBtnPressed:(id)sender {
    if (_currPwdOrPhoneField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"没有输入手机号码T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"发送申请中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@lostpasswd", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currPwdOrPhoneField.text, USER_NAME, ONE, LOST_PWD_SUBMIT, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD dismiss];
//        self.userId = emptystr([[dict objectForKey:WEB_DATA] objectForKey:UID]);
        if ([emptystr([[dict objectForKey:WEB_DATA] objectForKey:UID]) isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"服务器有毛病，没有uidT_T"];
            [SVProgressHUD changeDistance:-60];
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"取回密码的方法已经通过短信发送到您的手机中，请等待接收并修改您的密码"];
        [alert setCancelButtonWithTitle:@"确定" handler:^{
            ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
            con.aboutPwd = resetPwdForLostPwd;
            con.userId = emptystr([[dict objectForKey:WEB_DATA] objectForKey:UID]);
            [self.navigationController pushViewController:con animated:YES];
        }];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

//找回密码，第二步，输入新密码
- (IBAction)resetPwBtnPressed:(id)sender {
    if (_currPwdOrPhoneField.text.length <= 0 || _theNewPwdField.text.length <= 0 || _confirmPwdField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"重置密码中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@lostpasswd", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userId, UID, _currPwdOrPhoneField.text, @"code", _theNewPwdField.text, THE_NEW_PWD1, _confirmPwdField.text, THE_NEW_PWD2, ONE, RESET_SUBMIT, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重置成功" message:[dict objectForKey:WEB_MSG]];
        [alert setCancelButtonWithTitle:@"确定" handler:^{
            LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:con animated:YES];
        }];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

//修改密码
- (IBAction)changePwBtnPressed:(id)sender {
    if (_currPwdOrPhoneField.text.length <= 0 || _theNewPwdField.text.length <= 0 || _confirmPwdField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    if (![_theNewPwdField.text isEqualToString:_confirmPwdField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的新密码不一致T_T"];
        [SVProgressHUD changeDistance:-60];
        return;
    }
    [SVProgressHUD showWithStatus:@"修改密码中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@account", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currPwdOrPhoneField.text, PASSWORD, _theNewPwdField.text, THE_NEW_PWD1, _confirmPwdField.text, THE_NEW_PWD2, ONE, PWD_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dict objectForKey:WEB_MSG]];
            [alert setCancelButtonWithTitle:@"确定" handler:^{
                return ;
            }];
            [alert show];
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        //保存密码
        [[PDKeychainBindings sharedKeychainBindings] setObject:_theNewPwdField.text forKey:PASSWORD];
        [self uploadRequestToReLogin:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

//重新登录得到新的m_auth
- (void)uploadRequestToReLogin:(id)sender {
    NSString *url = $str(@"%@login", POST_API);
    NSString *cookie = MY_AUTO_LOGIN ? @"1" : @"0";
    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:MY_USER_NAME, USER_NAME, _theNewPwdField.text, PASSWORD, cookie, IS_COOKIE, nil];
    //    [[MyHttpClient sharedInstance] commandWithPathAndParams:@"/dapi/do.php?" params:[NSDictionary dictionaryWithObject:@"login" forKey:@"ac"] addData:^(id<AFMultipartFormData> formData) {
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [SVProgressHUD changeDistance:-60];
        [[PDKeychainBindings sharedKeychainBindings] setObject:[[dict objectForKey:DATA] objectForKey:M_AUTH] forKey:M_AUTH];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
        NSLog(@"error:%@", [error description]);
    }];
}

@end
