//
//  OnlyTextCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OnlyTextCell.h"

@implementation OnlyTextCell

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
- (void)initData:(NSDictionary *)aDict {
        _describeLbl.text = [aDict objectForKey:MESSAGE];
}

@end
