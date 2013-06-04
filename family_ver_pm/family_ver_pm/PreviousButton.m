//
//  PreviousButton.m
//  family_ver_pm
//
//  Created by pandara on 13-3-22.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PreviousButton.h"

@implementation PreviousButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PreviousButton" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        self.frame = frame;
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
