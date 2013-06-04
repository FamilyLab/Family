//
//  PostView.m
//  Family
//
//  Created by Aevitx on 13-1-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "PostView.h"

@implementation PostView
@synthesize describeTextView;
@synthesize firstTextField, secondTextField;
@synthesize albumBtn, locationBtn, personsBtn, firstImgView, secondImgView, thirdImgView, fourthImgView;
@synthesize wantToSayTable;

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
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self.albumBtn setBackgroundImage:ThemeImage(@"album_big_a") forState:UIControlStateNormal];
//    }
//    return self;
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
