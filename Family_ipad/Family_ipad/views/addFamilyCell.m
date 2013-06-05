//
//  addFamilyCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "addFamilyCell.h"
#import "UIImageView+AFNetworking.h"
#import "CKMacros.h"
#import "DDAlertPrompt.h"
#import "UIAlertView+BlocksKit.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
@implementation addFamilyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)addFriend:(id)sender
{
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"申请成为家人" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    __block DDAlertPrompt *blockAlert = alertPrompt;
    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        [SVProgressHUD showWithStatus:@"发送申请中..."];
        NSString *url = $str(@"%@friend&op=add", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:avatar.identify, APPLY_UID, ONE, G_ID, blockAlert.theTextView.text, NOTE, ONE, ADD_SUBMIT, POST_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"申请已发送"];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alertPrompt show];

}
- (void)setCellData:(NSDictionary *)dict
{
    [super setCellData:dict];
    
    avatar.identify = [dict objectForKey:UID];
    _feedLabel.text = $str(@"%@个家人   %@个动态",[dict objectForKey:FAMILY_MEMBERS],[dict objectForKey:FAMILY_FEEDS]);
    BOOL shouldHideAddBtn = [[dict objectForKey:IS_FAMILY] boolValue] ? YES : ([[dict objectForKey:UID] isEqualToString:MY_UID] ? YES : NO);
    self.addButton.hidden = shouldHideAddBtn;//[[aDcit objectForKey:IS_FAMILY] boolValue];
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
