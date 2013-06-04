//
//  HorizontalTableCell.m
//  family_ver_pm
//
//  Created by pandara on 13-3-21.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableCell.h"

@implementation HorizontalTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{   NSLog(@"initWithStyle in HorizontalTableCell");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSLog(@"init withStyle in horizontalTableCell");
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellStyle:(HorizontalTableCell *)cell
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.transform = transform;
}

@end
