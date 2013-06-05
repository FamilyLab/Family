//
//  ChangePwViewController.h
//  Family
//
//  Created by Aevitx on 13-3-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    changePwd               = 0,
    inputPhoneForLostPwd    = 1,
    resetPwdForLostPwd      = 2
} AboutPwd;

@interface ChangePwViewController : BaseViewController  {

}

@property (nonatomic, assign) AboutPwd aboutPwd;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) IBOutlet UITextField *currPwdField;
@property (nonatomic, strong) IBOutlet UITextField *theNewPwdField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPwdField;
@property (nonatomic, strong) IBOutlet UIImageView *checkImgView;

@property (nonatomic, strong) IBOutlet UIButton *doneBtn;

@end
