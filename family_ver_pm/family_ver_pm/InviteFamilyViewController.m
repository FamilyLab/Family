//
//  InviteFamilyViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "InviteFamilyViewController.h"
#import "TopBarView.h"

@interface InviteFamilyViewController ()

@end

@implementation InviteFamilyViewController
@synthesize theScrollView;
@synthesize nameTextField;
@synthesize addBtn;
@synthesize phoneNumTextField, passwordStr;
@synthesize messageTextView;
@synthesize inviteBtn;
@synthesize bgrImg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"这里是：%@", [self class]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = (CGRect){.origin = DEVICE_ORIGIN, .size = DEVICE_SIZE};
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    [self addToolbarOnTopOfTextView];
    [self setInterfaceButton];
    //messageTextView.returnKeyType = UIReturnKeyDone;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setTheTopBarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 65) TheFrameWidth:@"168"];
    customTopBarView.themeLbl.text = @"邀请家人";
    customTopBarView.familyLbl.text = MY_NAME;
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void)setTheBackBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", nil];
    customBackBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBackBottomBarView.delegate = self;
    [self.view addSubview:customBackBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)setInterfaceButton
{
    messageTextView.placeholder = @"邀请他们注册FamilyDay吧";
    
    phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    theScrollView.frame = CGRectMake(0, 85, DEVICE_SIZE.width, DEVICE_SIZE.height);
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, 500);
    
    UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTheBackgroundView)];
    tapGestrue.delegate = self;
    tapGestrue.numberOfTapsRequired = 1;
    tapGestrue.numberOfTouchesRequired = 1;
    [bgrImg addGestureRecognizer:tapGestrue];
    [tapGestrue release], tapGestrue = nil;
    
    addBtn.tag = kTheInterfaceButtonTag;
    [addBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    inviteBtn.tag = kTheInterfaceButtonTag + 1;
    [inviteBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)tapOnTheBackgroundView
{
    if([nameTextField isFirstResponder])
    {
        [nameTextField resignFirstResponder];
    }
    if ([phoneNumTextField isFirstResponder]) {
        [phoneNumTextField resignFirstResponder];
    }
    if ([messageTextView isFirstResponder]) {
        [messageTextView resignFirstResponder];
    }
}

-(void)buttonPressed:(UIButton*)button
{
    if (button.tag - kTheInterfaceButtonTag == 0) {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker .peoplePickerDelegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release], picker = nil;
    }else if(button.tag - kTheInterfaceButtonTag == 1){
        [self uploadRequestToInvite];
    }
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissModalViewControllerAnimated:YES];
    NSString *firstNameStr = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastNameStr = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *phoneStr = @"";
    ABMultiValueRef tempStr = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (ABMultiValueGetCount(tempStr) > 0) {
        phoneStr = ABMultiValueCopyValueAtIndex(tempStr, 0);
    }else{
        phoneStr = @"[none]";
    }
    NSMutableString *phoneNumbers = [[NSMutableString alloc] initWithString:phoneStr];
    if ([phoneNumbers characterAtIndex:1] == ' ') {
        [phoneNumbers deleteCharactersInRange:[phoneNumbers rangeOfString:@" "]];
        [phoneNumbers deleteCharactersInRange:[phoneNumbers rangeOfString:@"("]];
        [phoneNumbers deleteCharactersInRange:[phoneNumbers rangeOfString:@")"]];
        [phoneNumbers deleteCharactersInRange:[phoneNumbers rangeOfString:@" "]];
        [phoneNumbers deleteCharactersInRange:[phoneNumbers rangeOfString:@"-"]];
    }
    nameTextField.text = [NSString stringWithFormat:@"%@%@", lastNameStr, firstNameStr];
    phoneNumTextField.text = phoneNumbers;
    NSString *message = [NSString stringWithFormat:@"%@%@,我在familyday.com.cn帮你注册了用户,一起在这里团聚吧!(%@)", lastNameStr, firstNameStr, MY_NAME];
    messageTextView.text = message;
    return YES;
}

#pragma mark keyboard show event
-(void)keyboardWillShow:(NSNotification *)_notification
{
    if ([messageTextView isFirstResponder] || [phoneNumTextField isFirstResponder]) {
        
        NSDictionary *userInfo = [_notification userInfo];
        /*
        NSValue *aValue = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        */
        NSValue *animationDurationValue = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        CGFloat height;
        if ([phoneNumTextField isFirstResponder]) {
            height = 20.0f;
        }else{
            height = 90.0f;
        }
        
        if ([messageTextView hasText]) {
            CGSize inputSize = [messageTextView.text sizeWithFont:[UIFont systemFontOfSize:21.0f]];
            int row = (int)inputSize.width / messageTextView.frame.size.width;
        
            [UIView animateWithDuration:animationDuration animations:^{
                [theScrollView setContentOffset:CGPointMake(0, height + row * inputSize.height) animated:YES];
            }];
        }else{
            [UIView animateWithDuration:animationDuration animations:^{
                [theScrollView setContentOffset:CGPointMake(0, height) animated:YES];
            }];
        }
    }
    
}

-(void)keyboardWillHide:(NSNotification *)_notification
{
    if ([messageTextView isFirstResponder] || [phoneNumTextField isFirstResponder]) {
        NSDictionary *userInfo = [_notification userInfo];
        NSValue *animationDurationValue = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        
        [UIView animateWithDuration:animationDuration animations:^{
            [theScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    }
   
}

#pragma mark textview event
-(void)changeTheFrameOfTextView
{
    CGSize inputSize = [messageTextView.text sizeWithFont:[UIFont systemFontOfSize:21.0f]];
    int row = (int)inputSize.width / messageTextView.frame.size.width;
    
    [UIView animateWithDuration:0.1f animations:^{
        [theScrollView setContentOffset:CGPointMake(0, 90 + row * inputSize.height) animated:YES];
    }];
}

-(void)clearTheTextView
{
    if ([messageTextView isFirstResponder]) {
        messageTextView.text = @"";
        [theScrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    }else if([nameTextField isFirstResponder]){
        nameTextField.text = @"";
    }else if([phoneNumTextField isFirstResponder]){
        phoneNumTextField.text = @"";
    }
    
}

-(void)dismissTheTextView
{
    if([messageTextView isFirstResponder])
    {
        [messageTextView resignFirstResponder];
    }else if([nameTextField isFirstResponder]){
        [nameTextField resignFirstResponder];
    }else if([phoneNumTextField isFirstResponder]){
        [phoneNumTextField resignFirstResponder];
    }
}

-(void)addToolbarOnTopOfTextView
{
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topView.barStyle = UIBarStyleBlack;
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearTheTextView)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissTheTextView)];
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:clear, space, cancel, nil];
    [topView setItems:buttonArray];
    [nameTextField setInputAccessoryView:topView];
    [phoneNumTextField setInputAccessoryView:topView];
    [messageTextView setInputAccessoryView:topView];
    
    [buttonArray release], buttonArray = nil;
    [cancel release], cancel = nil;
    [space release], space = nil;
    [clear release], clear = nil;
    [topView release], topView = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([nameTextField isFirstResponder] || [phoneNumTextField isFirstResponder]) {
        return NO;
    }
    
    [self changeTheFrameOfTextView];
    return YES;
}

-(void)uploadRequestToInvite
{
    if ([nameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
        return;
    }
    if ([phoneNumTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"电话号码不能为空"];
        return;
    }
    if ([messageTextView.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"短信内容不能为空"];
        return;
    }
    [SVProgressHUD showWithStatus:@"注册中..."];
    NSString *url = $str(@"%@/dapi/cp.php?ac=invite", BASE_URL);
    NSMutableDictionary *para = $dict(phoneNumTextField.text, USER_NAME, nameTextField.text, NAME, ONE, SMS_INVITE, [SBToolKit getMAuth], M_AUTH, nil);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
        
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
             return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"注册成功！"];
        passwordStr = [[dict objectForKey:DATA] objectForKey:PASSWORD];
        [self showInviteMessage];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网路不好"];
        NSLog(@"error%@", [error description]);
    }];
}

-(void)showInviteMessage
{
    MFMessageComposeViewController *messageCon = nil;
    Class messageConClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageConClass == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"需要ios4.0及以上才支持程序内发送短信" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [alert release], alert = nil;
    }else{
        if ([MFMessageComposeViewController canSendText]) {
            messageCon = [[MFMessageComposeViewController alloc] init];
            messageCon.messageComposeDelegate = self;
            NSString *appendStr = [NSString stringWithFormat:@"账户:%@ 密码:%@", phoneNumTextField.text, passwordStr];
            messageCon.body = [NSString stringWithFormat:@"%@ %@", messageTextView.text, appendStr];
            messageCon.recipients = [NSArray arrayWithObjects:phoneNumTextField.text, nil];
            [self presentModalViewController:messageCon animated:YES];
            [messageCon release], messageCon = nil;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你的设备不支持发送短信！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            [alert release], alert = nil;
        }
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showSuccessWithStatus:@"取消成功！"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"发送成功！"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
            break;
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    [super dealloc];
    [theScrollView release], theScrollView = nil;
    [nameTextField release], nameTextField = nil;
    [addBtn release], addBtn = nil;
    [phoneNumTextField release], phoneNumTextField = nil;
    [passwordStr release], passwordStr = nil;
    [messageTextView release], messageTextView = nil;
    [inviteBtn release], inviteBtn = nil;
    [bgrImg release], bgrImg = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
