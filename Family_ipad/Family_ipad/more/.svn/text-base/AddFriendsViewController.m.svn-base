//
//  AddFriendsViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-20.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "addFamilyCell.h"
#import "InviteFamilyCell.h"
#import "HeaderView.h"
#import "DetailHeaderView.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "NSObject+BlocksKit.h"
@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

#pragma mark - request
- (void)sendRequest:(id)sender{
    [SVProgressHUD showWithStatus:@"搜索中..."];
    NSString *keyword = [_searchBar.searchTextFiled.text  length]?_searchBar.searchTextFiled.text:_kw;
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=fmembers&fsearch=1&kw=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, [keyword urlencode], currentPage, 20, GET_M_AUTH];
    [[MyHttpClient sharedInstance] commandWithPathAndNoHUD:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        }
        if (currentPage == 1) {
            [dataArray removeAllObjects];
        }
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
        if ([dataArray count] <= 0) {
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"没有搜到此人T_T"];
            } afterDelay:0.5f];
        } else {
            [_tableView reloadData];
        }    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [self stopLoading:sender];
        currentPage--;
    }];
}
- (IBAction)backAction:(id)sender
{
    if (self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        REMOVEDETAIL;
}
- (void)adjustLayout
{
    self.view.frame = [UIScreen mainScreen].bounds;
    _contentView.frame = CGRectMake(272, 0, 480, 768);
    self.toolBarView.frame = CGRectMake(0, 708, 480, 60);
    _searchView.frame = CGRectMake(_searchView.frame.origin.x, _searchView.frame.origin.y-87, _searchView.frame.size.width, _searchView.frame.size.height);
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y-87, _tableView.frame.size.width, _tableView.frame.size.height);
    [_toolBarView.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.detail_header removeFromSuperview];
    HeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
    [header setDarkImage];
    header.headerTitle.text = @"添加";
    [_contentView addSubview:header];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _kw = nil;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 480, 30)];
        [headerView setImage:[UIImage imageNamed:@"invite_header.png"]];
        return (UITableViewHeaderFooterView *)headerView;
    }
    else return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 97;
    else
        return 101;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([dataArray count]>0) {
        return [dataArray count];
    }
    else
        return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"addFamilyCellId";
    addFamilyCell *cell=(addFamilyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [array objectAtIndex:4];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setCellData:[dataArray objectAtIndex:indexPath.row]];
    return cell;
   
    
}

@end
