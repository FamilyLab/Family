//
//  LoginViewController.h
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomView.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "BaseViewController.h"


@interface LoginViewController : BaseViewController <BottomViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

//@property (nonatomic, strong) IBOutlet MyButton *loginBtn;
@property (nonatomic,strong)IBOutlet UITextField *userField;
@property (nonatomic,strong)IBOutlet UITextField *pwdField;

@property (nonatomic, strong) IBOutlet UIButton *cookieBtn;
@property (nonatomic, strong) IBOutlet UIImageView *symbolImgView;

//- (IBAction)loginBtnPressed:(id)sender;

@end
