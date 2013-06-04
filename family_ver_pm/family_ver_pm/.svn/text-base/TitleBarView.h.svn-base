//
//  TitleBarView.h
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowLayoutLabel.h"

@interface TitleBarView : UIView

@property (strong, nonatomic) IBOutlet UILabel *authorLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) FlowLayoutLabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *titleBackground;
@property (strong, nonatomic) UIView *titleLabelContainer;

- (void)setTitleLabelMaxWidth:(int)smaxWidth maxLine:(int)smaxLine font:(UIFont *)sfont;
- (void)setTitle:(NSString *)titleText;
- (void)setAuthor:(NSString *)authorName;
- (void)setDate:(NSString *)dateString;

@end
