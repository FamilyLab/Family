//
//  DialogueDetailViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "DialogueDetailViewController.h"
#import "TopBarView.h"
#import "NSBubbleData.h"
#import "FamilyCardViewController.h"
#import "SBToolKit.h"

@interface DialogueDetailViewController ()

@end

@implementation DialogueDetailViewController
@synthesize bubbleTableView;
@synthesize containView;
@synthesize backBtn;
@synthesize faceBtn;
@synthesize theTextView;
@synthesize speakerLbl;
@synthesize theTextViewImg;
@synthesize bgImageView;
@synthesize PMId, toUserId,toHeadStr, fromHeadStr,fromUserId, bubbleData, dataArray;
        
#define the_X                         0

#define the_Y                         391//346
#define the_Y_iPhone5                 454

#define theWidth                      320
#define theHeight                     49                   

#define theTextView_X                 45

#define theTextView_Y                 396//351
#define theTextView_Y_iPhone5         459

#define theTextView_Width             230
#define theTextView_Height            40


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
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    
    [self setTopbarView];
    [self setBottomBarView];
    [self initViewController];
    [self addToolbarOnTopOfTextView];
    
    [self performSelector:@selector(sendRequestToDialogueDetail) withObject:nil afterDelay:0.1f];
}

-(void)initViewController
{
    containView.frame = CGRectMake(0, 40, DEVICE_SIZE.width, DEVICE_SIZE.height - 40);
    CGFloat f= containView.frame.size.height;
    bubbleTableView.frame = CGRectMake(0, 5, DEVICE_SIZE.width, f - 49 - 5);
    
    theTextView.frame = iPhone5 ? CGRectMake(theTextView_X, theTextView_Y_iPhone5, theTextView_Width, theTextView_Height) : CGRectMake(theTextView_X, theTextView_Y, theTextView_Width, theTextView_Height);
    theTextViewImg.frame = iPhone5 ?CGRectMake(the_X, the_Y_iPhone5, theWidth, theHeight) :CGRectMake(the_X, the_Y, theWidth, theHeight);
    [theTextViewImg setImage:[[UIImage imageNamed:@"input_dialogue.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
    
    theTextView.returnKeyType = UIReturnKeySend;
    theTextView.placeholder = @"点击这里输入";
    bubbleTableView.bubbleDataSource = self;
    bubbleTableView.snapInterval = 0;
    bubbleTableView.showAvatars = YES;
    bubbleTableView.typingBubble = NSBubbleTypingTypeNobody;
    dataArray = [[NSMutableArray alloc] init];
    bubbleData = [[NSMutableArray alloc] init];
    currentPage = 1;
    isFirstShow = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBubbleTableView:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [bubbleTableView addGestureRecognizer:tapGesture];
    [tapGesture release];
    tapGesture = nil;
    /*
     if (iPhone5) {
     CGRect newFrame = CGRectMake(0, 70, 320, DEVICE_SIZE.height-70);
     [containView setFrame:newFrame];
     }
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideTheKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissTheTextView:) name:@"hideTheKeyboard" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showFamilyCardView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFamilyCardView:) name:@"showFamilyCardView" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backButtonPressed
{
    if([theTextView isFirstResponder])
    {
        [theTextView resignFirstResponder];
        
        CGFloat forTheTextViewY = iPhone5 ? theTextView_Y_iPhone5 : theTextView_Y;
        CGFloat forTheY = iPhone5 ? the_Y_iPhone5 :the_Y;
        
        [theTextView setFrame:CGRectMake(theTextView_X, forTheTextViewY, theTextView_Width, theTextView_Height)];
        [theTextViewImg setFrame:CGRectMake(the_X, forTheY, theWidth, theHeight)];
    }
//    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_POP_TO_DAILOGLIST object:nil];
}

-(void)setTopbarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 65) TheFrameWidth:@"168"];
    customTopBarView.themeLbl.text = @"对话记录";
    customTopBarView.familyLbl.text = MY_NAME;
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void)setBottomBarView
{
    [backBtn setImage:[UIImage imageNamed:@"back_a_bottombar.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_b_bottombar.png"] forState:UIControlStateHighlighted];
    [backBtn setImage:[UIImage imageNamed:@"back_b_bottombar.png"] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [faceBtn setImage:[UIImage imageNamed:@"face_a_dialogue.png"] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:@"face_b_dialogue.png"] forState:UIControlStateHighlighted];
    [faceBtn setImage:[UIImage imageNamed:@"face_b_dialogue.png"] forState:UIControlStateSelected];
}

#pragma mark sendrequesttodialoguedetail
-(void)sendRequestToDialogueDetail
{
    if (isFirstShow) {
       [SVProgressHUD showWithStatus:@"加载中..."];
    }
    NSString *url = $str(@"%@/dapi/space.php?do=pm&subop=view&m_auth=%@&touid=%@&page=%d&perpage=10", BASE_URL, [SBToolKit getMAuth], toUserId, currentPage);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        bubbleTableView.isLoaing = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (![dict objectForKey:DATA] || [[[dict objectForKey:DATA] objectForKey:DIALOG] isEqual:[NSNull null]] || [[[dict objectForKey:DATA] objectForKey:DIALOG] count] <=0) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            return;
        }
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:[[dict objectForKey:DATA] objectForKey:DIALOG]];
        if ([dataArray count] > 0) {
            fromUserId = [[[[dict objectForKey:DATA] objectForKey:FROM_USER] objectForKey:UID] stringValue];
            fromHeadStr = [[[dict objectForKey:DATA] objectForKey:FROM_USER] objectForKey:AVATAR];
            toHeadStr = [[[dict objectForKey:DATA] objectForKey:TO_USER] objectForKey:AVATAR];
            
            
            [self addBubbleData];
            
            if (isFirstShow) {
                [self scrollToBottomWithAnimation:NO];
                [SVProgressHUD dismiss];
                
            }
            isFirstShow = NO;
        }else{
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
        }
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@", [error description]);
        bubbleTableView.isLoaing = NO;
        currentPage--;
    }];
}
-(void)uploadRequestToDialogueDetail
{
    [SVProgressHUD showWithStatus:@"发送中..."];
    NSString *url = $str(@"%@/dapi/cp.php?ac=pm&op=send", BASE_URL);
    NSMutableDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:toUserId, PM_TO_UID, theTextView.text, MESSAGE, IPHONE, COME, @"1", PM_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
        
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        NSBubbleData *tmp = [NSBubbleData dataWithText:theTextView.text date:[NSDate date] type:BubbleTypeMine];
        tmp.userId = fromUserId;
        tmp.headStr = fromHeadStr;
        [bubbleData addObject:tmp];
        
        [bubbleTableView reloadData];
        [tmp release];
        theTextView.text = @"";
        [self scrollToBottomWithAnimation:YES];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@", [error description]);
    }];
}

-(void)showFamilyCardView:(NSNotification*)notification
{
    NSString *userId = [notification object];
    FamilyCardViewController *_con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    _con.userId = userId;
    [self presentModalViewController:_con animated:YES];
    [_con release], _con = nil;
}

#pragma mark uibubbleTableView datasource
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

-(void)addMoreDataOnTop:(UIBubbleTableView *)tableview
{
    if (tableview == bubbleTableView) {
        currentPage++;
        [self sendRequestToDialogueDetail];
    }
}

-(void)addBubbleData
{
    NSBubbleType bubbleType;
    for (int i = [dataArray count]-1; i >= 0; i--) {
        if ([fromUserId isEqualToString:[[dataArray objectAtIndex:i] objectForKey:MESSAGE_FROM_ID]]) {
            bubbleType = BubbleTypeMine;
        }else{
            bubbleType = BubbleTypeSomeoneElse;
        }
        NSBubbleData *tmp = [NSBubbleData dataWithText:[[dataArray objectAtIndex:i] objectForKey:MESSAGE] date:[NSDate dateWithTimeIntervalSince1970:[[[dataArray objectAtIndex:i] objectForKey:DATELINE] doubleValue]] type:bubbleType];
        tmp.userId = bubbleType == BubbleTypeSomeoneElse ? toUserId : fromUserId;
        tmp.headStr = bubbleType == BubbleTypeSomeoneElse ? toHeadStr : fromHeadStr;
        [bubbleData insertObject:tmp atIndex:0];
    }
    [bubbleTableView reloadData];
}

#pragma mark - Actions
- (void)scrollToBottomWithAnimation:(BOOL)_animation {
    
    int rowOfLastSection = [[bubbleTableView.bubbleSection objectAtIndex:[bubbleTableView.bubbleSection count] - 1] count] + 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowOfLastSection - 1 inSection:[bubbleTableView.bubbleSection count] - 1];
    
    [self.bubbleTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:_animation];
}

#pragma mark keyboard events
-(void)keyboardWillShow:(NSNotification *)_notification
{
    NSDictionary *userInfo = [_notification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect nextFrame = self.containView.frame;
    nextFrame.origin.y = -keyboardRect.size.height + 40;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.containView.frame = nextFrame;
    }];
    
    //NSLog(@"height is : %f", keyboardRect.size.height);
    //self.bubbleTableView.contentInset = UIEdgeInsetsMake(keyboardRect.size.height, 0, 0, 0);
}

-(void)keyboardWillHide:(NSNotification *)_notification
{
    NSDictionary *userInfo = [_notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        containView.frame = CGRectMake(0, 40, DEVICE_SIZE.width, DEVICE_SIZE.height - 40);
    }];
    //self.bubbleTableView.contentInset = UIEdgeInsetsZero;
}

#pragma mark textview
/*
-(void)chageTheFrameOfTextView:(UITextView *)_textView
{
    CGSize inputSize = [theTextView.text sizeWithFont:[UIFont systemFontOfSize:21.0f]];
    int row = (int)inputSize.width/theTextView_Width;
    
    CGFloat forTheTextViewY = iPhone5 ? theTextView_Y_iPhone5 :theTextView_Y;
    CGFloat forTheY = iPhone5 ? the_Y_iPhone5 :the_Y;
    
    [_textView setFrame:CGRectMake(theTextView_X, forTheTextViewY - row * inputSize.height, theTextView_Width, row * inputSize.height + theTextView_Height)];
    [theTextViewImg setFrame:CGRectMake(the_X, forTheY - row * inputSize.height, theWidth, row * inputSize.height + theHeight)];
}
*/
-(void)clearTheTextView
{
    theTextView.text = @"";
    
    CGFloat forTheTextViewY = iPhone5 ? theTextView_Y_iPhone5 : theTextView_Y;
    CGFloat forTheY = iPhone5 ? the_Y_iPhone5 :the_Y;
    
    [theTextView setFrame:CGRectMake(theTextView_X, forTheTextViewY, theTextView_Width, theTextView_Height)];
    [theTextViewImg setFrame:CGRectMake(the_X, forTheY, theWidth, theHeight)];
}

-(void)dismissTheTextView:(NSNotification *)_notification
{
    if([theTextView isFirstResponder])
    {
        [theTextView resignFirstResponder];
        
        CGFloat forTheTextViewY = iPhone5 ? theTextView_Y_iPhone5 : theTextView_Y;
        CGFloat forTheY = iPhone5 ? the_Y_iPhone5 :the_Y;
        
        [theTextView setFrame:CGRectMake(theTextView_X, forTheTextViewY, theTextView_Width, theTextView_Height)];
        [theTextViewImg setFrame:CGRectMake(the_X, forTheY, theWidth, theHeight)];
    }
}

-(void)addToolbarOnTopOfTextView
{
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.barStyle = UIBarStyleBlack;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTheTextView:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearTheTextView)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:clear, space, cancel, nil];
    [topView setItems:buttonArray];
    [theTextView setInputAccessoryView:topView];
    
    [cancel release];
    [clear release];
    [space release];
    [buttonArray release];
    [topView release];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[self chageTheFrameOfTextView:textView];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self performSelector:@selector(uploadRequestToDialogueDetail) withObject:nil afterDelay:0.2f];
        return NO;
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if ([textView hasText]) {
        CGFloat forTheTextViewY = iPhone5 ? theTextView_Y_iPhone5 : theTextView_Y;
        CGFloat forTheY = iPhone5 ? the_Y_iPhone5 :the_Y;
        
        [textView setFrame:CGRectMake(theTextView_X, forTheTextViewY, theTextView_Width, theTextView_Height)];
        [theTextViewImg setFrame:CGRectMake(the_X, forTheY, theWidth, theHeight)];
    }
}

#pragma mark uitapgesturerecognize
-(void)tapOnBubbleTableView:(UIGestureRecognizer*)_gesture
{
    if([theTextView isFirstResponder])
    {
        [theTextView resignFirstResponder];
    }
}

-(void)dealloc
{
    [super dealloc];
    [speakerLbl release],speakerLbl = nil;
    [bubbleTableView release],bubbleTableView = nil;
    [backBtn release],backBtn = nil;
    [theTextView release],theTextView = nil;
    [faceBtn release],faceBtn = nil;
    [theTextViewImg release], theTextViewImg = nil;
    [toUserId release], toUserId = nil;
    [toHeadStr release], toHeadStr = nil;
    [fromUserId release], fromUserId = nil;
    [fromHeadStr release], fromHeadStr = nil;
    [PMId release], PMId = nil;
    //[bubbleData release], bubbleData = nil;
    //[dataArray release], dataArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideTheKeyboard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showFamilyCardView" object:nil];
}

@end
