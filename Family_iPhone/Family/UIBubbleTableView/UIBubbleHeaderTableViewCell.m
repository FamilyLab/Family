//
//  UIBubbleHeaderTableViewCell.m
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов on 10/7/12.
//  Copyright (c) 2012 Stex Group. All rights reserved.
//

#import "UIBubbleHeaderTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface UIBubbleHeaderTableViewCell ()

@property (nonatomic, retain) UILabel *label;

@end

@implementation UIBubbleHeaderTableViewCell

@synthesize label = _label;
@synthesize date = _date;

+ (CGFloat)height
{
    return 28.0;
}

- (void)setDate:(NSDate *)value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *text = [dateFormatter stringFromDate:value];
    [dateFormatter release];
    
    if (self.label)
    {
        self.label.text = text;
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [UIBubbleHeaderTableViewCell height])];
    self.label.text = text;
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textAlignment = UITextAlignmentCenter;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    self.label.textAlignment = UITextAlignmentCenter;
//#else
//    self.label.textAlignment = NSTextAlignmentCenter;
//#endif
    self.label.shadowOffset = CGSizeMake(0, 1);
    self.label.shadowColor = [UIColor whiteColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor lightGrayColor];
    self.label.layer.cornerRadius = 3.0f;
    [self addSubview:self.label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize labelSize = [self.label.text sizeWithFont:self.label.font];
    labelSize.width += 6;
    labelSize.height += 4;
    self.label.frame = (CGRect){.origin.x = (self.frame.size.width - labelSize.width) / 2, .origin.y = 4, .size = labelSize};
}



@end
