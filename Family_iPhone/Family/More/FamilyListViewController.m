//
//  FamilyListViewController.m
//  Family
//
//  Created by Aevitx on 13-1-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyListViewController.h"
#import "FamilyListCell.h"
#import "CellHeader.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
//#import "UIButton+WebCache.h"
#import "AddFriendsViewController.h"
#import "PostViewController.h"
#import "FamilyCardViewController.h"
#import "PlistManager.h"

@interface FamilyListViewController ()

@end

@implementation FamilyListViewController
@synthesize topBarView, cellHeader, conType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _canSelect = NO;
        _isWantToPostPM = NO;
        self.userId = MY_UID;
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
    
//    self._tableView.refreshView.hidden = YES;
    if (conType == myFamilyListType || conType == taskListType) {
        self._tableView.loadMoreView.hidden = YES;
    }
//    if (_canSelect) {
////        _selectedArray = [[NSMutableArray alloc] init];
//        _tableView.loadMoreView.hidden = YES;
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if ((conType == askForMyFamilyListType && isFirstShow) || (conType == myFamilyListType && ![self.userId isEqualToString:MY_UID])) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *aView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    aView.topViewType = loginOrSignIn;
    [aView leftHeadAndName];
    [aView rightLblAndImgStr:nil];
    self.topBarView = aView;
    [self.view addSubview:topBarView];
    if ([self.userId isEqualToString:MY_UID]) {
        [self fillData];
    }
}

- (void)addBottomView {
    NSArray *normalImages;
    if (self.conType == myFamilyListType) {
        NSString *secondStr = _canSelect ? @"login_ok" : @"menu_goto_add";
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", secondStr, nil];
    } else if (self.conType == askForMyFamilyListType || conType == taskListType) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
    }
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
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0:
        {
            if (_canSelect) {
                PostViewController *con = (PostViewController*)preController;
                
//                [con.togetherArray removeAllObjects];
//                [con.togetherArray addObjectsFromArray:dataArray];
                
                [con.withFriendsArray removeAllObjects];
                [con.withFriendsArray addObjectsFromArray:_selectedArray];
                
                [con.familyListArray removeAllObjects];
                [con.familyListArray addObjectsFromArray:dataArray];
                
                [con setAvatarForTogether];
            }
            if ([self.navigationController.viewControllers count] <= 1 ) {//推送过来时的
                [self.navigationController dismissModalViewControllerAnimated:YES];
            } else
                [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case 1:
        {
            if (!_canSelect) {//加号按钮
                AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
                con.topViewType = notLoginOrSignIn;
                [self.navigationController pushViewController:con animated:YES];
            } else {//OK按钮
                PostViewController *con = (PostViewController*)preController;
                [con.withFriendsArray removeAllObjects];
                [con.withFriendsArray addObjectsFromArray:_selectedArray];
                
                [con.familyListArray removeAllObjects];
                [con.familyListArray addObjectsFromArray:dataArray];
                
                [con setAvatarForTogether];
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)sendRequest:(id)sender {
    if (_canSelect && [dataArray count] > 0 && isFirstShow) {
        [self fillData];
        isFirstShow = NO;
        [_tableView reloadData];
        return;
    }
    if ([PlistManager isPlistFileExists:PLIST_FAMILY_LIST] && [self.userId isEqualToString:MY_UID] && isFirstShow && conType == myFamilyListType) {
        NSDictionary *tmpDict = [[PlistManager readPlist:PLIST_FAMILY_LIST] objectForKey:MY_UID];
        if (tmpDict) {
            isFirstShow = NO;
            [dataArray addObjectsFromArray:[[tmpDict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
            [self changeDataArrayForSelect];
            return;
        }
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = @"";
    if (self.conType == myFamilyListType) {
        if (_userId) {
            url = [NSString stringWithFormat:@"%@space.php?do=fmembers&perpage=100&m_auth=%@&uid=%@", BASE_URL, [MY_M_AUTH urlencode], self.userId];
        } else {
//            if (_canSelect) {
//                url = [NSString stringWithFormat:@"%@do.php?ac=ajax&op=getfriend&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
//            } else {
                url = [NSString stringWithFormat:@"%@space.php?do=fmembers&perpage=100&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
//            }
        }
    } else if (self.conType == askForMyFamilyListType) {
        url = [NSString stringWithFormat:@"%@cp.php?ac=friend&op=request&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    }  else if (self.conType == taskListType) {
        url = [NSString stringWithFormat:@"%@space.php?do=task&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    }
//    url = @"http://www.familyday.com.cn/dapi/map.php";
////    url = @"http://www.familyday.com.cn";
//    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        isFirstShow = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
//            [_infoDict removeAllObjects];
//            self.infoDict = nil;
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
            return;
        }
//        if (_tableView.refreshView.hidden) {
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
//        }
        NSDictionary *topDict = [dict objectForKey:WEB_DATA];
        if (_canSelect) {
            [topBarView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
            [topBarView.leftHeadBtn setVipStatusWithStr:MY_VIP_STATUS isSmallHead:YES];
            topBarView.leftNameLbl.text = MY_NAME;
        } else {
            [topBarView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:[topDict objectForKey:AVATAR] plcaholderImageStr:nil];
            [topBarView.leftHeadBtn setVipStatusWithStr:emptystr([topDict objectForKey:VIP_STATUS]) isSmallHead:YES];
            topBarView.leftNameLbl.text = [topDict objectForKey:NAME];
        }
        [topBarView setNeedsLayout];
        if (conType == myFamilyListType) {
            topBarView.rightLbl.text = [NSString stringWithFormat:@"共%d人", [[topDict objectForKey:FAMILY_MEMBERS] intValue]];
        } else if (conType == askForMyFamilyListType) {
            int requestNum = [$str(@"%d", [emptystr([topDict objectForKey:@"requestnum"]) intValue]) isEqualToString:@""] ? [dataArray count] : [[topDict objectForKey:@"requestnum"] intValue];
            topBarView.rightLbl.text = [NSString stringWithFormat:@"共%d人", requestNum];
        } else
            topBarView.rightLbl.hidden = YES;
        
//        [self addTheInfoDict:topDict];
        if (self.conType == myFamilyListType) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
            [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
            if (_canSelect) {
                [self changeDataArrayForSelect];
            }
        } else if (self.conType == askForMyFamilyListType) {
            [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:REQUEST_LIST]];
        } else if (self.conType == taskListType) {
            [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:TASK_LIST]];
        }
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [self stopLoading:sender];
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
////    NSString *url = @"http://www.familyday.com.cn/dapi/map.php";
////    [_web stringByEvaluatingJavaScriptFromString:url];
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"error:%@", [error description]);
//}

- (void)fillData {
//        [topBarView.leftHeadBtn setImageWithURL:[NSURL URLWithString:[topDict objectForKey:AVATAR]] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [topBarView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
    [self.topBarView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
    topBarView.leftNameLbl.text = MY_NAME;
    [topBarView setNeedsLayout];
    if (conType != taskListType) {
        topBarView.rightLbl.text = [NSString stringWithFormat:@"共%d人", [dataArray count]];
    } else
        topBarView.rightLbl.hidden = YES;
    
    [self changeDataArrayForSelect];
}

- (void)sendRequestToSelectWithOthers:(id)sender {
    if ([dataArray count] > 0) {
        [self changeDataArrayForSelect];
        return;
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@do.php?ac=ajax&op=getfriend&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FRIEND_LIST]];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)changeDataArrayForSelect {
    for (int i = 0; i < [dataArray count]; i++) {
        NSMutableDictionary *selectDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:i]]; //initWithObjectsAndKeys:@"NO", @"checked", nil];
        [selectDict setObject:@"NO" forKey:@"checked"];
        for (int j = 0; j < [_selectedArray count]; j++) {
            if ([[_selectedArray objectAtIndex:j] objectForKey:@"index"]) {
                if ([[[_selectedArray objectAtIndex:j] objectForKey:@"index"] intValue] == i) {
                    [selectDict setObject:@"YES" forKey:@"checked"];
                }
            } else {
                if ([[[_selectedArray objectAtIndex:j] objectForKey:UID] intValue] == [[[dataArray objectAtIndex:i] objectForKey:UID] intValue]) {
                    [selectDict setObject:@"YES" forKey:@"checked"];
                }
            }
        }
        [dataArray replaceObjectAtIndex:i withObject:selectDict];
    }
}

#pragma mark -
#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (conType == taskListType) {
        return [FamilyListCell heightForCellWithText:[[dataArray objectAtIndex:indexPath.row] objectForKey:NOTE] andOtherHeight:50];
    } else
        return 70;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return cellHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *titleText = @"";//self.conType == myFamilyListType ? @"我的家人" : @"家人申请";
    if (self.conType == myFamilyListType) {
        titleText = @"我的家人";
    } else if (self.conType == askForMyFamilyListType) {
        titleText = @"家人申请";
    } else if (self.conType == taskListType) {
        titleText = @"有奖任务";
    }
    cellHeader.frame = (CGRect){.origin = CGPointZero, .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:titleText].height};
    [cellHeader initHeaderDataWithMiddleLblText:titleText];
    
    return cellHeader.frame.size.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (conType == askForMyFamilyListType || conType == myFamilyListType) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *tipStr = conType == askForMyFamilyListType ? @"忽略此申请中..." : @"删除家人关系中...";
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
            if (conType == askForMyFamilyListType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_NUM object:@"-1"];//更多的badge减1
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_CON object:nil];//刷新更多页面
            
            if (conType == myFamilyListType) {
                [self performBlock:^(id sender) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];//调用统计接口
                    [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
                } afterDelay:0.3f];//延迟0.3s防止卡顿
            }
            
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
    if (self.conType == myFamilyListType) {//我的家人列表
        FamilyListCell *cell;
        static NSString *familyListCellId = @"familyListCellId";
        cell = [tableView dequeueReusableCellWithIdentifier:familyListCellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
            if (_canSelect) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (_canSelect) {//发表界面的选择家人
            NSMutableDictionary *selectDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexPath.row]];
            [selectDict setObject:cell forKey:@"cell"];
            [dataArray replaceObjectAtIndex:indexPath.row withObject:selectDict];
            
            BOOL checked = [[selectDict objectForKey:@"checked"] boolValue];
            UIImage *image = checked ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"notChecked.png"];
            
            UIButton *checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            checkedButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            
            [checkedButton setBackgroundImage:image forState:UIControlStateNormal];
            [checkedButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryView = checkedButton;
//            [cell initFamilyListForSelect:[dataArray objectAtIndex:indexPath.row]];
        }
//        else {
            [cell initData:[dataArray objectAtIndex:indexPath.row]];
//        }
        return cell;
    } else if (self.conType == askForMyFamilyListType) {//家人申请列表
        static NSString *inviteCellId = @"inviteCellId";
        InviteCell *inviteCell = (InviteCell *)[tableView dequeueReusableCellWithIdentifier:inviteCellId];
        if (inviteCell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
            inviteCell = [array objectAtIndex:0];
        }
        inviteCell.indexRow = indexPath.row;
        inviteCell.delegate = self;
        [inviteCell initData:[dataArray objectAtIndex:indexPath.row]];
        return inviteCell;
    } else if (self.conType == taskListType) {//任务列表
        FamilyListCell *cell;
        static NSString *taskCellId = @"familyListCellId";
        cell = [tableView dequeueReusableCellWithIdentifier:taskCellId];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommonCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
            cell.simpleInfoView.headBtn.userInteractionEnabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell initTaskData:[dataArray objectAtIndex:indexPath.row]];
        return cell;
    } else return nil;
}

- (void)checkButtonTapped:(id)sender event:(id)event {
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:_tableView];
	NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil) {
		[self tableView: _tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (self.canSelect) {
        NSMutableDictionary *selectDict = [dataArray objectAtIndex:indexPath.row];
        
        BOOL checked = [[selectDict objectForKey:@"checked"] boolValue];
        
        if ([_selectedArray count] >= 4 && !checked) {
            [SVProgressHUD showErrorWithStatus:@"不能超过4个人T_T"];
            return;
        }
        
        [selectDict setObject:[NSNumber numberWithBool:!checked] forKey:@"checked"];
        if ([[selectDict objectForKey:@"checked"] boolValue]) {
            NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
            [aDict setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"index"];
            [aDict setObject:[[dataArray objectAtIndex:indexPath.row] objectForKey:UID] forKey:UID];
            [aDict setObject:[[dataArray objectAtIndex:indexPath.row] objectForKey:AVATAR] forKey:AVATAR];
            [_selectedArray addObject:aDict];
        } else {
            for (int i = 0; i < [_selectedArray count]; i++) {
                if ([[[_selectedArray objectAtIndex:i] objectForKey:@"index"] intValue] == indexPath.row) {
                    [_selectedArray removeObjectAtIndex:i];
                }
            }
        }
        
        UITableViewCell *cell = [selectDict objectForKey:@"cell"];
        UIButton *button = (UIButton *)cell.accessoryView;
        
        UIImage *newImage = (checked) ? [UIImage imageNamed:@"notChecked.png"] : [UIImage imageNamed:@"checked.png"];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.canSelect) {
        [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    } else if (conType == myFamilyListType) {
        if (self.isWantToPostPM) {//发表页面的发送对话
            PostViewController *con = (PostViewController*)preController;
            [con.upPostView.pmNameBtn setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:NAME] forState:UIControlStateNormal];
            con.postPMUserId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
            [con.upPostView layoutSubviews];
//            [con.upPostView setNeedsDisplay];
            [self.navigationController popViewControllerAnimated:YES];
        } else {//进入用户名片
            FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
            con.isMyFamily = YES;
            con.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
            [self.navigationController pushViewController:con animated:YES];
        }
    } else if (conType == taskListType) {
        if (![[[dataArray objectAtIndex:indexPath.row] objectForKey:DONE] boolValue]) {
            [self joinTaskWithIndexRow:indexPath.row];
        }
    }
}

#pragma mark - 参与有奖任务
- (void)joinTaskWithIndexRow:(int)indexRow {
    
}

#pragma mark - cell action
//同意成为家人
- (void)userPressedTheOperatorBtn:(CommonCell *)_cell {
    [SVProgressHUD showWithStatus:@"同意中..."];
    NSString *url = $str(@"%@friend&op=add", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[dataArray objectAtIndex:_cell.indexRow] objectForKey:UID], APPLY_UID, ONE, AGGRE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_NUM object:@"-1"];//更多的badge减1
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MORE_CON object:nil];
        
        [self performBlock:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];//调用统计接口
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
        } afterDelay:0.3f];//延迟0.3s防止卡顿
        
        [SVProgressHUD dismiss];
        [dataArray removeObject:[dataArray objectAtIndex:_cell.indexRow]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}



@end
