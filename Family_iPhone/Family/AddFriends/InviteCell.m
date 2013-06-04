//
//  InviteCell.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "InviteCell.h"
#import "Common.h"

@implementation InviteCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)initData:(NSDictionary *)_aDict {
    //    self.dataDict = _aDict;
    NSString *dateStr = [NSString stringWithFormat:@"%@申请成为你的家人", [Common convertToDate:[_aDict objectForKey:DATELINE]]];
    self.simpleInfoView.isFamilyList = NO;
    self.simpleInfoView.userId = [_aDict objectForKey:UID];
    [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([_aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
    [self.simpleInfoView initInfoWithHeadUrlStr:[_aDict objectForKey:AVATAR]
                                        nameStr:[_aDict objectForKey:NAME]
                                        infoStr:dateStr
                              rightlBtnNormaImg:@"agree_a.png"
                          rightlBtnHighlightImg:@"agree_b.png"
                           rightlBtnSelectedImg:nil];
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
