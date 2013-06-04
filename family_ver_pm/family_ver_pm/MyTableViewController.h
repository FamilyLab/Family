//
//  MyTableViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-4-26.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface MyTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>
{
    NSInteger currentPage;
    NSMutableArray *dataArray;
    IBOutlet PullTableView *_tableView;
    BOOL needRemoveAllObject;
    
}

@property (nonatomic, retain) IBOutlet PullTableView *_tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL needRemoveAllObject;

-(void)sendRequest:(id)sender;
-(void)stopLoading:(id)sender;

@end
