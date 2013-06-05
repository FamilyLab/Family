//
//  DialogueViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "DialogueViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "UIView+BlocksKit.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "UIButton+WebCache.h"
#import "Common.h"
@interface DialogueViewController ()

@end

@implementation DialogueViewController
@synthesize bubbleTable,theInputView, bubbleData, dataArray;

- (IBAction)backAction:(id)sender
{
    [[AppDelegate instance].rootViewController.stackScrollViewController removeThirdView];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 1;
        isFirstShow = YES;
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)swipeToDismiss:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.height, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self backAction:nil];
        
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //swipe
    _growingTextView.font = [UIFont fontWithName:@"Helvetica" size:19.0f];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    dataArray = [[NSMutableArray alloc] init];
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 0;
    bubbleTable.showAvatars = YES;
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    [self sendRequest:bubbleTable];
    
    [bubbleTable whenTapped:^{
        if ([_growingTextView isFirstResponder]) {
            [_growingTextView resignFirstResponder];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//#pragma mark - UIBubbleTableViewDataSource implementation
//
//- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
//{
//    return [bubbleData count];
//}
//
//- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
//{
//    return [bubbleData objectAtIndex:row];
//}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    kbSize = [[theInputView superview] convertRect:kbSize fromView:nil];
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = theInputView.frame;
        frame.origin.y -= kbSize.size.height;
        theInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.size.height;
        bubbleTable.frame = frame;
        
    }completion:^(BOOL finished) {
        [bubbleTable setContentOffset:CGPointMake(0, bubbleTable.contentSize.height - bubbleTable.frame.size.height)];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbSize = [[theInputView superview] convertRect:kbSize fromView:nil];

    [UIView animateWithDuration:0.5f animations:^{
        
        CGRect frame = theInputView.frame;
        frame.origin.y += kbSize.size.height;
        theInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.size
        .height;
        bubbleTable.frame = frame;
    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:_growingTextView.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    _growingTextView.text = @"";
    [_growingTextView resignFirstResponder];
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendText];
        return NO;
    }
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(id)sender {
    if (isFirstShow) {
    }
    NSString *url = $str(@"%@space.php?do=pm&subop=view&m_auth=%@&touid=%@&page=%d&perpage=10", BASE_URL, GET_M_AUTH, _toUserId, currentPage);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        bubbleTable.isLoaing = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if ([[dict objectForKey:WEB_DATA] count] <=0||![[[dict objectForKey:WEB_DATA] objectForKey:DIALOG]isKindOfClass:[NSArray class]]) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多对话了了T_T"];
            return;
        }
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:DIALOG]];
        if ([dataArray count] > 0) {
            
            NSDictionary *fromDict = [[dict objectForKey:WEB_DATA] objectForKey:PM_FROM_USER];
            NSDictionary *toDict = [[dict objectForKey:WEB_DATA] objectForKey:PM_TO_USER];
            
            self.fromUserId = [fromDict objectForKey:UID];
            self.fromHeadStr = [fromDict objectForKey:AVATER];
            self.toHeadStr = [toDict objectForKey:AVATER];
            
            [self.topView.avatarButton setImageForMyHeadButtonWithUrlStr:self.toHeadStr plcaholderImageStr:@"head_110.png" size:MIDDLE];
            self.topView.titleLabel.text = $safe([toDict objectForKey:NAME]);
            [self.topView.timeLabel fillWithPointInImgAndLblView:CGPointMake(378, 34) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[fromDict objectForKey:LAST_MSG_TIME]] withFont:[UIFont boldSystemFontOfSize:FONT_SIZE] withTextColor:[UIColor lightGrayColor]];
            [self addBubbleData];
            if (isFirstShow) {
                [self scrollToBottomWithAnimation:NO];
                [SVProgressHUD dismiss];
            }
            isFirstShow = NO;
        } else
            [SVProgressHUD showSuccessWithStatus:@"没有更多对话了T_T"];
    } failure:^(NSError *error) {
        bubbleTable.isLoaing = NO;
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        currentPage--;//刚开始进入详情时，currentPage为1，如果网络不好，用户此时再下拉加载的话，仍需要从第1页加载；已经进入详情后，currentPage>1了，如果网络不好，用户此时再下拉加载的话，因为currentPage已经加1了，所以需要将currentPage减1
    }];
}

- (void)addBubbleData {
    NSBubbleType bubbleType;
    for (int i=[dataArray count] - 1; i>=0; i--) {
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
        [self sendRequest:bubbleTable];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)faceBtnPressed:(id)sender {
    [self sendText];//tmp
}

- (void)sendText {
    if (![_growingTextView hasText]) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"发送中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_toUserId, PM_TO_UID, _growingTextView.text, MESSAGE, COME_VERSION, COME, @"1", PM_SUBMIT, POST_M_AUTH, M_AUTH, nil];
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
        [bubbleData addObject:sayBubble];
        [bubbleTable reloadData];
        
        _growingTextView.text = @"";
        
        [self scrollToBottomWithAnimation:YES];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
@end
