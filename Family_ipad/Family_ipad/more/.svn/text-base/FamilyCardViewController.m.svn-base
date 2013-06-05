//
//  FamilyCardViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "FamilyCardViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "MyHttpClient.h"
#import "UIImageView+AFNetworking.h"
#import "FamilyNewsCell.h"
#import "Common.h"
#import "FamilyMemberZoneViewController.h"
#import "PostBaseViewController.h"
#import "PostBaseView.h"
#import "DDAlertPrompt.h"
#import "UIAlertView+BlocksKit.h"
#import "UIImageView+JMImageCache.h"
#define kBASEFRIEND_TAG     10000

@interface FamilyCardViewController ()

@end

@implementation FamilyCardViewController
- (IBAction)addFriend:(id)sender
{
    DDAlertPrompt *alertPrompt = [[DDAlertPrompt alloc] initWithTitle:@"申请成为家人" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
    __block DDAlertPrompt *blockAlert = alertPrompt;
    [alertPrompt addButtonWithTitle:@"确认" handler:^{
        [SVProgressHUD showWithStatus:@"发送申请中..."];
        NSString *url = $str(@"%@friend&op=add", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_userId, APPLY_UID, ONE, G_ID, blockAlert.theTextView.text, NOTE, ONE, ADD_SUBMIT, POST_M_AUTH, M_AUTH, nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            [SVProgressHUD showSuccessWithStatus:@"申请已发送"];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        }];
    }];
    [alertPrompt show];
}
- (IBAction)sendPM:(id)sender
{
    PostBaseViewController *con = [[PostBaseViewController alloc]initWithNibName:@"PostBaseViewController" bundle:nil];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self isStackStartView:FALSE];
    con.postView.currentAction =  @"发私信";
     [con.postView changePostView];
    UIButton *friendBtn = ((UIButton *)[con.postView viewWithTag:kBASEFRIEND_TAG]);
    [friendBtn setTitle:_nameLabel.text forState:UIControlStateNormal];
    con.postView.touid = _userId;
}
- (IBAction)enterZoneAction:(id)sender
{
    FamilyMemberZoneViewController *memberZone = [[FamilyMemberZoneViewController alloc] initWithNibName:@"FamilyMemberZoneViewController" bundle:nil];
    memberZone.userId = _userId;
    [[AppDelegate instance].rootViewController.navigationController pushViewController:memberZone animated:YES];
}
- (void)setBabyDataWith:(NSDictionary *)dict
{
    _nameLabel.text = $safe([dict objectForKey:@"babyname"]);
    _birthdayLabel.text =$safe([dict objectForKey:@"babybirthday"]);
    _phoneLabel.text =$safe([dict objectForKey:@"babysex"]);
}
- (void)setFamilyCardData:(NSDictionary *)dict
{
    _isMyFamily =[[dict objectForKey:IS_FAMILY] boolValue];
    if (!_isMyFamily){
        _familyInfoView.hidden = YES;
        self.tipsLabel.text = @"你和TA还不是家人关系，快点加TA为好友吧！";
        self.tipsLabel.textColor = [UIColor lightGrayColor];
        self.tipsLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(138, 300, 200, 44);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"long_green_bg.png"] forState:UIControlStateNormal];
        [addBtn setTitle:@"申请成为家人" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn removeTarget:self action:@selector(sendPM:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addBtn];
        [self.view bringSubviewToFront:addBtn];
    }
    NSRange range = [[dict objectForKey:AVATER] rangeOfString:@"_small.jpg"];
    NSString *bigHeadURL=[dict objectForKey:AVATER];
    if (range.length!=0) {
       bigHeadURL  = [[dict objectForKey:AVATER] stringByReplacingCharactersInRange:range withString:@"_big.jpg"];

    }
    
    [_avatarImage setImageWithURLByJM:[NSURL URLWithString:bigHeadURL]  placeholder:[UIImage imageNamed:@"head220.png"]];
    _nameLabel.text = $safe([dict objectForKey:NAME]);
    _birthdayLabel.text =$safe([dict objectForKey:BIRTHDAY]);
    _phoneLabel.text =$safe([dict objectForKey:PHONE]);
    _fmembersLabel.text =$str(@"%@个",[dict objectForKey:PESONAL_MEMBER_NUM]);
    _zonesLabel.text =$str(@"%@个",[dict objectForKey:TAGS]);
    _lastLoginDateLabel.text =  [Common dateConvert:$str(@"%@",[dict objectForKey:LAST_LOGIN])];
}
- (void)sendRequest:(FamilyNewsCell *)sender
{
    [self sendRequestWith:sender.uid];
}
- (void)sendRequestWith:(NSString *)userid
{
    NSString *requestStr = $str(@"%@space.php?do=friend&fuid=%@&m_auth=%@",BASE_URL,userid,GET_M_AUTH);
    [[MyHttpClient sharedInstance] commandWithPath:requestStr
                                      onCompletion:^(NSDictionary *dict) {
                                          [self setFamilyCardData:[dict objectForKey:WEB_DATA]];
                                      }
                                           failure:^(NSError *error) {
                                           }];
}
- (IBAction)backAction:(id)sender
{
    REMOVEDETAIL;
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
