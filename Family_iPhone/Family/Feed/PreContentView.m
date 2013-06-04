//
//  PreContentView.m
//  Family
//
//  Created by Aevitx on 13-5-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "PreContentView.h"
#import "UILabel+VerticalAlign.h"

@implementation PreContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [_rightLbl alignTop];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [_rightLbl alignTop];
    }
    return self;
}

+ (CGSize)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font {
    if (!font) {
        font = [UIFont boldSystemFontOfSize:14.0f];
    }
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    size.height = _miniHeight + ceilf(size.height);//235
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize contentSize = [_rightLbl.text sizeWithFont:_rightLbl.font constrainedToSize:CGSizeMake(self.frame.size.width - _leftImgView.frame.origin.x - 5, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    _rightLbl.frame = (CGRect){.origin = _rightLbl.frame.origin, .size = contentSize};
    
    _leftImgView.image = [_leftImgView.image stretchableImageWithLeftCapWidth:0 topCapHeight:1];
    _leftImgView.frame = (CGRect){.origin = _leftImgView.frame.origin, .size.width = 2, .size.height = contentSize.height};
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
