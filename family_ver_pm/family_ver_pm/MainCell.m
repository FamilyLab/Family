//
//  MainCell.m
//  family_ver_pm
//
//  Created by pandara on 13-3-19.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell

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

    // Configure the view for the selected state
}

- (void)setSelectedStyle:(NSIndexPath *)indexPath
{
    if (indexPath.row == MAIN_CELL_COUNT - 1) {
        self.bgImg.image = [UIImage imageNamed:@"cell_bg_red_active.png"];
    } else if (indexPath.row % 2) {
        self.bgImg.image = [UIImage imageNamed:@"cell_bg_green_active.png"];
    } else {
        self.bgImg.image = [UIImage imageNamed:@"cell_bg_green_deep_active.png"];
    }
}

- (void)configCellStyle
{
    //去除默认背景 分割线
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.icon.frame = CGRectMake(20, self.bgImg.frame.origin.y + (self.bgImg.frame.size.height - self.icon.frame.size.height) / 2, self.icon.frame.size.width, self.icon.frame.size.height);
    self.label.frame = CGRectMake(80, self.bgImg.frame.origin.y + (self.bgImg.frame.size.height - self.label.frame.size.height) / 2, 85, 40);
    
}

- (void)configCellApparence:(NSIndexPath *)indexPath
{
    self.feedCount.alpha = 0;
    
    NSInteger row = indexPath.row;
    
    self.labelStrArray = [[NSArray alloc] initWithObjects:@"图片", @"日记", @"活动", @"视频", @"对话", @"空间", @"家人", @"设置", @"发表", nil];
    self.bgImgNameArray = [[NSArray alloc] initWithObjects:@"cell_bg_green_deep", @"cell_bg_green", @"cell_bg_red", nil];
    self.iconNameArray = [[NSArray alloc] initWithObjects:@"icon_pic", @"icon_daily",@"icon_activity", @"icon_video", @"icon_chat", @"icon_zone",@"icon_family", @"icon_setting", @"icon_submit", nil];
    
    self.label.text = [self.labelStrArray objectAtIndex:row];
    if (row == MAIN_CELL_COUNT - 1) {
        self.bgImg.image = [UIImage imageNamed:[self.bgImgNameArray objectAtIndex:2]];
    } else {
        self.bgImg.image = [UIImage imageNamed:[self.bgImgNameArray objectAtIndex:(row % 2)]];
    }
    self.icon.image = [UIImage imageNamed:[self.iconNameArray objectAtIndex:row]];
}

@end