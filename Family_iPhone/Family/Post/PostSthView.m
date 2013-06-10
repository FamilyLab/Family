//
//  PostSthView.m
//  Family
//
//  Created by Aevitx on 13-6-5.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "PostSthView.h"

@implementation PostSthView

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
    if (self.pmNameBtn && self.pmNameBtn.titleLabel.text.length != 0) {
        CGSize pmNameSize = [_pmNameBtn.titleLabel.text sizeWithFont:_pmNameBtn.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30) lineBreakMode:UILineBreakModeWordWrap];
        pmNameSize.width += 10;
        pmNameSize.height = fmaxf(pmNameSize.height, 30);
        _pmNameBtn.frame = (CGRect){.origin = _pmNameBtn.frame.origin, .size = pmNameSize};
    }
    if (iPhone5) {
        //0为照片、1为日志、3为活动
        if (_postTypeNum == 0 || _postTypeNum == 1) {
            CGFloat theH = _postTypeNum == 0 ? 112 : 168;
            _describeTextView.frame = (CGRect){.origin = _describeTextView.frame.origin, .size.width = _describeTextView.frame.size.width, .size.height = theH};
            _otherView.frame = (CGRect){.origin.x = _otherView.frame.origin.x, .origin.y = _describeTextView.frame.origin.y + _describeTextView.frame.size.height + 20, .size = _otherView.frame.size};
            _bgImgView.image = [_bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            _bgImgView.frame = (CGRect){.origin = _bgImgView.frame.origin, .size.width = _bgImgView.frame.size.width, .size.height = _describeTextView.frame.size.height + _describeTextView.frame.origin.y + 1};
        } else if (_postTypeNum == 3) {
            _otherView.frame = (CGRect){.origin.x = _otherView.frame.origin.x, .origin.y = _timeBtn.frame.origin.y + _timeBtn.frame.size.height + 15 + 88, .size = _otherView.frame.size};
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (_describeTextView && [_describeTextView isKindOfClass:[SSTextView class]]) {
        NSString *tipStr = _postTypeNum == 3 ? @"活动内容" : @"随便说点啥吧...";
        _describeTextView.placeholder = tipStr;
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
