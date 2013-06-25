//
//  FamilyViewController.m
//  Family
//
//  Created by Aevitx on 13-6-14.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyViewController.h"
#import "FamilyCell.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "PlistManager.h"
#import "AddFriendsViewController.h"
#import "FamilyListViewController.h"
#import "FamilyCardViewController.h"
#import "InviteViewController.h"

@interface FamilyViewController ()

- (IBAction)inviteBtnPressed:(id)sender;
- (IBAction)applyBtnPressed:(id)sender;

@end

@implementation FamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    
//    if (!self.userId) {
//        self.userId = MY_UID;
//    }
//    _tableView.refreshView.hidden = YES;
    _tableView.loadMoreView.hidden = YES;
    _tableView.tableHeaderView = _headerView;
//    [_applyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 240)];
//    [_inviteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 240)];
    
//    [_tableView setContentOffset:CGPointMake(0, 160) animated:NO];
//    [self onlyShowFamilyMember];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"家人"];
    [topView rightLogo];
    [topView rightLine];
    [topView dropShadowWithOffset:CGSizeZero radius:0 color:bgColor() opacity:0 shadowFrame:CGRectZero];//因为有cellHeader，所以这里不用阴影
    [self.view addSubview:topView];
}

- (IBAction)inviteBtnPressed:(id)sender {
    InviteViewController *con = [[InviteViewController alloc] initWithNibName:@"InviteViewController" bundle:nil];
//    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
    con.topViewType = notLoginOrSignIn;
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)applyBtnPressed:(id)sender {
    FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
    con.conType = askForMyFamilyListType;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark network
- (void)sendRequest:(id)sender {
//    if ([PlistManager isPlistFileExists:PLIST_FAMILY_LIST] && [self.userId isEqualToString:MY_UID]) {
//        [self stopLoading:_tableView];
//        needRemoveObjects = NO;
//        [self onlyShowFamilyMember];
//        NSDictionary *tmpDict = [[PlistManager readPlist:PLIST_FAMILY_LIST] objectForKey:MY_UID];
//        if (tmpDict) {
//            [dataArray addObjectsFromArray:[[tmpDict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
//            return;
//        }
//    }
    
//    [self performBlock:^(id sender) {
//        [self stopLoading:_tableView];
//    } afterDelay:1.0f];
//    return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];
    NSString *url = @"";
    if (_userId) {
        url = [NSString stringWithFormat:@"%@space.php?do=fmembers&perpage=100&m_auth=%@&uid=%@", BASE_URL, [MY_M_AUTH urlencode], self.userId];
    } else {
        url = [NSString stringWithFormat:@"%@space.php?do=fmembers&perpage=100&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:_tableView];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <= 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
//            currentPage--;
            return;
        }
        
        int applyNum = [emptystr([dict objectForKey:ASK_FOR_FAMILY_NUM]) intValue];
        if (applyNum > 0) {
            _applyNumLbl.text = [NSString stringWithFormat:@"%d个", applyNum];
            _applyNumLbl.hidden = NO;
        } else {
            _applyNumLbl.hidden = YES;
        }
        
        _familyNumLbl.text = $str(@"  家人通讯录 共%d人", [[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_MEMBERS] intValue]);
        [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
        [_tableView reloadData];
        [self onlyShowFamilyMember];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [self stopLoading:sender];
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}

- (void)onlyShowFamilyMember {
    //70为家人cell的高度，160为上面的 那一个的高度
    int maxFamilyCellNum = DEVICE_SIZE.height / 70;
#define FAMILY_MEMBER_NUM [dataArray count]
    int contentSizeH = FAMILY_MEMBER_NUM < maxFamilyCellNum ? (DEVICE_SIZE.height + 70) : (_headerView.frame.size.height + FAMILY_MEMBER_NUM * 70);
    _tableView.contentSize = CGSizeMake(DEVICE_SIZE.width, contentSizeH);
    int offsetY = FAMILY_MEMBER_NUM == 0 ? 0 : _headerView.frame.size.height;
    [_tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FAMILY_MEMBER_NUM;
//    if (section == 0) {
//        return 2;
//    } else {
//        return 3;// [dataArray count];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
//    return indexPath.row == 0 ? 160 : 70;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tipStr = @"删除家人关系中...";
        [SVProgressHUD showWithStatus:tipStr];
        
        NSString *url = $str(@"%@friend&op=ignore", POST_CP_API);
        NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:UID], UID, @"1", FRIENDS_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_CON object:nil];//刷新更多页面
            
            [self performBlock:^(id sender) {
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];//调用统计接口
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
            } afterDelay:0.3f];//延迟0.3s防止卡顿
            
            [SVProgressHUD dismiss];
            [dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FamilyCell *cell;
//    static NSString *otherCellId = @"otherCellId";
    static NSString *myFamilyCellId = @"myFamilyCellId";
//    if (indexPath.row == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
//    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:myFamilyCellId];
//    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FamilyCell" owner:self options:nil];
        cell = [array objectAtIndex:1];
//        int index = indexPath.row == 0 ? 0 : 1;
//        cell = [array objectAtIndex:index];
    }
    cell.indexRow = indexPath.row;
    
    [cell initData:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.isMyFamily = YES;
    con.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    [self.navigationController pushViewController:con animated:YES];
}

@end
