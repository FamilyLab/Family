//
//  MySingleSelectionCell.m
//  label_test
//
//  Created by pandara on 13-5-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MySingleSelectionCell.h"

@implementation MySingleSelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self setSelectedStyle];
    } else {
        [self setUnSelectedStyle];
    }
}

//被选中时的样式
- (void)setSelectedStyle
{
    self.indicatorImageView.image = [UIImage imageNamed:@"checked.png"];
}

//未被选中时的样式
- (void)setUnSelectedStyle
{
    self.indicatorImageView.image = [UIImage imageNamed:@"notChecked.png"];
}

- (void)setSelectText:(NSString *)selectText
{
    self.selectionLabel.text = selectText;
}

@end
