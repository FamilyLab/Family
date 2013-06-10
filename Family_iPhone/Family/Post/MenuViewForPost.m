//
//  MenuViewForPost.m
//  Family
//
//  Created by Aevitx on 13-6-5.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MenuViewForPost.h"

@implementation MenuViewForPost

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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_albumBtn) {
        if (!self.arrowImgView) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow1.png"]];
            self.arrowImgView = imgView;
            [self.albumBtn addSubview:imgView];
        }
        
        [self.albumBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_albumBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 2)];
        [_albumBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        self.arrowImgView.frame = (CGRect){.origin.x = _albumBtn.titleLabel.frame.origin.x + _albumBtn.titleLabel.frame.size.width + 1, .origin.y = _albumBtn.titleLabel.frame.origin.y + 2, .size = _arrowImgView.frame.size};
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
