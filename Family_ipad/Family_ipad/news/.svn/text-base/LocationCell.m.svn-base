//
//  LocationCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "LocationCell.h"
#import "Common.h"
#import "NSString+ConciseKit.h"
#import "UILabel+VerticalAlign.h"
#define ypFeedForImgAndText @"!294X390"//用于动态列表有一张图片和有文字的样式
//有图片的情况
#define aSubjectFrame   CGRectMake(165, 0, 193, 21)
#define aDateFrame      CGRectMake(165, 39, 193, 24)
#define aLocationFrame  CGRectMake(165, 75, 193, 24)
#define aDescribeFrame  CGRectMake(165, 107, 193, 68)

//无图片的情况
#define bSubjectFrame   CGRectMake(5, 0, 430, 21)
#define bDateFrame      CGRectMake(5, 39, 430, 24)
#define bLocationFrame  CGRectMake(5, 75, 430, 24)
#define bDescribeFrame  CGRectMake(5, 107, 430, 68)
@implementation LocationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_leftImgView.image) {
        _subjectLbl.frame = bSubjectFrame;
        _dateLbl.frame = bDateFrame;
        _locationLbl.frame = bLocationFrame;
        _describeLbl.frame = bDescribeFrame;
    } else {
        _subjectLbl.frame = aSubjectFrame;
        _dateLbl.frame = aDateFrame;
        _locationLbl.frame = aLocationFrame;
        _describeLbl.frame = aDescribeFrame;
    }
}
- (void)initData:(NSDictionary *)aDict {
    NSString *imgUrlStr = $emptystr([aDict objectForKey:FEED_IMAGE_1]);
    if (![imgUrlStr isEqualToString:@""]) {
        [_leftImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [imgUrlStr delLastStrForYouPai], ypFeedForImgAndText)] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        //        [_leftImgView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else {
        _leftImgView.image = nil;
    }
    _subjectLbl.text = $emptystr([aDict objectForKey:SUBJECT]);
    if (isEmptyStr([aDict objectForKey:EVENT_START_TIME])) {
        _dateLbl.text = [NSString stringWithFormat:@"时间："];
    } else
        _dateLbl.text = [NSString stringWithFormat:@"时间：%@", [Common dateConvert:[aDict objectForKey:EVENT_START_TIME]]];
    if (!isEmptyStr([aDict objectForKey:FEED_EVENT_LOCATION])) {
        _locationLbl.text = [NSString stringWithFormat:@"地点：%@", $emptystr([aDict objectForKey:FEED_EVENT_LOCATION])];
    } else
        _locationLbl.text = [NSString stringWithFormat:@"地点：%@", $emptystr([aDict objectForKey:ADDRESS])];
    _describeLbl.text = [NSString stringWithFormat:@"介绍：%@", $emptystr([aDict objectForKey:EVENT_DETAIL])];
    //[Common dateConvert:[aDict objectForKey:SUBJECT]]];
    [_describeLbl alignTop];
}
@end
