//
//  ModuleBottomBar.m
//  family_ver_pm
//
//  Created by pandara on 13-3-26.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "ModuleBottomBarView.h"

@implementation ModuleBottomBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"ModuleBottomBarView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        [self.backBtn addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.addSpaceButton addTarget:self action:@selector(addSpace) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)backToRoot
{
    [self.delegate backToRoot];
}

- (void)addSpace
{
    [self.delegate addSpace];
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
