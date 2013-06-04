//
//  PickerViewWithToolBar.m
//  family_ver_pm
//
//  Created by pandara on 13-5-11.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PickerViewWithToolBar.h"

@implementation PickerViewWithToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"PickerViewWithToolBar" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        
        self.barItem.target = self;
        self.barItem.action = @selector(pressFinishBarItem);
        
        self.picker.showsSelectionIndicator = YES;
    }
    return self;
}

- (void)setMyPickerDelegate:(id<PickerViewWithToolBarDelegate, UIPickerViewDelegate>) sdelegate
{
    self.delegate = sdelegate;
    self.picker.delegate = sdelegate;
}

- (void)setMyPickerDataSource:(id<UIPickerViewDataSource>) sdataSource
{
    self.picker.dataSource = sdataSource;
}


- (void)pressFinishBarItem
{
    [self.delegate pressFinishBarItem];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.picker selectedRowInComponent:component];
}

- (void)reloadAllComponents
{
    [self.picker reloadAllComponents];
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
