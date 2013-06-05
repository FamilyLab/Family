//
//  CellHeader.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CellHeader.h"

@implementation CellHeader
@synthesize leftImgView, rightBtn;
@synthesize rightImgView, middleLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGSize)getHeaderHeightWithText:(NSString*)_str {
    CGSize middleLblSize = [_str sizeWithFont:[UIFont boldSystemFontOfSize:24.0f] constrainedToSize:CGSizeMake(300, 60) lineBreakMode:UILineBreakModeWordWrap];
    middleLblSize.height = middleLblSize.height<30?30:middleLblSize.height;
    return middleLblSize;
}

- (void)initHeaderDataWithMiddleLblText:(NSString*)_str {
    self.middleLbl.text = _str;

    [self.leftImgView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.rightImgView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.middleLbl) {//左右为图片，中间为文字的情况
        self.middleLbl.numberOfLines = 0;
        CGSize middleLblSize = [CellHeader getHeaderHeightWithText:self.middleLbl.text]; //[self.middleLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(190, 40) lineBreakMode:UILineBreakModeWordWrap];
        self.middleLbl.frame = (CGRect){.origin.x = 18, .origin.y = 0, .size = middleLblSize};
        
        self.leftImgView.frame = (CGRect){.origin = CGPointZero, .size.width = self.leftImgView.frame.size.width, .size.height = self.frame.size.height};
        
        int rightImgViewX = self.middleLbl.frame.origin.x + self.middleLbl.frame.size.width + 10;
        self.rightImgView.frame = (CGRect){.origin.x = rightImgViewX, .origin.y = 0, .size.width = 480 - rightImgViewX, .size.height = self.frame.size.height};
    }
    UIButton *delBtn = nil;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            delBtn = (UIButton*)obj;
            break;
        }
    }
    if (delBtn) {
        delBtn.frame = (CGRect){.origin.x = self.frame.size.width - 80 + 10, .origin.y = 0, .size.width = 100, .size.height = self.frame.size.height};
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
