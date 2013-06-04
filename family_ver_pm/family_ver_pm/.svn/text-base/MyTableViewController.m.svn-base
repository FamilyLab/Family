//
//  MyTableViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-4-26.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "MyTableViewController.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController
@synthesize dataArray, _tableView, needRemoveAllObject, currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 1;
    }
    return self;
}

-(void)sendRequest:(id)sender
{
    
}

-(void)stopLoading:(id)sender
{
    if ([sender isKindOfClass:[PullTableView class]]) {
        ((PullTableView*)sender).pullTableIsRefreshing = NO;
        ((PullTableView*)sender).pullTableIsLoadingMore = NO;
        ((PullTableView*)sender).pullLastRefreshDate = [NSDate date];
    }
}

-(void)requestData
{
    if ([dataArray count] > 0) {
        return;
    }else{
        currentPage = 1;
        [self sendRequest:_tableView];
    }
}

-(void)requestNextPage:(id)sender
{
    currentPage++;
    [self sendRequest:sender];
}

-(void)refresh:(id)sender
{
    needRemoveAllObject = YES;
    currentPage = 1;
    if (MY_HAS_LOGIN) {
        [self sendRequest:sender];
    }
}

-(void)reloadData
{
    [dataArray removeAllObjects];
    [self requestData];
}

-(void)clearAllData:(id)sender
{
    [dataArray removeAllObjects];
    [_tableView reloadData];
    _tableView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] init];
    }
    if (self._tableView) {
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.pullArrowImage = [UIImage imageNamed:@"blackArrow.png"];
        _tableView.pullBackgroundColor = [UIColor clearColor];
        _tableView.pullTextColor = [UIColor blackColor];
        [self sendRequest:self._tableView];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequest:) name:SEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllData:) name:CLEAR_ALL_DATA object:nil];
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refresh:) withObject:pullTableView];
}

-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(requestNextPage:) withObject:pullTableView];
}

-(void)dealloc
{
    [super dealloc];
    [dataArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLEAR_ALL_DATA object:nil];
}
@end
