//
//  FeedCellHeadView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCellHeadView.h"
#import "Common.h"

@implementation FeedCellHeadView
@synthesize dataDict, headImgView, nameLbl, timeView, headBtn;

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
    self.frame = CGRectMake(0, 17, DEVICE_SIZE.width, 35);
    CGSize nameSize = [self.nameLbl.text sizeWithFont:self.nameLbl.font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    self.nameLbl.frame = (CGRect){.origin = self.nameLbl.frame.origin, .size = nameSize};
    if (_repostView.hidden) {//非转载，放在中间
        self.nameLbl.frame = (CGRect){.origin.x = self.nameLbl.frame.origin.x, .origin.y = (35 - nameSize.height) / 2, .size = nameSize};
    } else {//转载，放上面一点
        self.nameLbl.frame = (CGRect){.origin.x = self.nameLbl.frame.origin.x, .origin.y = 3, .size = nameSize};
    }
}

//- (void)initHeadViewData:(NSDictionary *)_aDict {
//    self.dataDict = _aDict;
//    self.nameLbl.textColor = [Common theLblColor];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
