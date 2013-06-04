//
//  MyViewCell.m
//  Family_pm
//
//  Created by shawjanfore on 13-5-1.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "MyViewCell.h"

@implementation MyViewCell
@synthesize button;
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
-(void)dealloc
{
    [super dealloc];
    [button release];
}
@end
