//
//  InviteOtherCell.m
//  Family
//
//  Created by Aevitx on 13-6-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "InviteOtherCell.h"

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
    [_headBtn setImageForMyHeadButtonWithUrlStr:emptystr([aDict objectForKey:AVATAR]) plcaholderImageStr:@"head_70.png"];
    _nameLbl.text = emptystr([aDict objectForKey:NAME]);
    _phoneLbl.text = $str(@"%.0f", [emptystr([aDict objectForKey:USER_NAME]) doubleValue]);
    
    NSString *normalStr = [emptystr([aDict objectForKey:UID]) isEqualToString:@""] ? @"invite_a_v13.png" : @"add_a_v13.png";
    NSString *highlighStr = [emptystr([aDict objectForKey:UID]) isEqualToString:@""] ? @"invite_b_v13.png" : @"add_b_v13.png";
    [_operateBtn setImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
    [_operateBtn setImage:[UIImage imageNamed:highlighStr] forState:UIControlStateHighlighted];
}

- (IBAction)operateBtnPressed:(id)sender {
    //添加
    
    //邀请
}

@end
