//
//  InviteViewController.m
//  Family
//
//  Created by Aevitx on 13-6-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "InviteViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "InviteListViewController.h"
#import "InviteOtherCell.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

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
    
    self.smsStr = @"xxx，我在familyday.com.cn帮你注册了，帐号:xxx，密码:*** 下载：www.familyday.com/app（xxx）";
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 53)];
    tmpView.backgroundColor = bgColor();
    MySearchBar *search = [[MySearchBar alloc] initWithFrame:CGRectMake(10, 0, DEVICE_SIZE.width - 10 * 2, 43)];
//    MySearchBar *search = [[MySearchBar alloc] initWithFrame:CGRectMake(10, 80, 300, 43)];
    [search buildMySearchBarWithImgStr:@"search_bg.png"];
    search.placeholder = @"输入姓名或电话号码";
    search.delegate = self;
    self.mySearchBar = search;
    
    [tmpView addSubview:_mySearchBar];
    _tableView.tableHeaderView = tmpView;
//    [self.view addSubview:_mySearchBar];
    
//    _tableView.tableFooterView = _tableFooter;
    _tableView.refreshView.hidden = YES;
    _tableView.loadMoreView.hidden = YES;
    
    if (self.topViewType == loginOrSignIn) {
        [_phoneTextField becomeFirstResponder];
    }
//    [_phoneTextField setInputAccessoryView:[self buildBottomView]];
//    [_nameTextField setInputAccessoryView:[self buildBottomView]];
    
    _addressBookArray = [[NSMutableArray alloc] init];
    [self scanAddressBookSample];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
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
        
//        self.containerView.frame = (CGRect){.origin.x = 0, .origin.y = 80, .size = self.containerView.frame.size};
        self.cellHeader.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:@"邀请家人"].height};
        [self.cellHeader initHeaderDataWithMiddleLblText:@"邀请家人"];
        self.cellHeader.userInteractionEnabled = YES;
        [self.cellHeader whenTapped:^{
            [self bgBtnPressed:nil];
        }];
        [topView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
        [topView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
        topView.leftNameLbl.text = MY_NAME;
        [topView setNeedsLayout];
    }
    [self.view addSubview:topView];
}

//邀请注册接口
- (void)inviteAndRegisterBtnPressed:(id)sender {
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

- (void)fillSmsContent {
    NSString *name = [emptystr(_nameTextField.text) isEqualToString:@""] ? @"xxx" : _nameTextField.text;
    NSString *phone = [emptystr(_phoneTextField.text) isEqualToString:@""] ? @"xxx" : _phoneTextField.text;
    NSString *pw = [emptystr(_passwordStr) isEqualToString:@""] ? @"***" : _passwordStr;
    _smsLbl.text = $str(@"%@，我在familyday.com.cn帮你注册了，账号:%@，密码:%@ 下载：www.familyday.com/app(%@)", name, phone, pw, MY_NAME);
    
    self.nameStr = emptystr(_nameTextField.text);
    self.phoneStr = emptystr(_phoneTextField.text);
    self.smsStr = _smsLbl.text;
    [_tableView reloadData];
    //    _smsLbl.text = $str(@"%@，我在www.familyday.com.cn帮你注册了，账号是%@，密码是%@，我们在这儿团聚吧！(%@)",name, phone, pw, MY_NAME);
    
}

- (IBAction)showActionSheet:(UIButton*)sender {
    [self showAddressPicker];
}

- (IBAction)bgBtnPressed:(id)sender {
    if (self.phoneTextField && [self.phoneTextField isFirstResponder]) {
        [_phoneTextField resignFirstResponder];
    }
    if (self.nameTextField && [self.nameTextField isFirstResponder]) {
        [_nameTextField resignFirstResponder];
    }
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//                     }];
//    [Common resignKeyboardInView:self.tableFooter];
}

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
//    int section = [dataArray count] > 0 ? 1 : 0;
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    CGFloat theY = textField == _phoneTextField ? 97 : 113;
    [_tableView setContentOffset:CGPointMake(0, [dataArray count] * 7 + 40 + theY) animated:YES];
    
//    CGFloat theY = textField == _nameTextField ? -60 : 0;
//    if (textField == _phoneTextField && self.topViewType == notLoginOrSignIn) {
//        theY = -50;
//    }
//    if (textField == _nameTextField && self.topViewType == notLoginOrSignIn) {
//        theY = -80;
//    }
//    if (self.view.frame.origin.y != theY) {
//        [UIView animateWithDuration:0.3f
//                         animations:^{
//                             self.view.frame = CGRectMake(0, theY, self.view.frame.size.width, self.view.frame.size.height);
//                         }];
//    }
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

#define FAMILY_KEYWORD [NSArray arrayWithObjects:@"爸", @"妈", @"弟", @"姐", @"妹", @"哥", @"baby", @"妈咪", @"舅", @"姨", @"姑", @"婶", @"伯", @"老政府", @"father", @"mother", @"爷爷", @"奶奶", @"外公", @"外婆", nil]
//查找通讯录
- (void)scanAddressBookSample {
    NSUInteger i;
    NSUInteger k;
    NSMutableArray *arr = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *people = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    if (people == nil) {
        NSLog(@"NO ADDRESS BOOK ENTRIES TO SCAN");
        CFRelease(addressBook);
        return;
    }
    for ( i = 0; i < [people count]; i++ ) {
        ABRecordRef person = (__bridge ABRecordRef)[people objectAtIndex:i];
        NSString *nameStr = (__bridge NSString*)ABRecordCopyCompositeName(person);
        //
        // Phone Numbers
        //
        ABMutableMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneNumberCount = ABMultiValueGetCount( phoneNumbers );
    
        for (k = 0; k < phoneNumberCount; k++) {
            CFStringRef phoneNumberLabel = ABMultiValueCopyLabelAtIndex( phoneNumbers, k );
            CFStringRef phoneNumberValue = ABMultiValueCopyValueAtIndex( phoneNumbers, k );
            CFStringRef phoneNumberLocalizedLabel = ABAddressBookCopyLocalizedLabel( phoneNumberLabel );    // converts "_$!<Work>!$_" to "work" and "_$!<Mobile>!$_" to "mobile"
            
            // Find the ones you want here
            //
//            NSLog(@"-----PHONE ENTRY -> %@ : %@", phoneNumberLocalizedLabel, phoneNumberValue);
            for (NSString *keyword in FAMILY_KEYWORD) {
                if ([nameStr rangeOfString:keyword].location != NSNotFound) {
//                    [arr addObject:$str(@"%@:%@",[(__bridge NSString *)phoneNumberValue clearNotNumberInString], nameStr)];
                    [arr addObject:[NSString stringWithFormat:@"%@:%@",[(__bridge NSString *)phoneNumberValue clearNotNumberInString], nameStr]];
                }
            }
            CFRelease(phoneNumberLocalizedLabel);
            CFRelease(phoneNumberLabel);
            CFRelease(phoneNumberValue);
        }
    }
    [_addressBookArray removeAllObjects];
    [_addressBookArray addObjectsFromArray:arr];
    if ([_addressBookArray count] > 0) {
        [self uploadRequestToScanUser];
    } else {
        [_tableView reloadData];
    }
    CFRelease(addressBook);
}

#pragma mark - 查询用户接口
- (void)uploadRequestToScanUser {
    NSString *url = $str(@"%@friend&op=find", POST_CP_API);
    NSString *unames = [_addressBookArray objectAtIndex:0];
    for (int i = 1; i < [_addressBookArray count]; i++) {
        unames = [NSString stringWithFormat:@"%@|%@", unames, [_addressBookArray objectAtIndex:i]];
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:unames, @"unames[]", MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count] > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArray count] > 0) {
        return section == 0 ?  [dataArray count] : 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dataArray count] > 0) {
        return indexPath.section == 0 ? 70 : 345;
    } else {
        return 345;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 20)];
    containerView.backgroundColor = bgColor();
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 20)];
    textLbl.backgroundColor = [UIColor grayColor];
    textLbl.textColor = [UIColor whiteColor];
    textLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    if ([dataArray count] > 0) {
        textLbl.text = section == 0 ? @"   他们非常可能是你的家人" : @"   短信邀请家人";
    } else {
        textLbl.text = @"  短信邀请家人";
    }
    textLbl.userInteractionEnabled = YES;
    [textLbl whenTapped:^{
        [self bgBtnPressed:nil];
    }];
    [containerView addSubview:textLbl];
    return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InviteOtherCell *cell;
    static NSString *phoneCellId = @"phoneCellId";
    static NSString *inviteCellId = @"inviteCellId";
    if ([dataArray count] > 0) {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:phoneCellId];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:inviteCellId];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:inviteCellId];
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InviteOtherCell" owner:self options:nil];
        if ([dataArray count] > 0) {
            cell = [array objectAtIndex:indexPath.section];
        } else {
            cell = [array objectAtIndex:1];
        }
    }
//    cell.indexRow = indexPath.row;
    if ([dataArray count] > 0) {
        if (indexPath.section == 0) {
            [cell initData:[dataArray objectAtIndex:indexPath.row]];
        } else {
            cell.phoneTextField.text = emptystr(_phoneStr);
            cell.nameTextField.text = emptystr(_nameStr);
            cell.smsLbl.text = emptystr(_smsStr);
//            cell.phoneTextField.delegate = self;
//            cell.nameTextField.delegate = self;
            self.phoneTextField = cell.phoneTextField;
            self.nameTextField = cell.nameTextField;
            self.smsLbl = cell.smsLbl;
            [_phoneTextField setInputAccessoryView:[self buildBottomView]];
            [_nameTextField setInputAccessoryView:[self buildBottomView]];
        }
    } else {
        cell.phoneTextField.text = emptystr(_phoneStr);
        cell.nameTextField.text = emptystr(_nameStr);
        cell.smsLbl.text = emptystr(_smsStr);
        self.phoneTextField = cell.phoneTextField;
        self.nameTextField = cell.nameTextField;
        self.smsLbl = cell.smsLbl;
        [_phoneTextField setInputAccessoryView:[self buildBottomView]];
        [_nameTextField setInputAccessoryView:[self buildBottomView]];
    }
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
//    con.isMyFamily = YES;
//    con.userId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
//    [self.navigationController pushViewController:con animated:YES];
}

@end
