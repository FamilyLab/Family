//
//  LoginViewController.m
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "TopView.h"
#import "SignInViewController.h"

#import "AFJSONRequestOperation.h"
#import "MyHttpClient.h"
//#import "JSONKit.h"
#import "SVProgressHUD.h"
//#import "UIButton+WebCache.h"
#import "GuideViewController.h"
#import "ChangePwViewController.h"
#import "AppDelegate.h"
#import "AddFriendsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
//@synthesize loginBtn;
@synthesize userField, pwdField, cookieBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shouldGoToJoinTopic = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = DEVICE_BOUNDS;
    UIScrollView *scroll = (UIScrollView*)[self.view.subviews objectAtIndex:0];
    scroll.frame = (CGRect){.origin.x = 0, .origin.y = 50, .size.width = DEVICE_SIZE.width, .size.height = DEVICE_SIZE.height - 50 - 40};//50为topview的高度，40为bottomview的高度
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, scroll.frame.size.height + 1);
    [self addTopView];
    [self addBottomView];
    cookieBtn.selected = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AUTO_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [cookieBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cookieBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [cookieBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
//    [cookieBtn setImage:[UIImage imageNamed:@"remeberpw_a.png"] forState:UIControlStateNormal];
//    [cookieBtn setImage:[UIImage imageNamed:@"remeberpw_b.png"] forState:UIControlStateHighlighted];
//    [cookieBtn setImage:[UIImage imageNamed:@"remeberpw_c.png"] forState:UIControlStateSelected];
    
//    [loginBtn makeCornerWithRadius:2.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = loginOrSignIn;
    [topView leftBg];
    [topView leftText:@"登录"];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_help", @"login_signin", nil];
//    UIImage *bottomBgImage =  @"login_bg.png";
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
            GuideViewController *con = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
            [self.navigationController pushViewController:con animated:YES];
            break;
        }
            
        case 1:
        {
            [self signInBtnPressed:nil];
            break;
        }
            
        default:
            break;
    }
}

- (void)signInBtnPressed:(id)sender {
    SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    con.topViewType = loginOrSignIn;
    con.aboutType = commonType;
    [self.navigationController pushViewController:con animated:YES];
}

- (IBAction)loginBtnPressed:(id)sender {
//    userField.text = userField.text.length != 0 ? userField.text : @"15013296747";//@"18620050490";
//    pwdField.text = pwdField.text.length != 0 ? pwdField.text : @"123456";
    if (userField.text.length == 0 || pwdField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户名或者密码为空T_T"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
//    if (cookieBtn.selected) {
        [[PDKeychainBindings sharedKeychainBindings] setObject:userField.text forKey:USER_NAME];
        [[PDKeychainBindings sharedKeychainBindings] setObject:pwdField.text forKey:PASSWORD];
//    }
    NSString *cookie = cookieBtn.selected ? @"1" : @"0";
    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:userField.text, USER_NAME, pwdField.text, PASSWORD, cookie, IS_COOKIE, nil];
    [self uploadRequestToLoginWithPara:para loginType:commonLoginType];
    
    //get
//    NSString *url = @"http://www.familyday.com.cn/dapi/do.php?ac=login&username=18620050490&password=123456&iscookie=0";
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [[AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"JSON:%@", JSON);
//        [self.navigationController dismissModalViewControllerAnimated:YES];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"error:%@", [error description]);
//    }] start];
    
    //post
//    NSURL *url = [NSURL URLWithString:@"http://www.familyday.com.cn"];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/dapi/do.php?" parameters:[NSDictionary dictionaryWithObject:@"login" forKey:@"ac"] constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", @"18620050490"] dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", @"123456"] dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@", @"0"] dataUsingEncoding:NSUTF8StringEncoding] name:@"iscookie"];
//    }];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDict = [(NSData*)responseObject objectFromJSONData];
//        NSLog(@"res:%@", resultDict);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error: %@", error);
//    }];
//    [operation start];
}

//- (void)uploadRequestToLoginWithPara:(NSMutableDictionary*)para loginType:(LoginType)loginType {
//    NSString *url = $str(@"%@login", POST_API);
//    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
//        
//    } onCompletion:^(NSDictionary *dict) {
//        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
//            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//            return ;
//        }
//        NSDictionary *dataDict = [dict objectForKey:DATA];
//        if (loginType == commonLoginType) {//普通登录
//            if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {
//                [SVProgressHUD showErrorWithStatus:@"用户名或者密码错误T_T"];
//                return;
//            }
//            if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
//                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//                return;
//            }
//        } else if (loginType == sinaLoginType) {//第三方登录
//            if ([[dataDict objectForKey:WEB_RETURN] intValue] == -2) {
//                SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
//                con.topViewType = loginOrSignIn;
//                con.aboutType = sinaSignInType;
//                SinaWeibo *sinaweibo = [self sinaweibo];
//                con.sinaUid = sinaweibo.userID;
//                con.sinaToken = sinaweibo.accessToken;
//                [self.navigationController pushViewController:con animated:YES];
//                return;
//            }
//            if ([[dataDict objectForKey:WEB_RETURN] intValue] == -1) {
//                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
//                return;
//            }
//        }
//        
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//        
//        NSString *avatarStr = [[dataDict objectForKey:AVATAR] stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
//        avatarStr = [avatarStr stringByReplacingOccurrencesOfString:@"middle" withString:@"big"];
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_LOGIN];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:UID] forKey:UID];
//        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:NAME] forKey:NAME];
//        [ConciseKit setUserDefaultsWithObject:avatarStr forKey:AVATAR_URL];
//        [ConciseKit setUserDefaultsWithObject:[dataDict objectForKey:VIP_STATUS] forKey:VIP_STATUS];
//        //        [ConciseKit setUserDefaultsWithObject:@"默认空间" forKey:LAST_ZONE_NAME];
//        
//        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:USER_NAME] forKey:USER_NAME];
//        [[PDKeychainBindings sharedKeychainBindings] setObject:[dataDict objectForKey:M_AUTH] forKey:M_AUTH];
//        
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [appDelegate uploadToken:MY_DEVICE_TOKEN];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SEND_REQUEST object:nil];
//        [self.navigationController dismissModalViewControllerAnimated:YES];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//        NSLog(@"error:%@", [error description]);
//    }];
//}


- (IBAction)bgBtnPressed:(id)sender {
    [self resignKeyboardInView:self.view];
}

- (void)resignKeyboardInView:(UIView *)view   {
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyboardInView:v];
        }
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}

- (IBAction)cookieBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
//    NSString *str = sender.selected ? @"     自动登录" : @"自动登录";
//    [sender setTitle:str forState:UIControlStateNormal];
//    [sender setTitle:str forState:UIControlStateHighlighted];
//    _symbolImgView.hidden = !sender.selected;
    
    NSString *checkImgStr = sender.selected ? @"checked.png" : @"notChecked.png";
    _symbolImgView.image = [UIImage imageNamed:checkImgStr];
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:AUTO_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)sinaBtnPressed:(id)sender {
    
//    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
//    con.topViewType = notLoginOrSignIn;
//    [self.navigationController pushViewController:con animated:YES];
//    return;
    
//    SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
//    con.topViewType = loginOrSignIn;
//    con.aboutType = sinaSignInType;
//    SinaWeibo *sinaweibo = [self sinaweibo];
//    con.sinaUid = sinaweibo.userID;
//    con.sinaToken = sinaweibo.accessToken;
//    [self.navigationController pushViewController:con animated:YES];
//    return;
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) {
        [sinaweibo logOut];
    } else {
        [sinaweibo logIn];
    }
}

- (IBAction)qqBtnPressed:(id)sender {
    
}

- (IBAction)findMyPwBtnPressed:(id)sender {
    ChangePwViewController *con = [[ChangePwViewController alloc] initWithNibName:@"ChangePwViewController" bundle:nil];
    con.aboutPwd = inputPhoneForLostPwd;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - sina weibo
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
    
    NSString *dateString = nil;
    if (sinaweibo.expirationDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        dateString = [dateFormatter stringFromDate:sinaweibo.expirationDate];
    }
    
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
    NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:sinaweibo.userID, @"sina_uid", @"weibo", @"logintype", dateString, @"sina_expires_in", nil];
    [self uploadRequestToLoginWithPara:para loginType:sinaLoginType];

//    return;
//    [self performBlock:^(id sender) {
////        NSMutableDictionary *para = [[NSMutableDictionary alloc]initWithObjectsAndKeys:sinaweibo.accessToken, @"token", @"weibo", @"logintype", nil];
////        [self uploadRequestToLoginWithPara:para];
//        SignInViewController *con = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
//        con.topViewType = loginOrSignIn;
//        con.aboutType = sinaSignInType;
//        con.sinaUid = sinaweibo.userID;
//        con.sinaToken = sinaweibo.accessToken;
//        [self.navigationController pushViewController:con animated:YES];
//    } afterDelay:0.3f];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
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

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
//    if ([request.url hasSuffix:@"users/show.json"])
//    {
//        [userInfo release], userInfo = nil;
//    }
//    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
//    {
//        [statuses release], statuses = nil;
//    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
//    if ([request.url hasSuffix:@"users/show.json"])
//    {
//        [userInfo release];
//        userInfo = [result retain];
//    }
//    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
//    {
//        [statuses release];
//        statuses = [[result objectForKey:@"statuses"] retain];
//    }
}

@end
