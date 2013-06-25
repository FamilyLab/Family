//
//  InviteOtherCell.m
//  Family
//
//  Created by Aevitx on 13-6-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "InviteOtherCell.h"
#import "MyYIPopupTextView.h"
#import "MPNotificationView.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"

@implementation InviteOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initData:(NSDictionary *)aDict {
    self.dataDict = aDict;
    [_headBtn setImageForMyHeadButtonWithUrlStr:emptystr([aDict objectForKey:AVATAR]) plcaholderImageStr:@"head_70.png"];
    _headBtn.userInteractionEnabled = NO;
    _nameLbl.text = emptystr([aDict objectForKey:NAME]);
    _phoneLbl.text = $str(@"%.0f", [emptystr([aDict objectForKey:USER_NAME]) doubleValue]);
    
    NSString *normalStr = [emptystr([aDict objectForKey:UID]) isEqualToString:@""] ? @"invite_a_v13.png" : @"add_a_v13.png";
    NSString *highlighStr = [emptystr([aDict objectForKey:UID]) isEqualToString:@""] ? @"invite_b_v13.png" : @"add_b_v13.png";
    [_operateBtn setImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
    [_operateBtn setImage:[UIImage imageNamed:highlighStr] forState:UIControlStateHighlighted];
}

- (IBAction)operateBtnPressed:(UIButton*)sender {
    if ([emptystr([_dataDict objectForKey:UID]) isEqualToString:MY_UID]) {
        [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩了T_T"];
        return;
    }
    if (![emptystr([_dataDict objectForKey:UID]) isEqualToString:@""]) {//添加
        MyYIPopupTextView *popTextView = [[MyYIPopupTextView alloc] initWithMaxCount:0 placeHolger:@"输入备注名称" textViewSize:CGSizeMake(DEVICE_SIZE.width - 10 * 2, 200) textViewInsets:UIEdgeInsetsMake(50, 10, 50, -10)];
        //    popTextView.delegate = self;
        [popTextView showInView:[Common viewControllerOfView:self].view];
        [popTextView.acceptButton whenTapped:^{
            [MPNotificationView notifyWithText:@"发送申请中..." detail:nil andDuration:0.5f];
            NSString *url = $str(@"%@friend&op=add", POST_CP_API);
            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_dataDict objectForKey:UID], APPLY_UID, ONE, G_ID, popTextView.text, NOTE, ONE, ADD_SUBMIT, MY_M_AUTH, M_AUTH, nil];
            [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
            } onCompletion:^(NSDictionary *dict) {
                if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                    return ;
                }
                [MPNotificationView notifyWithText:@"申请已发送" detail:nil andDuration:0.5f];
                sender.selected = YES;
            } failure:^(NSError *error) {
                NSLog(@"error:%@", [error description]);
                [MPNotificationView notifyWithText:@"网络不好T_T" detail:nil andDuration:0.5f];
                sender.selected = NO;
            }];
            [popTextView dismiss];
        }];
    } else {//邀请
        //    [SVProgressHUD showWithStatus:@"注册中..."];
        [MPNotificationView notifyWithText:[NSString stringWithFormat:@"邀请 %@ 中...", emptystr([_dataDict objectForKey:NAME])] detail:nil andDuration:0.5f];
        //    [SVProgressHUD changeDistance:-60];
        NSString *url = $str(@"%@invite", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:emptystr([_dataDict objectForKey:USER_NAME]), USER_NAME, emptystr([_dataDict objectForKey:NAME]), NAME, ONE, SMS_INVITE, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                [SVProgressHUD changeDistance:-60];
                return ;
            }
            [MPNotificationView notifyWithText:[NSString stringWithFormat:@"已发送短信通知%@", emptystr([_dataDict objectForKey:NAME])] detail:nil andDuration:0.5f];
            //        [SVProgressHUD dismiss];
            //        [self showSendSmsView];
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [MPNotificationView notifyWithText:@"网络不好T_T" detail:nil andDuration:0.5f];
            //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
            [SVProgressHUD changeDistance:-60];
        }];
    }
}

@end
