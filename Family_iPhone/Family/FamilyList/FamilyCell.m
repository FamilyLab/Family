//
//  FamilyCell.m
//  Family
//
//  Created by Aevitx on 13-6-14.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyCell.h"
#import "SVProgressHUD.h"

@implementation FamilyCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize nameSize = [_nameLbl.text sizeWithFont:_nameLbl.font constrainedToSize:CGSizeMake(185, 19) lineBreakMode:UILineBreakModeWordWrap];
    _nameLbl.frame = (CGRect){.origin = _nameLbl.frame.origin, .size = nameSize};
    
    CGSize noteSize = [_noteLbl.text sizeWithFont:_noteLbl.font constrainedToSize:CGSizeMake(185, 19) lineBreakMode:UILineBreakModeWordWrap];
    _noteLbl.frame = (CGRect){.origin.x = _nameLbl.frame.origin.x + _nameLbl.frame.size.width, .origin.y = _nameLbl.frame.origin.y, .size = noteSize};

}

- (void)initData:(NSDictionary *)aDict {
    self.dataDict = aDict;
    [_headBtn setImageForMyHeadButtonWithUrlStr:[aDict objectForKey:AVATAR] plcaholderImageStr:@"head_70.png"];
    [_headBtn setVipStatusWithStr:[aDict objectForKey:VIP_STATUS] isSmallHead:YES];
    _nameLbl.text = [aDict objectForKey:NAME];
    if ([emptystr([aDict objectForKey:NOTE]) isEqualToString:@""]) {
        _noteLbl.hidden = YES;
    } else {
        _noteLbl.hidden = NO;
        _noteLbl.text = $str(@"（%@）", emptystr([aDict objectForKey:NOTE]));
    }
    NSString *infoStr = @"";
    if (![emptystr([aDict objectForKey:FAMILY_MEMBERS]) isEqualToString:@""]) {
        infoStr =[NSString stringWithFormat:@"%@个家人", [aDict objectForKey:FAMILY_MEMBERS]];
    }
    if (![emptystr([aDict objectForKey:FAMILY_FEEDS]) isEqualToString:@""]) {
        infoStr = [NSString stringWithFormat:@"%@ %@个动态", infoStr, [aDict objectForKey:FAMILY_FEEDS]];
    }
    _contentLbl.text = infoStr;
    [_callBtn addTarget:self action:@selector(callBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)callBtnPressed:(id)sender {
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        [SVProgressHUD showErrorWithStatus:@"你的设备不能拨打电话T_T"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打电话" message:[_dataDict objectForKey:USER_NAME]];
    [alert setCancelButtonWithTitle:@"取消" handler:^{
        return ;
    }];
    [alert addButtonWithTitle:@"确认" handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:$str(@"tel://%@", [_dataDict objectForKey:USER_NAME])]];
    }];
    [alert show];
}

@end
