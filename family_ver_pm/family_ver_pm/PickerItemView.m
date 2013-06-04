//
//  PickerItemView.m
//  family_ver_pm
//
//  Created by pandara on 13-5-11.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PickerItemView.h"

@implementation PickerItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, REPOST_VIEW_PICKER_COM_WIDTH, REPOST_VIEW_PICKER_ROW_HEIGHT)];
        self.label.font = [UIFont boldSystemFontOfSize:24];
        self.label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setContentLabelText:(NSString *)contentText
{
    self.label.text = contentText;
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
