//
//  DailyViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-3-24.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "BottomBarViewDelegate.h"
#import "HorizontalTableView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "HorizontalScrollViewController.h"
#import "BaseScrollViewController.h"

@interface DailyViewController : BaseScrollViewController<BottomBarViewDelegate>

@property (strong, nonatomic) MainViewController *delegate;

@end
