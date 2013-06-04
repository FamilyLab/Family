//
//  PickerItemView.h
//  family_ver_pm
//
//  Created by pandara on 13-5-11.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerItemView : UIView

@property (strong, nonatomic) UILabel *label;

- (void)setContentLabelText:(NSString *)contentText;

@end
