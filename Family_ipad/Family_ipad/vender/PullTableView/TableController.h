//
//  TableController.h
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PullTableView.h"
@interface TableController : UIViewController
{
    NSMutableArray *dataArray;
    NSUInteger currentPage;
    BOOL needRemoveObjects;
    IBOutlet PullTableView *_tableView;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSUInteger currentPage;
@property (nonatomic,assign)BOOL needRemoveObjects;
@property (nonatomic,strong)IBOutlet PullTableView *_tableView;
- (void)refresh :(id)sender ;
- (void)stopLoading:(id)sender;
@end
