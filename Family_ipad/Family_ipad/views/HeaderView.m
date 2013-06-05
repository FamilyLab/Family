//
//  HeaderView.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView
- (void)setDarkImage
{
    [_headerLine setImage:[UIImage imageNamed:@"header_line2.png"]];
    [_headerLogo setImage:[UIImage imageNamed:@"logo_dark.png"]];
    [_headerTitleBg setImage:[UIImage imageNamed:@"header_title_bg2.png"]];
}
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

@end
