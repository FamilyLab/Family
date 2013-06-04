//
//  MessageViewController.m
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "DialogueViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "MyTabBarController.h"
#import "FamilyCardViewController.h"
#import "FeedDetailViewController.h"
#import "Common.h"
#import "FamilyListViewController.h"
#import "JSBadgeView.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
//@synthesize isTalk;// noticeDataArray, ;//, talkScrollLength, noticeScrollLength;
//@synthesize isTalkRefresh, isTalkLoadingMore, isNoticeRefresh, isNoticeLoadingMore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFirstShow = YES;
        _isFromPushForPM = NO;
        _isFromPushForNotice = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    self.isFirstTable = YES;
    self._secondTableView.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_TALK_LIST_READ_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTheNotification:) name:REFRESH_TALK_LIST_READ_STATE object:nil];
    
    MyTabBarController *tabCon = (MyTabBarController*)myTabBarController;
    [self setBadgeNumWithBtnTag:0 andBadgeNum:$str(@"%d", tabCon.dialogNum)];
    [self setBadgeNumWithBtnTag:1 andBadgeNum:$str(@"%d", tabCon.noticeNum)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_TALK_LIST_READ_STATE object:nil];
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *aView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    aView.topViewType = notLoginOrSignIn;
    [aView leftBg];
    [aView leftText:@"消息"];
    [aView rightLine];
    [aView rightBtnTextArray:[[NSArray alloc] initWithObjects:@"对话", @"通知", nil]];
    UIButton *firstBtn = (UIButton*)[aView viewWithTag:kTagBtnInTopBarView];
    firstBtn.frame = (CGRect){.origin.x = firstBtn.frame.origin.x - 10, .origin.y = firstBtn.frame.origin.y, .size = firstBtn.frame.size};
    aView.arrowImgView.frame = (CGRect){.origin.x = aView.arrowImgView.frame.origin.x - 10, .origin.y = aView.arrowImgView.frame.origin.y, .size = aView.arrowImgView.frame.size};
    aView.delegate = self;
    self.topView = aView;
    [self.view addSubview:aView];
}

#pragma mark - TopBarView delegate
- (void)userPressedTheTopViewBtn:(TopView *)_topView andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBtnInTopBarView;
    UIImageView *noneDialogImgView = (UIImageView*)[self.view viewWithTag:kTagNoneDialog];
    if (noneDialogImgView && btnTag == 0) {
        noneDialogImgView.hidden = NO;
    } else
        noneDialogImgView.hidden = YES;
    
    switch (btnTag) {
        case 0:
        {
            self.isFirstTable = YES;
            self._tableView.hidden = NO;
            self._secondTableView.hidden = YES;
//            [self._tableView reloadData];
            break;
        }
        case 1:
        {
            self.isFirstTable = NO;
            self._tableView.hidden = YES;
            self._secondTableView.hidden = NO;
            [self._secondTableView reloadData];
            if (isFirstShow) {
                [self sendRequestToNotice:self._secondTableView];
            }
            break;
        }
        default:
            break;
    }
}

//更改主题
- (void)configureViews {
    for (id obj in [self.view subviews]) {
        if ([obj isKindOfClass:[TopView class]]) {
            TopView *topView = (TopView*)obj;
            [topView changeTheme];
        }
    }
    [self._tableView reloadData];
    [self._secondTableView reloadData];
}

- (void)sendRequest:(id)sender {
    if (self.isFirstTable) {
        [self sendRequestToDialogue:self._tableView];
    } else {
        [self sendRequestToNotice:self._secondTableView];
    }
}

//“对话”列表
- (void)sendRequestToDialogue:(id)sender {
    if (currentPage == 1 && !_isFromPushForPM) {
        _tableView.pullTableIsRefreshing = YES;
    }
    if (_isFromPushForPM) {
        currentPage = 1;
        needRemoveObjects = YES;
    }
//    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=pm&filter=privatepm&m_auth=%@&page=%d", BASE_URL, [MY_M_AUTH urlencode], currentPage];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        _isFromPushForPM = NO;
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
            currentPage--;
            return;
        }
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];
        [dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
//        [_tableView reloadData];
        
        UIImageView *noneDialogImgView = (UIImageView*)[self.view viewWithTag:kTagNoneDialog];
        if ([dataArray count] > 0) {
            if (noneDialogImgView) {
                [noneDialogImgView removeFromSuperview];
                noneDialogImgView = nil;
            }
            [_tableView reloadData];
        } else {
            if (!noneDialogImgView) {
                UIImage *noneFeedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none_dialog" ofType:@"png"]];
                noneDialogImgView = [[UIImageView alloc] initWithImage:noneFeedImage];
                noneDialogImgView.tag = kTagNoneDialog;
                noneDialogImgView.center = self.view.center;
                noneDialogImgView.frame = (CGRect){.origin.x = noneDialogImgView.frame.origin.x + 10, .origin.y = DEVICE_SIZE.height - noneFeedImage.size.height - 50 - 5, .size = noneDialogImgView.frame.size};//50为customTabBar的高度
                [self.view addSubview:noneDialogImgView];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [self stopLoading:sender];
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}

//“通知”列表
- (void)sendRequestToNotice:(id)sender {
    if (secondCurrentPage == 1 && !_isFromPushForNotice) {
        _secondTableView.pullTableIsRefreshing = YES;
    }
    if (_isFromPushForNotice) {
        secondCurrentPage = 1;
        secondNeedRemoveObjects = YES;
    }
//    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=notice&m_auth=%@&page=%d", BASE_URL, [MY_M_AUTH urlencode], secondCurrentPage];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        _isFromPushForPM = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            isFirstShow = NO;
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (secondNeedRemoveObjects == YES) {
            [secondDataArray removeAllObjects];
            [self._secondTableView reloadData];
            secondNeedRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <= 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
            return;
        }
        [SVProgressHUD dismiss];
        [secondDataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        
//        int noticeBadgeNum = 0;
//        for (int i = 0; i < [secondDataArray count]; i++) {
//            if ([[[secondDataArray objectAtIndex:i] objectForKey:NEW] intValue] == 1) {
//                noticeBadgeNum++;
//            }
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:$str(@"%d", noticeBadgeNum)];
//        if (!isFirstShow && currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];
//        }
        isFirstShow = NO;
        
        [self._secondTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [self stopLoading:sender];
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        secondCurrentPage--;//加载更多时，若网络不好，因为secondCurrentPage有加1了，所以重新请求时secondCurrentPage要减1才行
    }];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFirstTable) {
        return [dataArray count];// + 1;//1为上面的广告
    } else
        return [secondDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.isFirstTable && indexPath.row == 0) {//第0行为广告
//        return 65;
//    }
    NSDictionary *dataDict;
    if (self.isFirstTable) {
        dataDict = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
//        dataDict = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row - 1]];
    } else {
        dataDict = [NSDictionary dictionaryWithDictionary:[secondDataArray objectAtIndex:indexPath.row]];
    }
    NSString *allNoteText = @"";
    if (self.isFirstTable) {
        allNoteText = [NSString stringWithFormat:@"%@ 在%@", [dataDict objectForKey:LAST_SUMMARY], [dataDict objectForKey:ADDRESS]];
    } else {
        NSString *name = emptystr([dataDict objectForKey:NOTICE_AUTHOR_NAME]);
        
        NSDictionary *noteDict = [dataDict objectForKey:NOTE_SPLIT];
        NSString *actionStr = [emptystr([noteDict objectForKey:ACTION_STR]) stringByReplacingOccurrencesOfString:@"，" withString:@""];
        allNoteText = [NSString stringWithFormat:@"%@ %@ %@", name, actionStr, emptystr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT])];
        
        NSMutableArray *withFriendsArray = [noteDict objectForKey:WITH_FRIENDS];
        if ([withFriendsArray count] > 0) {
            NSString *friendsNameStr = @"";
            for (int i = 0; i < [withFriendsArray count]; i++) {
                friendsNameStr = $str(@"%@ %@ ", friendsNameStr, [[withFriendsArray objectAtIndex:i] objectForKey:NAME]);
            }
            allNoteText = $str(@"%@, 和 %@在一起", allNoteText, friendsNameStr);
            if ([emptystr([[withFriendsArray objectAtIndex:0] objectForKey:AC]) isEqualToString:FRIEND]) {//申请成为家人的
                allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"和 " withString:@""];
                allNoteText = [allNoteText stringByReplacingOccurrencesOfString:@"在一起" withString:@""];
            }
        }
    }
//    NSString *noteStr = self.isFirstTable ? [dataDict objectForKey:LAST_SUMMARY] : [dataDict objectForKey:NOTE];
//    NSString *contentStr = [NSString stringWithFormat:@"%@ %@", noteStr, [dataDict objectForKey:ADDRESS]];
    CGFloat otherHeight = self.isFirstTable ? 50 : 30;
    CGFloat timeLblHeight = self.isFirstTable ? 0 : 15;
    return [MessageCell heightForCellWithText:allNoteText andOtherHeight:otherHeight + timeLblHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFirstTable) {
        return YES;
    } else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD showWithStatus:@"删除此对话中..."];
        NSString *url = $str(@"%@pm&op=delete&folder=inbox", POST_CP_API);
        NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[aDict objectForKey:PM_ID], PM_ID, ONE, DELETE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
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
    MessageCell *cell;
//    static NSString *adCellId = @"adCellId";
    static NSString *messageCellId = @"messageCellId";
    static NSString *noticeCellId = @"noticeCellId";
    if (self.isFirstTable) {
//        if (indexPath.row == 0) {//0为广告
//            cell = [tableView dequeueReusableCellWithIdentifier:adCellId];
//        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:messageCellId];
//        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:noticeCellId];
    }
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        int whichCell;
        if (self.isFirstTable) {
            whichCell = 1;//indexPath.row == 0 ? 0 : 1;//0为广告
        } else
            whichCell = 2;
		cell = [array objectAtIndex:whichCell];
        cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
    }
    if (self.isFirstTable) {//对话列表
//        if (indexPath.row > 0 && [dataArray count] > 0) {//第0行为广告
        if ([dataArray count] > 0) {
            [cell initTalkData:[dataArray objectAtIndex:indexPath.row]];
//            [cell initTalkData:[dataArray objectAtIndex:indexPath.row - 1]];
        }
    } else {//通知列表
        if ([secondDataArray count] > 0) {
            [cell initNoticeData:[secondDataArray objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isFirstTable) {//对话列表
//        if (indexPath.row == 0) {
//            [SVProgressHUD showSuccessWithStatus:@"广告"];
//            return;
//        }
        DialogueViewController *con = [[DialogueViewController alloc] initWithNibName:@"DialogueViewController" bundle:nil];
        con.indexRow = indexPath.row;
        con.toUserId = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:PM_TO_UID];
//        con.toUserId = [[self.dataArray objectAtIndex:indexPath.row - 1] objectForKey:PM_TO_UID];
        [self.navigationController pushViewController:con animated:YES];
    } else {//通知列表
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择"];
        as.delegate = self;
        
        NSDictionary *dict = [secondDataArray objectAtIndex:indexPath.row];
//        NSMutableArray *arr = [Common separateAndGetTheArrayWithStr:[dict objectForKey:NOTE_HTML]];
//        
//        for (int i = 0; i < [arr count]; i++) {
//            if (i % 2 == 1) {
//                NSString *title = [[arr objectAtIndex:i] isEqualToString:@""] ? @"详情" : [arr objectAtIndex:i];
//                [as addButtonWithTitle:title handler:^{
//                    NSLog(@"url11111:%@", [arr objectAtIndex:i - 1]);
//                }];
//            }
//        }
        //姓名
        if (!isEmptyStr([dict objectForKey:NOTICE_AUTHOR_NAME])) {
            [as addButtonWithTitle:[dict objectForKey:NOTICE_AUTHOR_NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.userId = [dict objectForKey:NOTICE_AUTHOR_ID];
                [self.navigationController pushViewController:con animated:YES];
            }];
        }
        //详情
        NSDictionary *noteDict = [dict objectForKey:NOTE_SPLIT];
        if (!isEmptyStr([[noteDict objectForKey:OBJ] objectForKey:SUBJECT])) {
            [as addButtonWithTitle:@"进入详情" handler:^{
                FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                con.hidesBottomBarWhenPushed = YES;
                NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
                [idDict setObject:[[noteDict objectForKey:OBJ] objectForKey:FEED_ID_TYPE] forKey:FEED_ID_TYPE];
                [idDict setObject:[[noteDict objectForKey:OBJ] objectForKey:ID] forKey:FEED_ID];
                [idDict setObject:[[noteDict objectForKey:OBJ] objectForKey:ID] forKey:FEED_COMMENT_ID];
                [idDict setObject:[[noteDict objectForKey:OBJ] objectForKey:UID] forKey:UID];
                [con.idArray addObject:idDict];
//                con.idType = [[noteDict objectForKey:OBJ] objectForKey:FEED_ID_TYPE];
//                con.feedId = [[noteDict objectForKey:OBJ] objectForKey:ID];
//                con.feedCommentId = [[noteDict objectForKey:OBJ] objectForKey:ID];
//                con.userId = [[noteDict objectForKey:OBJ] objectForKey:UID];
                con.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:con animated:YES];
            }];
        }
        //和谁在一起
        NSMutableArray *withFriendsArray = [noteDict objectForKey:WITH_FRIENDS];
        for (int i = 0; i < [withFriendsArray count]; i++) {
            [as addButtonWithTitle:[[withFriendsArray objectAtIndex:i] objectForKey:NAME] handler:^{
                if ([emptystr([[withFriendsArray objectAtIndex:i] objectForKey:AC]) isEqualToString:FRIEND]) {//通过申请成为家人的
                    
                    FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
                    con.conType = askForMyFamilyListType;
                    [self.navigationController pushViewController:con animated:YES];
                    
//                    [self agreeToFamilyWithUserId:[[withFriendsArray objectAtIndex:i] objectForKey:UID]];
                } else {//进入用户名片
                    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                    con.userId = [[withFriendsArray objectAtIndex:i] objectForKey:UID];
                    [self.navigationController pushViewController:con animated:YES];
                }
            }];
        }
        //取消
        [as addButtonWithTitle:@"取消" handler:^{
            return ;
        }];
        as.cancelButtonIndex = as.numberOfButtons - 1;
        [as sizeToFit];
        MyTabBarController *tabBarCon = (MyTabBarController*)self.parentViewController;
        [as showFromTabBar:tabBarCon.tabBar];
        if ([[[secondDataArray objectAtIndex:indexPath.row] objectForKey:NEW] boolValue]) {
            [self changeReadStateWithIndex:indexPath.row];
        }
    }
}

#pragma mark - 改变已读状态
- (void)receiveTheNotification:(NSNotification*)noti {
    int indexRow = [[noti object] intValue];
    [self changeReadStateWithIndex:indexRow];
}

- (void)changeReadStateWithIndex:(int)indexRow {
    NSMutableArray *array = self.isFirstTable ? dataArray : secondDataArray;
    NSMutableDictionary *dict = [array objectAtIndex:indexRow];
    if ([[dict objectForKey:NEW] intValue] != 0) {
        dict = [dict changeForKey:NEW withValue:@"0"];
        [array replaceObjectAtIndex:indexRow withObject:dict];
        PullTableView *table = self.isFirstTable ? _tableView : _secondTableView;
        [table reloadData];
    }
    
    MyTabBarController *tabCon = (MyTabBarController*)myTabBarController;
    int badgeNum = self.isFirstTable ? --tabCon.dialogNum : --tabCon.noticeNum;
    int btnNum = self.isFirstTable ? 0 : 1;
    [self setBadgeNumWithBtnTag:btnNum andBadgeNum:$str(@"%d", badgeNum)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:@"-1"];//消息数（对话或通知）减1
    if (!self.isFirstTable) {
        [self uploadRequestToMarkReadStateOfNoticeWithId:[dict objectForKey:ID]];
    }
}

- (void)uploadRequestToMarkReadStateOfNoticeWithId:(NSString*)noticeId {
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:noticeId, ID, MY_M_AUTH, M_AUTH, nil];
    NSString *url = $str(@"%@notice", POST_CP_API);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
    }];
}

#pragma mark - 上面的对话、通知的数目
- (void)setBadgeNumWithBtnTag:(int)btnTag andBadgeNum:(NSString*)badgeNum {
    NSString *preBadgeNum = @"0";
    UIButton *btn = (UIButton*)[_topView viewWithTag:kTagBtnInTopBarView + btnTag];
    JSBadgeView *badgeView = nil;
    for (id obj in btn.subviews) {
        if ([obj isKindOfClass:[JSBadgeView class]]) {
            badgeView = (JSBadgeView*)obj;
            preBadgeNum = badgeView.badgeText;//減少的
            [badgeView removeFromSuperview];
            badgeView = nil;
            break;
        }
    }
//    if ([badgeNum isEqualToString:ADD_MSG_NUM]) {
//        badgeNum = $str(@"%d", [preBadgeNum intValue] + 1);//推送过来的一条对话
//    } else if ([badgeNum isEqualToString:ADD_MSG_NUM]) {
//        
//    } else
    if ([badgeNum intValue] < 0) {
        badgeNum = $str(@"%d", [preBadgeNum intValue] + [badgeNum intValue]);//减少的
    }
    badgeNum = [badgeNum intValue] > 9 ? @"n" : badgeNum;
    
    if ([badgeNum intValue] > 0 || [badgeNum isEqualToString:@"n"]) {//真正的badgeNum
        badgeView = [[JSBadgeView alloc] initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        [badgeView setBadgeText:badgeNum];
        [badgeView setBadgePositionAdjustment:CGPointMake(badgeView.frame.origin.x, badgeView.frame.origin.y + 20)];
    }
}

//#pragma  mark - 同意成为家人接口
//- (void)agreeToFamilyWithUserId:(NSString*)userId {
//    [SVProgressHUD showWithStatus:@"同意中..."];
//    NSString *url = $str(@"%@friend&op=add", POST_CP_API);
//    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId, APPLY_UID, ONE, AGGRE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
//    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//    } onCompletion:^(NSDictionary *dict) {
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        [SVProgressHUD showSuccessWithStatus:@"同意成功"];
//    } failure:^(NSError *error) {
//        NSLog(@"error:%@", [error description]);
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//    }];
//}

#pragma mark cell action



@end
