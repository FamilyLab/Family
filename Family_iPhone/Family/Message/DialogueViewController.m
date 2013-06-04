//
//  DialogueViewController.m
//  Family
//
//  Created by Aevitx on 13-1-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DialogueViewController.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "SSLoadingView.h"
#import "UIView+BlocksKit.h"
//#import "UIButton+WebCache.h"
#import "Common.h"
#import "FamilyCardViewController.h"
#import "MessageViewController.h"

@interface DialogueViewController ()

@end

@implementation DialogueViewController
@synthesize bubbleTable, cellHeader, theInputView, bubbleData, dataArray;//, theTextView, theBgTextView;
@synthesize topView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 1;
        isFirstShow = YES;
        isFromPushWhenAppNotStart = NO;
        _isLastRequestFinished = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self buildGrowingTextView];
    
    [cellHeader initHeaderDataWithMiddleLblText:@"对话记录"];
    
    dataArray = [[NSMutableArray alloc] init];
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 30;
    bubbleTable.showAvatars = YES;
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    [self sendRequest:bubbleTable];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_FOR_DIALOG_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushForDialog:) name:PUSH_FOR_DIALOG_DETAIL object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_FOR_DIALOG_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_FOR_DIALOG_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *aView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    aView.topViewType = loginOrSignIn;
    [aView leftHeadAndName];
    [aView.leftHeadBtn addTarget:self action:@selector(topViewHeadBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aView rightLblAndImgStr:@"time.png"];
    self.topView = aView;
    [self.view addSubview:topView];
    
//    [self.topView.leftHeadBtn setImage:[UIImage imageNamed:@"head_70.png"] forState:UIControlStateNormal];//假数据
//    self.topView.leftNameLbl.text = @"杜拉拉";//假数据
//    self.topView.rightLbl.text = @"1小时前";//假数据
    self.topView.leftNameLbl.frame = (CGRect){.origin.x = self.topView.leftHeadBtn.frame.origin.x + self.topView.leftHeadBtn.frame.size.width + 5, .origin.y = self.topView.leftHeadBtn.frame.origin.y, .size = self.topView.leftNameLbl.frame.size};
    self.topView.leftNameLbl.textAlignment = UITextAlignmentLeft;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    self.topView.leftNameLbl.textAlignment = UITextAlignmentLeft;
//#else
//    self.topView.leftNameLbl.textAlignment = NSTextAlignmentLeft;
//#endif
    self.topView.rightLbl.font = [UIFont boldSystemFontOfSize:13.0f];
}

- (void)topViewHeadBtnPressed:(id)sender {
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.isMyFamily = YES;
    con.userId = self.toUserId;
    [self.navigationController pushViewController:con animated:YES];
}

//////////////////////////////////////自动拉伸度度 start////////////////////////////////////////////////////

- (void)buildGrowingTextView {
    // Keyboard events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.theInputView.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height - self.theInputView.frame.size.height, .size = self.theInputView.frame.size};
//    self.theInputViewY = self.theInputView.frame.origin.y;
    
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
    
	CGRect r = theInputView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	theInputView.frame = r;
    
    CGRect bubbleFrame = bubbleTable.frame;
    bubbleFrame.size.height += diff;
	bubbleTable.frame = bubbleFrame;
    [self scrollToBottomWithAnimation:YES];
    
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
    
	CGRect inputViewFrame = theInputView.frame;
    inputViewFrame.origin.y = DEVICE_SIZE.height - kbSize.height - inputViewFrame.size.height;
    
	CGRect bubbleFrame = bubbleTable.frame;
    bubbleFrame.size.height = DEVICE_SIZE.height - bubbleTable.frame.origin.y - inputViewFrame.size.height - kbSize.height;
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        theInputView.frame = inputViewFrame;
        bubbleTable.frame = bubbleFrame;
        if ([bubbleData count] > 0) {
            [self scrollToBottomWithAnimation:NO];
        }
    }];
    
    [bubbleTable whenTapped:^{
        if ([_growingTextView isFirstResponder]) {
            [_growingTextView resignFirstResponder];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
	CGRect inputViewFrame = theInputView.frame;
    inputViewFrame.origin.y = DEVICE_SIZE.height - inputViewFrame.size.height;
    
	CGRect bubbleFrame = bubbleTable.frame;
    bubbleFrame.size.height = DEVICE_SIZE.height - bubbleTable.frame.origin.y - inputViewFrame.size.height;
    
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        theInputView.frame = inputViewFrame;
        bubbleTable.frame = bubbleFrame;
    }];
    for (id obj in bubbleTable.gestureRecognizers) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *ges = (UITapGestureRecognizer*)obj;
            [bubbleTable removeGestureRecognizer:ges];
        }
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    return YES;
}

/////////////////////////////////////自动拉伸度度 end////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (isFirstShow) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
}

- (void)sendRequest:(id)sender {
//    if (isFirstShow) {
////        [self.mbHud show:YES];
//        [SVProgressHUD showWithStatus:@"加载中..."];
//    }
    NSString *url = @"";
    if (!isFromPushWhenAppNotStart) {
        NSString *endDateline = [dataArray count] > 0 ? emptystr([[dataArray objectAtIndex:0] objectForKey:DATELINE]) : @"";
        url = $str(@"%@space.php?do=pm&subop=view&m_auth=%@&touid=%@&perpage=10&endtime=%@", BASE_URL, [MY_M_AUTH urlencode], _toUserId, endDateline);
    } else {
//        NSString *startDateLine = [dataArray count] > 0 ? $str(@"%d", [emptystr([[dataArray objectAtIndex:[dataArray count] - 1] objectForKey:DATELINE]) intValue] + 1) : @"";
        NSString *startDateLine = [dataArray count] > 0 ? emptystr([[dataArray objectAtIndex:[dataArray count] - 1] objectForKey:DATELINE]) : @"";
        NSString *endDateline = $str(@"%f", [[NSDate date] timeIntervalSince1970]);
        url = $str(@"%@space.php?do=pm&subop=view&m_auth=%@&touid=%@&perpage=10&starttime=%@&endtime=%@", BASE_URL, [MY_M_AUTH urlencode], _toUserId, startDateLine, endDateline);
    }
    
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        bubbleTable.isLoaing = NO;
        self.isLastRequestFinished = YES;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            self.mbHud.labelText = [dict objectForKey:WEB_MSG];
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            [self.mbHud hide:NO];
            return ;
        }
        if (![[dict objectForKey:WEB_DATA] objectForKey:DIALOG] || [[[dict objectForKey:WEB_DATA] objectForKey:DIALOG] isEqual:[NSNull null]] || [[dict objectForKey:WEB_DATA] count] <= 0) {
            
//            [SVProgressHUD showSuccessWithStatus:@"没有更多对话了T_T"];
            return;
        }
        if (!isFromPushWhenAppNotStart) {//推送的不需要remove掉，不是推送的才要remove掉
            [dataArray removeAllObjects];
        }
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:DIALOG]];
        if ([dataArray count] > 0) {
            
            NSDictionary *fromDict = [[dict objectForKey:WEB_DATA] objectForKey:PM_FROM_USER];
            if (isFirstShow) {
                NSDictionary *toDict = [[dict objectForKey:WEB_DATA] objectForKey:PM_TO_USER];
                
                self.fromUserId = [fromDict objectForKey:UID];
                self.fromHeadStr = [fromDict objectForKey:AVATAR];
                self.toHeadStr = [toDict objectForKey:AVATAR];
                
                self.fromVipStatus = [fromDict objectForKey:VIP_STATUS];
                self.toVipStatus = [toDict objectForKey:VIP_STATUS];
                
                [self.topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:self.toHeadStr plcaholderImageStr:nil];
                [self.topView.leftHeadBtn setVipStatusWithStr:emptystr(self.toVipStatus) isSmallHead:YES];
                
                self.topView.leftNameLbl.text = [toDict objectForKey:NAME];
            }
            self.topView.rightLbl.text = [Common dateSinceNow:[fromDict objectForKey:LAST_MSG_TIME]];
            [topView setNeedsLayout];
            
            [self addBubbleData];
            if (isFirstShow) {
                [self scrollToBottomWithAnimation:NO];
                [SVProgressHUD dismiss];
//                [self.mbHud hide:YES];
            }
            if (isFromPushWhenAppNotStart) {
                [self scrollToBottomWithAnimation:YES];
                isFromPushWhenAppNotStart = NO;
            }
            isFirstShow = NO;
        } else {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多对话了T_T"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_TALK_LIST_READ_STATE object:[NSNumber numberWithInt:_indexRow]];
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        bubbleTable.isLoaing = NO;
        self.isLastRequestFinished = YES;
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        self.mbHud.labelText = @"网络不好TT_T";
//        [self.mbHud hide:YES afterDelay:1.0f];
        currentPage--;//刚开始进入详情时，currentPage为1，如果网络不好，用户此时再下拉加载的话，仍需要从第1页加载；已经进入详情后，currentPage>1了，如果网络不好，用户此时再下拉加载的话，因为currentPage已经加1了，所以需要将currentPage减1
        isFromPushWhenAppNotStart = NO;
    }];
}

- (void)addBubbleData {
    NSBubbleType bubbleType;
    int fuckNum = isFromPushWhenAppNotStart ? [dataArray count] - 1 : 0;
    for (int i = [dataArray count] - 1; i >= fuckNum; i--) {
        if ([[[dataArray objectAtIndex:i] objectForKey:PM_FROM_UID] isEqualToString:_toUserId]) {
            bubbleType = BubbleTypeSomeoneElse;
        } else {
            bubbleType = BubbleTypeMine;
        }
        NSBubbleData *tmp = [NSBubbleData dataWithText:[[dataArray objectAtIndex:i] objectForKey:MESSAGE] date:[NSDate dateWithTimeIntervalSince1970:[[[dataArray objectAtIndex:i] objectForKey:DATELINE] doubleValue]] type:bubbleType];
//        tmp.avatar = [UIImage imageNamed:@"head_70.png"];
//        tmp.userId = [[dataArray objectAtIndex:i] objectForKey:NOTICE_AUTHOR_ID];
        tmp.userId = bubbleType == BubbleTypeMine ? [[dataArray objectAtIndex:i] objectForKey:PM_FROM_UID] : self.toUserId;
        tmp.headStr = bubbleType == BubbleTypeMine ? self.fromHeadStr : self.toHeadStr;
        tmp.vipStatus = bubbleType == BubbleTypeMine ? emptystr(self.fromVipStatus) : emptystr(self.toVipStatus);
        [bubbleData insertObject:tmp atIndex:0];
    }
    [bubbleTable reloadData];
}

#pragma mark - UIBubbleTableViewDataSource implementation
#pragma mark -
#pragma mark Table view data source
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

- (void)addMoreDataOnTop:(UIBubbleTableView *)tableview {
    if (tableview == bubbleTable) {
        currentPage++;
        if (_isLastRequestFinished) {
            self.isLastRequestFinished = NO;
            [self sendRequest:bubbleTable];
        }
    }
}

#pragma mark - Actions
- (void)scrollToBottomWithAnimation:(BOOL)_animation {
//    NSUInteger rowCount = [bubbleData count];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:rowCount - 1];
    
    int rowOfLastSection = [[bubbleTable.bubbleSection objectAtIndex:[bubbleTable.bubbleSection count] - 1] count] + 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowOfLastSection - 1 inSection:[bubbleTable.bubbleSection count] - 1];
    
    [self.bubbleTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:_animation];
}

- (IBAction)backBtnPressed:(id)sender {
    if ([self.navigationController.viewControllers count] <= 1 ) {//推送过来时的
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendTextBtnPressed:(id)sender {
    [self sendText];
}

- (void)sendText {
    if (![_growingTextView hasText]) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"发送中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_toUserId, PM_TO_UID, _growingTextView.text, MESSAGE, IPHONE, COME, @"1", PM_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    NSString *url = $str(@"%@pm&op=send", POST_CP_API);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        NSBubbleData *sayBubble = [NSBubbleData dataWithText:_growingTextView.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
        sayBubble.userId = self.fromUserId;
        sayBubble.headStr = self.fromHeadStr;
        sayBubble.vipStatus = emptystr(self.fromVipStatus);
        [bubbleData addObject:sayBubble];
        [bubbleTable reloadData];
        
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [tmpDict setObject:MY_UID forKey:PM_FROM_UID];
        [tmpDict setObject:self.toUserId forKey:PM_TO_UID];
        [tmpDict setObject:_growingTextView.text forKey:MESSAGE];
        [tmpDict setObject:$str(@"%f", [[NSDate date] timeIntervalSince1970]) forKey:DATELINE];
        [tmpDict setObject:IPHONE forKey:COME];
        [dataArray addObject:tmpDict];
        
        _growingTextView.text = @"";
        
        [self scrollToBottomWithAnimation:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

#pragma mark - get push
- (void)getPushForDialog:(NSNotification*)noti {
    NSDictionary *userInfo = [noti object];
    if ([$str(@"%d", [[userInfo objectForKey:UID] intValue]) isEqualToString:self.toUserId]) {
        isFromPushWhenAppNotStart = YES;
        [self sendRequest:bubbleData];
    }
}


@end
