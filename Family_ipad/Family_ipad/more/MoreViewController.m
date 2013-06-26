//
//  MoreViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MoreViewController.h"
#import "HeaderView.h"
#import "DetailBaseViewController.h"
#import "InviteFamilyViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "ApplyFamilyViewController.h"
#import "MoreCell.h"
#import "FamilyCardViewController.h"
#import "AddChildViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+WebCache.h"
#import "SVProgressHUD.h"
#import "DDAlertPrompt.h"
#import "UIAlertView+BlocksKit.h"
#import "NSObject+BlocksKit.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UIActionSheet+BlocksKit.h"
#import "TaskViewController.h"
#import "AboutViewController.h"
#import "SinaWeibo.h"
#import "CKMacros.h"
#import "ChangePwViewController.h"
#import "KGModal.h"
#import "ZoneWaterFallView.h"
#import "NewsViewController.h"
#import "BlockAlertView.h"
#import "BlockTextPromptAlertView.h"

#define childNum  3//假数据
#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface MoreViewController ()
{
    NSString *tempBirthStr;
}
@end

@implementation MoreViewController
- (IBAction)openTopic:(id)sender
{
    
}
//退出登陆
- (IBAction)logoutBtnPressed:(id)sender {
    [SVProgressHUD showWithStatus:@"退出登录中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = [NSString stringWithFormat:@"%@do.php?ac=logout&m_auth=%@", BASE_URL, GET_M_AUTH];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            [[AppDelegate instance] logout];

            return ;
        }
      

      
        [SVProgressHUD dismiss];
        [[AppDelegate instance] logout];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];

        
    }];
}

- (IBAction)phoneBtnPressed:(id)sender
{
    
}
- (void)sendRequest:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=setup&m_auth=%@", BASE_URL, GET_M_AUTH];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            return ;
        }
        if (needRemoveObjects == YES) {
            self.dataDict = nil;
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            return;
        }
        self.dataDict = [dict objectForKey:WEB_DATA];
        NSString *bigHead = $str([[self.dataDict objectForKey:AVATER] stringByReplacingOccurrencesOfString:@"_small.jpg" withString:@"_big.jpg"]);
        [[PDKeychainBindings sharedKeychainBindings] setObject:$safe([_dataDict objectForKey:SINA_UID]) forKey:SINA_UID];
        [[PDKeychainBindings sharedKeychainBindings] setObject:$safe([_dataDict objectForKey:QQ_UID]) forKey:QQ_UID];

        [self.headBtn setBackgroundImageWithURL:[NSURL URLWithString:bigHead] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        self.nameLbl.text = [self.dataDict  objectForKey:NAME];
        NSMutableString *phone = [[NSMutableString alloc] initWithString:[self.dataDict objectForKey:PHONE]];
        [phone insertString:@"-" atIndex:3];
        [phone insertString:@"-" atIndex:8];
        self.phoneNumLbl.text = phone;
        self.birthDayLbl.text = [self.dataDict  objectForKey:BIRTHDAY];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [self stopLoading:sender];
        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}
- (IBAction)familyNewsAction:(id)sender
{
    REMOVEDETAIL;
    
    if (sender == _familyNewsButton) {
        DetailBaseViewController *detailViewController = [[DetailBaseViewController alloc] initWithNibName:@"DetailBaseViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
        detailViewController.header.titleLabel.text = @"我的家人";
    }
    if (sender == _applyFamilyButton) {
         ApplyFamilyViewController *detailViewController = [[ApplyFamilyViewController alloc] initWithNibName:@"ApplyFamilyViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
        
    }
    if (sender == _inviteFamilyButton) {
        InviteFamilyViewController  *detailViewController = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _titleArray = $arr(@"家人",@"孩子资料",@"查看",@"设置");
        
        //self.tableView.tableFooterView = self.tableFooter;
        _contentArray = [[NSArray alloc] initWithObjects:
                          [NSArray arrayWithObjects:@"家人", @"家人申请", @"邀请家人", nil],
                          [NSArray arrayWithObjects:@"我还有一个孩子", nil],
                         [NSArray arrayWithObjects:@"今日话题", @"收藏",nil],
                          [NSArray arrayWithObjects:@"今日话题", @"消息推送",@"新浪微博绑定", @"修改密码",@"给我们打个分吧",@"关于我们",nil],nil];
                  
        tempBirthStr = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _header.headerTitle.text =@"更多";
    self._tableView.loadMoreView.hidden = YES;
    self._tableView.tableHeaderView = self.tableHeader;
    if ([self._tableView respondsToSelector:@selector(backgroundView)])
        self._tableView.backgroundView = nil;
    _tableView.tableFooterView = self.tableFooter;
    if([UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone){
        [ConciseKit setUserDefaultsWithObject:$bool(NO) forKey:PUSH_MARK];
    }else{
        [ConciseKit setUserDefaultsWithObject:$bool(YES) forKey:PUSH_MARK];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [[self.dataDict objectForKey:BABY_LIST] count] + 1;
    } else if (section == 3)
        return 6;
    else if(section ==0 )
            return 3;
    else if(section ==2)
        return 2;
        else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
        return 40;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 8, 300, 25)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:24.0f];
    lbl.textColor = color(157, 212, 74, 1.0);
    lbl.text = $str(@"     %@",[_titleArray  objectAtIndex:section]);
    [headerView addSubview:lbl];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreCell *cell;
    static NSString *moreCellId = @"moreCellId";
    cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];

    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil];
        //		cell = [array objectAtIndex:indexPath.section];
		cell = [array objectAtIndex:0];
    }
    cell.indexSection = indexPath.section;
    cell.indexRow = indexPath.row;
    if (indexPath.section != 1) {
        cell.firstLbl.text = [[_contentArray  objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        if (indexPath.row == [[_dataDict objectForKey:BABY_LIST] count]) {
             cell.firstLbl.text = @"我还有一个孩子";
            cell.rightImgView.image = [UIImage imageNamed:@"addchild.png"];

        }
    }
    if (_dataDict) {
        [cell initData:_dataDict];
    }
    return cell;
}
- (SinaWeibo *)sinaWiebo
{
    return [AppDelegate instance].sinaweibo;
}
#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    REMOVEDETAIL;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DetailBaseViewController *detailViewController = [[DetailBaseViewController alloc] initWithNibName:@"DetailBaseViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
            detailViewController.header.titleLabel.text = @"我的家人";
        }
        else if(indexPath.row == 1)
        {
            ApplyFamilyViewController *detailViewController = [[ApplyFamilyViewController alloc] initWithNibName:@"ApplyFamilyViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
        }
        else if(indexPath.row==2)
        {
            InviteFamilyViewController  *detailViewController = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row !=[[_dataDict objectForKey:BABY_LIST] count]) {
            AddChildViewController  *detailViewController = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
            detailViewController.editMode = YES;
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
            [detailViewController setBabyDataWith:[[_dataDict objectForKey:BABY_LIST]  objectAtIndex:indexPath.row]];
        }
        else
        {
            AddChildViewController  *detailViewController = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
        }
    }
//    else if (indexPath.section == 2)
//    {
//        AboutViewController  *detailViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
//
//        if (indexPath.row == 0) {
//            detailViewController.type = money_image;
//        }
//        else if (indexPath.row == 1) {
//            detailViewController.type = vip_image;
//        }
//        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
//
//    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            ZoneWaterFallView *view = [[ZoneWaterFallView alloc]initWithFrame:CGRectMake(0, 0, 1024-100, 768)];
            view.contentType = TODAY_TOPIC;
            [view loadDataSource:[NSNumber numberWithInt:TODAY_TOPIC]];
            [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];
        }
        if (indexPath.row == 1) {
            NewsViewController  *con = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
            con.isLove = YES;
            con.view.frame = CGRectMake(0, 0, 480, 768);
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
            
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:@"如果要修改FamilyHD的新消息通知，请在iPad的”设置“－”通知“功能中，找到应用程序“FamilyHD”进行更改"];
            [alert setCancelButtonWithTitle:@"确认" handler:^{
                return ;
            }];
            [alert show];
        }
        else if(indexPath.row == 2){
            //sina weibo
            if (isEmptyStr([_dataDict objectForKey:SINA_UID])||![self sinaWiebo].isAuthValid || [self sinaWiebo].isAuthorizeExpired){
                [AppDelegate instance].sinaweibo.delegate = self;
                [[AppDelegate instance].sinaweibo logIn];
            }
        }
        else if(indexPath.row == 3){
            ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
            con.view.frame = con.contentView.frame;
            con.contentView.frame = CGRectMake(0, 0, 480, 768);
            con.aboutPwd = changePwd;
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];

        }
        else if(indexPath.row == 4){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/familyhd/id635791315?ls=1&mt=8"]];

        }
        else if (indexPath.row == 5){
            AboutViewController  *detailViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            detailViewController.type = about_image;
            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];

        }
//        else if (indexPath.row == 6){
//            TaskViewController  *detailViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
//            [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:self isStackStartView:FALSE];
//            
//        }
    }
   
}
//个人信息section
//头像
- (IBAction)headBtnPressed:(id)sender {
    _picker = [[MyImagePickerController alloc]initWithParent:self];
    [_picker showImagePickerMenu:@"本地照片" buttonTitle:@"拍一张照片" sender:sender];
}

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
}

- (void)saveImage:(UIImage*)_image {
    [SVProgressHUD showWithStatus:@"修改头像中..."];
    NSString *url = $str(@"%@avatar", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", AVATAR_SUBMIT, POST_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 1.0f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"头像修改成功"];
        //保存头像
        NSData *headImgData = UIImageJPEGRepresentation(_headBtn.imageView.image, 0.8);
        NSData *encodeHeadImgData = [NSKeyedArchiver archivedDataWithRootObject:headImgData];
        [ConciseKit setUserDefaultsWithObject:encodeHeadImgData forKey:AVATER];
        
        [_headBtn setImage:_image forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//名字
- (IBAction)nameBtnPressed:(id)sender {
//    UITextField *textField;
//    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"修改昵称" message:@"" textField:&textField block:^(BlockTextPromptAlertView *alert){
//        [alert.textField resignFirstResponder];
//        return YES;
//    }];
//    
//    
//    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
//    [alert addButtonWithTitle:@"Okay" block:^{
//        NSLog(@"Text: %@", textField.text);
//    }];
//    [alert show];
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"修改昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];

    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        [SVProgressHUD showWithStatus:@"修改昵称中..."];
        NSString *url = $str(@"%@name", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:alertPrompt.theTextView.text, NAME, @"1", NAME_SUBMIT, POST_M_AUTH,M_AUTH , nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } afterDelay:0.5f];
            //保存昵称
            [ConciseKit setUserDefaultsWithObject:alertPrompt.theTextView.text forKey:NAME];
            _nameLbl.text = alertPrompt.theTextView.text;   
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    alertPrompt.theTextView.text= _nameLbl.text;

    [alertPrompt show];
}
-(void)modifyBirth:(NSString *)dateString
{
    
    if (tempBirthStr==nil) {
         [SVProgressHUD showErrorWithStatus:@"选中了无效日期..."];
    }
    else{
        [SVProgressHUD showWithStatus:@"修改生日中..."   ];
        
        NSString *url = $str(@"%@birth", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:tempBirthStr, BIRTH, ONE, BIRTH_SUBMIT, POST_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } afterDelay:0.5f];
            _birthDayLbl.text = tempBirthStr;
            [_datePickerContainer dismissPopoverAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }
    
    
}
- (IBAction)birthdayBtnPressed:(UIButton *)sender {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
    
    //build our custom popover view
    UIViewController* popoverContent = [[UIViewController alloc]                                            init];
    UIView* popoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    datePicker.frame = CGRectMake(0, 44, 320, 300);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor grayColor];
    btn.frame = CGRectMake (0, 0, datePicker.frame.size.width, 44);
    [btn addTarget:self action:@selector(modifyBirth:) forControlEvents:UIControlEventTouchUpInside];
    [popoverView addSubview:btn];
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;        //resize the popover view shown        //in the current view to the view&apos;s size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 244);        //create a popover controller
    _datePickerContainer = [[UIPopoverController alloc]                                  initWithContentViewController:popoverContent];        //present the popover view non-modal with a        //refrence to the button pressed within the current view
    CGRect rect = CGRectMake(sender.frame.origin.x/2, sender.frame.origin.y-200, 320, 300) ;

    [_datePickerContainer presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
  
}
- (void)didSelectDate:(UIDatePicker *)pickerView
{
    
    NSDate *selectedDate = [pickerView date];
    if ([selectedDate compare:[NSDate date]] == NSOrderedDescending) {
        [SVProgressHUD showErrorWithStatus:@"生日不能超过当前时间T_T"];
        return ;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
    tempBirthStr = $str(dateString);
    
}
#pragma mark - sina weibo
- (void)loginSinaWeibo {
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    if ([ConciseKit userDefaultsObjectForKey:SINA_AUTH_DATA]) {
        [sinaweibo logOut];
    } else {
        [sinaweibo logIn];
    }
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate = self;
    return delegate.sinaweibo;
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
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
@end
