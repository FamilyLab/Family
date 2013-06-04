//
//  TableController.h
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullTableView.h"
#import "BaseViewController.h"
//#import "UIBubbleTableViewDataSource.h"

#import "MLNavigationController.h"
#import "TouchTableView.h"

@interface TableController : BaseViewController <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, TouchTableViewDelegate> {//, UIBubbleTableViewDataSource> {
    
    NSMutableArray *dataArray, *secondDataArray;
    NSUInteger currentPage;
    BOOL needRemoveObjects;
    IBOutlet PullTableView *_tableView;
    
    NSUInteger secondCurrentPage;
    BOOL secondNeedRemoveObjects;
    IBOutlet PullTableView *_secondTableView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL needRemoveObjects;
@property (nonatomic, strong) IBOutlet PullTableView *_tableView;

@property (nonatomic, assign) BOOL isFirstTable;
@property (nonatomic, strong) NSMutableArray *secondDataArray;
@property (nonatomic, assign) NSUInteger secondCurrentPage;
@property (nonatomic, assign) BOOL secondNeedRemoveObjects;
@property (nonatomic, strong) IBOutlet PullTableView *_secondTableView;


//@property (nonatomic, strong) IBOutlet UIBubbleTableView *bubbleTable;
- (void)sendRequest:(id)sender;
- (void)stopLoading:(id)sender;
- (void)refreshForDoubleClick:(id)sender;
@end
