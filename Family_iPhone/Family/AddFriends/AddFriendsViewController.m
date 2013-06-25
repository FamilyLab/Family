//
//  AddFriendsViewController.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "MyButton.h"
#import "InviteListViewController.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "Common.h"
//#import "UIButton+WebCache.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController
@synthesize topViewType;
@synthesize containerView;
@synthesize cellHeader;

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
    [self addTopView];
    [self addBottomView];
    
    MySearchBar *search = [[MySearchBar alloc] initWithFrame:CGRectMake(10, 0, 300, 43)];
    [search buildMySearchBarWithImgStr:@"search_bg.png"];
    search.placeholder = @"输入姓名或电话号码";
    search.delegate = self;
    self.mySearchBar = search;
    
    [containerView addSubview:_mySearchBar];
    
//    NSArray *lblTextArray = [[NSArray alloc] initWithObjects:@"电话本", @"新浪微博", @"腾讯微博", @"微信", nil];
//    NSArray *imgsArray = [[NSArray alloc] initWithObjects:@"invite_addressbook", @"invite_sina_weibo", @"invite_tencent_weibo", @"invite_weixin", nil];
//    for (int i=0; i<4; i++) {
//        MyButton *btn = (MyButton*)[self.view viewWithTag:kTagAddFriendsButton + i];
//        [btn changeLblWithText:[lblTextArray objectAtIndex:i] andColor:color(95, 95, 95, 1.0) andSize:14.0f theX:35];
//        [btn addALittleImageViewWithFrame:CGRectMake(14, 10, 18, 18) imgStr:[imgsArray objectAtIndex:i]];
//    }
    if (self.topViewType == loginOrSignIn) {
        [_phoneTextField becomeFirstResponder];
    }
    [_phoneTextField setInputAccessoryView:[self buildBottomView]];
    [_nameTextField setInputAccessoryView:[self buildBottomView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)pushInviteListWithAnimation:(BOOL)animation willSearch:(BOOL)willSearch {
    InviteListViewController *con = [[InviteListViewController alloc] initWithNibName:@"InviteListViewController" bundle:nil];
    con.topViewType = self.topViewType;
    con.canSearch = willSearch;
    con.searchText = _mySearchBar.text;
    con.searchWhere = searchInOurWeb;
    [_mySearchBar setShowsCancelButton:NO animated:YES];
    [_mySearchBar resignFirstResponder];
    [self.navigationController pushViewController:con animated:animation];
}

//- (IBAction)addBtnPressed:(UIButton*)sender {
//    switch (sender.tag - kTagAddFriendsButton) {
//        case 0:
//        {
//            //电话本
//            [self pushInviteListWithAnimation:YES willSearch:NO];
//            break;
//        }
//        case 1:
//        {
//            //新浪微博
//            [self pushInviteListWithAnimation:YES willSearch:NO];
//            break;
//        }
//        case 2:
//        {
//            //腾讯微博
//            [self pushInviteListWithAnimation:YES willSearch:NO];
//            break;
//        }
//        case 3:
//        {
//            //微信
//            [self pushInviteListWithAnimation:YES willSearch:NO];
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = self.topViewType;
    if (self.topViewType == loginOrSignIn) {
        [self.cellHeader removeFromSuperview];
        self.cellHeader = nil;
        [topView leftBg];
        [topView leftText:@"邀请家人"];
        [topView rightLogo];
        [topView rightLine];
    } else if (self.topViewType == notLoginOrSignIn) {
        [topView leftHeadAndName];
    
        self.containerView.frame = (CGRect){.origin.x = 0, .origin.y = 80, .size = self.containerView.frame.size};
        cellHeader.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:@"邀请家人"].height};
        [cellHeader initHeaderDataWithMiddleLblText:@"邀请家人"];
        
//        [topView.leftHeadBtn setImage:[UIImage imageNamed:@"head_70.png"] forState:UIControlStateNormal];//假数据
//        topView.leftNameLbl.text = @"杜拉拉";//假数据
        
//        [topView.leftHeadBtn setImageWithNoCacheWithURL:[NSURL URLWithString:MY_HEAD_AVATAR_URL] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
        [topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
        [topView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
        topView.leftNameLbl.text = MY_NAME;
        [topView setNeedsLayout];
    }
    [self.view addSubview:topView];
}

- (BottomView*)buildBottomView {
    NSArray *normalImages;
    if (self.topViewType == loginOrSignIn) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"inviteBtn", @"login_pass", nil];
    } else if (self.topViewType == notLoginOrSignIn) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"inviteBtn", nil];
    }
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    return aView;
}

- (void)addBottomView {
    [self.view addSubview:[self buildBottomView]];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            [self inviteAndRegisterBtnPressed:_button];
            break;
        }
        case 2:
        {//注册时才有这个
            [[NSNotificationCenter defaultCenter] postNotificationName:SEND_REQUEST object:nil];
            [self.navigationController dismissModalViewControllerAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"输入点东西吧T_T"];
        [SVProgressHUD changeDistance:-60];
    } else {
        [self pushInviteListWithAnimation:YES willSearch:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarSearchButtonClicked:searchBar];
//    searchBar.text = @"";
//    [searchBar setShowsCancelButton:NO animated:YES];
//    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (![searchBar.text isEqualToString:@""]) {
//        [self pushInviteListWithAnimation:NO willSearch:YES];
////        if (self.whichWeibo == sinaWeibo) {
////            [self searchForSinaUsers:searchBar.text];
////        } else if (self.whichWeibo == TCWeibo) {
////            [self searchForTCWeiboUser:searchBar.text];
////        }
//    }
//}

#pragma mark - textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _phoneTextField && ![Common isPureInt:string] && range.length != 1) {//isPureInt判断输入的是否为数字，range.length != 1表示输入的不是后退键
        [SVProgressHUD showErrorWithStatus:@"请输入数字T_T"];
        [SVProgressHUD changeDistance:-60];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat theY = textField == _nameTextField ? -60 : 0;
    if (textField == _phoneTextField && self.topViewType == notLoginOrSignIn) {
        theY = -50;
    }
    if (textField == _nameTextField && self.topViewType == notLoginOrSignIn) {
        theY = -80;
    }
    if (self.view.frame.origin.y != theY) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.frame = CGRectMake(0, theY, self.view.frame.size.width, self.view.frame.size.height);
                         }];
    }
//    UIScrollView *scrollView = (UIScrollView*)self.view;
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         scrollView.contentInset = UIEdgeInsetsMake(theY, 0, 0, 0);
//                     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self fillSmsContent];
//    if (self.view.frame.origin.y < 0) {
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//                         }];
//    }
    
//    UIScrollView *scrollView = (UIScrollView*)self.view;
//    if (scrollView.contentInset.top < 0) {
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                         }];
//    }
}

- (void)fillSmsContent {
    NSString *name = [emptystr(_nameTextField.text) isEqualToString:@""] ? @"xxx" : _nameTextField.text;
    NSString *phone = [emptystr(_phoneTextField.text) isEqualToString:@""] ? @"xxx" : _phoneTextField.text;
    NSString *pw = [emptystr(_passwordStr) isEqualToString:@""] ? @"***" : _passwordStr;
    _smsLbl.text = $str(@"%@，我在familyday.com.cn帮你注册了，账号:%@，密码:%@ 下载：www.familyday.com/app（%@）", name, phone, pw, MY_NAME);
//    _smsLbl.text = $str(@"%@，我在www.familyday.com.cn帮你注册了，账号是%@，密码是%@，我们在这儿团聚吧！(%@)",name, phone, pw, MY_NAME);
    
}

#pragma mark - 通讯录
- (void)showAddressPicker {
    [self bgBtnPressed:nil];
    ABPeoplePickerNavigationController *picker;
    if (!picker) {
        picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
    }
    [self presentModalViewController:picker animated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property == kABPersonPhoneProperty) {
        _nameTextField.text = (__bridge NSString*)ABRecordCopyCompositeName(person);
        
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        int index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        _phoneTextField.text = [phone clearNotNumberInString];//遍历字符串，清除非数字
        [self fillSmsContent];
    }
    [peoplePicker dismissModalViewControllerAnimated:YES];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark - my action(s)
- (IBAction)showActionSheet:(UIButton*)sender {
    [self showAddressPicker];

//    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择"];
//    as.delegate = self;
//    
//    [as addButtonWithTitle:@"进入通讯录" handler:^{
//        [self showAddressPicker];
//    }];
//    [as addButtonWithTitle:@"手动输入" handler:^{
//        [_phoneTextField becomeFirstResponder];
//        _showActionSheetBtn.hidden = YES;
//        UIScrollView *scrollView = (UIScrollView*)self.view;
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             scrollView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0);
//                         }];
//    }];
//    [as setCancelButtonWithTitle:@"取消" handler:^{
//        return ;
//    }];
//    [as sizeToFit];
//    [as showInView:self.view];
}

- (IBAction)bgBtnPressed:(id)sender {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }];
//    UIScrollView *scrollView = (UIScrollView*)self.view;
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//                     }];
    [Common resignKeyboardInView:self.containerView];
    
}

//邀请注册接口
- (IBAction)inviteAndRegisterBtnPressed:(id)sender {
    if (_phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        [_phoneTextField becomeFirstResponder];
        return;
    }
    if (_nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称未填写T_T"];
        [SVProgressHUD changeDistance:-60];
        [_nameTextField becomeFirstResponder];
        return;
    }
    [self bgBtnPressed:nil];
    [SVProgressHUD showWithStatus:@"注册中..."];
    [SVProgressHUD changeDistance:-60];
    NSString *url = $str(@"%@invite", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text, USER_NAME, _nameTextField.text, NAME, ONE, SMS_INVITE, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [SVProgressHUD changeDistance:-60];
            return ;
        }
        self.passwordStr = [[dict objectForKey:WEB_DATA] objectForKey:PASSWORD];
        [self fillSmsContent];
        [SVProgressHUD dismiss];
//        [self showSendSmsView];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [SVProgressHUD changeDistance:-60];
    }];
}

#pragma mark - 短信
- (void)showSendSmsView {
    MFMessageComposeViewController *messageCon = nil;
    //发送短信
    Class messageConClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageConClass == nil) {
        UIAlertView *alert = [UIAlertView alertViewWithTitle:nil message:@"需要ios4.0及以上才支持程序内发送短信"];
        [alert show];
    } else {
        if ([MFMessageComposeViewController canSendText]) {
            messageCon = [[MFMessageComposeViewController alloc] init];
            messageCon.messageComposeDelegate = self;
            //状态栏被遮挡掉的话用以下代码
            //                messageCon.view.layer.zPosition = messageCon.view.layer.zPosition + 1;
            //                messageCon.view.frame = CGRectMake(0, 0, 320, 480);
            //                messageCon.view.bounds = messageCon.view.frame;
            messageCon.body = _smsLbl.text;
//            messageCon.body = [NSString stringWithFormat:@"我在www.familyday.com.cn上帮你注册了一个帐号，快来加入FamilyDay社区吧～你的帐号：%@  密码：%@", _phoneTextField.text, self.passwordStr];
            messageCon.recipients = [NSArray arrayWithObjects:_phoneTextField.text, nil];
            [self presentModalViewController:messageCon animated:YES];
            //                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        } else {
            UIAlertView *alert = [UIAlertView alertViewWithTitle:nil message:@"设备没有短信功能"];
            [alert show];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
//            [SVProgressHUD showSuccessWithStatus:@"取消成功T_T"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"发送成功～"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"发送失败T_T"];
            break;
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}


@end
