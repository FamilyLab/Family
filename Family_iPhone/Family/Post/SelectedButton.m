//
//  SelectedButton.m
//  Family
//
//  Created by Aevitx on 13-5-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SelectedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation SelectedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.borderWidth = 1.0f;
        
        self.clipsToBounds = NO;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_pic.png"]];
        imgView.frame = CGRectMake(-1, -1, 73, 73);
        imgView.hidden = YES;
        self.selectedImgView = imgView;
        [self addSubview:_selectedImgView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor blackColor] CGColor];
        layer.borderWidth = 1.0f;
        
        self.clipsToBounds = NO;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_pic.png"]];
        imgView.frame = CGRectMake(0, 0, 72, 72);
        imgView.hidden = YES;
        self.selectedImgView = imgView;
        [self addSubview:_selectedImgView];
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

@end
