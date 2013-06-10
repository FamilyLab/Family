//
//  TableController.m
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"
#import "MyTabBarController.h"
@implementation TableController
@synthesize dataArray, secondDataArray, currentPage, needRemoveObjects, _tableView;
@synthesize isFirstTable, _secondTableView, secondCurrentPage, secondNeedRemoveObjects;

- (void)sendRequest:(id)sender {
    
}

- (void)stopLoading:(id)sender {
    if ([sender isKindOfClass:[PullTableView class]]) {
        ((PullTableView *)sender).pullTableIsRefreshing = NO;
        ((PullTableView *)sender).pullTableIsLoadingMore = NO;
        ((PullTableView *)sender).pullLastRefreshDate = [NSDate date];
    }
}

- (void)refreshForDoubleClick:(id)sender {
    if (isFirstTable) {
        needRemoveObjects = YES;
        currentPage = 1;
    } else {
        secondNeedRemoveObjects = YES;
        secondCurrentPage = 1;
    }
    PullTableView *table = isFirstTable ? self._tableView : self._secondTableView;
    [table setContentOffset:CGPointMake(0, -65) animated:NO];
    table.pullTableIsRefreshing = YES;
    [self sendRequest:table];
}

/**
 * 发送更新信息，标记needRemoveObjects设置为yes,currentPage重置为第一页
 * @param  无
 * @return 无
 */
- (void)refresh:(id)sender {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    if (isFirstTable) {
        needRemoveObjects = YES;
        currentPage = 1;
    } else {
        secondNeedRemoveObjects = YES;
        secondCurrentPage = 1;
    }
    if (MY_HAS_LOGIN) {
        [self sendRequest:_tableView];
    }
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

/**
 * 外部调用，请求数据，根据currentPage，已有数据来判断是否需要发送请求。
 * @param  无
 * @return 无
 */
- (void)requestData {
    if (isFirstTable) {
        if ([dataArray count] > 0) {
            return;
        } else {
            currentPage = 1;
            [self sendRequest:_tableView];
        }
    } else {
        if ([secondDataArray count] > 0) {
            return;
        } else {
            secondCurrentPage = 1;
            [self sendRequest:_secondTableView];
        }
    }
}

/**
 * 请求下一页的数据
 * @param  无
 * @return 无
 */
- (void)requestNextPage:(id)sender {
    if (isFirstTable) {
        currentPage ++;
    } else {
        secondCurrentPage ++;
    }
    [self sendRequest:sender];
}

/**
 * 重置列表数据
 * @param  无
 * @return 无
 */
- (void)reloadData {
    if (isFirstTable) {
        [dataArray removeAllObjects];
    } else {
        [secondDataArray removeAllObjects];
    }
    [self requestData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFirstTable = YES;
        currentPage = 1;
        secondCurrentPage = 1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] init];
    }
    if (_tableView) {
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _tableView.pullBackgroundColor = [UIColor clearColor];
        _tableView.pullTextColor = [UIColor blackColor];
        [self refresh:_tableView];
        
//        _tableView.touchDelegate = self;//使touch事件生效
    }
    
    if (_secondTableView) {
        secondDataArray = [[NSMutableArray alloc] init];
        _secondTableView.separatorStyle = UITableViewCellEditingStyleNone;
        _secondTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        _secondTableView.pullBackgroundColor = [UIColor clearColor];
        _secondTableView.pullTextColor = [UIColor blackColor];
//        [self refresh:_secondTableView];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllData) name:CLEAR_ALL_DATA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:SEND_REQUEST object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView {
    [self performSelector:@selector(refresh:) withObject:pullTableView];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView {
    [self performSelector:@selector(requestNextPage:) withObject:pullTableView];
}

- (void)clearAllData {
    if (self._tableView) {
        [self.dataArray removeAllObjects];
        [self._tableView reloadData];
        self._tableView.contentOffset = CGPointMake(0, 0);
    }
    if (self._secondTableView) {
        [self.secondDataArray removeAllObjects];
        [self._secondTableView reloadData];
        self._secondTableView.contentOffset = CGPointMake(0, 0);
    }
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MyTabBarController class]]) {
//        MyTabBarController *tabBarCon = (MyTabBarController*)myTabBarController;
//        if ([tabBarCon.viewControllers containsObject:self]) {
//            [tabBarCon hidePostMenu];
//        }
//    }
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    MyTabBarController *tabBarCon = (MyTabBarController*)myTabBarController;
//    [tabBarCon hidePostMenu];
//}


//#pragma mark - touch事件
//- (MLNavigationController *)firstAvailableNavigationController
//{
//    if ([self.navigationController isKindOfClass:[MLNavigationController class]])
//    {
//        return (MLNavigationController *)self.navigationController;
//    }
//    //    if ([[self viewController].navigationController isKindOfClass:[MLNavigationController class]])
//    //    {
//    //        return (MLNavigationController *)[self viewController].navigationController;
//    //    }
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    
//    //send the event to MLNavigationController
//    [self.firstAvailableNavigationController touchesBegan:touches withEvent:event];
//    
//    self._tableView.scrollEnabled = NO;
//}
//
//- (void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
//    
//    [self.firstAvailableNavigationController touchesMoved:touches withEvent:event];
//}
//
//- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    
//    [self.firstAvailableNavigationController touchesEnded:touches withEvent:event];
//    
//    self._tableView.scrollEnabled = YES;
//}
//
//- (void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
//    
//    [self.firstAvailableNavigationController touchesCancelled:touches withEvent:event];
//    
//    self._tableView.scrollEnabled = YES;
//}





@end
