//
//  ActivityViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomBarViewDelegate.h"
#import "MainViewController.h"
#import "HorizontalTableView.h"
#import "ActivityViewTableCell.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "BaseScrollViewController.h"

@interface ActivityViewController : BaseScrollViewController

@property (strong, nonatomic) MainViewController *delegate;

@end
