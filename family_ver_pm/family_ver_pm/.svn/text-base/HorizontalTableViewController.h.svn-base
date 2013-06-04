//
//  HorizontalTableViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-4-22.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "BottomBarViewDelegate.h"
#import "MainViewController.h"

@interface HorizontalTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BottomBarViewDelegate>

@property (strong, nonatomic) HorizontalTableView *tableView;
@property (strong, nonatomic) NSMutableArray *infoList;
@property (strong, nonatomic) NSMutableArray *detailInfoList;
@property (strong, nonatomic) PreviousButton *prevBtn;
@property (strong, nonatomic) NextButton *nextBtn;
@property (strong, nonatomic) MainViewController *delegate;

- (void)loadMore;//加载更多数据
- (void)prevPage;
- (void)nextPage;

@end
