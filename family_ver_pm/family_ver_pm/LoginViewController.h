//
//  LoginViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-4-3.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayTextField.h"
#import "LoginViewBottomBar.h"

@interface LoginViewController : UIViewController {
    BOOL autoLogin;
}

@property (strong, nonatomic) GrayTextField *userNameField;
@property (strong, nonatomic) GrayTextField *passwordField;
@property (strong, nonatomic) LoginViewBottomBar *loginViewBottomBar;
@property (strong, nonatomic) IBOutlet UIButton *autoLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *checkImage;

@end
