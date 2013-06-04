//
//  DialogueListCell.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "DialogueListCell.h"

@implementation DialogueListCell
@synthesize dataDic, headBtn, nameLbl, nicknameLbl, unreadLbl, unreadRightImg;

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

-(void)init:(NSDictionary *)_dataDic
{
    dataDic = _dataDic;
    [headBtn setImageForMyHeadButtonWithUrlStr:[dataDic objectForKey:PM_AVATAR] placeholderImageStr:@"head_110.png"];
    NSString *nicknameStr = [[dataDic objectForKey:NOTE] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"(%@)", [dataDic objectForKey:NOTE]];
    NSString *noteStr = [NSString stringWithFormat:@"%@%@", [dataDic objectForKey:PM_TO_NAME], nicknameStr];
    nameLbl.text = noteStr;
    //nicknameLbl.text = ;
    if ([[dataDic objectForKey:UNREAD_MESSAGE] intValue] <= 0) {
        unreadLbl.hidden = YES;
        unreadRightImg.hidden = YES;
    }else{
        unreadLbl.hidden = NO;
        unreadRightImg.hidden = NO;
        unreadLbl.text = [dataDic objectForKey:UNREAD_MESSAGE];
    }
}

-(void)dealloc
{
    [super dealloc];
    [dataDic release], dataDic = nil;
    [headBtn release], headBtn = nil;
    [nameLbl release], nameLbl = nil;
    [nicknameLbl release], nicknameLbl = nil;
    [unreadLbl release], unreadLbl = nil;
    [unreadRightImg release], unreadRightImg = nil;
}

@end
