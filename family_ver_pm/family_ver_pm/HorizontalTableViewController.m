//
//  HorizontalTableViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-4-22.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableViewController.h"
#import "BottomBarView.h"

@interface HorizontalTableViewController ()

@end

@implementation HorizontalTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //表视图
        self.tableView = [[HorizontalTableView alloc] initWithFrame:CGRectMake(-1 * (DEVICE_SIZE.height - DEVICE_SIZE.width) / 2, (DEVICE_SIZE.height - DEVICE_SIZE.width) / 2, DEVICE_SIZE.height, DEVICE_SIZE.width)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        //前后按钮
        self.prevBtn = [[PreviousButton alloc] initWithFrame:CGRectMake(0, (DEVICE_SIZE.height - PREV_BTN_SIZE.height) / 2 + 13, PREV_BTN_SIZE.width, PREV_BTN_SIZE.height)];
        [self.prevBtn addTarget:self action:@selector(prevPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.prevBtn];
        
        self.nextBtn = [[NextButton alloc] initWithFrame:CGRectMake(DEVICE_SIZE.width - NEXT_BTN_SIZE.width, (DEVICE_SIZE.height - NEXT_BTN_SIZE.height) / 2 + 13, NEXT_BTN_SIZE.width, NEXT_BTN_SIZE.height)];
        [self.nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.nextBtn];
        
        //bottom bar
        BottomBarView *bottomBarView = [[BottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - BOTTOM_BAR_SIZE.height, DEVICE_SIZE.width, BOTTOM_BAR_SIZE.height)];
        bottomBarView.delegate = self;
        [self.view addSubview:bottomBarView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate UITableViewDatasource
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.infoList count] == 0? 2:[self.infoList count];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.infoList count] == 0) {
        return;
    }

    if (scrollView.contentOffset.y > ([self.infoList count] - 1)* self.tableView.rowHeight) {
        [self loadMore];
    }
}

//前后按钮操作
- (void)prevPage
{
    NSIndexPath *currentIndex = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    [self.tableView prevPage:currentIndex];
}

- (void)nextPage
{
    NSIndexPath *currentIndex = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    if ([self.tableView nextPage:currentIndex withTotalPage:[self.tableView numberOfRowsInSection:0]]) {
        [self loadMore];
    }
}

- (void)backToRoot
{
    [self.delegate.navigationController popToViewController:self.delegate animated:YES];
    [self.delegate reflesh];
}

@end
