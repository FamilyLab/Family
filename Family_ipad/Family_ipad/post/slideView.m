//
//  slideView.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-25.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "slideView.h"

@implementation slideView
- (IBAction)switchWantToSay:(UIButton *)sender
{
    if (preSelectButton==sender) {
        return;
    }
    preSelectButton.selected = NO;
    sender.selected = !sender.selected;
    preSelectButton = sender;
    [UIView animateWithDuration:0.3f animations:^{
        _delter_image.frame = CGRectMake(sender.frame.origin.x+15, _delter_image.frame.origin.y, _delter_image.frame.size.width, _delter_image.frame.size.height);
    }];
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
