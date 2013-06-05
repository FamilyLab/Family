//
//  MessageViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "DialogueViewController.h"
#import "NewsOutlineCell.h"
#import "MyHttpClient.h"
#import "FamilyCardViewController.h"
#import "DetailViewController.h"
#import "UIActionSheet+BlocksKit.h"
#import "DetailBaseViewController.h"
#import "ApplyFamilyViewController.h"
#import "JSBadgeView.h"
#define NOTICE_X 355
#define MESSAGEX_X 425
@interface MessageViewController ()
{
    BOOL isNotice;
    UIButton *preSelectButton;
}
@end

@implementation MessageViewController
- (void)sendRequest:(id)sender
{
    NSString *requestStr;
    if (!isNotice) 
        requestStr = $str(@"%@space.php?do=pm&filter=privatepm&page=%d&m_auth=%@",BASE_URL,currentPage,GET_M_AUTH);
    else
        requestStr = $str(@"%@space.php?do=notice&m_auth=%@&page=%d",BASE_URL,GET_M_AUTH,currentPage);

    [[MyHttpClient sharedInstance] commandWithPath:requestStr
                                      onCompletion:^(NSDictionary *dict) {
                                          [self stopLoading:sender];
                                          if (needRemoveObjects == YES) {
                                              [dataArray removeAllObjects];
                                              [_tableView reloadData];
                                              needRemoveObjects = NO;
                                          }
                                          NSArray *resultArr = [dict objectForKey:WEB_DATA] ;
                                          [dataArray addObjectsFromArray:resultArr];
                                          [_tableView reloadData];
                                          
                                      }
                                           failure:^(NSError *error) {
                                               [self stopLoading:sender];
                                           }];
}
- (IBAction)switchTableView:(UIButton *)sender
{
    if (preSelectButton==sender) {
        return;
    }
    preSelectButton.selected = NO;
    sender.selected = !sender.selected;
    preSelectButton = sender;
    if (_noticeButton.selected){
        isNotice = YES;
        [UIView animateWithDuration:0.3f animations:^{
            _delter_image.frame = CGRectMake(sender.frame.origin.x+15, _delter_image.frame.origin.y, _delter_image.frame.size.width, _delter_image.frame.size.height);
        }];
    }
    else{
        isNotice = NO;
        [UIView animateWithDuration:0.3f animations:^{
            _delter_image.frame = CGRectMake(sender.frame.origin.x+15, _delter_image.frame.origin.y, _delter_image.frame.size.width, _delter_image.frame.size.height);
        }];
    }
    [self refresh:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isNotice = NO;
        preSelectButton = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    header.headerTitle.text = @"消息";
    //[self switchTableView:_messageButton];
    JSBadgeView *messagebadgeView = [[JSBadgeView alloc] initWithParentView:_messageButton alignment:JSBadgeViewAlignmentTopRight];

    JSBadgeView *noticebadgeView = [[JSBadgeView alloc] initWithParentView:_noticeButton alignment:JSBadgeViewAlignmentTopRight];
   
   // [ConciseKit setUserDefaultsWithObject:nil forKey:ELDER_COUNT];
    [[MyHttpClient sharedInstance]commandWithPathAndNoHUD:$str(@"%@?do=elder&m_auth=%@",SPACE_API,GET_M_AUTH) onCompletion:^(NSDictionary *dict) {
        NSDictionary *dataDict = [dict objectForKey: WEB_DATA];
        messagebadgeView.badgeText = [dataDict objectForKey:PM_COUNT];
        messagebadgeView.hidden = [[dataDict objectForKey:PM_COUNT] isEqualToString:ZERO];
        NSString *noticeNews = $str(@"%d",[[dataDict objectForKey:NOTE_COUNT] intValue]);
        noticebadgeView.badgeText = noticeNews;
        noticebadgeView.hidden = [noticeNews isEqualToString:ZERO];
        
    } failure:^(NSError *error) {
        ;
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dataArray count]>0) {
        if (isNotice) {
            NSDictionary  *dataDict = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
            NSString *allNoteText;
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
            CGFloat height = [NewsOutlineCell heightForCellWithText:allNoteText andOtherHeight:95.0f];
            return height;
        }
        else{
            NSDictionary  *dataDict = [NSDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
            
            NSString *contentStr = [NSString stringWithFormat:@"%@ %@", [dataDict objectForKey:LAST_SUMMARY], [dataDict objectForKey:ADDRESS]];
            
            return [MessageCell heightForCellWithText:contentStr andOtherHeight:85.0f];
        }
       
    }
    else
return 0;

}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isNotice) {
        static NSString *CellIdentifier = @"NewsOutlineCellId";
        NewsOutlineCell *cell=(NewsOutlineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [array objectAtIndex:2];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ([dataArray count]>0) {
            [cell initNoticeData:[dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"MessageCellId";
        MessageCell *cell=(MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            cell = [array objectAtIndex:1];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        if ([dataArray count]>0) {
            [cell setCellData:[dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    REMOVEDETAIL;
    if (isNotice) {
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        NewsOutlineCell *cell = (NewsOutlineCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell.multiTextTypeView.imgView.hidden) {
            cell.multiTextTypeView.imgView.hidden = YES;
            NSMutableDictionary *para = $dict([dict objectForKey:ID_ ],ID_,POST_M_AUTH,M_AUTH,nil);
            [[MyHttpClient sharedInstance]commandWithPathAndParamsAndNoHUD:$str(@"%@notice",POST_CP_API) params:para addData:^(id<AFMultipartFormData> formData) {
                ;
            } onCompletion:^(NSDictionary *dict) {
                [self clearBadge:_noticeButton];
                NSMutableDictionary *replaceDict = [NSMutableDictionary dictionaryWithDictionary:[dataArray objectAtIndex:indexPath.row]];
                [replaceDict setObject:[NSNumber numberWithInt:0] forKey:NEW];
                [dataArray replaceObjectAtIndex:indexPath.row withObject:replaceDict];
            } failure:^(NSError *error) {
                ;
            }];
        }
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择"];
        
        
        //姓名
        if (!isEmptyStr([dict objectForKey:NOTICE_AUTHOR_NAME])) {
            [as addButtonWithTitle:[dict objectForKey:NOTICE_AUTHOR_NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.userId = [dict objectForKey:NOTICE_AUTHOR_ID];
                [con sendRequestWith: [dict objectForKey:NOTICE_AUTHOR_ID]];

                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];            }];
        }
        //详情
        NSDictionary *noteDict = [dict objectForKey:NOTE_SPLIT];
        //NSLog(@"%@",[[noteDict objectForKey:OBJ] objectForKey:SUBJECT]);
        if ([[noteDict objectForKey:OBJ] objectForKey:SUBJECT]) {
            [as addButtonWithTitle:@"进入详情" handler:^{
                DetailViewController *con = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                con.idType = [[noteDict objectForKey:OBJ] objectForKey:FEED_ID_TYPE];
                con.feedId = [[noteDict objectForKey:OBJ] objectForKey:ID_];
                con.feedCommentId = [[noteDict objectForKey:OBJ] objectForKey:ID_];
                con.userId = [[noteDict objectForKey:OBJ] objectForKey:UID];
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
            }];
        }
//        if ([[dict objectForKey:TYPE] rangeOfString:COMMENT].location != NSNotFound)
//        {
//            [as addButtonWithTitle:@"进入详情" handler:^{
//                DetailViewController *con = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//                con.idType = $str(@"%@id",[dict objectForKey:FEED_ID_TYPE]);
//                con.feedId = [dict objectForKey:F_ID];
//                con.feedCommentId = [dict objectForKey:F_ID];
//                con.userId = [dict objectForKey:F_UID];
//                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
//            }];
//        }
        //和谁在一起
        NSMutableArray *withFriendsArray = [noteDict objectForKey:WITH_FRIENDS];
        for (int i = 0; i < [withFriendsArray count]; i++) {
            [as addButtonWithTitle:[[withFriendsArray objectAtIndex:i] objectForKey:NAME] handler:^{
                if ([$str([[withFriendsArray objectAtIndex:i] objectForKey:AC]) isEqualToString:FRIEND]) {//通过申请成为家人的
                    
                    ApplyFamilyViewController *con = [[ApplyFamilyViewController alloc] initWithNibName:@"ApplyFamilyViewController" bundle:nil];
                    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];  ;
                    } else {//进入用户名片
                    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                    con.userId = [[withFriendsArray objectAtIndex:i] objectForKey:UID];
                    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];                }
            }];
        }
        //取消
        [as addButtonWithTitle:@"取消" handler:^{
            return ;
        }];
        [as showInView:[AppDelegate instance].rootViewController.view];
    }
    else{
        MessageCell *cell = (MessageCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell.isNewImage.hidden) {
            [self clearBadge:_messageButton];
            cell.isNewImage.hidden = YES;
        }
        DialogueViewController *detailViewController = [[DialogueViewController alloc] initWithNibName:@"DialogueViewController" bundle:nil];
        detailViewController.toUserId = [[dataArray objectAtIndex:indexPath.row] objectForKey:PM_TO_UID];
        
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
    }
    
    
}
-(void)clearBadge:(UIButton *)sender
{
    for (UIView *view in sender.subviews) {
        if ([view isKindOfClass:[JSBadgeView class]]) {
            if (isNotice) {
                ((JSBadgeView *)view).badgeText = $str(@"%d",[((JSBadgeView *)view).badgeText intValue]-1);
                if ([((JSBadgeView *)view).badgeText isEqualToString:ZERO]) {
                    view.hidden = YES;
                }
            }else{
                view.hidden = YES;
            }
            break;
        }
    }
}
@end
