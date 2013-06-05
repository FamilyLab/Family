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
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _actionLabel.backgroundColor = [UIColor clearColor];
        _actionLabel.textColor = [UIColor lightGrayColor];
        _actionLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        _actionImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"actionre.png"]];
        _actionImage.frame = CGRectMake(0, 0, 18, 11);
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize nameSize = [nameLbl.text sizeWithFont:nameLbl.font constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    nameSize.height = nameSize.height < 20 ? 20 : nameSize.height;
    //        nameLbl.frame = (CGRect){.origin = nameLbl.frame.origin, .size = CGSizeMake(40, 30)};
    nameLbl.frame = (CGRect){.origin = nameLbl.frame.origin, .size = nameSize};
   // _actionLabel.frame = CGRectMake(_actionImage.frame.origin.x+_actionImage.frame.size.width +5, _actionImage.frame.origin.y, 1000, nameLbl.frame.size.height);

    //        containerView.frame = (CGRect){.origin = containerView.frame.origin, .size.width = containerView.frame.size.width, .size.height = timeView.frame.origin.y + timeView.frame.size.height + 3};
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
