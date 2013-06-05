//
//  TableController.m
//  Family
//
//  Created by Walter.Chan on 12-12-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"
@implementation TableController
@synthesize dataArray,currentPage,needRemoveObjects,_tableView;

- (void)sendRequest:(id)sender
{
    
}
- (void)stopLoading:(id)sender
{
    if ([sender isKindOfClass:[PullTableView class]]) {
        ((PullTableView *)sender).pullTableIsRefreshing = NO;
        ((PullTableView *)sender).pullTableIsLoadingMore = NO;
        ((PullTableView *)sender).pullLastRefreshDate = [NSDate date];
        
    }
}
/**
 * 发送更新信息，标记needRemoveObjects设置为yes,currentPage重置为第一页
 * @param  无
 * @return 无
 */
- (void)refresh :(id)sender {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    needRemoveObjects = YES;
    currentPage = 1;
    [self sendRequest:sender];
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


/**
 * 外部调用，请求数据，根据currentPage，已有数据来判断是否需要发送请求。
 * @param  无
 * @return 无
 */
- (void)requestData {
    
    if ([dataArray count] > 0) {
        return;
    }
    else {
        currentPage = 1;
        [self sendRequest:nil];
    }
}
/**
 * 请求下一页的数据
 * @param  无
 * @return 无
 */
- (void)requestNextPage:(id)sender {
    currentPage ++;
    [self sendRequest:sender];
}
/**
 * 重置列表数据
 * @param  无
 * @return 无
 */
- (void)reloadData {
    [dataArray removeAllObjects];
    [self requestData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 1;
        dataArray = [[NSMutableArray alloc]init];
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
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow.png"];
    _tableView.pullBackgroundColor = [UIColor clearColor];
    _tableView.pullTextColor = [UIColor blackColor];
    [self refresh:_tableView];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    [self performSelector:@selector(refresh:) withObject:pullTableView];
}   
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self performSelector:@selector(requestNextPage:) withObject:pullTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([dataArray count]>0) {
        return [dataArray count];
    }
    else
        return 0;
}
@end
