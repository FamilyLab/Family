//
//  FamilyCardView.m
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyCardView.h"
#import "Common.h"
#import "DDAlertPrompt.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
//#import "UIButton+WebCache.h"

//A为我的家人，B不是我的家人
#define tipsLblFrame_A       CGRectMake(10, 150, 300, 45)
#define containerFrame_A     CGRectMake(10, 180, 300, 135)
#define callBtnFrame_A       CGRectMake(10, 330, 146, 44)
#define postBtnFrame_A       CGRectMake(164, 330, 146, 44)

#define tipsLblFrame_B       CGRectMake(10, 170, 300, 45)
#define callBtnFrame_B       CGRectMake(10, 225, 300, 44)
#define postBtnFrame_B       CGRectMake(164, 330, 146, 44)

@implementation FamilyCardView

@synthesize headBtn, nameLbl, phoneNumLbl, birthdayLbl;
@synthesize tipsLbl;
@synthesize containerView, familyNumLbl, zoneNumLbl, lastLoginDateLbl;
@synthesize callBtn;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCardDataWithIsMyFamily:(BOOL)_isMyFamily
                        headUrlStr:(NSString*)_headStr
                           nameStr:(NSString*)_namStr
                       phoneNumStr:(NSString*)_phoneNumStr
                       birthdayStr:(NSString*)_birthdayStr
                            tipStr:(NSString*)_tipStr
                         familyNum:(int)_familyNum
                        zoneNumStr:(NSString*)_zoneNumStr
                  lastLoginDateStr:(NSString*)_lastLoginDateStr {
    self.contentSize = CGSizeMake(DEVICE_SIZE.width, DEVICE_SIZE.height + 50);
//    [self.headBtn setImageWithURL:[NSURL URLWithString:_headStr] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    
    _headStr = [_headStr stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
    [self.headBtn setImageForMyHeadButtonWithUrlStr:_headStr plcaholderImageStr:nil];
    self.nameLbl.text = _namStr;
    NSMutableString *phone = [[NSMutableString alloc] initWithString:_phoneNumStr];
    [phone insertString:@"-" atIndex:3];
    [phone insertString:@"-" atIndex:8];
    self.phoneNumLbl.text = phone;
    self.birthdayLbl.text = _birthdayStr;
    self.tipsLbl.text = _isMyFamily ? @"详情" : @"你和TA还不是家人关系，快点加TA为好友吧！";//@"TA还不是FamilyDay的用户，帮TA注册，并且邀请TA加入吧！！";
    self.tipsLbl.textColor = _isMyFamily ? [Common theLblColor]: [UIColor lightGrayColor];
    
    if (_isMyFamily) {
        self.arrorImgView.hidden = NO;
        
        self.tipsLbl.frame = tipsLblFrame_A;
        self.containerView.frame = containerFrame_A;
        self.callBtn.frame = callBtnFrame_A;
        self.postPMBtn.frame = postBtnFrame_A;
        
        self.familyNumLbl.text = [NSString stringWithFormat:@"%d个", _familyNum];
        self.zoneNumLbl.text = [NSString stringWithFormat:@"%@个", _zoneNumStr];
        self.lastLoginDateLbl.text = _lastLoginDateStr;
        
        self.postPMBtn.hidden = NO;
        self.containerView.hidden = NO;
        self.callBtn.hidden = NO;
        
        [self.changeNoteBtn addTarget:self action:@selector(changeNoteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.arrorImgView.hidden = YES;
        
        [self.containerView removeFromSuperview];
        self.containerView = nil;
        self.tipsLbl.frame = tipsLblFrame_B;
        self.callBtn.frame = callBtnFrame_B;
//        self.postPMBtn.frame = postBtnFrame_B;
        [self.postPMBtn removeFromSuperview];
        [self.containerView removeFromSuperview];
        self.callBtn.hidden = NO;
    }
    if ([MY_UID isEqualToString:_userId]) {
        self.arrorImgView.hidden = YES;
    }
}

//修改备注
- (IBAction)changeNoteBtnPressed:(id)sender {
    if ([MY_UID isEqualToString:_userId]) {
        [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩啦T_T"];
        return;
    }
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"修改备注名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    alertPrompt.theTextView.text = _noteNameStr;
    __block DDAlertPrompt *blockAlert = alertPrompt;
    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        [SVProgressHUD showWithStatus:@"修改中..."];
        NSString *url = $str(@"%@friend&op=changenote", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_userId, F_UID, blockAlert.theTextView.text, NOTE, ONE, CHANGE_NOTE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } afterDelay:0.5f];
            NSString *allNameStr = @"";
            if (!isEmptyStr(blockAlert.theTextView.text)) {
                allNameStr = $str(@"%@(%@)", _nameStr, blockAlert.theTextView.text);
                _noteNameStr = blockAlert.theTextView.text;
            }
            nameLbl.text = allNameStr;
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alertPrompt show];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
