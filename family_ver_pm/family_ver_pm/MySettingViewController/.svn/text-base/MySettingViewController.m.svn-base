//
//  MySettingViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "MySettingViewController.h"
#import "TopBarView.h"
#import "DDAlertPrompt.h"
//#import "FamilyAppDelegate.h"
#import "IntroductionViewController.h"
#import "AppDelegate.h"
#import "MyLikeViewController.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController
@synthesize dataDict;
@synthesize theScrollView, headBtn, vipTipImg, nameBtn, nameLbl, phoneLbl, birthBtn, birthLbl, moneyBtn, countMonLbl, countTaskBtn, countTaskLbl, myCollectBtn, aboutBtn, serverBtn, logoutBtn;

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
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    [self setInterfaceButton];
    
    dataDict = [[NSMutableDictionary alloc] init];
    theScrollView.frame = CGRectMake(0, 65, DEVICE_SIZE.width, 579);
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, 770);

    //注册返回到此处的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToHere) name:NOTIFI_POP_TO_MYSETTINGVIEW object:nil];
    
    [self sendRequestToMyInfo];
}

- (void)backToHere
{
    [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void) setTheTopBarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"1" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 36)];
    customTopBarView.themeLbl.text = MY_NAME;
    customTopBarView.themeLbl.text = @"设置";
    
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void) setTheBackBottomBarView
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
//    [self dismissModalViewControllerAnimated:YES];
    POST_NOTI(NOTIFI_POP_TO_MAINVIEW);
}

-(void)setInterfaceButton
{
    headBtn.tag = kTheInterfaceButtonTag;
    [headBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [nameBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [nameBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [nameBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    nameBtn.tag = kTheInterfaceButtonTag + 1;
    [nameBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [birthBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [birthBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [birthBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    birthBtn.tag = kTheInterfaceButtonTag + 2;
    [birthBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [countTaskBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [countTaskBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [countTaskBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    //countTaskBtn.tag = kTheInterfaceButtonTag + 3;
    //[countTaskBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    moneyBtn.tag = kTheInterfaceButtonTag + 3;
    [moneyBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [serverBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    [serverBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    [serverBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    serverBtn.tag = kTheInterfaceButtonTag + 4;
    [serverBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[myCollectBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    //[myCollectBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    //[myCollectBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    myCollectBtn.tag = kTheInterfaceButtonTag + 5;
    [myCollectBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[aboutBtn setImage:[UIImage imageNamed:@"arrow_a_family.png"] forState:UIControlStateNormal];
    //[aboutBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateHighlighted];
    //[aboutBtn setImage:[UIImage imageNamed:@"arrow_b_family.png"] forState:UIControlStateSelected];
    aboutBtn.tag = kTheInterfaceButtonTag + 6;
    [aboutBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [logoutBtn setImage:[UIImage imageNamed:@"logout_a.png"] forState:UIControlStateNormal];
    [logoutBtn setImage:[UIImage imageNamed:@"logout_b.png"] forState:UIControlStateHighlighted];
    [logoutBtn setImage:[UIImage imageNamed:@"logout_b.png"] forState:UIControlStateSelected];
    logoutBtn.tag = kTheInterfaceButtonTag + 7;
    [logoutBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonPressed:(UIButton*)_button
{
    int tag = _button.tag - kTheInterfaceButtonTag;
    switch (tag) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置我的头像"];
            actionSheet.delegate = self;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [actionSheet addButtonWithTitle:@"打开相机" handler:^{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentModalViewController:imagePicker animated:YES];
                }else{
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentModalViewController:imagePicker animated:YES];
                }
            }];
            [actionSheet addButtonWithTitle:@"本地图库" handler:^{
                imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentModalViewController:imagePicker animated:YES];
            }];
            [actionSheet addButtonWithTitle:@"取消" handler:^{
                return ;
            }];
            [actionSheet showInView:self.view];
            [actionSheet release];
            [imagePicker release];
        }
            break;
        case 1:
        {
            DDAlertPrompt *aPrompt = [[DDAlertPrompt alloc] initWithTitle:@"修改昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitle:nil];
            [aPrompt addButtonWithTitle:@"确认" handler:^{
                [SVProgressHUD showWithStatus:@"上传中..."];
                NSString *url = $str(@"%@/dapi/cp.php?ac=name", BASE_URL);
                NSMutableDictionary *para = $dict(aPrompt.theTextView.text, NAME, @"1", NAME_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
                [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData>formData){
                    
                }onCompletion:^(NSDictionary *dict){
                    if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                        return ;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                }failure:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"网络不好"];
                    NSLog(@"error:%@", [error description]);
                }];
            }];
            [aPrompt show];
            [aPrompt release];
        }
            break;
        case 2:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n"];
            actionSheet.delegate = self;
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-M-d"];
            NSDate *birthDate = [dateFormatter dateFromString:birthLbl.text];
            [datePicker setDate:birthDate animated:YES];
            [actionSheet addSubview:datePicker];
            [actionSheet addButtonWithTitle:@"确认" handler:^{
                
                NSString *birthday = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePicker.date]];
                NSString *url = $str(@"%@/dapi/cp.php?ac=birth", BASE_URL);
                NSMutableDictionary *para = $dict(birthday, MY_BIRTHDAY, @"1", BIRTHDAY_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
                [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData>formData){
                    
                }onCompletion:^(NSDictionary *dict){
                    if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                        [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                        return ;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
                }failure:^(NSError *error){
                    [SVProgressHUD showErrorWithStatus:@"网络不好"];
                    NSLog(@"error:%@", [error description]);
                }];
                
            }];
            [actionSheet addButtonWithTitle:@"取消" handler:^{
                return ;
            }];
            [actionSheet showInView:self.view];
            [datePicker release];
            [actionSheet release];

        }
            break;
        case 3:
        {
            IntroductionViewController *_con = [[IntroductionViewController alloc] initWithNibName:@"IntroductionViewController" bundle:nil];
            _con.whichType = aquirecoin;
            [self presentModalViewController:_con animated:YES];
            [_con release], _con = nil;
        }
            break;
        case 4:
        {
            IntroductionViewController *_con = [[IntroductionViewController alloc] initWithNibName:@"IntroductionViewController" bundle:nil];
            _con.whichType = vipintroduction;
            [self presentModalViewController:_con animated:YES];
            [_con release], _con = nil;
        }
            break;
        case 5:
        {
//            NSLog(@"我的收藏");
            MyLikeViewController *myLikeViewController = [[MyLikeViewController alloc] initWithNibName:@"MyLikeViewController" bundle:nil];
            [self.navigationController pushViewController:myLikeViewController animated:YES];
            [myLikeViewController release], myLikeViewController = nil;
            
        }
            break;
        case 6:
        {
            IntroductionViewController *_con = [[IntroductionViewController alloc] initWithNibName:@"IntroductionViewController" bundle:nil];
            _con.whichType = aboutfamily;
            [self presentModalViewController:_con animated:YES];
            [_con release], _con = nil;
        }
            break;
        case 7:
        {
            [self logoutButtonPressed];
        }
            break;
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveHeadImage:) withObject:headImage afterDelay:0.3f];
}

-(void)saveHeadImage:(UIImage*)_headImage
{
    [SVProgressHUD showWithStatus:@"保存图像中..."];
    NSString *url = $str(@"%@/dapi/cp.php?ac=avatar", BASE_URL);
    NSMutableDictionary *para = $dict(@"1", AVATAR_SUBMIT, [SBToolKit getMAuth], M_AUTH, nil);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_headImage, 0.8f) name:@"Filedata" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"头像更新成功!"];
        NSData *headImageData = UIImageJPEGRepresentation(_headImage, 0.8f);
        NSData *encodeHeadImage = [NSKeyedArchiver archivedDataWithRootObject:headImageData];
        [ConciseKit setUserDefaultsWithObject:encodeHeadImage forKey:AVATAR];
        
        [headBtn setImage:_headImage forState:UIControlStateNormal];
    }failure:^(NSError *error){
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
    }];
}

-(void)sendRequestToMyInfo
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = $str(@"%@/dapi/space.php?do=setup&m_auth=%@", BASE_URL, [SBToolKit getMAuth]);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [dataDict addEntriesFromDictionary:[dict objectForKey:DATA]];
        [SVProgressHUD showSuccessWithStatus:@"加载成功!"];
        [self headImageStr:[dataDict objectForKey:AVATAR]
                     isVip:[dataDict objectForKey:VIP_STATUS]
                   nameStr:[dataDict objectForKey:NAME]
               phoneNumStr:[dataDict objectForKey:PHONE]
               birthdayStr:[dataDict objectForKey:BIRTHDAY]
                  moneyStr:[dataDict objectForKey:CREDIT]
                taskNumStr:[dataDict objectForKey:TASK_NUMBER]];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@", [error description]);
    }];
    
}

-(void)headImageStr:(NSString*)_headStr
              isVip:(NSString*)_vipTip
            nameStr:(NSString*)_nameStr
        phoneNumStr:(NSString*)_phoneNumStr
        birthdayStr:(NSString*)_birthStr
           moneyStr:(NSString*)_moneyStr
         taskNumStr:(NSString*)_taskNumStr
{
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
    nameLbl.text = _nameStr;
    NSMutableString *phone = [NSMutableString stringWithFormat:@"%@", _phoneNumStr];
    [phone insertString:@"-" atIndex:3];
    [phone insertString:@"-" atIndex:8];
    phoneLbl.text = phone;
    birthLbl.text = _birthStr;
    countMonLbl.text = [NSString stringWithFormat:@"剩余%@", _moneyStr];
    countTaskLbl.text = [NSString stringWithFormat:@"%@", _taskNumStr];
}

-(void)logoutButtonPressed
{
    [SVProgressHUD showWithStatus:@"退出登录中..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *url = $str(@"%@/dapi/do.php?ac=logout&m_auth=%@", BASE_URL, [SBToolKit getMAuth]);
    NSMutableDictionary *para = $dict([SBToolKit getMAuth], M_AUTH, nil);
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData){
        
    }onCompletion:^(NSDictionary *dict){
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            //ReloginForAuthFailure(dict);
            if ([[dict objectForKey:@"msgkey"] isEqualToString:@"auth_failure"]) {
                //[self dismissModalViewControllerAnimated:YES];
                LoginViewController *_con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_con];
                //nav.navigationBarHidden = YES;
                [self presentModalViewController:_con animated:NO];
                //[nav release], nav = nil;
                [_con release], _con = nil;
            }
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:@"退出成功！"];
        [self dismissModalViewControllerAnimated:YES];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate logoutFromFamily];
    }failure:^(NSError *error){
        [SVProgressHUD showErrorWithStatus:@"网络不好"];
        NSLog(@"error:%@", [error description]);
    }];
}

-(void)dealloc
{
    [super dealloc];
    //[dataDict release], dataDict = nil;
    [theScrollView release], theScrollView = nil;
    [headBtn release], headBtn = nil;
    [vipTipImg release], vipTipImg = nil;
    [nameLbl release], nameLbl = nil;
    [nameBtn release], nameBtn = nil;
    [phoneLbl release], phoneLbl = nil;
    [birthLbl release], birthLbl = nil;
    [birthBtn release], birthLbl = nil;
    
    [moneyBtn release], moneyBtn = nil;
    [countMonLbl release], countMonLbl = nil;
    [countTaskLbl release], countTaskLbl = nil;
    [countTaskBtn release], countTaskBtn = nil;
    [serverBtn release], serverBtn = nil;
    [myCollectBtn release], myCollectBtn = nil;
    [aboutBtn release], aboutBtn = nil;
    [logoutBtn release], logoutBtn = nil;
}

@end
