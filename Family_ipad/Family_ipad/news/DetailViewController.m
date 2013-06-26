        //
//  DetailViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentCell.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "DetailFeedCell.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"
#import "Common.h"
#import "UIView+BlocksKit.h"
#import "PostBaseView.h"
#import "KGModal.h"
#import "CellHeader.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PostBaseViewController.h"
#import "NSString+ConciseKit.h"
#import "UIActionSheet+BlocksKit.h"
#import "NSObject+BlocksKit.h"
#import "MPNotificationView.h"
#import "UIAlertView+BlocksKit.h"
#define kFirstPhotoY    30
#define kPhotoSnap      15
#define kPhotoX         15

#define kPhotoHeight    300
#define KPhotoWidth     450
#define commentHeader   58.0f
#define BIGIMG_HEIGHT   400.0f
#define CLICK_PHOTO_FUN         @"6"//开心
#define CLICK_PHOTO_GOOD        @"7"//赞
#define CLICK_PHOTO_CRY         @"32"//伤心
#define CLICK_PHOTO_SMILE       @"9"//微笑
#define CLICK_PHOTO_SUR         @"10"//惊讶

//日志
#define CLICK_BLOG_FUN          @"1"//开心
#define CLICK_BLOG_GOOD         @"2"//赞
#define CLICK_BLOG_CRY          @"29"//伤心
#define CLICK_BLOG_SMILE        @"4"//微笑
#define CLICK_BLOG_SUR          @"5"//惊讶

//活动
#define CLICK_EVENT_FUN         @"11"//开心
#define CLICK_EVENT_GOOD        @"12"//赞
#define CLICK_EVENT_CRY         @"13"//伤心
#define CLICK_EVENT_SMILE       @"14"//微笑
#define CLICK_EVENT_SUR         @"15"//惊讶

//视频
#define CLICK_VIDEO_FUN         @"16"//开心
#define CLICK_VIDEO_GOOD        @"17"//赞
#define CLICK_VIDEO_CRY         @"33"//伤心
#define CLICK_VIDEO_SMILE       @"19"//微笑
#define CLICK_VIDEO_SUR         @"20"//惊讶
#define kTagBtnOfFace   220//动态详情的表态按钮
#define SinaUploadPicURL    @"http://api.weibo.com/2/statuses/update.json"
@interface DetailViewController ()

@end

@implementation DetailViewController
- (SinaWeibo *)sinaWiebo
{
    return [AppDelegate instance].sinaweibo;
}
- (void)sendToSinaWeiboWithPic:(NSString*)text {
    SinaWeibo *sinaweibo = [self sinaWiebo];
    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               text, @"status",
                               [UIImage imageNamed:@"logo_bright.png"], @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}
- (void)sendToSinaWeiboWithText:(NSString*)text {
    SinaWeibo *sinaweibo = [AppDelegate instance].sinaweibo;
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"sinaweibo didFailWithError:%@", error);
    if ([request.url hasSuffix:@"statuses/update.json"]) {
        [MPNotificationView notifyWithText:@"分享失败T_T" detail:nil andDuration:0.5f];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    if ([request.url hasSuffix:@"statuses/update.json"]) {
        [MPNotificationView notifyWithText:@"分享成功" detail:nil andDuration:0.5f];
    }
    
}

- (IBAction)showActionSheet:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"菜单"];
    if ([$str(self.userId) isEqualToString:MY_UID]){
        [as setDestructiveButtonWithTitle:@"删除" handler:^{
            NSString *deleteTypeStr = [self.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"delete", OP, self.feedId, deleteTypeStr, ONE, DELETE_SUBMIT, POST_M_AUTH, M_AUTH, nil];
            [self uploadRequestToDeleteWithPara:para];
            [self backAction:nil];
        }];
        [as setCancelButtonWithTitle:@"编辑" handler:^{
            ;
        }];
            
        
    }
    NSLog(@"%@",[AppDelegate instance].sinaweibo.accessToken);

    [as setCancelButtonWithTitle:@"分享到新浪微博" handler:^{
        //sina weibo
        NSLog(@"%@ %i %i ",[[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_TOKEN],[self sinaWiebo].isAuthorizeExpired,[self sinaWiebo].isAuthValid);
        if (![[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_TOKEN]||[self sinaWiebo].isAuthorizeExpired||![self sinaWiebo].isAuthValid ){
            [AppDelegate instance].sinaweibo.delegate = self;
            [[AppDelegate instance].sinaweibo logIn];

        }else{
            FeedDetailType type = [DetailViewController whichDetailType:_idType];
            NSString *titleText =nil;
            if (type == eventDetailType) {
                titleText = _dataDict ? [_dataDict objectForKey:TITLE] : @"      ";
                
            } else {
                titleText = _dataDict ? [_dataDict objectForKey:SUBJECT] : @"      ";
            }
            if ([titleText isEqualToString:@""]) {
                titleText = @"无标题";
            }
            if (type == photoDetailType) {
                [self sendToSinaWeiboWithPic:$str(@"%@  %@",titleText,[_dataDict objectForKey:MESSAGE]]);

            }
            [self sendToSinaWeiboWithText:$str(@"%@  %@",titleText,[_dataDict objectForKey:MESSAGE]]);
        }
    }];
    [as setCancelButtonWithTitle:@"取消" handler:^{
        ;
    }];
    [as showInView:self.view];
}
-(void)playRemoteVideo:(UIButton *)sender
{
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[sender titleForState:UIControlStateDisabled]]];
    [player setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [player shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    [[AppDelegate instance].rootViewController presentMoviePlayerViewControllerAnimated:player];
}
- (void)uploadRequestToClickWithId:(NSString*)clickId {
    [SVProgressHUD showWithStatus:@"表态中..."];
    NSString *url = $str(@"%@click&op=add", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedId, ID_, _idType, FEED_ID_TYPE, clickId, CLICK_ID, COME_VERSION, COME, POST_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"表态成功"];
        [_faceContainer dismissPopoverAnimated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (IBAction)faceBtnForClickPressed:(UIButton*)sender {
    NSArray *clickArray = nil;
    if ([_idType isEqualToString:PHOTO_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_PHOTO_SMILE, CLICK_PHOTO_FUN, CLICK_PHOTO_SUR, CLICK_PHOTO_CRY, CLICK_PHOTO_GOOD, nil];
    } else if ([_idType isEqualToString:BLOG_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_BLOG_SMILE, CLICK_BLOG_FUN, CLICK_BLOG_SUR, CLICK_BLOG_CRY, CLICK_BLOG_GOOD, nil];
    } else if ([_idType isEqualToString:EVENT_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_EVENT_SMILE, CLICK_EVENT_FUN, CLICK_EVENT_SUR, CLICK_EVENT_CRY, CLICK_EVENT_GOOD, nil];
    } else if ([_idType isEqualToString:VIDEO_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_VIDEO_SMILE, CLICK_VIDEO_FUN, CLICK_VIDEO_SUR, CLICK_VIDEO_CRY, CLICK_VIDEO_GOOD, nil];
    } else{
        [SVProgressHUD showErrorWithStatus:@"暂时不能表态T_T"];
        return;
    }
    [self uploadRequestToClickWithId:[clickArray objectAtIndex:sender.tag - kTagBtnOfFace]];
}
- (IBAction)willShowFaceView:(UIButton *)sender {
    
    //    CGFloat faceViewY = DEVICE_SIZE.height - kBottomViewHeight - kFaceViewHeight;
    
//    CGRect faceViewRect = _faceView.frame;
//    if (willShow) {
//        faceViewRect.origin.y = _toolView.frame.size.height;
//    } else
//        faceViewRect.origin.y = -_faceView.frame.size.height;
//    
//    [UIView animateWithDuration:0.1f
//                     animations:^{
//                         _faceView.frame = faceViewRect;
//                         //                             _faceView.frame = (CGRect){.origin.x = 0, .origin.y = faceViewY + kFaceViewHeight, .size = _faceView.frame.size};
//                     }];
    UIViewController* popoverContent = [[UIViewController alloc]                                            init];

    popoverContent.view = _faceView;        //resize the popover view shown        //in the current view to
    popoverContent.contentSizeForViewInPopover = _faceView.frame.size;        //create a popover controller
    _faceContainer = [[UIPopoverController alloc]                                  initWithContentViewController:popoverContent];
    

    [_faceContainer presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}
- (IBAction)rePostBtnPressed:(UIButton*)sender {
    if ([[_dataDict objectForKey:UID] isEqualToString:MY_UID]) {
        [SVProgressHUD showErrorWithStatus:@"不能转载自己的东西T_T"];
        return;
    }
    FeedDetailType type = [DetailViewController whichDetailType:_idType];
    if (type == eventDetailType ||type == videoDetailType) {
        [SVProgressHUD showErrorWithStatus:@"活动和视频不能转载T_T"];   
    }else{
        REMOVEDETAIL;
        PostBaseViewController *con = [[PostBaseViewController alloc]initWithNibName:@"PostBaseViewController" bundle:nil];
        if (!_isFromZone) {
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
        }else{
            con.modalPresentationStyle = UIModalPresentationFormSheet;

            [self presentModalViewController:con animated:YES];
            con.view.superview.frame = CGRectMake(0, 0, 470, 768);//it's important to do this after
            con.view.superview.center = CGPointMake(1024/2, 768/2);
        }
       
        con.postView.dataDict = _dataDict;
       con.postView.rePostType =[DetailViewController whichDetailType:_idType];
        [con.postView initPostView:nil];
        


     }
   
}

- (void)uploadRequestToCommentOrJoinEvent:(NSMutableDictionary*)para withCommentText:(NSString*)msg {
    NSString *tipsStr =@"发送中...";
 //   [SVProgressHUD showWithStatus:tipsStr];
    [MPNotificationView notifyWithText:tipsStr detail:nil andDuration:0.5f];
    NSString *url = $str(@"%@comment", POST_API);
    
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"评论成功" detail:nil andDuration:0.5f];

        //[SVProgressHUD dismiss];
        //更新动态列表的评论数据
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:MY_UID forKey:AUTHOR_ID];
        [aDict setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:DATELINE];
        [aDict setObject:msg forKey:MESSAGE];
        [aDict setObject:MY_NAME forKey:COMMENT_AUTHOR_NAME];
        [aDict setObject:[NSNumber numberWithInt:_indexRow] forKey:@"indexRow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LIST object:aDict];
        
        //更新当前页面的评论列表
        [aDict setObject:MY_HEAD_AVATAR_URL forKey:AVATER];
        [dataArray insertObject:aDict atIndex:0];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (IBAction)commentAction:(UIView *)sender
{
    NSString *holder;
    if (sender.tag !=0) {
        NSLog(@"sender.tag:%d",sender.tag);
        NSDictionary *dict = [dataArray objectAtIndex:sender.tag-1];
        holder = $str(@"回复%@：",[dict objectForKey:NOTICE_AUTHOR_NAME]);
    }else{
        holder = COMMENT_HOLDER;
    }
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:holder
                                                                         maxCount:1000
                                                                      buttonStyle:YIPopupTextViewButtonStyleRightCancelAndDone
                                                                  tintsDoneButton:YES];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    //    popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    if ([_idType isEqualToString:FEED_EVENT_ID]) {
        popupTextView.text = @"参与了活动";
    }
    if (!_isFromZone) {
        [popupTextView showInView:[AppDelegate instance].rootViewController.view];
    }
    else
        [popupTextView showInView:self.view];

}
- (IBAction)loveAction:(UIButton *)sender
{
    NSString *type = _hasLoved?ZERO:ONE;
    NSString *tips = _hasLoved ? @"取消收藏中..." : @"收藏中...";
    [MPNotificationView notifyWithText:tips detail:nil andDuration:0.5f];

    //[SVProgressHUD showWithStatus:tips];
    NSString *url = $str(@"%@feedlove", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedId, ID_, _idType, FEED_ID_TYPE, type, TYPE, POST_M_AUTH, M_AUTH, nil];
    if (para.count != 4) {
        [SVProgressHUD showErrorWithStatus:@"出错了"];

        return;
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tips = _hasLoved? @"取消收藏成功":@"收藏成功";
        [MPNotificationView notifyWithText:tips detail:nil andDuration:0.5f];
        
        sender.selected = !sender.selected;
        _hasLoved = sender.selected;
        
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:$bool(YES) forKey:@"refresh_love"];

        [aDict setObject:$bool(sender.selected) forKey:MY_LOVE];
        [aDict setObject:[NSNumber numberWithInt:_indexRow] forKey:@"indexRow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LIST object:aDict];

        //我是否已经收藏
        //[_dataDict setObject:[NSNumber numberWithBool:sender.selected] forKey:MY_LOVE];
   
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
@synthesize idType = _idType;
- (IBAction)swicthComment:(UIButton *)sender
{

    [_tableView reloadData];
}
- (void)setIdType:(NSString *)idType {
    NSRange range = [idType rangeOfString:@"re"];
    if (range.location ==NSNotFound) {
        _idType = idType;
    } else{
        _idType = [idType stringByReplacingCharactersInRange:range withString:@""];
    }
    if ([DetailViewController whichDetailType:_idType] == eventDetailType) {
        _joinMemberArray = [[NSMutableArray alloc] init];
        //        for (int i=0; i<10; i++) {
        //            NSDictionary *tmp = [NSDictionary dictionaryWithObjectsAndKeys:@"吴盛潮", @"name", @"", @"avatar", @"4", @"uid", nil];
        //            [_joinMemberArray addObject:tmp];
        //        }
        _tableView.loadMoreView.hidden = YES;
    }
}

- (NSString*)idType {
    return _idType;
}
- (void)sendRequest:(id)sender {
    if (currentPage == 1) {

       // _tableView.pullTableIsRefreshing = _isFromZone ? NO : YES;
        [self sendRequestToDetail:sender];
    }

    [self sendRequestToComment:sender];
}
- (void)sendRequestToDetail:(id)sender {
    [_picArray removeAllObjects];
    //    NSString *doTypeStr = [_idType stringByReplacingOccurrencesOfString:@"id" withString:@""];
    //    doTypeStr = [doTypeStr stringByReplacingOccurrencesOfString:@"re" withString:@""];
    NSString *doTypeStr = _idType;
    if ([doTypeStr hasPrefix:@"re"]) {
        doTypeStr = [doTypeStr substringFromIndex:2];//2为“re”两个字母
    }
    if ([doTypeStr hasSuffix:@"id"]) {
        doTypeStr = [doTypeStr substringToIndex:(doTypeStr.length - 2)];//2为“id”两个字母
    }
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=%@&id=%@&uid=%@&m_auth=%@", BASE_URL, doTypeStr, _feedId, _userId, GET_M_AUTH];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        _isFirstShow = NO;
        if (_isFromZone) {
            [SVProgressHUD dismiss];
        }
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [self performBlock:^(id sender) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                REMOVEDETAIL;

            } afterDelay:0.8f];
            return ;
        }
        self.dataDict = [dict objectForKey:WEB_DATA];
        if ([[_dataDict objectForKey:PIC_LIST] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *picDict in [_dataDict objectForKey:PIC_LIST]) {
                [ _picArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[picDict objectForKey:PIC] delLastStrForYouPai] ]]];
            }
        }
        
        _hasLoved = [[_dataDict objectForKey:MY_LOVE] boolValue];//1为我已收藏，0为我未收藏

        _loveButton.selected = _hasLoved;//1为我已收藏，0为我未收藏
        
        [_topView.avatarButton setImageForMyHeadButtonWithUrlStr:[_dataDict objectForKey:AVATER] plcaholderImageStr:nil size:MIDDLE];
        _topView.avatarButton.type = HEAD_BTN;
        _topView.avatarButton.identify = [_dataDict objectForKey:UID];
        NSString *tagName = [[_dataDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[_dataDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";

        [_topView.avatarButton setVipStatusWithStr:[_dataDict objectForKey:VIPSTATUS] isSmallHead:YES];
            self.topView.zoneBtn.type = ZONE_BTN;
            if (!_isFromZone) {
                self.topView.zoneBtn.identify = [[_dataDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[_dataDict objectForKey:TAG] objectForKey:TAG_ID] : @"";
        
            }
            self.topView.zoneBtn.extraInfo = [_dataDict objectForKey:UID];
        
        [self.topView.zoneBtn setTitle:tagName forState:UIControlStateNormal];
        _topView.timeLabelview.text = [Common dateSinceNow:[_dataDict objectForKey:DATELINE]];
        FeedDetailType type = [DetailViewController whichDetailType:_idType];
        NSString *otherText = type == photoDetailType ? @"发表了照片" : (type == blogDetailType ? @"发表了日志" : (type == videoDetailType ? @"发表了视频" : (type == eventDetailType ? @"发表了活动" : @"")));
        _topView.nameLabel.text = [_dataDict objectForKey:NAME];
        _topView.nameLabel.frame = [_topView.nameLabel textRectForBounds:_topView.nameLabel.frame limitedToNumberOfLines:1];
        _topView.actionLabel.text = otherText;
        _topView.actionLabel.frame = CGRectMake(_topView.nameLabel.frame.origin.x+_topView.nameLabel.frame.size.width +5, _topView.nameLabel.frame.origin.y, _topView.actionLabel.frame.size.width, _topView.actionLabel.frame.size.height);
       
        //[_topView.titleLabel sizeToFit];
        if (type == blogDetailType) {
            _hasLoaded = NO;
            [_theWebView loadHTMLString:[_dataDict objectForKey:MESSAGE] baseURL:nil];
        } else if (type == eventDetailType) {
            //            [_joinMemberArray removeAllObjects];
            [_joinMemberArray addObjectsFromArray:[_dataDict objectForKey:FEED_TOGETHER]];
            _hasLoaded = NO;
            [_theWebView loadHTMLString:[_dataDict objectForKey:DETAIL] baseURL:nil];
        }
        
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [self stopLoading:sender];
    }];
}

- (void)sendRequestToComment:(id)sender {
    NSString *doTypeStr = [_idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=comment&id=%@&idtype=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _feedCommentId, doTypeStr, currentPage, 10, GET_M_AUTH];
    [[MyHttpClient sharedInstance] commandWithPathAndNoHUD:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (_isFromZone) {
            [SVProgressHUD dismiss];
        }
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            if (!_isFromZone) {
                [SVProgressHUD showSuccessWithStatus:@"没有更多评论了T_T"];
            }
        }
        [dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [self stopLoading:sender];
        currentPage--;
    }];
}

+ (FeedDetailType)whichDetailType:(NSString*)typeStr {
    if ([typeStr rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {
        return photoDetailType;
    } else if ([typeStr rangeOfString:FEED_BLOG_ID].location != NSNotFound) {
        return blogDetailType;
    } else if ([typeStr rangeOfString:FEED_VIDEO_ID].location != NSNotFound) {
        return videoDetailType;
    } else if ([typeStr rangeOfString:FEED_EVENT_ID].location != NSNotFound) {
        return eventDetailType;
    } else {
        return unknownDetailType;
    }
}
- (IBAction)swipeToDismiss:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.height, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

    } completion:^(BOOL finished) {
        [self backAction:nil];

    }];

}
- (IBAction)backAction:(id)sender
{
    if (_isFromZone) 
        [self dismissModalViewControllerAnimated:YES];
    else
        [[AppDelegate instance].rootViewController.stackScrollViewController removeThirdView];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _picArray = $marrnew;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    if (_isFromZone) {
        self.view.superview.frame = CGRectMake(0, 0, 480, 768);//it's important to do this after
        self.view.superview.center = CGPointMake(1024/2, 768/2);

    }
}
- (void)refreshComment:(NSNotification*)noti
{
    NSMutableDictionary *aDict = (NSMutableDictionary*)[noti object];
    if (_indexRow == [(NSNumber *)[aDict objectForKey:@"indexRow"] intValue]) {
        NSLog(@"success");
        //更新当前页面的评论列表
        [aDict setObject:MY_HEAD_AVATAR_URL forKey:AVATER];
        [dataArray insertObject:aDict atIndex:0];
        [_tableView reloadData];
    }

}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeGesture];
    _tableView.tableHeaderView = _topView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshComment:)
                                                 name:@"refreshComment" object:nil];
//    if ([DetailViewController whichDetailType:_idType] == eventDetailType) {
//        [commentBtn  setBackgroundImage:[UIImage imageNamed:@"joinevent.png"] forState:UIControlStateNormal];
//
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _cellHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *titleText;// = _dataDict ? [_dataDict objectForKey:SUBJECT] : @"      ";
    FeedDetailType type = [DetailViewController whichDetailType:_idType];
    if (type == eventDetailType) {
        titleText = _dataDict ? [_dataDict objectForKey:TITLE] : @"      ";
         
    } else {
        titleText = _dataDict ? [_dataDict objectForKey:SUBJECT] : @"      ";
    }
    if ([titleText isEqualToString:@""]) {
        titleText = @"无标题";
    }
    _cellHeader.frame = (CGRect){.origin = CGPointZero, .size.width = DEVICE_SIZE.width, .size.height =  [CellHeader getHeaderHeightWithText:titleText].height};
    [_cellHeader initHeaderDataWithMiddleLblText:titleText];
//    if ([$str(self.userId) isEqualToString:MY_UID]) {
//        UIButton *delBtn = nil;
//        for (id obj in self.cellHeader.subviews) {
//            if ([obj isKindOfClass:[UIButton class]]) {
//                delBtn = (UIButton*)obj;
//                break;
//            }
//        }
//        if (!delBtn) {
//            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            delBtn.frame = CGRectZero;
//            [delBtn setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal];
//        [delBtn whenTapped:^{
//            UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"是否删除?"];
//            [as setDestructiveButtonWithTitle:@"删除" handler:^{
//                NSString *deleteTypeStr = [self.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
//                NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"delete", OP, self.feedId, deleteTypeStr, ONE, DELETE_SUBMIT, POST_M_AUTH, M_AUTH, nil];
//                [self uploadRequestToDeleteWithPara:para];
//                [self backAction:nil];
//            }];
//            [as setCancelButtonWithTitle:@"取消" handler:^{
//                ;
//            }];
//            [as showInView:self.view];
//        }];
//            [self.cellHeader addSubview:delBtn];
//
//        }
//    }
    return _cellHeader.frame.size.height; //+10;
}
#pragma mark - 删除帖子的接口
- (void)uploadRequestToDeleteWithPara:(NSMutableDictionary*)para {
    NSString *tipsStr = @"删除中...";//isCommentCell ? @"发送评论中..." : @"参与活动中...";
    [SVProgressHUD showWithStatus:tipsStr];
    NSString *acStr = [self.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
    acStr = [acStr stringByReplacingOccurrencesOfString:@"id" withString:@""];
    NSString *url = $str(@"%@%@", POST_CP_API, acStr);
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        REMOVEDETAIL;

    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        int commentNum = [dataArray count] == 0 ? 1 : [dataArray count];
        return 1 + commentNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!_dataDict) {
            return BIGIMG_HEIGHT;
        }
        FeedDetailType type = [DetailViewController whichDetailType:_idType];
        if (type == photoDetailType) {//photoid或rephotoid
            
            CGFloat picHeight = 0;
            if ([[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]]) {
                picHeight = 35;
            } else {
                NSArray *picArray = [_dataDict objectForKey:PIC_LIST];
                for (int i = 0; i < [picArray count]; i++) {
                    int currImageHeight = [[[picArray objectAtIndex:i] objectForKey:HEIGHT] intValue];
                    int currImageWidth = [[[picArray objectAtIndex:i] objectForKey:WIDTH] intValue];
                    if (currImageWidth > KPhotoWidth) {
                        currImageHeight = KPhotoWidth * currImageHeight / currImageWidth;
                    }
                    picHeight = picHeight + currImageHeight + i * kPhotoSnap;
                }
            }

            return picHeight + [DetailFeedCell heightForPhotoSubject:[_dataDict objectForKey:MESSAGE] andOtherHeight:45] + kFirstPhotoY;
        } else if (type == blogDetailType) {
            return 95 + _theWebView.frame.size.height;// 290;
        } else if (type == videoDetailType) {
            return BIGIMG_HEIGHT + [DetailFeedCell heightForPhotoSubject:[_dataDict objectForKey:MESSAGE]andOtherHeight:-30];
        } else if (type == eventDetailType) {
            return  168 + _theWebView.frame.size.height;
        } else
            return BIGIMG_HEIGHT;
    } else {//评论列表
        FeedDetailType type = [DetailViewController whichDetailType:_idType];
        if ([dataArray count] == 0) {
            return 60;
        } else {
            return [self heightForCellWithIndexRow:indexPath.row andType:type];
        }
    }
    //    return 65;
}

- (CGFloat)heightForCellWithIndexRow:(int)indexRow andType:(FeedDetailType)type {
    NSDictionary *dict = [dataArray objectAtIndex:indexRow - 1];
    
    NSString *name = [dict objectForKey:NAME];
    CGSize nameSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(470, 320) lineBreakMode:UILineBreakModeWordWrap];
    NSString *text = [dict objectForKey:MESSAGE];
    CGFloat theHeight = [DetailFeedCell heightForCellWithText:text andOtherHeight:55 withNameX:82 withNameWidth:nameSize.width];
    return fmaxf(theHeight, 75);// theHeight;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailFeedCell *cell;
    static NSString *detailFeedCellId = @"detailFeedCellId";
    static NSString *webViewCellId = @"webViewCellId";
    static NSString *eventDetailFeedCellId = @"eventDetailFeedCellId";
    static NSString *commentCellId = @"commentCellId";
    FeedDetailType detailType = [DetailViewController whichDetailType:_idType];
    if (indexPath.row == 0) {
        if (detailType == photoDetailType) {
            cell = [tableView dequeueReusableCellWithIdentifier:detailFeedCellId];
        } else if (detailType == eventDetailType) {
            cell = [tableView dequeueReusableCellWithIdentifier:eventDetailFeedCellId];
        }else {// if (detailType == videoDetailType) {
            cell = [tableView dequeueReusableCellWithIdentifier:webViewCellId];
        }
    } else
        cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DetailFeedCell" owner:self options:nil];
        if (indexPath.row == 0) {
            if (detailType == photoDetailType) {
                cell = [array objectAtIndex:0];
            } else if (detailType == videoDetailType) {
                cell = [array objectAtIndex:1];
            } else if (detailType == blogDetailType) {
                cell = [array objectAtIndex:1];
                
                [cell.webView removeFromSuperview];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPhotoX, 30, KPhotoWidth, 300)];
                webView.delegate = self;
                webView.opaque = NO;
                [webView setScalesPageToFit:NO];
                //                webView.userInteractionEnabled = NO;
                webView.backgroundColor = self.view.backgroundColor;
                self.theWebView = webView;
                [cell.contentView addSubview:webView];
            } else if (detailType == eventDetailType) {
                cell = [array objectAtIndex:2];
                [cell.webView removeFromSuperview];
                UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPhotoX, 30, KPhotoWidth, 300)];
                webView.delegate = self;
                webView.opaque = NO;
                [webView setScalesPageToFit:NO];
                //                webView.userInteractionEnabled = NO;
                webView.backgroundColor = self.view.backgroundColor;
                self.theWebView = webView;
                [cell.contentView addSubview:webView];
            }
            //
            NSMutableArray *textArray = [[NSMutableArray alloc] init];
            if (detailType == eventDetailType) {
                [textArray addObject:@"参与"];
               
            }
            [textArray addObject:@"评论"];

        } else {
            cell = [array objectAtIndex:3];
        }
    }
    if (indexPath.row == 0) {//
        //照片
        if (detailType == eventDetailType && isOperatViewBtnPressed) {//防止切换“参与”、“评论”按钮时刷新第0行的数据
            isOperatViewBtnPressed = NO;
            return cell;
        }
        if (detailType == photoDetailType) {
            if (self.dataDict) {
                //            int thePicNum = _dataDict ? [[_dataDict objectForKey:PIC_LIST] count] : 1;
                int thePicNum = _dataDict ? ([[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]] ? 0 : [[_dataDict objectForKey:PIC_LIST] count]) : 1;
                for (UIView *obj in [cell.contentView subviews]) {
                    if ([obj isKindOfClass:[UIImageView class]]) {
                        UIImageView *photoImgView = (UIImageView*)obj;
                        [photoImgView removeFromSuperview];
                    }
                }
                int preYAndHeight = kFirstPhotoY;
                
                NSArray *picArray = [_dataDict objectForKey:PIC_LIST];
                for (int i = 0; i < thePicNum; i++) {
                    int imageWidth = [[[picArray objectAtIndex:i] objectForKey:WIDTH] intValue];
                    int imageHeight = [[[picArray objectAtIndex:i] objectForKey:HEIGHT] intValue];
                    if (imageWidth > KPhotoWidth) {
                        imageHeight = KPhotoWidth * imageHeight / imageWidth;
                    }
                    CGFloat actuallyWidth = imageWidth>KPhotoWidth?KPhotoWidth:imageWidth;
                    CGFloat actuallyX = (cell.contentView.frame.size.width-actuallyWidth)/2;
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(actuallyX,preYAndHeight + kPhotoSnap * i, actuallyWidth, imageHeight)];
                    preYAndHeight = preYAndHeight + i * kPhotoSnap + imageHeight;
                    imgView.userInteractionEnabled = YES;
                    [imgView whenTapped:^{
                        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                        browser.displayActionButton = YES;
                        browser.dataDict = _dataDict;
                        browser.idType = _idType;
                        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
                        [browser setInitialPageIndex:i];
                        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        if (!_isFromZone)
                        {
                           
                            [[AppDelegate instance].rootViewController presentModalViewController:nc animated:YES];
                        }
                        else{
                            [self presentModalViewController:nc animated:YES];
                        }
                        
                    }];
                    //                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kPhotoX, kFirstPhotoY + (kPhotoHeight   + kPhotoSnap) * i, KPhotoWidth, kPhotoHeight)];
                    [cell.contentView addSubview:imgView];
                }

            }
                    } else if (detailType == blogDetailType) {
            cell.infoLbl.hidden = _hasLoaded;
            [cell.webView layoutSubviews];
        }
        if (self.dataDict) {
            NSString *rePostNum = detailType == photoDetailType ? @"rephotonum" : (detailType == blogDetailType ? @"reblognum" : (detailType == videoDetailType ? @"revideonum" : (detailType == eventDetailType ? @"reeventnum" : @"")));
            rePostNum = [rePostNum isEqualToString:@""] ? @"见鬼了" : rePostNum;
            cell.hotLbl.text = [NSString stringWithFormat:@"转发(%@) 收藏(%@) 评论(%@)", [_dataDict objectForKey:rePostNum], [_dataDict objectForKey:FEED_LOVE_NUM], [_dataDict objectForKey:FEED_REPLY_NUM]];
            cell.feedDetailType = detailType;
            if (detailType == photoDetailType) {
                //                cell.picNum = [[_dataDict objectForKey:PIC_LIST] count];
                cell.picNum = [[_dataDict objectForKey:PIC_LIST] isEqual:[NSNull null]] ? 0 : [[_dataDict objectForKey:PIC_LIST] count];
            }
        } else {
            cell.hotLbl.text = @"转发(0) 收藏(0) 评论(0)";//假数据
            cell.feedDetailType = detailType;
            if (detailType == photoDetailType) {
                cell.picNum = 1;//假数据
            }
        }
        cell.isFromZone = _isFromZone;
        [cell initFirstCellData:_dataDict];
    } else {
        cell.isLoadingFirstCell = _isFirstShow;
        if ([dataArray count] == 0) {
            [cell initCommentData:nil];
        } else{
                [cell initCommentData:[dataArray objectAtIndex:indexPath.row - 1]];
                cell.replyBtn.tag = indexPath.row;
        }
        if (detailType == eventDetailType) {
        }
        
    }
    
    return cell;

    
    
}

#pragma mark - webview delegate
//webview委托   高度自适应
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    NSString *width = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth;"];
    //    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    
    CGSize actualSize = [webView sizeThatFits:CGSizeMake(290, MAXFLOAT)];
    CGRect theFrame = webView.frame;
    theFrame.size.height = actualSize.height;
    webView.frame = theFrame;
    _hasLoaded = YES;
    [_tableView reloadData];
}

#pragma mark -

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
   // NSLog(@"will dismiss: cancelled=%d",cancelled);
    // self.textView.text = text;
    
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
   /// NSLog(@"holder:%@",textView.placeholder);

    //NSLog(@"did dismiss: cancelled=%d",cancelled);
    if (!cancelled) {
        NSString *str = $str(@"%@%@",textView.placeholder,text);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedCommentId, ID_,_idType, FEED_ID_TYPE, str, MESSAGE, POST_M_AUTH, M_AUTH, nil];
            [self uploadRequestToCommentOrJoinEvent:para withCommentText:str];
    }
}
            - (void)storeAuthData
                {
                    SinaWeibo *sinaweibo = [self sinaWiebo];
                    
                    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                              sinaweibo.accessToken, @"AccessTokenKey",
                                              sinaweibo.expirationDate, @"ExpirationDateKey",
                                              sinaweibo.userID, @"UserIDKey",
                                              sinaweibo.refreshToken, @"refresh_token", nil];
                    [ConciseKit setUserDefaultsWithObject:authData forKey:SINA_AUTH_DATA];
                    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.userID forKey:SINA_UID];
                    [[PDKeychainBindings sharedKeychainBindings] setObject:sinaweibo.accessToken forKey:SINA_TOKEN];
                }
                 
                 - (void)removeAuthData
                {
                    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:SINA_UID];
                    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:SINA_TOKEN];
                    [ConciseKit removeUserDafualtForKey:SINA_AUTH_DATA];
                }

#pragma mark - SinaWeibo Delegate
                 - (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
                {
                    [SVProgressHUD showWithStatus:@"绑定中..."];
                    NSString *url = $str(@"%@bindweibo", POST_API);
                    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"sina", TYPE, sinaweibo.userID, ID_, sinaweibo.accessToken, @"token", POST_M_AUTH, M_AUTH, nil];
                    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
                        ;
                    } onCompletion:^(NSDictionary *dict) {
                        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                            return ;
                        }
                        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_BIND_SINA_WEIBO];
                        //        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self storeAuthData];
                        [_tableView reloadData];
                        
                        
                    } failure:^(NSError *error) {
                        NSLog(@"error:%@", [error description]);
                        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
                    }];
                }
                 
                 - (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
                {
                    
                    if (MY_HAS_LOGIN) {
                        [sinaweibo logIn];
                    }
                }
                 
                 - (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
                {
                    NSLog(@"sinaweiboLogInDidCancel");
                }
                 
                 - (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
                {
                    NSLog(@"sinaweibo logInDidFailWithError %@", error);
                }
                 
                 - (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
                {
                    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
                    //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
                    //    [[NSUserDefaults standardUserDefaults] synchronize];
                    //    [self removeAuthData];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博授权已过期，是否重新授权?"];
                    [alert addButtonWithTitle:@"重新授权" handler:^{
                        [sinaweibo logOut];
                    }];
                    [alert setCancelButtonWithTitle:@"取消" handler:^{
                        return ;
                    }];
                    [alert show];
                }

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _picArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _picArray.count)
        return [_picArray objectAtIndex:index];
    return nil;
}
@end
