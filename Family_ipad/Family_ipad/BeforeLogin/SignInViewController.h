//
//  SignInViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderView.h"
@interface SignInViewController : BaseViewController
@property (nonatomic,strong)IBOutlet UITextField *username;
@property (nonatomic,strong)IBOutlet UITextField *password;
@property (nonatomic,strong)IBOutlet UITextField *secureCode;
@property (nonatomic,strong)IBOutlet UIView *secureCodeView;
@property (nonatomic,strong)IBOutlet UIView *inputView;
@property (nonatomic,assign)BOOL thirdParty;
@property (nonatomic,strong)IBOutlet HeaderView *header;
@property (nonatomic, copy) NSString *sinaUid;
@property (nonatomic, copy) NSString *sinaToken;
@property (nonatomic, strong) IBOutlet UIImageView *checkImgView;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;
@property (nonatomic, strong) IBOutlet UIButton *bindTypeBtn;
@property (nonatomic, strong) IBOutlet UIImageView *bindImgView;
@property (nonatomic, strong) IBOutlet UIButton *signInTypeBtn;
@property (nonatomic, strong) IBOutlet UIImageView *signInImgView;
@property (nonatomic, strong) IBOutlet UIView *selectView;

- (IBAction)okBtnPressed:(id)sender;
- (IBAction)getSecureCode:(id)sender;
@end
