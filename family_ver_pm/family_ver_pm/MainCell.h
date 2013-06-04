//
//  MainCell.h
//  family_ver_pm
//
//  Created by pandara on 13-3-19.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bgImg;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *feedCount;

@property (strong, nonatomic) NSArray *labelStrArray;
@property (strong, nonatomic) NSArray *bgImgNameArray;
@property (strong, nonatomic) NSArray *iconNameArray;

- (void)configCellApparence:(NSIndexPath *)indexPath;
- (void)configCellStyle;
- (void)setSelectedStyle:(NSIndexPath *)indexPath;
//- (void)setUnSelectedStyle:(NSIndexPath *)indexPath;

@end