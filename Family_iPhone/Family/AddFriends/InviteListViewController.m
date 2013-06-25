//
//  InviteListViewController.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "InviteListViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
//#import "UIButton+WebCache.h"
#import "FamilyCardViewController.h"
#import "MPNotificationView.h"

@interface InviteListViewController ()

@end

@implementation InviteListViewController
@synthesize topViewType;
@synthesize containerView;
@synthesize cellHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _canSearch = NO;
        isFirstShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self addBottomView];
    
    _tableView.refreshView.hidden = YES;
    _tableView.loadMoreView.hidden = YES;
    
    MySearchBar *search = [[MySearchBar alloc] initWithFrame:CGRectMake(10, 0, 300, 43)];
    [search buildMySearchBarWithImgStr:@"search_bg.png"];
    search.placeholder = @"输入姓名或电话号码...";
    search.delegate = self;
    if (_canSearch) {
        search.text = _searchText;
    }
    self.mySearchBar = search;
    [self.containerView addSubview:_mySearchBar];
    
    if (_canSearch) {
        [self sendRequestWithSearch:_tableView];
    }
    
//    self._tableView.frame = CGRectMake(0, 50 + mySearchBar.frame.size.height + 10, DEVICE_SIZE.width, DEVICE_SIZE.height - 40 - 10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (isFirstShow) {
        [SVProgressHUD showWithStatus:@"搜索中..."];
    }
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = self.topViewType;
    if (self.topViewType == loginOrSignIn) {
        [self.cellHeader removeFromSuperview];
        self.cellHeader = nil;
        [topView leftBg];
        [topView leftText:@"添加"];
        [topView rightLogo];
        [topView rightLine];
    } else if (self.topViewType == notLoginOrSignIn) {
        [topView leftHeadAndName];
        
        self.containerView.frame = (CGRect){.origin.x = 0, .origin.y = 80, .size = self.containerView.frame.size};
        self._tableView.frame = (CGRect){.origin = self._tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = self._tableView.frame.size.height - 20};
        cellHeader.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:@"邀请家人"].height};
        [cellHeader initHeaderDataWithMiddleLblText:@"邀请家人"];
        
        
//        [topView.leftHeadBtn setImage:[UIImage imageNamed:@"head_70.png"] forState:UIControlStateNormal];//假数据
//        [topView.leftHeadBtn setImageWithURL:[NSURL URLWithString:MY_HEAD_AVATAR_URL] placeholderImage:[UIImage imageNamed:@"haed_70.png"]];
        [topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
        [topView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
        topView.leftNameLbl.text = MY_NAME;
        [topView setNeedsLayout];
    }
    [self.view addSubview:topView];
}

- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case 1:
        {
            [self.navigationController dismissModalViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _searchWhere == searchInOurWeb ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [dataArray count];
    } else return 25;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
    
    
    UIView *headerView;
    if (section == 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 5)];
        headerView.backgroundColor = bgColor();
    } else if (section == 1) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 20)];
        headerView.backgroundColor = [UIColor grayColor];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 302, 20)];
        lbl.backgroundColor = bgColor();
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = UITextAlignmentLeft;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        lbl.textAlignment = UITextAlignmentLeft;
//#else
//        lbl.textAlignment = NSTextAlignmentLeft;
//#endif
        lbl.text = @"邀请他们注册FamilyDay";
        lbl.font = [UIFont boldSystemFontOfSize:13.0f];
        [headerView addSubview:lbl];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
    
    
    if (section == 0) {
        return 5;
    } else return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inviteCellId = @"inviteCellId";
    InviteCell *cell = (InviteCell *)[tableView dequeueReusableCellWithIdentifier:inviteCellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
		cell = [array objectAtIndex:0];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.section == 0) {//已经是本站用户的
        cell.simpleInfoView.isFamilyList = NO;
        cell.indexRow = indexPath.row;
        
        NSDictionary *aDcit = [dataArray objectAtIndex:indexPath.row];
        cell.simpleInfoView.userId = [aDcit objectForKey:UID];
        NSString *infoStr = $str(@"%d个家人  %d个动态",
                                 [emptystr([aDcit objectForKey:FAMILY_FEEDS]) intValue], [emptystr([aDcit objectForKey:FAMILY_MEMBERS]) intValue]);
        [cell.simpleInfoView.headBtn setVipStatusWithStr:emptystr([aDcit objectForKey:VIP_STATUS]) isSmallHead:YES];
        NSString *nameAndNoteStr = emptystr([aDcit objectForKey:NAME]);
        if (!isEmptyStr([aDcit objectForKey:NOTE])) {
            nameAndNoteStr = $str(@"%@(%@)", nameAndNoteStr, [aDcit objectForKey:NOTE]);
        }
        [cell.simpleInfoView initInfoWithHeadUrlStr:[aDcit objectForKey:AVATAR]
                                            nameStr:nameAndNoteStr
                                            infoStr:infoStr
                                  rightlBtnNormaImg:@"add_a.png"
                              rightlBtnHighlightImg:nil
                               rightlBtnSelectedImg:@"add_a.png"];
        BOOL shouldHideAddBtn = [[aDcit objectForKey:IS_FAMILY] boolValue] ? YES : ([[aDcit objectForKey:UID] isEqualToString:MY_UID] ? YES : NO);
        cell.simpleInfoView.operatorBtn.hidden = shouldHideAddBtn;//[[aDcit objectForKey:IS_FAMILY] boolValue];
    } else if (indexPath.section == 1) {//搜索电话号码（不一定是本站用户）
        cell.simpleInfoView.isFamilyList = NO;
        cell.indexRow = indexPath.row;
        
//        cell.simpleInfoView.userId = [_aDict objectForKey:UID];
//        [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([aDcit objectForKey:VIP_STATUS]) isSmallHead:YES];
//        [cell.simpleInfoView initInfoWithHeadUrlStr:nil nameStr:@"哥哥" infoStr:@"15015045678" rightlBtnNormaImg:@"invite_a.png" rightlBtnHighlightImg:nil  rightlBtnSelectedImg:@"inviting.png"];
    }
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

#pragma mark - cell action
- (void)userPressedTheOperatorBtn:(CommonCell *)_cell {
//    self.commonCell = _cell;
    NSDictionary *aDcit = [dataArray objectAtIndex:_cell.indexRow];
    if ([[aDcit objectForKey:IS_FAMILY] boolValue]) {
        [SVProgressHUD showErrorWithStatus:@"你们已经是家人关系了T_T"];
        return;
    }
    if (_cell.simpleInfoView.operatorBtn.selected) {
        [SVProgressHUD showErrorWithStatus:@"已发过申请T_T"];
        return;
    }
    
    MyYIPopupTextView *popTextView = [[MyYIPopupTextView alloc] initWithMaxCount:0 placeHolger:@"输入备注名称" textViewSize:CGSizeMake(DEVICE_SIZE.width - 10 * 2, 200) textViewInsets:UIEdgeInsetsMake(50, 10, 50, -10)];
    popTextView.delegate = self;
    [popTextView showInView:self.view];
    [popTextView.acceptButton whenTapped:^{
        [MPNotificationView notifyWithText:@"发送申请中..." detail:nil andDuration:0.5f];
        NSString *url = $str(@"%@friend&op=add", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[aDcit objectForKey:UID], APPLY_UID, ONE, G_ID, popTextView.text, NOTE, ONE, ADD_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [MPNotificationView notifyWithText:@"申请已发送" detail:nil andDuration:0.5f];
            _cell.simpleInfoView.operatorBtn.selected = YES;
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [MPNotificationView notifyWithText:@"网络不好T_T" detail:nil andDuration:0.5f];
            _cell.simpleInfoView.operatorBtn.selected = NO;
        }];
        [popTextView dismiss];
    }];
    
//    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"备注名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
////    alertPrompt.DDAlertDelegate = self;
//    __block DDAlertPrompt *blockAlert = alertPrompt;
//    [alertPrompt addButtonWithTitle:@"确认" handler:^{
//        [SVProgressHUD showWithStatus:@"发送申请中..."];
//        NSString *url = $str(@"%@friend&op=add", POST_CP_API);
//        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[aDcit objectForKey:UID], APPLY_UID, ONE, G_ID, blockAlert.theTextView.text, NOTE, ONE, ADD_SUBMIT, MY_M_AUTH, M_AUTH, nil];
//        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//        } onCompletion:^(NSDictionary *dict) {
//            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//                return ;
//            }
//            [SVProgressHUD showSuccessWithStatus:@"申请已发送"];
//            _cell.simpleInfoView.operatorBtn.selected = YES;
//        } failure:^(NSError *error) {
//            NSLog(@"error:%@", [error description]);
//            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//            _cell.simpleInfoView.operatorBtn.selected = NO;
//        }];
//    }];
//    [alertPrompt show];
}

//- (void)userPressedTheCancelBtn:(DDAlertPrompt *)alert {
//    _commonCell.simpleInfoView.operatorBtn.selected = !_commonCell.simpleInfoView.operatorBtn.selected;
//    
//}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mySearchBar && [self.mySearchBar isFirstResponder]) {
        [self.mySearchBar resignFirstResponder];
    }
}

#pragma mark - request
- (void)sendRequestWithSearch:(id)sender {
    if (!isFirstShow) {
        [SVProgressHUD showWithStatus:@"搜索中..."];
    }
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=fmembers&fsearch=1&kw=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, [_mySearchBar.text urlencode], currentPage, 20, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        isFirstShow = NO;
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
        [_tableView reloadData];
        if ([dataArray count] <= 0) {
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"没有搜到此人T_T"];
            } afterDelay:0.3f];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
        currentPage--;
    }];
}


#pragma mark - UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    _canSearch = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"输入点东西吧T_T"];
    } else {
        [_mySearchBar setShowsCancelButton:NO animated:YES];
        [_mySearchBar resignFirstResponder];
        [self sendRequestWithSearch:nil];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarSearchButtonClicked:searchBar];
//    searchBar.text = @"";
//    [searchBar setShowsCancelButton:NO animated:YES];
//    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (![searchBar.text isEqualToString:@""]) {
//        //        if (self.whichWeibo == sinaWeibo) {
//        //            [self searchForSinaUsers:searchBar.text];
//        //        } else if (self.whichWeibo == TCWeibo) {
//        //            [self searchForTCWeiboUser:searchBar.text];
//        //        }
//    }
//}



@end
