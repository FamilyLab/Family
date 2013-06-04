//
//  GrayTextField.m
//  family_ver_pm
//
//  Created by pandara on 13-4-3.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "GrayTextField.h"

@implementation GrayTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.background = [UIImage imageNamed:@"edit_back.png"];
        self.textColor = [UIColor colorWithRed:200/255 green:200/255 blue:200/255 alpha:1];
        self.font = [UIFont fontWithName:@"Arial" size:24];//bounds.size.height - 2 * topPadding - 5];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat topPadding = 14;
    CGFloat leftPadding = 5;

    return CGRectMake(leftPadding, topPadding, bounds.size.width - 2 * leftPadding, bounds.size.height - 2 * topPadding);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGFloat topPadding = 14;
    CGFloat leftPadding = 5;
    
    return CGRectMake(leftPadding, topPadding, bounds.size.width - 2 * leftPadding, bounds.size.height - 2 * topPadding);
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
