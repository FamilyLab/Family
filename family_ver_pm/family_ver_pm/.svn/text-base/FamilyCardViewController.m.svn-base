//
//  FamilyCardViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-4-1.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FamilyCardViewController.h"
#import "FamilyListViewController.h"
#import "DDAlertPrompt.h"
#import "DialogueDetailViewController.h"
#import "UIView+BlocksKit.h"
#import "UIGestureRecognizer+BlocksKit.h"

//#import "ConciseKit.h"

@interface FamilyCardViewController ()

@end

#define AdjustCallBtnFrame CGRectMake(8, 220, 303, 54)
#define AdjustTheScrollerView CGSizeMake(320, 320)

@implementation FamilyCardViewController
@synthesize userId, userName, dataDict;
@synthesize theScrollView, headBtn, vipTipImg, nameLbl, nicknameLbl, phoneLbl, birthLbl, tipsLbl, countPerLbl, countPerBtn,countSpaceLbl, countSpaceBtn, settingBtn, callBtn, messageBtn, lastLoginLbl, appendView, detailsView;

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
    
    [self setTheInterface];
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    
    theScrollView.frame = CGRectMake(0, 65, DEVICE_SIZE.width, DEVICE_SIZE.height);
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, 720);
    dataDict = [[NSMutableDictionary alloc] init];
    
    
    [self sendRequestToFamilyCard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheInterface
{
    [countPerBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [countPerBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [countPerBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    countPerBtn.tag = kTheInterfaceButtonTag;
    [countPerBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [countSpaceBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [countSpaceBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [countSpaceBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    countSpaceBtn.tag = kTheInterfaceButtonTag + 1;
    [countSpaceBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [settingBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [settingBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [settingBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    settingBtn.tag = kTheInterfaceButtonTag + 2;
    [settingBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [callBtn setImage:[UIImage imageNamed:@"call_a_family.png"] forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"call_b_family.png"] forState:UIControlStateHighlighted];
    [callBtn setImage:[UIImage imageNamed:@"call_b_family.png"] forState:UIControlStateSelected];
    callBtn.tag = kTheInterfaceButtonTag + 3;
    [callBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[messageBtn setImage:[UIImage imageNamed:@"call_a_family.png"] forState:UIControlStateNormal];
    //[messageBtn setImage:[UIImage imageNamed:@"call_b_family.png"] forState:UIControlStateHighlighted];
    //[messageBtn setImage:[UIImage imageNamed:@"call_b_family.png"] forState:UIControlStateSelected];
    messageBtn.tag = kTheInterfaceButtonTag + 4;
    [messageBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [headBtn whenTapped:^{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(160, 240, 0, 0)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5f;
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 240, 0, 0)];
        NSString *tempUrl = [[NSMutableString alloc] initWithString:@""];
        if (dataDict != nil) {
            tempUrl = [dataDict objectForKey:AVATAR];
            tempUrl = [tempUrl stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
        }
        [headView setImageWithURL:[NSURL URLWithString:tempUrl] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location){
            [headView removeFromSuperview];
            [bgView removeFromSuperview];
        }];
        gesture.delegate = self;
        [bgView addGestureRecognizer:gesture];
        [gesture release];
        
        [UIView animateWithDuration:0.5f animations:^{
            [bgView setFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
            [headView setFrame:CGRectMake(20, 90, 280, 280)];
        }];
        
        [self.view addSubview:bgView];
        [bgView release];
        [self.view addSubview:headView];
        [headView release];
    }];
}

-(void)setTheTopBarView
{
    customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, 320, 65) TheFrameWidth:@"168"];
    customTopBarView.themeLbl.text = @"家人名片";
    //customTopBarView.familyLbl.text = @"杜拉拉";
    //customTopBarView.countPerLbl.hidden = NO;
    [self.view addSubview:customTopBarView];
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

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)buttonPressed:(UIButton*)_button
{
    int tag = _button.tag - kTheInterfaceButtonTag;
    switch (tag) {
        case 0:
        {
            FamilyListViewController *_con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
            _con.userId = [dataDict objectForKey:UID];
            _con.userName = [dataDict objectForKey:NAME];
            [self presentModalViewController:_con animated:YES];
            [_con release], _con = nil;
        }
            break;
        case 1:
        {
            NSLog(@"个人空间"); 
        }
            break;
        case 2:
        {
            DDAlertPrompt *settingPrompt = [[DDAlertPrompt alloc] initWithTitle:@"修改备注" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
            [settingPrompt addButtonWithTitle:@"确定" handler:^{
                NSString *url = $str(@"%@/dapi/cp.php?ac=friend&op=changenote", BASE_URL);
                NSMutableDictionary *para = $dict([dataDict objectForKey:UID], FAMILY_UID, settingPrompt.theTextView.text, NOTE, @"1", CHANGENOTE_SUBMIT, [SBToolKit getMAuth] , M_AUTH,  nil);
                [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
                    
                }onCompletion:^(NSDictionary *dict){
                    if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                        return ;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                    nicknameLbl.text = settingPrompt.theTextView.text;
                }failure:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"网络不好"];
                    NSLog(@"error:%@", [error description]);
                }];
            }];
            [settingPrompt show];
            [settingPrompt release];
        }
            break;
        case 3:
        {
            if ([[dataDict objectForKey:UID] isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩了"];
                return;
            }
            if (![[dataDict objectForKey:IS_MY_FAMILY] boolValue]) {
                DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
                alertPrompt.theTextView.text = [NSString stringWithFormat:@"你好！我是%@,我想申请成为你的家人。", [self.delegate returnUserNickName]];
                [alertPrompt addButtonWithTitle:@"确认" handler:^{
                    [SVProgressHUD showWithStatus:@"发送申请中..."];
                    NSString *url = $str(@"%@/dapi/cp.php?ac=friend&op=add", BASE_URL);
                    NSMutableDictionary *para = $dict([dataDict objectForKey:UID], APPLY_UID, ONE, G_ID, alertPrompt.theTextView.text, NOTE, ONE, ADD_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
                    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
                        
                    }onCompletion:^(NSDictionary *dict){
                        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                            return ;
                        }
                        [SVProgressHUD showSuccessWithStatus:@"申请发送成功，等待对方验证。"];
                    }failure:^(NSError *error){
                        [SVProgressHUD showErrorWithStatus:@"网络不好"];
                        NSLog(@"error:%@", [error description]);
                    }];
                }];
                [alertPrompt show];
                [alertPrompt release], alertPrompt = nil;
            }else{
                if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
                {
                    [SVProgressHUD showErrorWithStatus:@"您的设备不能够打电话！"];
                    return;
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打电话:" message:[dataDict objectForKey:PHONE] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert addButtonWithTitle:@"确定" handler:^{
                    [[UIApplication sharedApplication] openURL:[NSString stringWithFormat:@"tel://%@", [dataDict objectForKey:PHONE]]];
                }];
                [alert show];
                [alert release];
            }
            
        }
            break;
        case 4:
        {
            /*
            NSLog(@"发私信");
            DialogueDetailViewController *_con = [[DialogueDetailViewController alloc] initWithNibName:@"DialogueDetailViewController" bundle:nil];
            [self presentModalViewController:_con animated:YES];
            [_con release], _con = nil;
             */
            
            [self uploadRequestToPM];
        }
            break;
        default:
            break;
    }
}

-(void)uploadRequestToPM
{
    if ([[dataDict objectForKey:UID] isEqualToString:MY_UID]) {
        [SVProgressHUD showErrorWithStatus:@"这是你自己，不要玩了T_T"];
        return;
    }
    DDAlertPrompt *PMPrompt = [[DDAlertPrompt alloc] initWithTitle:@"说点什么吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    [PMPrompt addButtonWithTitle:@"发送" handler:^{
        if (PMPrompt.theTextView.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入内容"];
            return ;
        }
        NSString *url = $str(@"%@/dapi/cp.php?ac=pm&op=send", BASE_URL);
        //NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:];
        NSMutableDictionary *para = $dict([dataDict objectForKey:UID],PM_TO_UID, PMPrompt.theTextView.text, MESSAGE, @"", LAT, @"", LNG, @"", ADDRESS, IPHONE, COME, ONE, PM_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
        [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
            
        }onCompletion:^(NSDictionary *dict){
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:WEB_MSG];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"发送私信成功"];
        }failure:^(NSError *error){
            [SVProgressHUD showErrorWithStatus:@"网络不好"];
            NSLog(@"error:%@", [error description]);
        }];
    }];
    [PMPrompt show];
    [PMPrompt release];
}

-(void)sendRequestToFamilyCard
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = $str(@"%@/dapi/space.php?do=friend&m_auth=%@&fuid=%@", BASE_URL, [SBToolKit getMAuth], userId);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:WEB_MSG];
            return ;
        }
        
        if (![dataDict count]) {
            [dataDict removeAllObjects];
        }
         
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [dataDict addEntriesFromDictionary:[dict objectForKey:DATA]];
        [self isMyFamily:[[dataDict objectForKey:IS_MY_FAMILY] boolValue]
            headImageStr:[dataDict objectForKey:AVATAR]
                   isVip:[dataDict objectForKey:VIP_STATUS]
                 nameStr:[dataDict objectForKey:NAME]
                noteName:[dataDict objectForKey:NOTE]
                phoneNum:[dataDict objectForKey:PHONE]
                birthStr:[dataDict objectForKey:BIRTHDAY]
             countPerStr:[dataDict objectForKey:FAMILY_MEMBERS]
           countSpaceStr:[dataDict objectForKey:SPACE_TAG]
            lastLoginStr:[dataDict objectForKey:LAST_LOGIN_TIME]];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@",[error description]);
    }];
}

-(void)isMyFamily:(BOOL)_isMyFamily
     headImageStr:(NSString*)_headStr
            isVip:(NSString*)_vipTip
          nameStr:(NSString*)_nameStr
         noteName:(NSString*)_notenameStr
         phoneNum:(NSString*)_phoneStr
         birthStr:(NSString*)_birthStr
      countPerStr:(NSString*)_countPerStr
    countSpaceStr:(NSString*)_countSpaceStr
     lastLoginStr:(NSString*)_lastLoginStr
{
    
    customTopBarView.familyLbl.text = [self.delegate returnUserNickName];//[userName isEqual:[NSNull null]] || [userName isEqualToString:@""] || userName == nil ? MY_NAME : userName;
    //NSString *headStr = [[dataDict objectForKey:AVATAR] copy];
    _headStr = [_headStr stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
    [headBtn setImageForMyHeadButtonWithUrlStr:_headStr placeholderImageStr:@"head_220.png"];
    if ([_vipTip isEqualToString:PERSONAL]) {
        vipTipImg.hidden = NO;
    }else if([_vipTip isEqualToString:FAMILY]){
        vipTipImg.hidden = NO;
        [vipTipImg setImage:[UIImage imageNamed:@"vip_tip_b.png"]];
    }else{
        vipTipImg.hidden = YES;
    }
    NSString *nicknameStr = [_notenameStr isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"(%@)", _notenameStr];
    NSString *noteStr = [NSString stringWithFormat:@"%@%@", [_nameStr isEqual:[NSNull null]] ? @"" : _nameStr, nicknameStr];
    nameLbl.text = noteStr;
    nameLbl.adjustsFontSizeToFitWidth = YES;
    //nameLbl.lineBreakMode = YES;
    //nicknameLbl.text = _notenameStr;
    NSMutableString *phone = [[NSMutableString alloc] initWithString:_phoneStr];
    [phone insertString:@"-" atIndex:3];
    [phone insertString:@"-" atIndex:8];
    phoneLbl.text = phone;
    [phone release];
    birthLbl.text = _birthStr;
    tipsLbl.text = _isMyFamily ? @"详情" : @"你和TA还不是家人关系，快点加TA为好友吧！";
    if (_isMyFamily) {
        detailsView.hidden = NO;
        appendView.hidden = NO;
        countPerLbl.text = [NSString stringWithFormat:@"%@",_countPerStr];
        countSpaceLbl.text = _countSpaceStr;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_lastLoginStr doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-M-d"];
        [lastLoginLbl setText:[dateFormatter stringFromDate:date]];
        [dateFormatter release];
    }else{
        [theScrollView setContentSize:AdjustTheScrollerView];
        callBtn.frame = AdjustCallBtnFrame;
        [callBtn setImage:[UIImage imageNamed:@"requestfamily.png"] forState:UIControlStateNormal];
        [callBtn setImage:[UIImage imageNamed:@"requestfamily.png"] forState:UIControlStateHighlighted];
        [callBtn setImage:[UIImage imageNamed:@"requestfamily.png"] forState:UIControlStateSelected];
        
        tipsLbl.font = [UIFont systemFontOfSize:15.0f];
        tipsLbl.textColor = [UIColor lightGrayColor];
        tipsLbl.numberOfLines = 2;
        tipsLbl.textAlignment = UITextAlignmentCenter;
        detailsView.hidden = YES;
        appendView.hidden = YES;
    }
}

-(void)dealloc
{
    [super dealloc];
    [userId release], userId = nil;
    [userName release], userName = nil;
    //[dataDict release], dataDict = nil;
    [customTopBarView release], customTopBarView = nil;
    [headBtn release], headBtn = nil;
    [vipTipImg release], vipTipImg = nil;
    [nameLbl release], nameLbl = nil;
    [nicknameLbl release], nicknameLbl = nil;
    [phoneLbl release],phoneLbl = nil;
    [birthLbl release],birthLbl = nil;
    [tipsLbl release], tipsLbl = nil;
    [countPerLbl release],countPerLbl = nil;
    [countPerBtn release], countPerBtn = nil;
    [countSpaceLbl release], countSpaceLbl = nil;
    [countSpaceBtn release], countSpaceBtn = nil;
    [settingBtn release], settingBtn = nil;
    [callBtn release], callBtn = nil;
    [messageBtn release], messageBtn = nil;
    [lastLoginLbl release], lastLoginLbl = nil;
    [appendView release], appendView = nil;
    [detailsView release], detailsView = nil;
    //[customBackBottomBarView release], customBackBottomBarView = nil;
}


@end
