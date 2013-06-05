//
//  InviteFamilyViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "InviteFamilyViewController.h"
#import "addFamilyCell.h"
#import "InviteFamilyCell.h"
#import "HeaderView.h"
#import "AddFriendsViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "MyHttpClient.h"
#import "NSObject+BlocksKit.h"
#import "GuideViewController.h"
#define  skipRect CGRectMake(288,17,108,33)
#define  backRect CGRectMake(138,17,60,33)
#define  LOCK 0

@interface InviteFamilyViewController ()

@end

@implementation InviteFamilyViewController
@synthesize toolBarView,detail_header;
#pragma mark - request
- (IBAction)showGuidAction:(id)sender
{
    GuideViewController *con = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
    if (sender) {
        con.father = self;
    }
    con.selector = @selector(overSlideBtnPressed:);
    [self.navigationController pushViewController:con animated:YES];
}
- (IBAction)setscrollerviewContentOffset:(id)sender
{
    [_scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)sendRequest:(id)sender{
    if (_searchBar.searchTextFiled.text.length) {
        [SVProgressHUD showWithStatus:@"搜索中..."];

        NSString *keyword = [_searchBar.searchTextFiled.text  length]?_searchBar.searchTextFiled.text:@"";
        NSString *url = [NSString stringWithFormat:@"%@space.php?do=fmembers&fsearch=1&kw=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, [keyword urlencode], currentPage, 20, GET_M_AUTH];
        [[MyHttpClient sharedInstance] commandWithPathAndNoHUD:url onCompletion:^(NSDictionary *dict) {
            [self stopLoading:sender];
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [SVProgressHUD dismiss];
            if (needRemoveObjects == YES) {
                [dataArray removeAllObjects];
                [_tableView reloadData];
                needRemoveObjects = NO;
            }
            if (currentPage == 1) {
                [dataArray removeAllObjects];
            }
            [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
            if ([dataArray count] <= 0) {
                [self performBlock:^(id sender) {
                    [SVProgressHUD showSuccessWithStatus:@"没有搜到此人T_T"];
                } afterDelay:0.5f];
            } else {
                [_tableView reloadData];
                [_scrollerView setContentOffset:CGPointMake(470, 0) animated:YES];
                [_searchBar.searchTextFiled resignFirstResponder];
            }    } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
                [self stopLoading:sender];
                currentPage--;
            }];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField !=_searchBar.searchTextFiled)
        [self fillSmsContent];



}
//邀请注册接口
- (IBAction)inviteAndRegisterBtnPressed:(id)sender {
    if (_nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称未填写T_T"];
        return;
    }
    if (_phoneTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号码未填写T_T"];
        return;
    }
    [SVProgressHUD showWithStatus:@"注册中..."];
    NSString *url = $str(@"%@invite", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text, USER_NAME, _nameTextField.text, NAME, ONE, SMS_INVITE, POST_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        self.passwordStr = [[dict objectForKey:WEB_DATA] objectForKey:PASSWORD];
        [self fillSmsContent];
        [SVProgressHUD dismiss];
        REMOVEDETAIL;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (void)showAddressPicker {
    ABPeoplePickerNavigationController *picker;
    if (!picker) {
        picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
    }
    if (self.navigationController) {
        [self presentModalViewController:picker animated:YES];
    }else{
        picker.view.frame = CGRectMake(0, 0, 480,768);
        [[AppDelegate instance].rootViewController.stackScrollViewController  addViewInSlider:picker invokeByController:self isStackStartView:NO];
        for (UIGestureRecognizer *gesture in picker.view.gestureRecognizers) {
            [picker.view removeGestureRecognizer:gesture];
        }
    }
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property == kABPersonPhoneProperty) {
        _nameTextField.text = (__bridge NSString*)ABRecordCopyCompositeName(person);

        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        int index = ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        NSString *phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        _phoneTextField.text = phone;//遍历字符串，清除非数字
        [self fillSmsContent];
        if (self.navigationController) {
            [self dismissModalViewControllerAnimated:YES];
        }else{
            REMOVEDETAIL;
        }
    }
    return NO;
}
- (void)fillSmsContent {
    NSString *name = [emptystr(_nameTextField.text) isEqualToString:@""] ? @"xxx" : _nameTextField.text;
    NSString *phone = [emptystr(_phoneTextField.text) isEqualToString:@""] ? @"xxx" : _phoneTextField.text;
    NSString *pw = [emptystr(_passwordStr) isEqualToString:@""] ? @"***" : _passwordStr;
    _smsLbl.text = $str(@"%@，我在www.familyday.com.cn帮你注册了，账号是%@，密码是%@，我们在这儿团聚吧！(%@)",name, phone, pw, MY_NAME);
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    if (self.navigationController) {
        [self dismissModalViewControllerAnimated:YES];
    }else{
        REMOVEDETAIL;
    }
}
- (void)skipAction:(id)sender
{
    if (LOCK) {
        [SVProgressHUD showSuccessWithStatus:@"尚未注册."];
        return;
    }
    [self showGuidAction:nil];
}
- (IBAction)backAction:(id)sender
{
    if (_scrollerView.contentOffset.x == 470) {
        [self setscrollerviewContentOffset:nil];
        return;
    }
    if (self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        REMOVEDETAIL;
}
- (void)adjustLayout
{
    self.view.frame = [UIScreen mainScreen].bounds;
    contentView.frame = CGRectMake(272, 0, 480, 768);
    self.toolBarView.frame = CGRectMake(0, 708, 480, 60);
    _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y-90, _searchBar.frame.size.width, _searchBar.frame.size.height);
    _scrollerView.frame = CGRectMake(_scrollerView.frame.origin.x, _scrollerView.frame.origin.y-103, _scrollerView.frame.size.width, _scrollerView.frame.size.height);
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [skipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;

    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    skipButton.frame = skipRect;
    [skipButton addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:skipButton];
    toolBarView.backButton.frame = backRect;
    [toolBarView.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = self.detail_header.frame;
    frame.origin.y =frame.origin.y+10;
    self.detail_header.frame = frame;
    //[self.detail_header removeFromSuperview];
    HeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
    [header setDarkImage];
    header.headerTitle.text = @"邀请家人";
    header.headerTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [contentView addSubview:header];
    detail_header.hidden = YES;
    
}
- (void)selectSource:(id)sender
{
    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
    if (self.navigationController) {
        [self.navigationController pushViewController:con animated:YES];
        [con adjustLayout];
    }
    else
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
   
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
    [detail_header setViewDataWithLocal];
    _scrollerView.contentSize = CGSizeMake(self.view.frame.size.width*2, 0);
    [_scrollerView setScrollEnabled:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - my method(s)
- (IBAction)pushInviteListWithAnimation:(id)sender {
    [_searchBar.searchTextFiled resignFirstResponder];
    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
    con.kw = self.searchBar.searchTextFiled.text;
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
    con.searchBar.searchTextFiled.text = self.searchBar.searchTextFiled.text;
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 97;
    else
        return 101;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([dataArray count]>0) {
        return [dataArray count];
    }
    else
        return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"addFamilyCellId";
    addFamilyCell *cell=(addFamilyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [array objectAtIndex:4];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *aDcit = [dataArray objectAtIndex:indexPath.row];



    [cell setCellData:aDcit];
    return cell;
    
    
}

@end
