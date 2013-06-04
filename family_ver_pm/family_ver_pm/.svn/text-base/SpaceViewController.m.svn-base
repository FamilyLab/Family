//
//  SpaceViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "SpaceViewController.h"
#import "SpaceViewSubController.h"
#import "SpaceViewTableCell.h"
#import "ModuleTitleBarView.h"
#import "ModuleBottomBarView.h"
#import "SVProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SBToolKit.h"
#import "JSONKit.h"
#import "UIImageView+AFNetworking.h"

@interface SpaceViewController ()

@end

@implementation SpaceViewController
int loadMorePage = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.spaceList = [[NSMutableArray alloc] initWithObjects:nil];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        showHUD = YES;
        
        // config tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MODULE_TITLE_BAR_SIZE.height + 5, DEVICE_SIZE.width, DEVICE_SIZE.height - MODULE_BOTTOM_BAR_SIZE.height - MODULE_BOTTOM_BAR_SIZE.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = NO;
        self.tableView.rowHeight = SPACE_VIEW_TABLE_ROWHIGHT;
        [self addFooterView];
        [self.view addSubview:self.tableView];
        
        //config ModuleTitleBarView
        ModuleTitleBarView *moduleTitle = [[ModuleTitleBarView alloc] initWithFrame:CGRectMake(0, 0, MODULE_TITLE_BAR_SIZE.width, MODULE_TITLE_BAR_SIZE.height)];
        [self.view addSubview:moduleTitle];
        
        //config ModuleBottomBar
        ModuleBottomBarView *moduleBottomBarView = [[ModuleBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - MODULE_BOTTOM_BAR_SIZE.height, MODULE_BOTTOM_BAR_SIZE.width, MODULE_BOTTOM_BAR_SIZE.height)];
        moduleBottomBarView.delegate = self;
        [self.view addSubview:moduleBottomBarView];
        
        //遮罩view
        blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        blankView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:blankView];
        
        [self requestSpaceList:1 withPerPageCount:SPACE_LIST_PERPAGE_COUNT withSuccessSel:@selector(reloadTableView)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - loading more and refresh
- (void)reloadTableViewDataSource
{
    [super reloadTableViewDataSource];
    [self requestSpaceList:1 withPerPageCount:[self.spaceList count] withSuccessSel:@selector(doneLoadingTableViewData)];
}

- (void)doneLoadingTableViewData
{
    [super doneLoadingTableViewData];
    [self reloadTableView];
}

- (void)loadMoreTableViewDataSource
{
    [super loadMoreTableViewDataSource];
    loadMorePage++;
    [self requestSpaceList:loadMorePage withPerPageCount:SPACE_LIST_PERPAGE_COUNT withSuccessSel:@selector(doneLoadMoreTableViewData)];
}

- (void)doneLoadMoreTableViewData
{
    [super doneLoadMoreTableViewData];
    [self reloadTableView];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    [self refreshFooterViewLayout];
}

- (void)refreshSpaceListWithResultArray:(NSArray *)spaceListArray
                 willReceiveResultCount:(int)resultCount
                                 atPage:(int)page
{
    if (page == 0) {//page为0代表全部刷新
        self.spaceList = [NSMutableArray arrayWithArray:spaceListArray];
        return;
    }
    
    int low = (page - 1) * SPACE_LIST_PERPAGE_COUNT;
    int high = low + [spaceListArray count] - 1;
    int index = low;
    
    //删除空间
    if ([spaceListArray count] < resultCount) {
        for (int j = high + 1; j < [self.spaceList count]; j++) {
            [self.spaceList removeObjectAtIndex:j];
        }
    }
    //更新spaceList
    int i;
    for (i = 0; index < [self.spaceList count] && i < [spaceListArray count]; index++, i++) {
        [self.spaceList replaceObjectAtIndex:index withObject:[spaceListArray objectAtIndex:i]];
    }
    
    //追加spaceList
    for (; index <= high; index++, i++) {
        [self.spaceList addObject:[spaceListArray objectAtIndex:i]];
    }
}

#pragma mark - UITableViewDelegate UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.spaceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpaceViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"space_cell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpaceViewTableCell" owner:cell options:nil] objectAtIndex:0];
        cell.spaceIcon.contentMode = UIViewContentModeScaleAspectFill;
        cell.spaceIcon.clipsToBounds = YES;
    }
    
    [cell.spaceIcon setImageWithURL:[NSURL URLWithString:[(NSDictionary *)[self.spaceList objectAtIndex:indexPath.row] objectForKey:PIC]] placeholderImage:SPACE_VIEW_SPACEICON_PLACEHOLDER];
    cell.spaceName.text = [(NSDictionary *)[self.spaceList objectAtIndex:indexPath.row] objectForKey:TAGNAME];
    cell.tagID = [(NSDictionary *)[self.spaceList objectAtIndex:indexPath.row] objectForKey:TAGID];
    
    return cell;
}

//选中进入某个空间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpaceViewSubController *subController = [[SpaceViewSubController alloc] initWithNibName:@"SpaceViewSubController" bundle:nil];
    subController.spaceViewDelegate = self;
    [subController setSpaceID:[(SpaceViewTableCell *)[tableView cellForRowAtIndexPath:indexPath] tagID]];
    NSLog(@"the tag id is %@", [(SpaceViewTableCell *)[tableView cellForRowAtIndexPath:indexPath] tagID]);
    [self.navigationController pushViewController:subController animated:YES];
    [subController beginRequest];
}

//取个人空间列表
- (void)requestSpaceList:(int)page withPerPageCount:(int)perpageCount withSuccessSel:(SEL)successSel
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:SPACE_LIST_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:m_auth, M_AUTH, [NSString stringWithFormat:@"%d", page], PAGE, [NSString stringWithFormat:@"%d", perpageCount], PERPAGE, nil]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = (NSDictionary *)[(NSData *)responseObject objectFromJSONData];
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSDictionary *dataDict = [resultDict objectForKey:DATA];
            
            //将数据添加到spaceList
            NSArray *spaceListArray = (NSArray *)[dataDict objectForKey:SPACELIST];
            [self refreshSpaceListWithResultArray:spaceListArray willReceiveResultCount:perpageCount  atPage:page];
            
//            [self.tableView reloadData];
            if (successSel != nil) {
                [self performSelector:successSel];
                NSLog(@"perform refresh when pull down");
            }
            
            [SVProgressHUD dismiss];
            [blankView removeFromSuperview];
        } else {
            NSLog(@"获取空间列表出错:%@", resultDict);
            [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取空间列表请求出错:%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络不好！"];
    }];
    
    [operation start];
}

#pragma mark ModuleTitleBarViewDelegate
- (void)backToRoot
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_POP_TO_MAINVIEW object:self];
}

- (void)addSpace
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新建空间" message:@"\n" delegate:self cancelButtonTitle:@"还是不了" otherButtonTitles:@"好了！", nil];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_ORIGIN_IN_ALERTVIEW.x, TEXTFIELD_ORIGIN_IN_ALERTVIEW.y, TEXTFIELD_WIDTH_IN_ALERVIEW, 35)];
    [alertView addSubview:textField];
//    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:23];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [alertView show];
}

- (void)requestToMakeNewSpace:(NSString *)newTagName
{
//    NSLog(@"新建空间的名字:%@", newTagName);
    [SVProgressHUD show];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/dapi/cp.php?ac=tag" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[newTagName dataUsingEncoding:NSUTF8StringEncoding] name:TAGNAME];
        [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"tagsubmit"];
        [formData appendPartWithFormData:[[SBToolKit getMAuth] dataUsingEncoding:NSUTF8StringEncoding] name:M_AUTH];
    }];
    
    AFHTTPRequestOperation *operaiton = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operaiton setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([[resultDict objectForKey:ERROR] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"新建空间完成！"];
            [self requestSpaceList:1 withPerPageCount:SPACE_LIST_PERPAGE_COUNT withSuccessSel:@selector(reloadTableView)];//刷新空间列表
        } else {
            NSLog(@"新建空间错误：%@", resultDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operaiton start];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *newTagName = nil;
    for (id subview in [alertView subviews]) {
        if ([[subview class] isSubclassOfClass:[UITextField class]]) {
            newTagName = ((UITextField *)subview).text;
        }
    }
    
    if (newTagName == nil)
        return;
    
    if (buttonIndex == 1) {
        [self requestToMakeNewSpace:newTagName];
    }
}

@end
