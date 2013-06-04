//
//  RootViewController.m
//  TableViewPullLift
//
//  Created by zhe wang on 11-7-6.
//  Copyright 2011年 nasawz.com. All rights reserved.
//

#import "PullAndLiftTableViewController.h"


@implementation PullAndLiftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
//		self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height) style:UITableViewStylePlain];
//        [self.view addSubview:self.tableView];
        
		WZRefreshTableHeaderView *view1 = [[WZRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view1.delegate = self;
		[self.tableView addSubview:view1];
		_refreshHeaderView = view1;
		[view1 release];
	}
	
	//  update the last update date
    [self setHeaderStyle];
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //注意此处，添加footerview的时机
//    [self performSelector:@selector(addFooterView) withObject:nil afterDelay:0.3f];
    
}

- (void)addFooterView {
    
    if (_loadMoreFooterView == nil) {
        
		WZLoadMoreTableFooterView *view2 = [[WZLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view2.delegate = self;
		[self.tableView addSubview:view2];
		_loadMoreFooterView = view2;
		[view2 release];
    }
    [self setFooterStyle];
	[_loadMoreFooterView loadmoreLastUpdatedDate];
}

//自定义header的样式
- (void)setHeaderStyle
{
    _refreshHeaderView.backgroundColor = TABLE_HEADER_BACKCOLOR;
    [_refreshHeaderView setLastUpdateLabelColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] andFont:nil];
    [_refreshHeaderView setStatusLabelColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] andFont:nil];
}

//自定义footer的样式
- (void)setFooterStyle
{
    _loadMoreFooterView.backgroundColor = TABLE_FOOTER_BACKCOLOR;
    [_loadMoreFooterView setLastUpdateLabelColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] andFont:nil];
    [_loadMoreFooterView setStatusLabelColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] andFont:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)refreshFooterViewLayout
{
    CGRect rect = _loadMoreFooterView.frame;
    _loadMoreFooterView.frame = CGRectMake(rect.origin.x, self.tableView.contentSize.height, rect.size.width, rect.size.height);
}

#pragma mark -
#pragma mark UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 10;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	
//	return [NSString stringWithFormat:@"Section %i", section];
//	
//}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_loading = YES;
    NSLog(@"reloadTableViewDataSource");
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_loading = NO;
	[_refreshHeaderView wzRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    NSLog(@"doneLoadingTableViewData");
	
}
- (void)loadMoreTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_loading = YES;
	
}

- (void)doneLoadMoreTableViewData{
	
	//  model should call this when its done loading
	_loading = NO;
	[_loadMoreFooterView wzLoadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView wzRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView wzLoadMoreScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView wzRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreFooterView wzLoadMoreScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark WZRefreshTableHeaderDelegate Methods
- (void)wzRefreshTableHeaderDidTriggerRefresh:(WZRefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)wzRefreshTableHeaderDataSourceIsLoading:(WZRefreshTableHeaderView*)view{
	
	return _loading; // should return if data source model is reloading
	
}

- (NSDate*)wzRefreshTableHeaderDataSourceLastUpdated:(WZRefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
#pragma mark -
#pragma mark WZLoadMoreTableFooterDelegate Methods
- (void)wzLoadMoreTableHeaderDidTriggerRefresh:(WZLoadMoreTableFooterView*)view {
    
	[self loadMoreTableViewDataSource];
	[self performSelector:@selector(doneLoadMoreTableViewData) withObject:nil afterDelay:3.0];
}
- (BOOL)wzLoadMoreTableHeaderDataSourceIsLoading:(WZLoadMoreTableFooterView*)view {
    return _loading;
}
- (NSDate*)wzLoadMoreTableHeaderDataSourceLastUpdated:(WZLoadMoreTableFooterView*)view {
    return [NSDate date]; // should return date data source was last changed
}
#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
    [super dealloc];
}

@end
