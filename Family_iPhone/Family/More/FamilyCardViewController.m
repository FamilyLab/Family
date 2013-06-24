//
//  FamilyCardViewController.m
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FamilyCardViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "FamilyListViewController.h"
#import "ZoneViewController.h"
#import "DDAlertPrompt.h"
#import "MPNotificationView.h"

@interface FamilyCardViewController ()
- (IBAction)familyBtnPressed:(id)sender;
- (IBAction)zoneBtnPressed:(id)sender;
@end

@implementation FamilyCardViewController
@synthesize isMyFamily, familyCardView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isMyFamily = YES;
        _isMyChild = NO;
        isFirstShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
    [self addBottomView];
    [self sendRequestToCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"名片"];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (void)addBottomView {
    if (self.bottomView) {
        [_bottomView removeFromSuperview];
        self.bottomView = nil;
    }
    NSArray *normalImages;
    if (isMyFamily) {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
    } else {
        normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"menu_add", nil];
    }
    BottomView *tmpView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    tmpView.delegate = self;
    self.bottomView = tmpView;
    [self.view addSubview:tmpView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0://后退
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1://加为好友
        {
            if ([emptystr([_dataDict objectForKey:UID]) isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩啦T_T"];
                return ;
            }
            if (_button.selected) {
                [SVProgressHUD showErrorWithStatus:@"已发过申请T_T"];
                return;
            }
            DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"申请成为家人" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
            __block DDAlertPrompt *blockAlert = alertPrompt;
            [alertPrompt addButtonWithTitle:@"确认" handler:^{
                [SVProgressHUD showWithStatus:@"发送申请中..."];
                NSString *url = $str(@"%@friend&op=add", POST_CP_API);
                NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:emptystr([_dataDict objectForKey:UID]), APPLY_UID, ONE, G_ID, blockAlert.theTextView.text, NOTE, ONE, ADD_SUBMIT, MY_M_AUTH, M_AUTH, nil];
                [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
                } onCompletion:^(NSDictionary *dict) {
                    if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                        return ;
                    }
                    _button.selected = YES;
                    [SVProgressHUD showSuccessWithStatus:@"申请已发送"];
                } failure:^(NSError *error) {
                    NSLog(@"error:%@", [error description]);
                    [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
                    _button.selected = NO;
                }];
            }];
            [alertPrompt show];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (isFirstShow) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
}

- (void)sendRequestToCard {
//    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@?do=friend&m_auth=%@&fuid=%@", SPACE_API, [MY_M_AUTH urlencode], self.userId];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        isFirstShow = NO;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
//        [SVProgressHUD showSuccessWithStatus:@"加载完成^_^"];
//        NSDictionary *data = [dict objectForKey:WEB_DATA];
        self.dataDict = [dict objectForKey:WEB_DATA];
        BOOL isFamily;
        if ([emptystr([_dataDict objectForKey:UID]) isEqualToString:MY_UID]) {
            isFamily = YES;
        } else
            isFamily = [[_dataDict objectForKey:IS_FAMILY] boolValue];
        isMyFamily = isFamily;
        [self addBottomView];
        
        [self.familyCardView.headBtn setVipStatusWithStr:emptystr([_dataDict objectForKey:VIP_STATUS]) isSmallHead:NO];
        NSString *allNameStr = emptystr([_dataDict objectForKey:NAME]);
        if (!isEmptyStr([_dataDict objectForKey:NOTE])) {
            allNameStr = $str(@"%@(%@)", allNameStr, [_dataDict objectForKey:NOTE]);
        }
        self.familyCardView.userId = _userId;
        self.familyCardView.nameStr = emptystr([_dataDict objectForKey:NAME]);
        self.familyCardView.noteNameStr = emptystr([_dataDict objectForKey:NOTE]);
        [self.familyCardView initCardDataWithIsMyFamily:isFamily
                                            headUrlStr:[_dataDict objectForKey:AVATAR]
                                               nameStr:allNameStr
                                           phoneNumStr:emptystr([_dataDict objectForKey:PHONE])
                                           birthdayStr:emptystr([_dataDict objectForKey:BIRTHDAY])
                                                tipStr:@""
                                             familyNum:[emptystr([_dataDict objectForKey:FAMILY_MEMBERS]) intValue]
                                            zoneNumStr:emptystr([_dataDict objectForKey:FAMILY_TAGS])
                                      lastLoginDateStr:[Common convertToDate:emptystr([_dataDict objectForKey:LAST_LOGIN])]];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (IBAction)changeNoteNameBtnPressed:(id)sender {
    ;
}

//进入家人列表
- (IBAction)familyBtnPressed:(id)sender {
    FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
    con.conType = myFamilyListType;
    con.userId = emptystr([_dataDict objectForKey:UID]);
    [self.navigationController pushViewController:con animated:YES];
}

//进入空间列表
- (IBAction)zoneBtnPressed:(id)sender {
    ZoneViewController *con = [[ZoneViewController alloc] initWithNibName:@"ZoneViewController" bundle:nil];
    con.userId = emptystr([_dataDict objectForKey:UID]);
    con.isOnlyShowMyZone = YES;
    [self.navigationController pushViewController:con animated:YES];
}

//发送私信
- (IBAction)postPMBtnPressed:(id)sender {
    if ([emptystr([_dataDict objectForKey:UID]) isEqualToString:MY_UID]) {
        [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩啦T_T"];
        return ;
    }
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"发送私信" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    __block DDAlertPrompt *blockAlert = alertPrompt;
    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        if (blockAlert.theTextView.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"没有输入内容T_T"];
            return ;
        }
        [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:0.5f];
//        [SVProgressHUD showWithStatus:@"发送中..."];
        NSString *url = $str(@"%@pm&op=send", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:emptystr([_dataDict objectForKey:UID]), PM_TO_UID, blockAlert.theTextView.text, MESSAGE, @"", LAT, @"", LNG, @"", ADDRESS, IPHONE, COME, ONE, PM_SUBMIT, MY_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [MPNotificationView notifyWithText:@"发送私信成功" detail:nil andDuration:0.5f];
//            [SVProgressHUD showSuccessWithStatus:@"发送私信成功"];
        } failure:^(NSError *error) {
            NSLog(@"error:%@", [error description]);
            [MPNotificationView notifyWithText:@"发送私信失败T_T" detail:nil andDuration:0.5f];
//            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alertPrompt show];
}

//打电话
- (IBAction)callBtnPressed:(id)sender {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        [SVProgressHUD showErrorWithStatus:@"你的设备不能拨打电话T_T"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打电话" message:[_dataDict objectForKey:PHONE]];
    [alert setCancelButtonWithTitle:@"取消" handler:^{
        return ;
    }];
    [alert addButtonWithTitle:@"确认" handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:$str(@"tel://%@", [_dataDict objectForKey:PHONE])]];
    }];
    [alert show];
}


@end
