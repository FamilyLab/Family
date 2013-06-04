//
//  RegisterViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-4-3.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayTextField.h"
#import "RegisterViewBottomBar.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *confirmCode;
@property (strong, nonatomic) GrayTextField *userNameField;
@property (strong, nonatomic) GrayTextField *passwordField;
@property (strong, nonatomic) GrayTextField *confirmPasswordField;
@property (strong, nonatomic) GrayTextField *confirmCodeField;
@property (strong, nonatomic) RegisterViewBottomBar *bottomBar;

@end
