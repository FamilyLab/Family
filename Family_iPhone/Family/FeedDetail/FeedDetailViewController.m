//
//  FeedDetailViewController.m
//  Family
//
//  Created by Aevitx on 13-1-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "DetailFeedCell.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "FamilyCardViewController.h"
#import "MyAnnotation.h"
#import "ZoneDetailViewController.h"
#import "DDAlertPrompt.h"
//#import "PostViewController.h"
#import "PostSthViewController.h"
#import "PlistManager.h"
#import "MPNotificationView.h"


#define kFaceViewHeight     66
#define kBottomViewHeight   40

#define kFirstShowNumForZone    5

@interface FeedDetailViewController ()

- (IBAction)hideInputView:(id)sender;

@end

@implementation FeedDetailViewController
@synthesize bottomView;//, cellHeader;
//@synthesize idType = _idType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        _isFirstShow = YES;
        _hasLoaded = NO;
        offsetYOfJoin = 0;
        offsetYOfComment = 0;
        //        isCommentCell = YES;
        isOperatViewBtnPressed = NO;
        isFirstShownComment = YES;
        
        _isFromZone = NO;
        _isFirstShowFromZone = YES;
        _currRequestPageToGetIdArray = 1;
        _allFeedNum = 1;
        if (!_idArray) {
            _idArray = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self addTopView];
    [self addBottomView];
    [self buildGrowingTextView];
    
    JTListView *jt = [[JTListView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height - self.bottomView.frame.size.height) layout:JTListViewLayoutLeftToRight];
    jt.delegate = self;
    jt.dataSource = self;
    jt.scrollEnabled = _isFromZone;
    [self.view insertSubview:jt atIndex:0];
    self.theListView = jt;
    _theListView.showsHorizontalScrollIndicator = NO;
    _theListView.showsVerticalScrollIndicator = YES;
    _theListView.pagingEnabled = YES;
    if (!_isFromZone) {
        [_theListView reloadData];
    } else {
        [self sendRequestToGetIdArrayFromTagId];
    }
    
    [self.goBackBtn setImage:[UIImage imageNamed:@"feed_back_a.png"] forState:UIControlStateNormal];
    [self.goBackBtn setImage:[UIImage imageNamed:@"feed_back_b.png"] forState:UIControlStateHighlighted];
    [self.goForwardBtn setImage:[UIImage imageNamed:@"feed_forward_a.png"] forState:UIControlStateNormal];
    [self.goForwardBtn setImage:[UIImage imageNamed:@"feed_forward_b.png"] forState:UIControlStateHighlighted];
    
    //表情
    NSArray *hightLightedOrSelectedImagesArray = [[NSArray alloc] initWithObjects:@"click_smile_b", @"click_fun_b", @"click_surprise_b", @"click_cry_b", @"click_good_b", nil];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = (UIButton*)[_faceView viewWithTag:kTagBtnOfFace + i];
        [btn setImage:[UIImage imageNamed:[hightLightedOrSelectedImagesArray objectAtIndex:i]] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:[hightLightedOrSelectedImagesArray objectAtIndex:i]] forState:UIControlStateSelected];
    }
    _faceView.frame = (CGRect){.origin = CGPointMake(0, DEVICE_SIZE.height - kBottomViewHeight), .size = _faceView.frame.size};//44为bottomviw的高度，66为faceview的高度
    [self.view insertSubview:_faceView belowSubview:bottomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_isFromZone && _isFirstShowFromZone) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [PlistManager deletePlist:PLIST_FEED_TOP_DATA];
    [PlistManager deletePlist:PLIST_FEED_COMMENT];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - HPGrowingTextView
//////////////////////////////////////自动拉伸度度 start/////////////////////////////////////////////////

- (void)buildGrowingTextView {
    // Keyboard events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.theInputView.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height, .size = self.theInputView.frame.size};
    [self.view addSubview:_theInputView];
    
    _growingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    _growingTextView.placeHolder = @"随便说点啥...";
	_growingTextView.minNumberOfLines = 1;
	_growingTextView.maxNumberOfLines = 4;
	_growingTextView.returnKeyType = UIReturnKeySend;
    _growingTextView.font = [UIFont systemFontOfSize:15.0f];
	_growingTextView.delegate = self;
    _growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _growingTextView.backgroundColor = [UIColor clearColor];
    //    _growingTextView.internalTextView.scrollEnabled = YES;
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    _growingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imgView = (UIImageView*)[[self.theInputView subviews] objectAtIndex:i];
        imgView.image = [imgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    //    theInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _theInputView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_theInputView.frame = r;
    
    [self pointToCurrPanelView];
    CGRect bubbleFrame = _panelView.pullTable.frame;
    bubbleFrame.size.height += diff;
	_panelView.pullTable.frame = bubbleFrame;
    _theListView.frame = bubbleFrame;
//    CGRect bubbleFrame = _tableView.frame;
//    bubbleFrame.size.height += diff;
//	_tableView.frame = bubbleFrame;
    //    [self scrollToBottomWithAnimation:YES];
    
    if (_growingTextView.frame.size.height != 30) {
        CGRect gFrame = _growingTextView.frame;
        gFrame.size.height = 30;
        _growingTextView.frame = gFrame;
    }
}

#pragma mark - Keyboard events
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
	CGRect inputViewFrame = _theInputView.frame;
    inputViewFrame.origin.y = DEVICE_SIZE.height - kbSize.height - inputViewFrame.size.height;
    
    [self pointToCurrPanelView];
	CGRect bubbleFrame = _panelView.pullTable.frame;
    bubbleFrame.size.height = DEVICE_SIZE.height - _panelView.pullTable.frame.origin.y - inputViewFrame.size.height - kbSize.height;
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _theInputView.frame = inputViewFrame;
        _theListView.frame = bubbleFrame;
        _panelView.pullTable.frame = bubbleFrame;
    }];
    [_panelView.pullTable whenTapped:^{
        if ([_growingTextView isFirstResponder]) {
            [_growingTextView resignFirstResponder];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
	CGRect inputViewFrame = _theInputView.frame;
    inputViewFrame.origin.y = DEVICE_SIZE.height;
    
    [self pointToCurrPanelView];
    CGRect bubbleFrame = _panelView.pullTable.frame;
    bubbleFrame.size.height = DEVICE_SIZE.height - _panelView.pullTable.frame.origin.y - inputViewFrame.size.height;
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _theInputView.frame = inputViewFrame;
        _theListView.frame = bubbleFrame;
        _panelView.pullTable.frame = bubbleFrame;
    }];
    for (id obj in _panelView.pullTable.gestureRecognizers) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *ges = (UITapGestureRecognizer*)obj;
            [_panelView.pullTable removeGestureRecognizer:ges];
        }
    }
    
//	CGRect bubbleFrame = _tableView.frame;
//    bubbleFrame.size.height = DEVICE_SIZE.height - _tableView.frame.origin.y - inputViewFrame.size.height;
//    
//    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//        _theInputView.frame = inputViewFrame;
//        _tableView.frame = bubbleFrame;
//    }];
//    for (id obj in _tableView.gestureRecognizers) {
//        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
//            UITapGestureRecognizer *ges = (UITapGestureRecognizer*)obj;
//            [_tableView removeGestureRecognizer:ges];
//        }
//    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    return YES;
}


//- (void)scrollToBottomWithAnimation:(BOOL)_animation {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[dataArray count] inSection:0];
//    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:_animation];
//}

- (IBAction)hideInputView:(id)sender {
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
    self.theInputView.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height, .size = self.theInputView.frame.size};
}

- (IBAction)sendTextBtnPressed:(id)sender {
    [self sendText];
}

- (void)sendText {
    if (![_growingTextView hasText]) {
        return;
    }
    if ([self currIdDict]) {
        NSString *commentIdType = [[self currIdDict] objectForKey:FEED_ID_TYPE];
        commentIdType = [commentIdType stringByReplacingOccurrencesOfString:@"re" withString:@""];
        
        if (self.replyWhoseNameStr) {//回复某人评论的
            self.replyWhoseNameStr = $str(@"回复%@: %@", self.replyWhoseNameStr, _growingTextView.text);
        } else {
            self.replyWhoseNameStr = _growingTextView.text;
        }
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self currIdDict] objectForKey:FEED_ID], ID, commentIdType, FEED_ID_TYPE, self.replyWhoseNameStr, MESSAGE, MY_M_AUTH, M_AUTH, nil];
        [self uploadRequestToCommentOrJoinEvent:para withCommentText:self.replyWhoseNameStr];
    }
}

//////////////////////////////////////自动拉伸度度 end///////////////////////////////////////////////////

#pragma mark - my method(s)
- (void)sendRequestToGetIdArrayFromTagId {
    NSString *url;
    int perpage = _isFirstShowFromZone ? kFirstShowNumForZone : 5;//第二次加载时加载5篇，之前是1篇而已
    if (_isFirstShowFromZone) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    if (_userId) {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspacesimple&tagid=%@&uid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, _userId, _currRequestPageToGetIdArray, perpage, [MY_M_AUTH urlencode]];
    } else {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspacesimple&tagid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, _currRequestPageToGetIdArray, perpage, [MY_M_AUTH urlencode]];
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        _allFeedNum = [[[dict objectForKey:WEB_DATA] objectForKey:FEED_NUM] intValue];
        if (_allFeedNum <= 1) {
            _theListView.scrollEnabled = NO;
        }
        NSArray *feedList = [[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST];
        for (int i = 0; i < [feedList count]; i++) {
//            BOOL hasExist = NO;
//            NSString *tmpFeedId = [[feedList objectAtIndex:i] objectForKey:ID];
//            for (int j = 0; j < [_idArray count]; j++) {
//                if ([tmpFeedId isEqualToString:[[_idArray objectAtIndex:j] objectForKey:ID]]) {
//                    hasExist = YES;
//                    break;
//                }
//            }
//            if (!hasExist) {
                NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
                [idDict setObject:[[feedList objectAtIndex:i] objectForKey:FEED_ID_TYPE] forKey:FEED_ID_TYPE];
                [idDict setObject:[[feedList objectAtIndex:i] objectForKey:ID] forKey:FEED_ID];
                [idDict setObject:[[feedList objectAtIndex:i] objectForKey:F_ID] forKey:FEED_COMMENT_ID];
                [idDict setObject:[[feedList objectAtIndex:i] objectForKey:UID] forKey:UID];
                [idDict setObject:[[feedList objectAtIndex:i] objectForKey:DATELINE] forKey:DATELINE];
                [_idArray addObject:idDict];
//            }
        }
//        [_idArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            int dateline1 = [[obj1 objectForKey:DATELINE] intValue];
//            int dateline2 = [[obj2 objectForKey:DATELINE] intValue];
//            if (dateline1 > dateline2) {
//                return (NSComparisonResult)NSOrderedAscending;
//            }
//            if (dateline1 < dateline2) {
//                return (NSComparisonResult)NSOrderedDescending;
//            }
//            return (NSComparisonResult)NSOrderedSame;
//        }];//根据dateline对idArray进行降序，防止等下详情显示的次序不正确
        
//        _currRequestPageToGetIdArray++;//接口这里有问题
//        if (_isFirstShowFromZone) {
//            _currRequestPageToGetIdArray = kFirstShowNumForZone;
//        }
        _currRequestPageToGetIdArray++;
        
        _isFirstShowFromZone = NO;
        [_theListView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        _currRequestPageToGetIdArray--;
    }];
}

- (void)pointToCurrPanelView {
    NSUInteger currItemIndex = [self.theListView indexForItemAtCenterOfBounds];
    self.panelView = (MyPanelView*)[self.theListView viewForItemAtIndex:currItemIndex];
}

- (NSDictionary*)currIdDict {
    if ([_idArray count] > 0) {
        return [_idArray objectAtIndex:[self.theListView indexForItemAtCenterOfBounds]];
    } else
        return nil;
}

- (void)addBottomView {
    NSString *fourthBtnImageStr = [emptystr([[self currIdDict] objectForKey:FEED_ID_TYPE]) isEqualToString:FEED_EVENT_ID] ? @"joinevent" : @"menu_comment";
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", @"menu_repost", @"feed_detail_love_a", fourthBtnImageStr, @"threedot_a", nil];//menu_face
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - kBottomViewHeight, DEVICE_SIZE.width, kBottomViewHeight)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:nil
                                       andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    
    UIButton *loveBtn = (UIButton*)[aView viewWithTag:kTagBottomButton + 2];
    [loveBtn setImage:[UIImage imageNamed:@"feed_detail_love_b"] forState:UIControlStateHighlighted];
    [loveBtn setImage:[UIImage imageNamed:@"feed_detail_love_b"] forState:UIControlStateSelected];
    
    self.bottomView = aView;
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
//    if (_button.tag - kTagBottomButton != 4) {//非表态按钮
//        [self willShowFaceView:NO];
//    }
    switch (_button.tag - kTagBottomButton) {
        case 0://后退
        {
            if ([[Common viewControllerOfView:self.view] isKindOfClass:[ZoneDetailViewController class]]) {
                popAConInView(self.view.superview);//进入某个空间查看时的后退按钮
            }
            else if ([self.navigationController.viewControllers count] <= 1) {//PUSH进来的
                [self.navigationController dismissModalViewControllerAnimated:YES];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];//
            }
            break;
        }
        case 1://转发
        {
            [self pointToCurrPanelView];
            if ([[_panelView.dataDict objectForKey:UID] isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"不能转载自己的东西T_T"];
                return;
            }
            [self rePostBtnPressed:_button];
            break;
        }
        case 2://收藏
        {
            [self uploadRequestToLove];
            break;
        }
        case 3://评论
        {
            [self showCommentInputView:NO];
            break;
        }
        case 4://表情
        {
//            [self willShowFaceView:!_button.selected];
            [self pointToCurrPanelView];
            NSString *desctructiveStr = [MY_UID isEqualToString:_panelView.userId] ? @"删除" : nil;
            UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"分享至..." delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:desctructiveStr otherButtonTitles:@"新浪微博", @"微信好友", @"微信朋友圈", nil];
            [ac showInView:self.view];
            break;
        }
        default:
            break;
    }
}

- (void)showCommentInputView:(BOOL)isReplyAComment {
    isReplyAComment = isReplyAComment ? isReplyAComment : NO;
    self.theInputView.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height - self.theInputView.frame.size.height, .size = self.theInputView.frame.size};
    if (!isReplyAComment && [emptystr([[self currIdDict] objectForKey:FEED_ID_TYPE]) isEqualToString:FEED_EVENT_ID]) {
        _growingTextView.text = @"参与了活动";
    }
    if (isReplyAComment) {
        _growingTextView.placeHolder = $str(@"回复%@:", self.replyWhoseNameStr);
    } else {
        _growingTextView.placeHolder = @"随便说点啥...";
    }
    [_growingTextView becomeFirstResponder];
}

- (void)willShowFaceView:(BOOL)willShow {
    UIButton *faceBtn = (UIButton*)[bottomView viewWithTag:kTagBottomButton + 4];//表态按钮
    faceBtn.selected = willShow;
    //    CGFloat faceViewY = DEVICE_SIZE.height - kBottomViewHeight - kFaceViewHeight;
    
    CGRect faceViewRect = _faceView.frame;
    if (willShow) {
        faceViewRect.origin.y = DEVICE_SIZE.height - kBottomViewHeight - kFaceViewHeight;
    } else
        faceViewRect.origin.y = DEVICE_SIZE.height - kBottomViewHeight;
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         _faceView.frame = faceViewRect;
                         //                             _faceView.frame = (CGRect){.origin.x = 0, .origin.y = faceViewY + kFaceViewHeight, .size = _faceView.frame.size};
                     }];
    
}

- (IBAction)faceBtnForClickPressed:(UIButton*)sender {
    if (![self currIdDict]) {
        return;
    }
    NSArray *clickArray = nil;
    NSString *currIdType = [[self currIdDict] objectForKey:FEED_ID_TYPE];
    if ([currIdType isEqualToString:PHOTO_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_PHOTO_SMILE, CLICK_PHOTO_FUN, CLICK_PHOTO_SUR, CLICK_PHOTO_CRY, CLICK_PHOTO_GOOD, nil];
    } else if ([currIdType isEqualToString:BLOG_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_BLOG_SMILE, CLICK_BLOG_FUN, CLICK_BLOG_SUR, CLICK_BLOG_CRY, CLICK_BLOG_GOOD, nil];
    } else if ([currIdType isEqualToString:EVENT_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_EVENT_SMILE, CLICK_EVENT_FUN, CLICK_EVENT_SUR, CLICK_EVENT_CRY, CLICK_EVENT_GOOD, nil];
    } else if ([currIdType isEqualToString:VIDEO_ID]) {
        clickArray = [[NSArray alloc] initWithObjects:CLICK_VIDEO_SMILE, CLICK_VIDEO_FUN, CLICK_VIDEO_SUR, CLICK_VIDEO_CRY, CLICK_VIDEO_GOOD, nil];
    } else
        [SVProgressHUD showErrorWithStatus:@"暂时不能表态T_T"];
    [self uploadRequestToClickWithId:[clickArray objectAtIndex:sender.tag - kTagBtnOfFace]];
    
    //    switch (sender.tag - kTagBtnOfFace) {
    //        case 0://特么地微笑一下！！！
    //        {
    //            break;
    //        }
    //        case 1://次奥，右眼眯一下！！！
    //        {
    //            break;
    //        }
    //        case 2://我去啊，惊讶！！！
    //        {
    //            break;
    //        }
    //        case 3://尼玛，哭了啊！！！
    //        {
    //            break;
    //        }
    //        case 4://老子赞一下！！！
    //        {
    //            break;
    //        }
    //        default:
    //            break;
    //    }
}

- (void)uploadRequestToClickWithId:(NSString*)clickId {
    if (![self currIdDict]) {
        return;
    }
    [MPNotificationView notifyWithText:@"表态中..." detail:nil andDuration:0.5f];
//    [SVProgressHUD showWithStatus:@"表态中..."];
    NSString *url = $str(@"%@click&op=add", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self currIdDict] objectForKey:FEED_ID], ID, [[self currIdDict] objectForKey:FEED_ID_TYPE], FEED_ID_TYPE, clickId, CLICK_ID, IPHONE, COME, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [MPNotificationView notifyWithText:[dict objectForKey:WEB_MSG] detail:nil andDuration:0.5f];
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"表态成功" detail:nil andDuration:0.5f];
//        [SVProgressHUD showSuccessWithStatus:@"表态成功"];
        [self willShowFaceView:NO];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [MPNotificationView notifyWithText:@"表态失败T_T" detail:nil andDuration:0.5f];
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//- (void)sendRequestToGetFaceType:(id)sender {
//    [SVProgressHUD showErrorWithStatus:@"获取表情中..."];
//    NSString *url = $str(@"%@space.php?ac=click&op=clicktype&idtype=%@&m_auth=%@", BASE_URL, _idType, [MY_M_AUTH urlencode]);
//    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
//        [self stopLoading:sender];
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        [SVProgressHUD dismiss];
//        [_faceArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
//
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        NSLog(@"error:%@", [error description]);
//    }];
//}


#pragma mark - 上行接口
- (void)uploadRequestToLove {
    if (![self currIdDict]) {
        return;
    }
    UIButton *loveBtn = (UIButton*)[bottomView viewWithTag:kTagBottomButton + 2];
    BOOL hasLoved = loveBtn.selected;//1为我已收藏，0为我未收藏
    
    NSString *tips1 = hasLoved ? @"取消收藏中..." : @"收藏中...";
    [MPNotificationView notifyWithText:tips1 detail:nil andDuration:0.5f];
//    [SVProgressHUD showWithStatus:tips1];
    NSString *url = $str(@"%@feedlove", POST_API);
    NSDictionary *idDict = [self currIdDict];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[idDict objectForKey:FEED_ID], ID, [idDict objectForKey:FEED_ID_TYPE], FEED_ID_TYPE, $str(@"%d", !hasLoved), TYPE, MY_M_AUTH, M_AUTH, nil];
//    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedId, ID, _idType, FEED_ID_TYPE, $str(@"%d", !hasLoved), TYPE, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tips2 = hasLoved ? @"取消收藏成功" : @"收藏成功";
        [MPNotificationView notifyWithText:tips2 detail:nil andDuration:0.5f];
//        [SVProgressHUD showSuccessWithStatus:tips2];
        
        loveBtn.selected = !loveBtn.selected;
        
        //更新动态列表的收藏状态
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:[NSNumber numberWithBool:loveBtn.selected] forKey:MY_LOVE];
        [aDict setObject:[NSNumber numberWithInt:_indexRow] forKey:@"indexRow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LOVE_NUM object:aDict];
        
        //更新当前页面上面的评论数目
        [self pointToCurrPanelView];
        int num = loveBtn.selected ? 1 : -1;
        NSString *loveNum = $str(@"%d", [emptystr([_panelView.dataDict objectForKey:FEED_LOVE_NUM]) intValue] + num);
        _panelView.dataDict = [_panelView.dataDict changeForKey:FEED_LOVE_NUM withValue:loveNum];
        [_panelView.pullTable reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        NSString *tips2 = hasLoved ? @"取消收藏失败T_T" : @"收藏失败T_T";
        [MPNotificationView notifyWithText:tips2 detail:nil andDuration:0.5f];
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)uploadRequestToCommentOrJoinEvent:(NSMutableDictionary*)para withCommentText:(NSString*)msg {
//    NSString *tipsStr = @"发送中...";//isCommentCell ? @"发送评论中..." : @"参与活动中...";
    [MPNotificationView notifyWithText:@"发送评论中..." detail:nil andDuration:0.5f];
    [self hideInputView:nil];
//    [SVProgressHUD showWithStatus:tipsStr];
    NSString *url = $str(@"%@comment", POST_API);
    
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"评论成功" detail:nil andDuration:0.5f];
        [SVProgressHUD dismiss];
        //        if (isCommentCell) {
        
        _growingTextView.text = @"";
        self.replyWhoseNameStr = nil;
        
        //更新动态列表的评论数据
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:MY_UID forKey:COMMENT_AUTHOR_ID];
        [aDict setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:DATELINE];
        [aDict setObject:msg forKey:MESSAGE];
        [aDict setObject:MY_NAME forKey:COMMENT_AUTHOR_NAME];
        [aDict setObject:[NSNumber numberWithInt:_indexRow] forKey:@"indexRow"];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LIST object:aDict];
        
        //更新当前页面的评论列表
        [self pointToCurrPanelView];
        [aDict setObject:MY_HEAD_AVATAR_URL forKey:AVATAR];
        [_panelView.dataArray insertObject:aDict atIndex:0];
//        [_panelView.pullTable reloadData];
        
//        //更新当前页面上面的转发数目
//        NSString *rePostNumStr = _panelView.idType;
//        rePostNumStr = [rePostNumStr stringByReplacingOccurrencesOfString:@"id" withString:@"num"];
//        rePostNumStr = $str(@"re%@", rePostNumStr);
//        NSString *rePostNum = $str(@"%d", [emptystr([_panelView.dataDict objectForKey:rePostNumStr]) intValue] + 1);
//        _panelView.dataDict = [_panelView.dataDict changeForKey:rePostNumStr withValue:rePostNum];
//        [_panelView.pullTable reloadData];
        
        //更新当前页面上面的评论数目
        NSString *replyNum = $str(@"%d", [emptystr([_panelView.dataDict objectForKey:FEED_REPLY_NUM]) intValue] + 1);
        _panelView.dataDict = [_panelView.dataDict changeForKey:FEED_REPLY_NUM withValue:replyNum];
        [_panelView.pullTable reloadData];
        
//        [self hideInputView:nil];
        
        //        } else
        //            [self sendRequestToDetail:_tableView];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [MPNotificationView notifyWithText:@"评论失败T_T" detail:nil andDuration:0.5f];
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)rePostBtnPressed:(UIButton*)sender {
    if (![self currIdDict]) {
        return;
    }
    NSDictionary *idDict = [self currIdDict];
    if ([[idDict objectForKey:FEED_ID_TYPE] isEqualToString:FEED_EVENT_ID]) {
        [SVProgressHUD showErrorWithStatus:@"活动不能转载T_T"];
        return;
    }
    if ([[idDict objectForKey:FEED_ID_TYPE] isEqualToString:FEED_VIDEO_ID]) {
        [SVProgressHUD showErrorWithStatus:@"视频不能转载T_T"];
        return;
    }
    [self pointToCurrPanelView];
    if (_panelView.dataDict) {
//#warning 后退会出现空白页面
        PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
//        PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
        con.shouldAddDefaultImage = YES;
        con.dataDict = _panelView.dataDict;// [[PlistManager readPlist:PLIST_FEED_TOP_DATA] objectForKey:$str(@"%d", currItemIndex)];
        con.idType = [idDict objectForKey:FEED_ID_TYPE];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
        nav.navigationBarHidden = YES;
        [self presentModalViewController:nav animated:YES];
    }
}

#pragma mark - my method(s)

//#pragma mark - webview delegate
////webview委托   高度自适应
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //    NSString *width = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetWidth;"];
//    //    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//    
//    CGSize actualSize = [webView sizeThatFits:CGSizeMake(290, MAXFLOAT)];
//    CGRect theFrame = webView.frame;
//    theFrame.size.height = actualSize.height;
//    webView.frame = theFrame;
//    _hasLoaded = YES;
//    [self pointToCurrPanelView];
//    [_panelView.pullTable reloadData];
////    [_tableView reloadData];
//}

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

#pragma mark - ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
//    NSLog(@"destruct:%d", actionSheet.destructiveButtonIndex);
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //@"删除"
        [self pointToCurrPanelView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:@""];
        [alert setCancelButtonWithTitle:@"取消" handler:^{
            ;
        }];
        [alert addButtonWithTitle:@"删除" handler:^{
            NSString *deleteTypeStr = [_panelView.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"delete", OP, _panelView.feedId, deleteTypeStr, ONE, DELETE_SUBMIT, MY_M_AUTH, M_AUTH, nil];
            [self uploadRequestToDeleteWithPara:para];
        }];
        [alert show];
        return;
    }
    switch (buttonIndex - 1 - actionSheet.destructiveButtonIndex) {
        case 0://新浪微博
        {
            SinaWeibo *sinaweibo = [self sinaweibo];
            if (MY_HAS_BIND_SINA_WEIBO && sinaweibo.isAuthValid && !sinaweibo.isAuthorizeExpired) {
                MyYIPopupTextView *popupTextView = [[MyYIPopupTextView alloc] initWithMaxCount:140];
                popupTextView.delegate = self;
                [popupTextView showInView:self.view];
                [self pointToCurrPanelView];
                NSString *idType = [_panelView.idType stringByReplacingOccurrencesOfString:@"id" withString:@""];
                popupTextView.text = [NSString stringWithFormat:@"%@（来自@Family社区）", emptystr([_panelView.dataDict objectForKey:SUBJECT])];
                [popupTextView.acceptButton whenTapped:^{
                    [MPNotificationView notifyWithText:@"分享中..." detail:nil andDuration:0.5f];
                    NSString *postText = [NSString stringWithFormat:@"%@ http://familyday.com.cn/space.php?do=%@&uid=%@&id=%@（来自@Family社区）", emptystr([_panelView.dataDict objectForKey:SUBJECT]), idType, _panelView.userId, _panelView.feedId];
                    [self sendToSinaWeiboWithText:postText];
                    [popupTextView dismiss];
                }];
            } else {
                [self loginSinaWeibo];
            }
            break;
        }
        case 1: case 2://1:微信好友 //2:微信朋友圈
        {
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                _scene = buttonIndex == 1 ? WXSceneSession : WXSceneTimeline;
                [self sendContent];
            } else {
                UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"" message:@"你的iPhone上还没有安装微信，无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"];
                [alView setCancelButtonWithTitle:@"取消" handler:^{
                    return ;
                }];
                [alView addButtonWithTitle:@"免费下载微信" handler:^{
                    NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
                }];
                [alView show];
            }
            break;
        }
        default:
            break;
    }
}

//删除帖子的接口
#pragma mark - 删除帖子的接口
- (void)uploadRequestToDeleteWithPara:(NSMutableDictionary*)para {
    NSString *tipsStr = @"删除中...";//isCommentCell ? @"发送评论中..." : @"参与活动中...";
    [SVProgressHUD showWithStatus:tipsStr];
    [self pointToCurrPanelView];
    NSString *acStr = [_panelView.idType stringByReplacingOccurrencesOfString:@"re" withString:@""];
    acStr = [acStr stringByReplacingOccurrencesOfString:@"id" withString:@""];
    NSString *url = $str(@"%@%@", POST_CP_API, acStr);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            popAConInView(self);
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        if (!_isFromZone) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_FEED_LIST_FOR_DELETE object:[NSNumber numberWithInt:_panelView.indexRowInFeedList]];
            [self.navigationController popViewControllerAnimated:YES];
//            FeedDetailViewController *con = (FeedDetailViewController*)[Common viewControllerOfView:self];
//            [con.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

#pragma mark - sina weibo
- (void)sendToSinaWeiboWithText:(NSString*)text {
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

- (void)loginSinaWeibo {
    SinaWeibo *sinaweibo = [self sinaweibo];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) {
        [sinaweibo logOut];
    } else {
        [sinaweibo logIn];
    }
}

- (SinaWeibo *)sinaweibo
{
    [AppDelegate app].sinaweibo.delegate = self;
    return [AppDelegate app].sinaweibo;
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SINA_AUTH_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
}
#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_BIND_SINA_WEIBO];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    [self uploadRequestToBindSinaWeibo];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
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

#pragma mark - 微信
- (void)sendContent {
    //发送新闻
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"Family社区";
    [self pointToCurrPanelView];
    message.description = emptystr([_panelView.dataDict objectForKey:SUBJECT]);
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iTunesArtwork" ofType:@"png"]];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.4f)];//SDK协议中对缩略图的大小作了限制，大小不能超过32K
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"http://www.familyday.com.cn/wx/wx.php?do=detail&id=%@&uid=%@&idtype=%@&wxkey=orfjpjjq5v7t-wfzga0gECo6cIcU", _panelView.feedId, _panelView.userId, _panelView.idType];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

#pragma mark - JTListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    return [_idArray count];
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    MyPanelView *panel = (MyPanelView*)[listView dequeueReusableView];
    
    if (!panel) {
        panel = [[MyPanelView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height - kBottomViewHeight)];
        panel.backgroundColor = bgColor();
        [panel addPullTableView];
    }
    panel.pullTable.touchDelegate = self;
    
    if (index == 0) {
        self.goBackBtn.hidden = YES;
    } else
        self.goBackBtn.hidden = NO;
    if (index == _allFeedNum - 1) {
        self.goForwardBtn.hidden = YES;
    } else
        self.goForwardBtn.hidden = NO;
    if (!_isFromZone) {
        panel.indexRowInFeedList = _indexRow;
    }
//    panel.delegate = self;
    panel.indexRow = index;
    panel.isFromZone = _isFromZone;
    [self performBlock:^(id sender) {
        if ([_idArray count] > 0) {
            
            if (panel.dataDict) {
                panel.dataDict = nil;
            }
            if ([panel.dataArray count] > 0) {
                [panel.dataArray removeAllObjects];
            }
            [panel.pullTable reloadData];
        }
    } afterDelay:0.1f];
    
    [self performBlock:^(id sender) {
        if ([_idArray count] > 0) {
            NSDictionary *idDict = [_idArray objectAtIndex:index];
            panel.idType = [idDict objectForKey:FEED_ID_TYPE];
            panel.feedId = [idDict objectForKey:FEED_ID];
            panel.feedCommentId = [idDict objectForKey:FEED_COMMENT_ID];
            panel.userId = [idDict objectForKey:UID];
            
            if ([PlistManager isPlistFileExists:PLIST_FEED_TOP_DATA] && [[PlistManager readPlist:PLIST_FEED_TOP_DATA] objectForKey:panel.feedId]) {
                panel.dataDict = [[PlistManager readPlist:PLIST_FEED_TOP_DATA] objectForKey:panel.feedId];
                [panel fillDataForDetail];
                [panel stopLoading:panel.pullTable];
                [panel.pullTable reloadData];
            } else {
                [panel sendRequestToDetail:panel.pullTable];
            }
            
            if ([PlistManager isPlistFileExists:PLIST_FEED_COMMENT] && [[PlistManager readPlist:PLIST_FEED_COMMENT] objectForKey:panel.feedId]) {
                [panel.dataArray addObjectsFromArray:[[[PlistManager readPlist:PLIST_FEED_COMMENT] objectForKey:panel.feedId] objectForKey:COMMENT]];
                [panel stopLoading:panel.pullTable];
                [panel.pullTable reloadData];
            } else {
                [panel sendRequestToComment:panel.pullTable];
            }
        }
    } afterDelay:0.3];
    return panel;
}


#pragma mark - JTListViewDelegate
- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return (CGFloat)DEVICE_SIZE.width;
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return (CGFloat)DEVICE_SIZE.height - kBottomViewHeight;
}

//- (void)listView:(JTListView *)listView willDisplayView:(UIView *)view forItemAtIndex:(NSUInteger)index {
//    MyPanelView *panel = (MyPanelView*)view;
//    if ([_idArray count] > 0) {
//        
//        NSDictionary *idDict = [_idArray objectAtIndex:index];
//        panel.idType = [idDict objectForKey:FEED_ID_TYPE];
//        panel.feedId = [idDict objectForKey:FEED_ID];
//        panel.feedCommentId = [idDict objectForKey:FEED_COMMENT_ID];
//        panel.userId = [idDict objectForKey:UID];
//        
//        if ([PlistManager isPlistFileExists:PLIST_FEED_TOP_DATA] && [[PlistManager readPlist:PLIST_FEED_TOP_DATA] objectForKey:panel.feedId]) {
//            panel.dataDict = [[PlistManager readPlist:PLIST_FEED_TOP_DATA] objectForKey:panel.feedId];
//            [panel fillDataForDetail];
//            [panel stopLoading:panel.pullTable];
//            [panel.pullTable reloadData];
//        } else {
//            [panel sendRequestToDetail:panel.pullTable];
//        }
//        
//        if ([PlistManager isPlistFileExists:PLIST_FEED_COMMENT] && [[PlistManager readPlist:PLIST_FEED_COMMENT] objectForKey:panel.feedId]) {
//            [panel.dataArray addObjectsFromArray:[[[PlistManager readPlist:PLIST_FEED_COMMENT] objectForKey:panel.feedId] objectForKey:COMMENT]];
//            [panel stopLoading:panel.pullTable];
//            [panel.pullTable reloadData];
//        } else {
//            [panel sendRequestToComment:panel.pullTable];
//        }
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_idArray count] <= 0) {
        return;
    }
    NSUInteger currItemIndex = [_theListView indexForItemAtCenterOfBounds];
    
    if (currItemIndex == 0) {
        self.goBackBtn.hidden = YES;
    } else
        self.goBackBtn.hidden = NO;
    if (currItemIndex == _allFeedNum - 1) {
        self.goForwardBtn.hidden = YES;
    } else
        self.goForwardBtn.hidden = NO;
    
    UIButton *commentBtn = (UIButton*)[self.bottomView viewWithTag:kTagBottomButton + 3];
    
    NSString *fourthBtnImageStr = [[[_idArray objectAtIndex:currItemIndex] objectForKey:FEED_ID_TYPE] isEqualToString:FEED_EVENT_ID] ? @"joinevent" : @"menu_comment";
    [commentBtn setImage:[UIImage imageNamed:fourthBtnImageStr] forState:UIControlStateNormal];
    
    if ([_idArray count] >= kFirstShowNumForZone && [_idArray count] < _allFeedNum && currItemIndex > ([_idArray count] / 2 - 1)) {
        [self sendRequestToGetIdArrayFromTagId];
    }
    if (currItemIndex >= _allFeedNum) {
        [SVProgressHUD showSuccessWithStatus:@"已经是最后一篇了"];
    }
}

#pragma mark - MyPanelView delegate
//- (void)sendRequestForTableViewInMyPanelView:(id)sender {
//    [self performBlock:^(id sender) {
////        [self sendRequest:sender];
//    } afterDelay:0.3f];
//}

#pragma mark - go back or forward button
- (IBAction)goBackBtnPressed:(id)sender {
    [self.theListView goBack:YES];
    [self scrollViewDidEndDecelerating:self.theListView];
}

- (IBAction)goForwardBtnPressed:(id)sender {
    [self.theListView goForward:YES];
    [self scrollViewDidEndDecelerating:self.theListView];
}


@end
