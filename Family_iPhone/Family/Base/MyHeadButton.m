//
//  MyHeadButton.m
//  Family
//
//  Created by Aevitx on 13-3-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyHeadButton.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+JMImageCache.h"

@implementation MyHeadButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 1.0f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)addBorderColor:(UIColor*)borderColor {
    CALayer *layer = self.layer;
    layer.borderColor = [borderColor CGColor];
    layer.borderWidth = 1.0f;
}

- (void)setVipStatusWithStr:(NSString*)vipStatus isSmallHead:(BOOL)isSmallHead {
    CGFloat vipWidth = isSmallHead ? 10 : 15;
    if (!_vipImgView) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - vipWidth, self.frame.size.height - vipWidth, vipWidth, vipWidth)];
        [self addSubview:imgView];
        self.vipImgView = imgView;
    }
    if ([vipStatus isEqualToString:@"personal"]) {
        _vipImgView.image = [UIImage imageNamed:@"personal_v_red.png"];
        _vipImgView.hidden = NO;
    } else if ([vipStatus isEqualToString:@"family"]) {
        _vipImgView.image = [UIImage imageNamed:@"family_v_blue.png"];
        _vipImgView.hidden = NO;
    } else {
        _vipImgView.hidden = YES;
    }
}

- (void)setImageForMyHeadButtonWithUrlStr:(NSString*)urlStr plcaholderImageStr:(NSString*)placeholderImageStr {
    placeholderImageStr = placeholderImageStr ? placeholderImageStr : @"head_220.png";
    
    NSString *tmpStr1 = [urlStr copy];
    tmpStr1 = [tmpStr1 stringByReplacingOccurrencesOfString:@"small" withString:@""];
    tmpStr1 = [tmpStr1 stringByReplacingOccurrencesOfString:@"middle" withString:@""];
    tmpStr1 = [tmpStr1 stringByReplacingOccurrencesOfString:@"big" withString:@""];
    
    NSString *tmpStr2 = [MY_HEAD_AVATAR_URL copy];
    tmpStr2 = [tmpStr2 stringByReplacingOccurrencesOfString:@"small" withString:@""];
    tmpStr2 = [tmpStr2 stringByReplacingOccurrencesOfString:@"middle" withString:@""];
    tmpStr2 = [tmpStr2 stringByReplacingOccurrencesOfString:@"big" withString:@""];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"small" withString:@"middle"];//不用小头像，用中头像
    if ([tmpStr1 isEqualToString:tmpStr2]) {//对比tmpStr1和tmpStr2，如果相同刚是我自己的头像
        [self setImageWithNoCacheWithURLByJM:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImageStr]];//我自己的头像
    } else {
        [self setImageWithURLByJM:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImageStr]];
    }
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
