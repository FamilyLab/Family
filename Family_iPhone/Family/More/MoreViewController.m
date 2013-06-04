//
//  MoreViewController.m
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MoreViewController.h"
#import "MyButton.h"
#import "Common.h"
#import "MoreCell.h"
#import "AppDelegate.h"
#import "AddFriendsViewController.h"
#import "FamilyCardViewController.h"
#import "AddChildViewController.h"
#import "ThemeViewController.h"
#import "MyImagePickerController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
//#import "UIButton+WebCache.h"
#import "MyTabBarController.h"
#import "LoginViewController.h"
#import "DDAlertPrompt.h"
#import "TopicViewController.h"
#import "ChangePwViewController.h"
#import "FeedViewController.h"
#import "MyNavigationController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController
//@synthesize theScrollView, logoutBtn;
//@synthesize tipsDict;
@synthesize dataDict, tableHeader, headBtn, nameLbl, phoneNumLbl, birthDayLbl, tableFooter;

//static const char *headerText[4] = {"  家人", "  孩子资料", "  积分", "  设置"};
//static const char *cellIdText[5] = {"myInfoCellId", "familesCellId", "childCellId", "creditCellId", "settingCellId"};
//#define charToNSString(charText) [NSString stringWithUTF8String:charText]


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
//    dataDict = [[NSMutableDictionary alloc] init];
    self._tableView.loadMoreView.hidden = YES;
    self._tableView.tableHeaderView = self.tableHeader;
    self._tableView.tableFooterView = self.tableFooter;
    
//    SinaWeibo *sinaWiebo = [self sinaweibo];
    if (MY_HAS_BIND_SINA_WEIBO) {
//    if (!sinaWiebo.isAuthValid || sinaWiebo.isAuthorizeExpired) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _sectionTitleArray = [[NSArray alloc] initWithObjects:@"家人", @"孩子资料", @"查看", @"设置", @"关于", nil];
    //孩子资料后面暂时去掉“积分”，这里加上后，还需要改的地方有
    //1、_tipsArray（增加[NSArray arrayWithObjects:@"金币", @"VIP会员服务", nil],）
    //2、didSelectRowAtIndexPath里的creditSection
    //3、moreCell.h文件里的MoreCellSection这个枚举
    //4、moreCell.m文件里的creditSection，总共4个地方
    
    //[NSArray arrayWithObjects:@"金币", @"有奖任务", @"VIP会员服务", nil],
    _tipsArray = [[NSArray alloc] initWithObjects:
                  [NSArray arrayWithObjects:@"家人", @"家人申请", @"邀请家人", nil],
                  [NSArray arrayWithObjects:@"我还有一个孩子", nil],
                  
                  [NSArray arrayWithObjects:@"我的收藏", @"今日话题", nil],
                  [NSArray arrayWithObjects:@"主题", @"消息推送", @"启动时显示今日话题", @"修改密码", @"同步至新浪微博", @"同步至微信", nil],
                  [NSArray arrayWithObjects:@"关于我们", @"给我们打个分吧", nil],
                  nil];
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MORE_CON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestForMore:) name:REFRESH_MORE_CON object:nil];
    
//    _hint = [[EMHint alloc] init];
//    [_hint setHintDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MORE_CON object:nil];
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"更多"];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

//更改主题
- (void)configureViews {
    for (id obj in [self.view subviews]) {
        if ([obj isKindOfClass:[TopView class]]) {
            TopView *topView = (TopView*)obj;
            [topView changeTheme];
        }
    }
    [self._tableView reloadData];
}

- (void)sendRequest:(id)sender {
//    [SVProgressHUD showWithStatus:@"刷新中..."];
    if (currentPage == 1) {
        _tableView.pullTableIsRefreshing = YES;
    }
    [self sendRequestForMore:sender];
}

- (void)sendRequestForMore:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=setup&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:_tableView];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
            self.dataDict = nil;
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
            return;
        }
        [SVProgressHUD dismiss];
        self.dataDict = [dict objectForKey:WEB_DATA];
        BOOL hasBindSinaWeibo = [emptystr([self.dataDict objectForKey:@"sina_uid"]) isEqualToString:@""] ? NO : YES;
        [[NSUserDefaults standardUserDefaults] setBool:hasBindSinaWeibo forKey:HAS_BIND_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [self.headBtn setImageWithURL:[NSURL URLWithString:emptystr([dataDict objectForKey:AVATAR])] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        self.nameLbl.text = emptystr([dataDict objectForKey:NAME]);
        
        NSString *headUrl = [dataDict objectForKey:AVATAR];
        headUrl = [headUrl stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
//        [self.headBtn setImageWithNoCacheWithURL:[NSURL URLWithString:emptystr(headUrl)] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        [self.headBtn setImageForMyHeadButtonWithUrlStr:emptystr(headUrl) plcaholderImageStr:nil];
        [self.headBtn setVipStatusWithStr:emptystr([dataDict objectForKey:VIP_STATUS]) isSmallHead:NO];
        
        [ConciseKit setUserDefaultsWithObject:self.nameLbl.text forKey:NAME];
        
        NSMutableString *phone = [[NSMutableString alloc] initWithString:emptystr([dataDict objectForKey:PHONE])];
        [phone insertString:@"-" atIndex:3];
        [phone insertString:@"-" atIndex:8];
        self.phoneNumLbl.text = phone;
        self.birthDayLbl.text = emptystr([dataDict objectForKey:BIRTHDAY]);
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        [self stopLoading:_tableView];
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
//    return [[tipsDict allKeys] count];
    return [_sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 2) {
//        return childNum + 1;
//    } else return 1;
    if (section == 1) {
        return [[dataDict objectForKey:BABY_LIST] count] + 1;
    } else
        return [[_tipsArray objectAtIndex:section] count];//3
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 2) {
//        return 41;
//    } else if (indexPath.section == 4) {
//        return 275;
//    } else return 130;
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return nil;
//    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 30)];
    headerView.backgroundColor = color(242, 241, 235, 1.0);
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 300, 25)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [Common theLblColor];
    lbl.font = [UIFont boldSystemFontOfSize:15.0f];
//    lbl.text = charToNSString(headerText[section - 1]);
//    NSArray *tmpArray = [NSArray arrayWithObjects:@"家人", @"孩子资料", @"积分", @"查看", @"设置", nil];
    lbl.text = [_sectionTitleArray objectAtIndex:section];// [[tipsDict allKeys] objectAtIndex:section];
    [headerView addSubview:lbl];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    } else {
//        return 30;
//    }
    return 30;
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
//    cell.indexSection = indexPath.section;
    cell.seciontType = indexPath.section;
    cell.indexRow = indexPath.row;
    if (cell.seciontType != childSection) {
//    if (indexPath.section != 1) {
        cell.tipsLbl.text = [[_tipsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else {
        if (indexPath.row == [[dataDict objectForKey:BABY_LIST] count]) {
            cell.tipsLbl.text = @"我还有一个孩子";
        }
    }
    [cell initData:dataDict];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoreCellSection moreCellSectionType = indexPath.section;
    switch (moreCellSectionType) {
//    switch (indexPath.section) {
        case familySection://家人
        {
            if (indexPath.row == 0 || indexPath.row == 1) {//家人列表 或 家人申请
                FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
                con.conType = indexPath.row == 0 ? myFamilyListType : askForMyFamilyListType;
                [self.navigationController pushViewController:con animated:YES];
            } else if (indexPath.row == 2) {//邀请家人
                AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
                con.topViewType = notLoginOrSignIn;
                [self.navigationController pushViewController:con animated:YES];
            }
            break;
        }
        case childSection://孩子资料
        {
            AddChildViewController *con = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
            con.topViewType = notLoginOrSignIn;
            con.myHeadUrl = [dataDict objectForKey:AVATAR];
            con.myNameStr = [dataDict objectForKey:NAME];
            con.isShowChildInfo = YES;
            [self.navigationController pushViewController:con animated:YES];
            
            if (indexPath.row != [[dataDict objectForKey:BABY_LIST] count]) {//不是最后一行
                con.canEditChildInfo = YES;
                [con fillChildInfo:[[dataDict objectForKey:BABY_LIST] objectAtIndex:indexPath.row]];
            } else {//最后一行
                
            }
            break;
        }
//        case creditSection://积分
//        {
//            if (indexPath.row == 0) {//金币
//                [self showPhotoBorwserWithImageStr:@"aboutcoin", nil];
////            }
////            else if (indexPath.row == 1) {//有奖任务列表
////                FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
////                con.conType = taskListType;
////                [self.navigationController pushViewController:con animated:YES];
//            } else if (indexPath.row == 1) {//VIP会员服务
//                [self showPhotoBorwserWithImageStr:@"aboutvip", nil];
//            }
//            break;
//        }
        case watchSection://查看
        {
            if (indexPath.row == 0) {//我的收藏
                FeedViewController *con = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
                con.isForMyLoveFeed = YES;
                [self.navigationController pushViewController:con animated:YES];
            } else if (indexPath.row == 1) {//今日话题
                TopicViewController *con = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
                con.isFromMoreCon = YES;
                [self.navigationController pushViewController:con animated:YES];
            }
            break;
        }
        case settingSection://设置
        {
            if (indexPath.row == 0) {//主题
                ThemeViewController *con = [[ThemeViewController alloc] initWithNibName:@"ThemeViewController" bundle:nil];
                [self.navigationController pushViewController:con animated:YES];
            } else if (indexPath.row == 1) {//推送
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:@"如果要修改Family的新消息通知，请在iPhone的”设置“－”通知“功能中，找到应用程序“Family”进行更改"];
                [alert setCancelButtonWithTitle:@"确认" handler:^{
                    return ;
                }];
                [alert show];
            } else if (indexPath.row == 2) {//启动时显示今日话题
                [[NSUserDefaults standardUserDefaults] setBool:!MY_WANT_SHOW_TODAY_TOPIC forKey:WANT_SHOW_TODAY_TOPIC];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_tableView reloadData];
            } else if (indexPath.row == 3) {//修改密码
                ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
                con.aboutPwd = changePwd;
                [self.navigationController pushViewController:con animated:YES];
            } else if (indexPath.row == 4) {//绑定新浪微博
                if (MY_HAS_BIND_SINA_WEIBO) {
//                if (sinaWiebo.isAuthValid && !sinaWiebo.isAuthorizeExpired) {
//                if ((MY_HAS_BIND_SINA_WEIBO && [[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) && sinaWiebo.isAuthValid && !sinaWiebo.isAuthorizeExpired) {
                    [[NSUserDefaults standardUserDefaults] setBool:!MY_SHARE_TO_SINA_WEIBO forKey:SHARE_TO_SINA_WEIBO];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [_tableView reloadData];
                } else {
                    [self loginSinaWeibo];
                }
            } else if (indexPath.row == 5) {//绑定微信
                [[NSUserDefaults standardUserDefaults] setBool:!MY_HAS_BIND_WEIXIN forKey:HAS_BIND_WEIXIN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_tableView reloadData];
            }
            break;
        }
        case aboutSection://关于
        {
            if (indexPath.row == 0) {//关于我们
                [self showPhotoBorwserWithImageStr:@"aboutfamily", nil];
            } else if (indexPath.row == 1) {//给我们打个分吧
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=538285014"]];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - MWPhotoBrowser
- (void)showPhotoBorwserWithImageStr:(NSString*)imageStr, ... {
    if (imageStr) {
        if (self.photosArray) {
            [self.photosArray removeAllObjects];
            self.photosArray = nil;
        }
        self.photosArray = [[NSMutableArray alloc] init];
        
        [_photosArray addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:imageStr ofType:@"jpg"]]];
        
        va_list list;
        id arg;
        va_start(list, imageStr);
        while ((arg = va_arg(list, id))) {
            [_photosArray addObject:[MWPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:arg ofType:@"jpg"]]];
        }
        va_end(list);
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.wantsFullScreenLayout = YES;
        browser.displayActionButton = YES;
        browser.isOnlyNeedBackBtn = YES;
        [browser setInitialPageIndex:0];
        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:browser];
        nav.navigationBarHidden = YES;
        [self presentModalViewController:nav animated:YES];
    }
    
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photosArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photosArray.count)
        return [_photosArray objectAtIndex:index];
    return nil;
}

#pragma mark cell action
//个人信息section
//头像
- (IBAction)headBtnPressed:(id)sender {
    MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
    [picker showImagePickerMenu:@"设置我的头像" buttonTitle:@"打开相机" sender:sender];
    MyTabBarController *tabBarCon = (MyTabBarController*)self.parentViewController;
    [picker.ImagePickerMenu showFromTabBar:tabBarCon.tabBar];
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
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", AVATAR_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"头像修改成功"];
        //保存头像
        [Common saveImage:_image withQuality:1.0f saveKey:AVATAR];
//        NSData *headImgData = UIImageJPEGRepresentation(_image, 0.8);
//        NSData *encodeHeadImgData = [NSKeyedArchiver archivedDataWithRootObject:headImgData];
//        [ConciseKit setUserDefaultsWithObject:encodeHeadImgData forKey:AVATAR];
        
        [headBtn setImage:_image forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//名字
- (IBAction)nameBtnPressed:(id)sender {
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"修改昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    alertPrompt.theTextView.text = nameLbl.text;
    __block DDAlertPrompt *blockAlert = alertPrompt;
    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        [SVProgressHUD showWithStatus:@"修改昵称中..."];
        NSString *url = $str(@"%@name", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:blockAlert.theTextView.text, NAME, @"1", NAME_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
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
            [ConciseKit setUserDefaultsWithObject:blockAlert.theTextView.text forKey:NAME];
            nameLbl.text = blockAlert.theTextView.text;
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alertPrompt show];
}

//手机
- (IBAction)phoneNumBtnPressed:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"不能修改T_T"];
}


//生日
- (IBAction)birthdayBtnPressed:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
    MyTabBarController *con = (MyTabBarController*)myTabBarController;
//    [_hint presentModalMessage:@"" where:con.view];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    datePicker.datePickerMode = UIDatePickerModeDate;
    CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
    datePicker.frame = [self pickerFrameWithSize:pickerSize];
        
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 40)];
    topView.barStyle = UIBarStyleBlack;
//        UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered target:self action:@selector(currDateBtnPressed)];
    __block UIButton *blockSender = sender;
    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
        [datePicker removeFromSuperview];
        blockSender.userInteractionEnabled = YES;
    }];
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        
        NSDate *selectedDate = [datePicker date];
        if ([selectedDate compare:[NSDate date]] == NSOrderedDescending) {
            [SVProgressHUD showErrorWithStatus:@"生日不能超过当前时间T_T"];
            return ;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
        
        [SVProgressHUD showWithStatus:@"修改生日中..."];
        NSString *url = $str(@"%@birth", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:dateString, BIRTH, @"1", BIRTH_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [self performBlock:^(id sender) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } afterDelay:0.5f];
            birthDayLbl.text = dateString;
            [datePicker removeFromSuperview];
            blockSender.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    NSArray *btnArray = [NSArray arrayWithObjects:spaceBtn, cancleBtn, doneBtn, nil];
    [topView setItems:btnArray];
    [datePicker addSubview:topView];
    
    //add this picker to our view controller, initially hidden
//    MyTabBarController *con = (MyTabBarController*)myTabBarController;
    [con.view addSubview:datePicker];
//    [self.view addSubview:datePicker];
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(0, screenRect.size.height - size.height, size.width, size.height);//50为tabbar的高度
	return pickerRect;
}

//退出登陆
- (IBAction)logoutBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出登录？"];
    [alert addButtonWithTitle:@"确定" handler:^{
        [SVProgressHUD showWithStatus:@"退出登录中..." maskType:SVProgressHUDMaskTypeGradient];
        NSString *url = [NSString stringWithFormat:@"%@do.php?ac=logout&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
        [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
            [self stopLoading:sender];
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                reLoginForAuthFailure(dict);
                return ;
            }
            [SVProgressHUD dismiss];
            SinaWeibo *sinaWeibo = [self sinaweibo];
            [sinaWeibo logOut];
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate logoutFamily];
        } failure:^(NSError *error) {
            NSLog(@"error%@", error);
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alert setCancelButtonWithTitle:@"取消" handler:^{
        return ;
    }];
    [alert show];
}

#pragma mark - sina weibo
- (void)loginSinaWeibo {
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) {
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
//    [self uploadRequestToSinaWeibo:sinaweibo];
    [self uploadRequestToBindSinaWeibo];
    [_tableView reloadData];
//    [self storeAuthData];
//    [SVProgressHUD showWithStatus:@"绑定中..."];
//    NSString *url = $str(@"%@bindweibo", POST_API);
//    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"sina", TYPE, sinaweibo.userID, ID, sinaweibo.accessToken, @"token", MY_M_AUTH, M_AUTH, nil];
//    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//        ;
//    } onCompletion:^(NSDictionary *dict) {
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"error:%@", [error description]);
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//    }];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (MY_HAS_LOGIN) {
//        [sinaweibo logIn];
//    }
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

#pragma mark - hint deleage
-(UIView*)hintStateViewToHint:(id)hintState {
    return _birthdayBtn;
    //    return _info;
}

//- (CGRect)hintStateRectToHint:(id)hintState {
//    return CGRectMake(100, 30, 170, 37);
//}

//-(UIView*)hintStateViewForDialog:(id)hintState
//{
//    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
//    
//    [l setBackgroundColor:[UIColor clearColor]];
//    [l setTextColor:[UIColor whiteColor]];
//    [l setText:@"I am the info button!"];
//    return l;
//}

- (void)hintStateWillClose:(id)hintState {
    MyTabBarController *con = (MyTabBarController*)myTabBarController;
    for (id obj in con.view.subviews) {
        if ([obj isKindOfClass:[UIDatePicker class]]) {
            UIDatePicker *datePicker = (UIDatePicker*)obj;
            [datePicker removeFromSuperview];
            _birthdayBtn.userInteractionEnabled = YES;
        }
    }
}
- (void)hintStateDidClose:(id)hintState {
}


@end
