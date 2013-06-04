//
//  PickerViewWithToolBar.h
//  family_ver_pm
//
//  Created by pandara on 13-5-11.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewWithToolBarDelegate.h"

@interface PickerViewWithToolBar : UIView

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barItem;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) id<PickerViewWithToolBarDelegate, UIPickerViewDelegate> delegate;
@property (strong, nonatomic) id<UIPickerViewDataSource> dataSource;

- (void)setMyPickerDataSource:(id<UIPickerViewDataSource>) sdataSource;
- (void)setMyPickerDelegate:(id<PickerViewWithToolBarDelegate, UIPickerViewDelegate>) sdelegate;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)reloadAllComponents;

@end
