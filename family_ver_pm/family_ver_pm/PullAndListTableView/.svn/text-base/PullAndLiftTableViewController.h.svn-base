//
//  RootViewController.h
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WZRefreshTableHeaderView.h"
#import "WZLoadMoreTableFooterView.h"

/*
 1.实现声明的四个函数r、d、l、d
 2.注意addFooterView的调用时机
 */

@interface PullAndLiftTableViewController : UIViewController <WZRefreshTableHeaderDelegate,WZLoadMoreTableFooterDelegate, UITableViewDelegate, UITableViewDataSource>{
    WZRefreshTableHeaderView * _refreshHeaderView;
    WZLoadMoreTableFooterView * _loadMoreFooterView;
    BOOL _loading;
}

@property (strong, nonatomic) UITableView *tableView;
- (void)addFooterView;
- (void)setHeaderStyle;
- (void)setFooterStyle;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


- (void)loadMoreTableViewDataSource;
- (void)doneLoadMoreTableViewData;

- (void)refreshFooterViewLayout;
@end
