//
//  SignInViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BottomView.h"
#import "TopView.h"

typedef enum {
    commonType          = 0,//非第三方的
    sinaSignInType      = 1,//新浪微博注册
    sinaBindType        = 2//新浪微博绑定
} AboutType;

@interface SignInViewController : BaseViewController <BottomViewDelegate, UITextFieldDelegate> {
//    NSTimer *timer;
//    int countTime;
}

@property (nonatomic, assign) TopViewType topViewType;
//@property (nonatomic, strong) BottomView *bottomView;

@property (nonatomic,strong)IBOutlet UITextField *phoneField;
@property (nonatomic,strong)IBOutlet UITextField *firstPwdField;
@property (nonatomic,strong)IBOutlet UITextField *checkCodeField;

//@property (nonatomic,strong)IBOutlet UIButton *showPwBtn;
@property (nonatomic, strong) IBOutlet UIImageView *checkImgView;

@property (nonatomic, assign) AboutType aboutType;
@property (nonatomic, copy) NSString *sinaUid;
@property (nonatomic, copy) NSString *sinaToken;
@property (nonatomic, copy) NSString *sinaExpiresInDateStr;

@property (nonatomic, strong) IBOutlet UIButton *bindTypeBtn;
@property (nonatomic, strong) IBOutlet UIImageView *bindImgView;
@property (nonatomic, strong) IBOutlet UIButton *signInTypeBtn;
@property (nonatomic, strong) IBOutlet UIImageView *signInImgView;

@property (nonatomic, strong) IBOutlet UIView *selectView;
@property (nonatomic, strong) IBOutlet UIView *inputView;
@property (nonatomic, strong) IBOutlet UIView *checkView;
@property (nonatomic, strong) IBOutlet UIView *passwordView;
//@property (nonatomic, strong) IBOutlet UIView *someViews;

@property (nonatomic, strong) IBOutlet UILabel *tipLabel;

@end
