//
//  NewsViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "NewsViewController.h"
#import "AppDelegate.h"
#import "ZoneTableViewController.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "NewsOutlineCell.h"
#import "DetailViewController.h"
#import "FeedCell.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "UIControl+BlocksKit.h"
#import "KGModal.h"
#import "PostBaseView.h"
#import "DetailViewController.h"
#import "FamilyCardViewController.h"
#import "UIActionSheet+BlocksKit.h"
#import "PostBaseViewController.h"
#import "CKMacros.h"
#import "MPNotificationView.h"
#define kNotifyForOpertingTime           0.5f//“后台发送中...”这几个字要显示的时间

@interface NewsViewController ()

@end

@implementation NewsViewController
- (IBAction)handleEditButton:(UIButton *)sender
{
    // NOTE: maxCount = 0 to hide count
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:COMMENT_HOLDER
                                                                         maxCount:1000
                                                                      buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone
                                                                  tintsDoneButton:YES];
    popupTextView.tag = sender.tag;
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    //    popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    [popupTextView showInView:[AppDelegate instance].rootViewController.view];
    
    //
    // NOTE:
    // You can add your custom-button after calling -showInView:
    // (it's better to add on either superview or superview.superview)
    // https://github.com/inamiy/YIPopupTextView/issues/3
    //
    // [popupTextView.superview addSubview:customButton];
    //
}
- (void)sendRequest:(id)sender
{
    NSString *url = $str(@"%@space.php?do=home&m_auth=%@&page=%d&perpage=%d", BASE_URL, GET_M_AUTH, currentPage, 10);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            return ;
        }
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据了T_T"];
        }
        
        [dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        if (dataArray.count <3 &&currentPage == 1) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:VOID_FEED_NOTIFICATION object:nil]];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [self stopLoading:sender];
        currentPage--;
    }];
}
+ (FeedCellType)whichType:(NSDictionary*)dict {
    NSString *idType = [dict objectForKey:FEED_ID_TYPE];
    if ([idType rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {//@"photoid"或@"rephotoid"
        if ([[dict objectForKey:FEED_IMAGE_2] isEqualToString:@""]) {
            return bigImgType;//只有一张图片
        } else
            return someImgsType;//>1张图片
    } else if (([idType rangeOfString:FEED_BLOG_ID].location != NSNotFound) || ([idType rangeOfString:FEED_VIDEO_ID].location != NSNotFound)) {//@"blogid"或@"reblogid"或"videoid"或"revideoid"
        if ([[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {
            return onlyTextType;//没有图片
        } else
            return imgAndTextType;//
    } else if ([idType rangeOfString:FEED_EVENT_ID].location != NSNotFound) {//@"eventid"或"reeventid"
        return locationType;
    } else if ([[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {//idtype里除了照片、日记、视频、活动及其转采的
        return otherNoImgType;//右边没有图片
    } else
        return otherHasImgType;//右边有图片
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentForNotification:) name:REFRESH_FEED_LIST object:nil];

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedCellType type = [NewsViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    if (type == otherHasImgType || type == otherNoImgType) {
        return 121;
    }
    CGFloat noCommentHeight = 0;
    switch (type) {
        case bigImgType:
            noCommentHeight = 480;
            break;
        case someImgsType:
            noCommentHeight = 246*1.5;
            break;
        case imgAndTextType:
            noCommentHeight = 238*1.5+10;
            break;
        case onlyTextType:
            noCommentHeight = 160*1.5;
            break;
        case locationType:
            noCommentHeight = 238*1.5+10;
            break;
        default:
            break;
    }
    int theCommentNum = [[[dataArray objectAtIndex:indexPath.row] objectForKey:COMMENT] count];//取两者中最小值
    
   // theCommentNum = theCommentNum == 0 ? 1 : theCommentNum;//没有评论时加”给你的家人评论一下吧～“这一句
    if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"loveuser"]count]!=0) {
        theCommentNum++;
    }
    return noCommentHeight + 45 * theCommentNum;//55为一条评论的高度
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell;
    static NSString *bigImgCellId = @"bigImgCellId";
    static NSString *someImgsCellId = @"someImgsCellId";
    static NSString *imgAndTextCellId = @"imgAndTextCellId";
    static NSString *onlyTextCellId = @"onlyTextCellId";
    static NSString *locationCellId = @"locationCellId";
    static NSString *otherHasImgCellId = @"otherHasImgCellId";
    static NSString *otherNoImgCellId = @"otherNoImgCellId";
    FeedCellType type = [NewsViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    switch (type) {
        case bigImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:bigImgCellId];
            break;
        case someImgsType:
            cell = [tableView dequeueReusableCellWithIdentifier:someImgsCellId];
            break;
        case imgAndTextType:
            cell = [tableView dequeueReusableCellWithIdentifier:imgAndTextCellId];
            break;
        case onlyTextType:
            cell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellId];
            break;
        case locationType:
            cell = [tableView dequeueReusableCellWithIdentifier:locationCellId];
            break;
        case otherHasImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:otherHasImgCellId];
            break;
        case otherNoImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:otherNoImgCellId];
            break;
        default:
            break;
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
		cell = [array objectAtIndex:type];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexPath.row]];
    
    cell.cellType = type;
    NSString *idType = [[dataArray objectAtIndex:indexPath.row] objectForKey:FEED_ID_TYPE];
    if ([idType hasPrefix:@"re"]) {
        cell.isRepost = YES;
    } else
        cell.isRepost = NO;
    cell.indexRow = indexPath.row;
    cell.authorUserId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    
    if (type != otherNoImgType || type != otherHasImgType) {
        [cell initCommonData:[dataArray objectAtIndex:indexPath.row]];
        if ([[currDict objectForKey:MY_LOVE]isEqualToNumber:$int(1)])
            cell.albumView.likeitBtn.selected = YES;
        else
            cell.albumView.likeitBtn.selected = NO;
        [cell.albumView.likeitBtn removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [cell.albumView.repostBtn removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [cell.albumView.repostBtn addEventHandler:^(id sender) {
            if ([[currDict objectForKey:UID] isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"不能转载自己的东西T_T"];
                return;
            }
            if ([[currDict objectForKey:FEED_ID_TYPE]isEqualToString:VIDEO_ID]) {
                [SVProgressHUD showErrorWithStatus:@"视频不能转载T_T"];
                return ;
            }
            if (type == locationType) {
                [SVProgressHUD showErrorWithStatus:@"活动不能转载T_T"];
            }else{
                REMOVEDETAIL;
                PostBaseViewController *con = [[PostBaseViewController alloc]initWithNibName:@"PostBaseViewController" bundle:nil];
              
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
                con.postView.dataDict = [dataArray objectAtIndex:indexPath.row];
                con.postView.rePostType = [DetailViewController whichDetailType:idType];
                [con.postView initPostView:nil];
            
            }
         
        } forControlEvents:UIControlEventTouchUpInside];
        [cell.albumView.likeitBtn addEventHandler:^(UIButton * sender) {

            MyButton *btn = (MyButton*)sender;

            sender.enabled= NO;
            BOOL hasLoved = cell.albumView.hasLoved;//1为我已收藏，0为我未收藏
            NSString *type = hasLoved?@"0":@"1";
            //[SVProgressHUD showWithStatus:tips];
            NSString *url = $str(@"%@feedlove", POST_API);
            NSString *idtype =  [[currDict objectForKey:FEED_ID_TYPE] stringByReplacingOccurrencesOfString:@"re" withString:@""];

            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[currDict objectForKey:ID_], ID_, idtype, FEED_ID_TYPE, type, TYPE, POST_M_AUTH, M_AUTH, nil];
            [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
                //                [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
            } onCompletion:^(NSDictionary *dict) {

                if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                    [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                    sender.enabled= YES;

                    return ;
                }
                NSString *tips = hasLoved ? @"取消收藏成功" : @"收藏成功";
                [MPNotificationView notifyWithText:tips detail:nil andDuration:kNotifyForOpertingTime];
                cell.albumView.hasLoved = !cell.albumView.hasLoved;

                //我是否已经收藏
                NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexPath.row]];

                [currDict setObject:[NSNumber numberWithBool:cell.albumView.hasLoved] forKey:MY_LOVE];
                NSMutableArray *loveuserArr = [NSMutableArray arrayWithArray:[currDict objectForKey:LOVEUSER]];
                NSDictionary *lovedict = [NSDictionary dictionaryWithObject:[ConciseKit userDefaultsObjectForKey:NAME
                                                                             ] forKey:NAME];
                [loveuserArr addObject:lovedict];
                [currDict setObject:loveuserArr forKey:LOVEUSER];
                
                
                [dataArray replaceObjectAtIndex:indexPath.row withObject:currDict];
                [_tableView reloadData];
                //收藏数目
//                int loveNum = [[currDict objectForKey:FEED_LOVE_NUM] intValue];
//                loveNum = btn.selected ? loveNum + 1 : loveNum - 1;
//                [currDict setObject:[NSString stringWithFormat:@"%d", loveNum] forKey:FEED_LOVE_NUM];
//                
//                [dataArray replaceObjectAtIndex:indexPath.row withObject:currDict];
//                
//                [cell.albumView.likeitBtn setTitle:$str(@"%d",loveNum) forState:UIControlStateNormal];
                sender.enabled = YES;

            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
                sender.enabled = YES;

            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [cell.albumView.commentBtn removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        [cell.albumView.commentBtn addEventHandler:^(UIButton * sender) {
            sender.tag = indexPath.row;
            [self handleEditButton:sender];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    [cell initData:[dataArray objectAtIndex:indexPath.row]];//由具体的子类去实现
    return cell;

}

#pragma mark - 上行接口
- (void)uploadRequestToComment:(NSMutableDictionary*)para withMsg:(NSString*)msg andIndexRow:(int)indexRow {
    //[SVProgressHUD showWithStatus:@"发送评论中..."];
    [MPNotificationView notifyWithText:@"发送评论中..." detail:nil andDuration:0.5f];

    NSString *url = $str(@"%@comment", POST_API);
    
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"评论成功" detail:nil andDuration:kNotifyForOpertingTime];
        //[SVProgressHUD showSuccessWithStatus:@"评论成功"];
        
        //更新当前页面的评论数据
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:MY_UID forKey:AUTHOR_ID];
        [aDict setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:DATELINE];
        [aDict setObject:msg forKey:MESSAGE];
        [aDict setObject:MY_NAME forKey:COMMENT_AUTHOR_NAME];
        [aDict setObject:[NSNumber numberWithInt:indexRow] forKey:@"indexRow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshComment" object:aDict];

        [self refreshCommentWithDict:aDict];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (void)refreshCommentForNotification:(NSNotification*)noti {
    NSMutableDictionary *aDict = (NSMutableDictionary*)[noti object];
    if ([aDict objectForKey:@"refresh_love"]) {
        [self refreshLoveWith:aDict];
    }
    else{
        [self refreshCommentWithDict:aDict];

    }
}
- (void)refreshLoveWith:(NSMutableDictionary *)aDict{
    int indexRow = [[aDict objectForKey:@"indexRow"] intValue];
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexRow]];
    NSMutableArray *loveuserArr = [NSMutableArray arrayWithArray:[currDict objectForKey:LOVEUSER]];
    NSDictionary *lovedict = [NSDictionary dictionaryWithObject:[ConciseKit userDefaultsObjectForKey:NAME
                                                                 ] forKey:NAME];
    [loveuserArr addObject:lovedict];
    [currDict setObject:loveuserArr forKey:LOVEUSER];
    [currDict setObject:[aDict objectForKey:MY_LOVE] forKey:MY_LOVE];
    if ([[aDict objectForKey:MY_LOVE] intValue])
        [currDict setObject:$int([[aDict objectForKey:FEED_LOVE_NUM]intValue]+1) forKey:FEED_LOVE_NUM];
    else
        [currDict setObject:$int([[aDict objectForKey:FEED_LOVE_NUM]intValue]) forKey:FEED_LOVE_NUM];

    [dataArray replaceObjectAtIndex:indexRow withObject:currDict];
    [_tableView reloadData];


}
- (void)refreshCommentWithDict:(NSMutableDictionary*)aDict {
    int indexRow = [[aDict objectForKey:@"indexRow"] intValue];
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexRow]];
    [aDict removeObjectForKey:@"indexRow"];
    NSMutableArray *commentArray;
    if ([currDict objectForKey:COMMENT]) {
        commentArray = [[NSMutableArray alloc] initWithArray:[currDict objectForKey:COMMENT]];
        if ([commentArray count] >= 2) {
            [commentArray removeObjectAtIndex:1];
        }
        [commentArray insertObject:aDict atIndex:0];
    } else {
        commentArray = [[NSMutableArray alloc] init];
        [commentArray addObject:aDict];
    }
    [currDict setObject:commentArray forKey:COMMENT];
    int replyNum = [[currDict objectForKey:FEED_REPLY_NUM] intValue] + 1;
    [currDict setObject:[NSString stringWithFormat:@"%d", replyNum] forKey:FEED_REPLY_NUM];
    [dataArray replaceObjectAtIndex:indexRow withObject:currDict];
    [_tableView reloadData];
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCellType type = [NewsViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    if (type == otherHasImgType || type == otherNoImgType) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择"];
        
        //        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        if (!isEmptyStr([dict objectForKey:NAME])) {
            [as addButtonWithTitle:[dict objectForKey:NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.isMyFamily = YES;
                con.userId = [dict objectForKey:UID];
                [con sendRequestWith:[dict objectForKey:UID]];
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
            }];
        }
        if (!isEmptyStr([dict objectForKey:F_NAME])){
            [as addButtonWithTitle:[dict objectForKey:F_NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.isMyFamily = YES;
                con.userId = [dict objectForKey:F_UID];
                [con sendRequestWith:[dict objectForKey:F_UID]];
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
            }];
        }
        if ((!isEmptyStr([dict objectForKey:F_ID]))&&(![[dict objectForKey:F_ID] isEqualToString:ZERO])) {
            [as addButtonWithTitle:@"进入详情" handler:^{
                DetailViewController *con = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                NSRange range = [[dict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT];
                NSString *type;
                if (range.location!=NSNotFound) 
                    type =  [[dict objectForKey:FEED_ID_TYPE] stringByReplacingCharactersInRange:range withString:ID_];
                else
                    type =  [dict objectForKey:FEED_ID_TYPE];
                con.idType = type;
                con.feedId = [dict objectForKey:ID_];
                con.feedCommentId = [dict objectForKey:F_ID] ;
                con.userId = [dict objectForKey:UID];
                [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
            }];
        }
        [as addButtonWithTitle:@"取消" handler:^{
            return ;
        }];
        [as showInView:[AppDelegate instance].rootViewController.view];
    }
    else
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        
        //    con.detailType = bigImgType;
        //    con.dataDict = [dataArray objectAtIndex:indexPath.row];
        
        NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
        detailViewController.idType = [aDict objectForKey:FEED_ID_TYPE];
        detailViewController.feedId = [aDict objectForKey:@"id"];
        detailViewController.userId = [aDict objectForKey:UID];
        detailViewController.feedCommentId = [aDict objectForKey:F_ID];
        detailViewController.indexRow = indexPath.row;
        REMOVEDETAIL;
        
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
    }
   
    
}

#pragma mark -

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    NSLog(@"will dismiss: cancelled=%d",cancelled);
   // self.textView.text = text;
   
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    NSLog(@"did dismiss: cancelled=%d",cancelled);
    if (!cancelled) {
        NSMutableDictionary *currDict = [dataArray objectAtIndex:textView.tag];
        NSString *idType = [currDict objectForKey:FEED_ID_TYPE];
        NSRange range = [idType rangeOfString:@"re"];
        if (range.location !=NSNotFound) {
            idType = [idType stringByReplacingCharactersInRange:range withString:@""];
        }
        
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[currDict objectForKey:F_ID], ID_, idType, FEED_ID_TYPE, text, MESSAGE, POST_M_AUTH, M_AUTH, nil];
        [self uploadRequestToComment:para withMsg:text andIndexRow:textView.tag];
    }
}

@end
