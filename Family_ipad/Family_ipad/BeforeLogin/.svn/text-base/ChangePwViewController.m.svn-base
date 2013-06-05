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
#import "UIAlertView+BlocksKit.h"
#import "LoginViewController.h"
#import "Common.h"
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
            break;
        }
        case inputPhoneForLostPwd:
        {
            int index = 0;
            int allSubNum = [self.contentView.subviews count];
            for (UIView *sub in self.contentView.subviews) {
                if (index > 2 && index < allSubNum - 1&&sub.tag<100) {
                    [sub removeFromSuperview];
                } else {
                    sub.hidden = NO;
                }
                index++;
            }
            _currPwdField.placeholder = @"输入您的手机号码";
            _currPwdField.secureTextEntry = NO;
            _doneBtn.frame = (CGRect){.origin.x = _doneBtn.frame.origin.x, .origin.y = _currPwdField.frame.origin.y + 70, .size = _doneBtn.frame.size};
            [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
            break;
        }
        case resetPwdForLostPwd:
        {
            _currPwdField.secureTextEntry = NO;
            _currPwdField.placeholder = @"输入收到的验证码";
            [_doneBtn setTitle:@"提交" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)


- (IBAction)bgBtnPressed:(id)sender {
  [Common resignKeyboardInView:self.contentView];
}

- (IBAction)showPwdBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    NSString *checkImgStr = sender.selected ? @"checked.png" : @"notChecked.png";
    _checkImgView.image = [UIImage imageNamed:checkImgStr];
    if (_aboutPwd != changePwd) {
        _currPwdField.secureTextEntry = NO;
    } else {
        _currPwdField.secureTextEntry = !sender.selected;
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
    if (_currPwdField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"没有输入手机号码T_T"];
        return;
    }
    [SVProgressHUD showWithStatus:@"发送申请中..."];
    NSString *url = $str(@"%@lostpasswd", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currPwdField.text, USER_NAME, ONE, LOST_PWD_SUBMIT, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        self.userId = emptystr([[dict objectForKey:WEB_DATA] objectForKey:UID]);
        if (isEmptyStr(_userId)) {
            [SVProgressHUD showErrorWithStatus:@"服务器有毛病T_T"];
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"取回密码的方法已经通过短信发送到您的手机中，请等待接收并修改您的密码"];
        [alert setCancelButtonWithTitle:@"确定" handler:^{
            ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
            con.aboutPwd = resetPwdForLostPwd;
            con.userId= emptystr([[dict objectForKey:WEB_DATA] objectForKey:UID]);
            [self.navigationController pushViewController:con animated:YES];
        }];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//找回密码，第二步，输入新密码
- (IBAction)resetPwBtnPressed:(id)sender {
    if (_currPwdField.text.length <= 0 || _theNewPwdField.text.length <= 0 || _confirmPwdField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        return;
    }
    [SVProgressHUD showWithStatus:@"重置密码中..."];
    NSString *url = $str(@"%@lostpasswd", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userId, UID, _currPwdField.text, @"code", _theNewPwdField.text, THE_NEW_PWD1, _confirmPwdField.text, THE_NEW_PWD2, ONE, RESET_SUBMIT, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重置成功" message:[dict objectForKey:WEB_MSG]];
        [alert setCancelButtonWithTitle:@"确定" handler:^{
            UIViewController *login;
            for (UIViewController *con  in self.navigationController.viewControllers) {
                if ([con isKindOfClass:[LoginViewController class]]) {
                    login = con;
                }
            }
            [self.navigationController popToViewController:login animated:YES];
        }];
        [alert show];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//修改密码
- (IBAction)changePwBtnPressed:(id)sender {
    if (_currPwdField.text.length <= 0 || _theNewPwdField.text.length <= 0 || _confirmPwdField.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"有信息未填写T_T"];
        return;
    }
    if (![_theNewPwdField.text isEqualToString:_confirmPwdField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的新密码不一致T_T"];
        return;
    }
    [SVProgressHUD showWithStatus:@"修改密码中..."];
    NSString *url = $str(@"%@account", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_currPwdField.text, PASSWORD, _theNewPwdField.text, THE_NEW_PWD1, _confirmPwdField.text, THE_NEW_PWD2, ONE, PWD_SUBMIT, POST_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
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
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [Common resignKeyboardInView:self.contentView];

        //保存密码
//        [[PDKeychainBindings sharedKeychainBindings] setObject:_theNewPwdField.text forKey:PASSWORD];
//        [self uploadRequestToReLogin:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//重新登录得到新的m_auth
//- (void)uploadRequestToReLogin:(id)sender {
//    NSString *url = $str(@"%@login", POST_API);
//    NSString *cookie = MY_AUTO_LOGIN ? @"1" : @"0";
//    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:MY_USER_NAME, USER_NAME, _theNewPwdField.text, PASSWORD, cookie, IS_COOKIE, nil];
//    //    [[MyHttpClient sharedInstance] commandWithPathAndParams:@"/dapi/do.php?" params:[NSDictionary dictionaryWithObject:@"login" forKey:@"ac"] addData:^(id<AFMultipartFormData> formData) {
//    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//        
//    } onCompletion:^(NSDictionary *dict) {
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//        [[PDKeychainBindings sharedKeychainBindings] setObject:[[dict objectForKey:DATA] objectForKey:M_AUTH] forKey:M_AUTH];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        NSLog(@"error:%@", [error description]);
//    }];
//}

@end
