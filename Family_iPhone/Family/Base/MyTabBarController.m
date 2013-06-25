//
//  MyTabBarController.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "MyTabBarController.h"
//#import "PostViewController.h"
#import "TableController.h"
#import "JSBadgeView.h"
#import "MyHttpClient.h"
#import "MessageViewController.h"
#import "PlistManager.h"
#import "CameraPickerController.h"
#import "CameraOverlayViewController.h"
#import "PostSthViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import <AVFoundation/AVCaptureSession.h>
#import "FuckViewController.h"

// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
// this works for iOS 4.x
#define CAMERA_TRANSFORM_Y 1.24299

@interface MyTabBarController ()

@end

@implementation MyTabBarController
@synthesize tabBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currIndex = 0;
        NSMutableArray *consArray = [[NSMutableArray alloc] init];
//        NSArray *conNamesArray = [[NSArray alloc] initWithObjects:@"FeedViewController", @"ZoneViewController", @"MessageViewController", @"MoreViewController", nil];
        NSArray *conNamesArray = [[NSArray alloc] initWithObjects:@"FeedViewController", @"FamilyViewController", @"MessageViewController", @"ZoneViewController", nil];
        for (int i=0; i<4; i++) {
            UIViewController *con = [(UIViewController*)[NSClassFromString([conNamesArray objectAtIndex:i]) alloc] initWithNibName:[conNamesArray objectAtIndex:i] bundle:nil];
            
            con.hidesBottomBarWhenPushed = YES;
            [consArray addObject:con];
        }
        self.viewControllers = consArray;
//        NSLog(@"resource path:%@", [[NSBundle mainBundle] resourcePath]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _shouldPresentAConToOpenCamera = NO;
    
    [self createCustomTabBar];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:THEME_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImgForThemeChanged) name:THEME_CHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MESSAGE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeForMsgBtn:) name:REFRESH_MESSAGE_NUM object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MORE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBadgeForMoreBtn:) name:REFRESH_MORE_NUM object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_FAMILY_AND_ZONE_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestForList:) name:GET_FAMILY_AND_ZONE_LIST object:nil];
    
    self.loadingView = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:_loadingView];
    [_loadingView loadingAnimation];
    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FIRST_SHOW];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [self buildPostView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PRESENT_POST_VIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPostViewCon:) name:PRESENT_POST_VIEWCONTROLLER object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DISMISS_CUSTOM_CAMERA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissCustomCamera:) name:DISMISS_CUSTOM_CAMERA object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOW_CUSTOM_CAMERA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCustomCamera:) name:SHOW_CUSTOM_CAMERA object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(notificationCallback:)
//                                                 name:nil
//                                               object:nil
//     ];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraIsReady:) name:AVCaptureSessionDidStartRunningNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self hideTheTabBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:THEME_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MESSAGE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_MORE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GET_FAMILY_AND_ZONE_LIST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PRESENT_POST_VIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DISMISS_CUSTOM_CAMERA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOW_CUSTOM_CAMERA object:nil];
}

#pragma mark my method(s)
//- (void)cameraIsReady:(NSNotification *) notification {
//    NSLog(@"Iris open");
//    [self getAllPhotoImages];
////    if ([[notification name] isEqualToString:@"PLCameraViewIrisAnimationDidEndNotification"]) {
//        // we don't need to listen any more
////        [[NSNotificationCenter defaultCenter] removeObserver:self];
////    }
//}

- (void)hideTheTabBar {
    for (UIView *aView in self.view.subviews) {
        if ([aView isKindOfClass:[UITabBar class]]) {
//            CGRect tabBarRect = aView.frame;
////            tabBarRect.size.height -= 19;
//            tabBarRect.origin.y += 109;
//            aView.frame = tabBarRect;
            aView.hidden = YES;
            break;
        }
    }
}

//改变主题
- (void)changeImgForThemeChanged {
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_feed_a", @"menu_space_a", @"menu_new_a", @"menu_message_a", @"menu_more_a", nil];
//    NSArray *selectedImages = [[NSArray alloc] initWithObjects:@"menu_feed_b", @"menu_space_b", @"menu_new_b", @"menu_message_b", @"menu_more_b", nil];
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"tab_home_a", @"tab_family_a", @"menu_new_a", @"tab_conversation_a", @"tab_space_a", nil];
    NSArray *selectedImages = [[NSArray alloc] initWithObjects:@"tab_home_b", @"tab_family_b", @"menu_new_b", @"tab_conversation_b", @"tab_space_b", nil];
    tabBarView.bgImgView.image = ThemeImage(@"menu_bg");
    for (int i=0; i< [normalImages count]; i++) {
        UIButton *btn = (UIButton*)[tabBarView viewWithTag:kTagBottomButton + i];
        [btn setImage:ThemeImage([normalImages objectAtIndex:i]) forState:UIControlStateNormal];
        [btn setImage:ThemeImage([selectedImages objectAtIndex:i]) forState:UIControlStateHighlighted];
        [btn setImage:ThemeImage([selectedImages objectAtIndex:i]) forState:UIControlStateSelected];
    }
}

- (void)createCustomTabBar {
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_feed_a", @"menu_space_a", @"menu_new_a", @"menu_message_a", @"menu_more_a", nil];
//    NSArray *selectedImages = [[NSArray alloc] initWithObjects:@"menu_feed_b", @"menu_space_b", @"menu_new_b", @"menu_message_b", @"menu_more_b", nil];
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"tab_home_a", @"tab_family_a", @"menu_new_a", @"tab_conversation_a", @"tab_space_a", nil];
    NSArray *selectedImages = [[NSArray alloc] initWithObjects:@"tab_home_b", @"tab_family_b", @"menu_new_b", @"tab_conversation_b", @"tab_space_b", nil];
    
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 50, DEVICE_SIZE.width, 50)
                                                          type:tabBarType
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:selectedImages
                                            andBackgroundImage:@"menu_bg"];
    bottomView.delegate = self;
    self.tabBarView = bottomView;
    [self.view addSubview:tabBarView];
}

- (void)selecteFirstIndexForLogout {
    UIButton *feedBtn = (UIButton*)[tabBarView viewWithTag:kTagBottomButton];
    for (id obj in [self.tabBarView subviews]) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            if (btn.tag == feedBtn.tag)
                btn.selected = YES;
            else
                btn.selected = NO;
        }
    }
    [self userPressedTheBottomButton:tabBarView andButton:feedBtn];
}

- (void)refreshTabView:(TableController*)_con {
    [_con._tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//统计接口
- (void)sendRequestForCount:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=elder&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([dict isMemberOfClass:[NSDictionary class]] && [[dict objectForKey:WEB_ERROR] intValue] != 0) {
            return ;
        }
        NSDictionary *dataDict = [dict objectForKey:WEB_DATA];
        //消息按钮
        self.dialogNum = [[dataDict objectForKey:PM_COUNT] intValue];
        self.noticeNum = [[dataDict objectForKey:NOTICE_COUNT] intValue];
//        MessageViewController *con = (MessageViewController*)[self.viewControllers objectAtIndex:2];
//        [con setBadgeNumWithBtnTag:0 andBadgeNum:$str(@"%d", self.dialogNum)];//上面的对话数量
//        [con setBadgeNumWithBtnTag:1 andBadgeNum:$str(@"%d", self.noticeNum)];//上面的通知数量
        
        //下面的消息数量
//        NSString *msgNum = $str(@"%d", _dialogNum + _noticeNum);
        NSString *msgNum = $str(@"%d", _dialogNum);
        [self setBadgeNumWithBtnTag:3 andBadgeNum:msgNum];
        //更多里的家人申请数量
        NSString *applyNum = $str(@"%d", [[dataDict objectForKey:APPLY_COUNT] intValue]);
        [self setBadgeNumWithBtnTag:1 andBadgeNum:applyNum];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}

//设置消息按钮的badge值
- (void)setBadgeForMsgBtn:(NSNotification*)noti {
    if ([[noti object] isEqualToString:REFRESH_COUNT_NUM])
        [self sendRequestForCount:nil];//刷新统计接口
    else
        [self setBadgeNumWithBtnTag:3 andBadgeNum:[noti object]];//设置值
}

//设置更多按钮的badge值
- (void)setBadgeForMoreBtn:(NSNotification*)noti {
    if ([[noti object] isEqualToString:REFRESH_COUNT_NUM])
        [self sendRequestForCount:nil];//刷新统计接口
    else
        [self setBadgeNumWithBtnTag:1 andBadgeNum:[noti object]];//设置值
}

- (void)setBadgeNumWithBtnTag:(int)btnTag andBadgeNum:(NSString*)badgeNum {
    NSString *originBadgeNum = badgeNum;
    
    NSString *preBadgeNum = @"0";
    UIButton *btn = (UIButton*)[self.tabBarView viewWithTag:kTagBottomButton + btnTag];
    JSBadgeView *badgeView = nil;
    
    for (id obj in btn.subviews) {
        if ([obj isKindOfClass:[JSBadgeView class]]) {
            badgeView = (JSBadgeView*)obj;
            preBadgeNum = $str(@"%d", _dialogNum);// badgeView.badgeText;//保存原来的
            //            preBadgeNum = $str(@"%d", _dialogNum + _noticeNum);// badgeView.badgeText;//保存原来的
            [badgeView removeFromSuperview];
            badgeView = nil;
            break;
        }
    }
    if ([badgeNum intValue] < 0) {
        badgeNum = $str(@"%d", [preBadgeNum intValue] + [badgeNum intValue]);//减少的
    }
    badgeNum = [badgeNum intValue] > 9 ? @"n" : badgeNum;
    
    if (btnTag == 0) {//非动态tab的
        badgeNum = originBadgeNum;
    }
    if ([badgeNum intValue] > 0 || [badgeNum isEqualToString:@"n"]) {//真正的badgeNum
        badgeView = [[JSBadgeView alloc] initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
        [badgeView setBadgeText:badgeNum];
        [badgeView setBadgePositionAdjustment:CGPointMake(badgeView.frame.origin.x - 10, badgeView.frame.origin.y + 10)];
    }
}

- (void)postBtnPressed:(UIButton*)sender {
    _postBtn.selected = NO;
    [self showOrHidePostView];
}

- (void)buildPostView {
    UIView *postView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 50, DEVICE_SIZE.width, 100)];
    
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setImage:[UIImage imageNamed:@"post_btn_a_v12"] forState:UIControlStateNormal];
    aBtn.frame = (CGRect){.origin.x = ( DEVICE_SIZE.width - aBtn.imageView.image.size.width ) / 2, .origin.y = 0, .size = aBtn.imageView.image.size};
    [aBtn addTarget:self action:@selector(postBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *inImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_cha_a_v12.png"]];
    inImgView.frame = (CGRect){.origin.x = 16, .origin.y = 16, .size = inImgView.frame.size};
    inImgView.transform = CGAffineTransformMakeRotation(-M_PI_4);
    self.inPostBtnImgView = inImgView;
    [aBtn addSubview:inImgView];
    
    self.postBtn = aBtn;
    
    [postView addSubview:aBtn];
    
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"photo_a_v12", @"diary_a_v12", @"menu_dialogue_a_v12", @"activity_a_v12", @"hello_a_v12", nil];
    NSArray *highlighImages = [[NSArray alloc] initWithObjects:@"photo_b_v12", @"diary_b_v12", @"menu_dialogue_b_v12", @"activity_b_v12", @"hello_b_v12", nil];
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, _postBtn.frame.size.height, DEVICE_SIZE.width, 50)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:highlighImages
                                       andBackgroundImage:@"menu_bg_v12"];
    aView.delegate = self;
    self.postBottomView = aView;
    [postView addSubview:aView];
    self.postContainerView = postView;
    
    _postContainerView.hidden = YES;
    
    [self.view addSubview:_postContainerView];
}

- (void)hidePostMenu {
    if (_postBottomView && _postBtn.selected) {
        _postBtn.selected = NO;
        [self showOrHidePostView];
    }
}


//下面的菜单
- (void)showOrHidePostView {
    _postContainerView.hidden = NO;
    [UIView animateWithDuration:0.2f animations:^{
        if (_postBtn.selected) {//将要显示
            _postContainerView.frame = CGRectMake(0, DEVICE_SIZE.height - _postBottomView.frame.size.height * 2, _postContainerView.frame.size.width, _postContainerView.frame.size.height);
            
            UIButton *bgBtnForTouch = [UIButton buttonWithType:UIButtonTypeCustom];
            bgBtnForTouch.frame = DEVICE_BOUNDS;
            bgBtnForTouch.tag = 10010;
            [bgBtnForTouch addTarget:self action:@selector(hidePostMenu) forControlEvents:UIControlEventTouchDown];
            
            [self.view insertSubview:bgBtnForTouch belowSubview:_postContainerView];
            
        } else {//将要隐藏
            _inPostBtnImgView.transform = CGAffineTransformMakeRotation(-M_PI_4);
            
            UIButton *bgBtnForTouch = (UIButton*)[self.view viewWithTag:10010];
            [bgBtnForTouch removeFromSuperview];
        }
        _postContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [self bounceOutStoped];
    }];
}

- (void)bounceOutStoped {
    [UIView animateWithDuration:0.1f animations:^{
        _postContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             if (_postBtn.selected) {//将要显示
                                 _inPostBtnImgView.transform = CGAffineTransformMakeRotation(0);
                             } else {//将要隐藏
                                 _postContainerView.frame = CGRectMake(0, DEVICE_SIZE.height - _postBottomView.frame.size.height, _postContainerView.frame.size.width, _postContainerView.frame.size.height);
                             }
                         } completion:^(BOOL finished) {
                             _postContainerView.hidden = !_postBtn.selected;
                         }];
    }];
}

- (void)buildMultiSelectAlbum {
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
        if (error == nil) {
            //            NSLog(@"User has cancelled.");
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
//                [self.modalViewController dismissModalViewControllerAnimated:YES];
//            } else {
//                [self.presentedViewController dismissModalViewControllerAnimated:YES];
//            }
            [_agImgPickerCon dismissModalViewControllerAnimated:YES];
        } else {
            NSLog(@"Error: %@", error);
            // Wait for the view controller to show first and hide it after that
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissModalViewControllerAnimated:YES];
            });
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    } andSuccessBlock:^(NSArray *info) {
        //        NSLog(@"Info: %@", info);
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [info count]; i++) {
            ALAsset *albumSet = (ALAsset*)[info objectAtIndex:i];
            UIImage *fullImg = [UIImage imageWithCGImage:[albumSet.defaultRepresentation fullScreenImage]];
            [tmpArray addObject:fullImg];
        }
        [_postSthViewCon.imagesArray removeAllObjects];
        [_postSthViewCon.imagesArray addObjectsFromArray:tmpArray];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_postSthViewCon];
        nav.navigationBarHidden = YES;
        [_agImgPickerCon presentModalViewController:nav animated:YES];
        [_postSthViewCon setupHorizontalViewWithType:postPhoto];
//        [_postSthViewCon.postSthView.jtListView reloadData];
        _postBtn.selected = NO;
        [self showOrHidePostView];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENT_POST_VIEWCONTROLLER object:tmpArray];
//        [self dismissModalViewControllerAnimated:YES];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    self.agImgPickerCon = imagePickerController;
//    [_customPicker presentModalViewController:imagePickerController animated:YES];
}

- (void)userPressedTheBottomButton:(BottomView *)theView andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    if (theView == self.tabBarView) {
        if (btnTag == 2) {
            if (self.postBottomView) {
                _postBtn.selected = YES;
                [self showOrHidePostView];
            } else {
                [self buildPostView];
            }
            return;
        }
        int selected = btnTag < 2 ? btnTag : btnTag - 1;//MyTabBarController只有4个tab，而bottomView多了中间的按钮
        //再次点击当前tab时刷新
        if (_currIndex == selected) {
            TableController *con = [self.viewControllers objectAtIndex:selected];
            [con refreshForDoubleClick:con._tableView];
            return;
        }
        self.selectedIndex = selected;
        _currIndex = self.selectedIndex;
    } else if (theView == self.postBottomView) {
        PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
        self.postSthViewCon = con;
//        PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
//        self.postViewCon = con;
        if (btnTag == 0) {
            [self showCustomCamera:nil];
            
            _postBtn.selected = NO;
            [self showOrHidePostView];
            return;
            
        } else if (btnTag == 1) {
//            con.thePostType = postDiary;
            con.postSthType = postDiary;
        } else if (btnTag == 2) {
//            con.thePostType = postPrivateMsg;
            con.postSthType = postPrivateMsg;
        } else if (btnTag == 3) {
//            con.thePostType = postActivity;
            con.postSthType = postActivity;
        } else if (btnTag == 4) {
//            con.thePostType = postWantToSay;
            con.postSthType = postWantToSay;
        }
        [self showPostViewCon:nil];
    }
}

- (void)showCustomCamera:(NSNotification*)noti {
    if (self.postSthViewCon) {
        self.postSthViewCon = nil;
    }
    if (self.customPicker.overlayViewCon) {
        self.customPicker.overlayViewCon = nil;
    }
    if (self.customPicker) {
        self.customPicker = nil;
    }
//    if (self.overlayViewCon) {
//        self.overlayViewCon = nil;
//    }
    if (self.agImgPickerCon) {
        self.agImgPickerCon = nil;
    }
    PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
    self.postSthViewCon = con;
    con.postSthType = postPhoto;
    if ([noti object]) {
        con.topicId = MY_LAST_TOPIC_ID;
    }
    CameraPickerController *imagePickerController = [[CameraPickerController alloc] init];
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self buildMultiSelectAlbum];
//        [self.navigationController pushViewController:_agImgPickerCon animated:YES];
        [self presentModalViewController:_agImgPickerCon animated:YES];
        
        _postBtn.selected = NO;
        [self showOrHidePostView];
        return;
    }
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.showsCameraControls = YES;
    imagePickerController.navigationBarHidden = YES;
    imagePickerController.wantsFullScreenLayout = YES;
//    imagePickerController.cameraViewTransform = CGAffineTransformScale(imagePickerController.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
    
    CameraOverlayViewController *tmp = [[CameraOverlayViewController alloc] initWithNibName:@"CameraOverlayViewController" bundle:nil];
    tmp.pickerController = imagePickerController;
    [tmp buildMorePicBtnBlock:^(UIButton *morePicBtn) {
        if (!_agImgPickerCon) {
            [self buildMultiSelectAlbum];
        }
        [imagePickerController presentModalViewController:_agImgPickerCon animated:YES];
    }];
    self.customPicker = imagePickerController;
    self.customPicker.overlayViewCon = tmp;
    imagePickerController.cameraOverlayView = self.customPicker.overlayViewCon.view;
//    self.overlayViewCon = tmp;
//    imagePickerController.cameraOverlayView = _overlayViewCon.view;
//    imagePickerController.overlayViewCon = _overlayViewCon;
//    self.customPicker = imagePickerController;
    
//    [self performBlock:^(id sender) {
//        [self getAllPhotoImages];
//    } afterDelay:1.0f];
    
//    [self getAllPhotoImages];
    [self presentModalViewController:imagePickerController animated:YES];
    
//    [self performBlock:^(id sender) {
//        FuckViewController *fuckCon = [[FuckViewController alloc] initWithNibName:@"FuckViewController" bundle:nil];
//        [imagePickerController presentModalViewController:fuckCon animated:NO];
//        [self performBlock:^(id sender) {
//            [fuckCon dismissModalViewControllerAnimated:NO];
//        } afterDelay:1.5f];
//    } afterDelay:1.2f];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    if (_customPicker && _shouldPresentAConToOpenCamera) {
        _customPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        UIViewController *con = [[UIViewController alloc] init];
//        FuckViewController *fuckCon = [[FuckViewController alloc] initWithNibName:@"FuckViewController" bundle:nil];
//        fuckCon.modalPresentationStyle = UIModalPresentationCurrentContext;
        [_customPicker presentModalViewController:con animated:NO];
        [self performBlock:^(id sender) {
            [con dismissModalViewControllerAnimated:NO];
        } afterDelay:0.1f];
        _shouldPresentAConToOpenCamera = NO;
    }
}

- (void)getAllPhotoImages {
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    //    self.assetsArray = collector;
    //    return;
    
    ALAssetsLibrary *al = [CameraOverlayViewController defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset && [[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto] && [collector count] < 10) {
                  [collector addObject:asset];
              }
          }];
         self.customPicker.overlayViewCon.assetsArray = collector;
         [self presentModalViewController:_customPicker animated:YES];
//         [self performBlock:^(id sender) {
//             [self.customPicker.overlayViewCon.jtListView reloadData];
//         } afterDelay:0.2f];
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
}

- (void)showPostViewCon:(NSNotification*)noti {
    if (noti) {
        NSMutableArray *imgArray = [noti object];
        [_postSthViewCon.imagesArray removeAllObjects];
        for (int i = 0; i < [imgArray count]; i++) {
            ALAsset *asset = (ALAsset*)[[imgArray objectAtIndex:i] objectForKey:IMAGE];
            [_postSthViewCon.imagesArray addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
        }
//        [_postSthViewCon.imagesArray addObjectsFromArray:imgArray];
        [_postSthViewCon setupHorizontalViewWithType:postPhoto];
//        [_postSthViewCon.postSthView.jtListView reloadData];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_postSthViewCon];
    nav.navigationBarHidden = YES;
    if (noti || _postSthViewCon.postSthType == postPhoto) {
        [_customPicker presentModalViewController:nav animated:YES];
    } else {
        [self presentModalViewController:nav animated:YES];
    }
    _postBtn.selected = NO;
    [self showOrHidePostView];
}

- (void)dismissCustomCamera:(NSNotification*)noti {
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver < 5.0) {
        if (_agImgPickerCon && _agImgPickerCon.parentViewController) {
            [_agImgPickerCon dismissModalViewControllerAnimated:NO];
            self.agImgPickerCon = nil;
        }
    } else {
        if (_agImgPickerCon && _agImgPickerCon.presentingViewController) {
            [_agImgPickerCon dismissModalViewControllerAnimated:NO];
            self.agImgPickerCon = nil;
        }
    }
    [_customPicker dismissModalViewControllerAnimated:YES];
    
    if (self.postSthViewCon) {
        self.postSthViewCon = nil;
    }
    if (self.customPicker.overlayViewCon) {
        [self.customPicker.overlayViewCon.assetsArray removeAllObjects];
        self.customPicker.overlayViewCon.assetsArray = nil;
        self.customPicker.overlayViewCon = nil;
    }
    if (self.customPicker) {
        self.customPicker = nil;
    }
//    if (self.overlayViewCon) {
//        self.overlayViewCon = nil;
//    }
}

//- (void)buildCustomCameraView:(NSNotification*)noti {
//    if (self.cameraViewController) {
//        self.cameraViewController = nil;
//    }
////    if (self.customPicker) {
////        self.customPicker = nil;
////    }
//    CameraOverlayViewController *tmp = [[CameraOverlayViewController alloc] initWithNibName:@"CameraOverlayViewController" bundle:nil];
//    tmp.pickerController = _customPicker;
//    self.cameraViewController = tmp;
//    _customPicker.cameraOverlayView = _cameraViewController.view;
//}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self addSomeElements:viewController];
}

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
    Class cl = [aView class];
    NSString *desc = [cl description];
    if ([name isEqualToString:desc])
        return aView;
    for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

#pragma mark addSomeElements
- (void)addSomeElements:(UIViewController *)viewController {
	//Add the motion view here, PLCameraView and picker.view are both OK
	UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
	//Add label to cropOverlay
//	UIView *cropOverlay=[self findView:PLCameraView withName:@"PLCropOverlay"];
//    [cropOverlay addSubview:_cameraViewController.view];
	
	//Change the BottomBar for taking camera a little bit
	UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    
    self.customPicker.overlayViewCon.retakeBtn = (UIButton*)[self findView:viewController.view withName:@"PLCropOverlayBottomBarButton"];
    self.customPicker.overlayViewCon.theCon = viewController;
    
    self.customPicker.overlayViewCon.bottomBar = bottomBar;
    
//    self.cameraBottomView = bottomBar;
//	_overlayViewCon.retakeBtn = (UIButton*)[self findView:viewController.view withName:@"PLCropOverlayBottomBarButton"];
//    _overlayViewCon.theCon = viewController;
//    
//    _overlayViewCon.bottomBar = bottomBar;
    
    bottomBar.hidden = YES;
}

- (void)hideCameraBottomBar {
	UIView *PLCameraView=[self findView:self.customPicker.overlayViewCon.theCon.view withName:@"PLCameraView"];
	UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    bottomBar.hidden = YES;
}

#pragma mark - imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    [picker dismissModalViewControllerAnimated:YES];
    UIImage *theImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (!self.postSthViewCon.imagesArray) {
        self.postSthViewCon.imagesArray = [[NSMutableArray alloc] init];
    }
    [self.postSthViewCon.imagesArray removeAllObjects];
    [self.postSthViewCon.imagesArray addObject:theImage];
    _postSthViewCon.shouldAddDefaultImage = YES;
    [self showPostViewCon:nil];
    for (int i = 0; i < 3; i++) {
        UIView *obj = [self.customPicker.overlayViewCon.containerView.subviews objectAtIndex:i];
//        UIView *obj = [_overlayViewCon.containerView.subviews objectAtIndex:i];
        obj.hidden = NO;
    }
    [self.customPicker.overlayViewCon canCameraBtnSelect:NO];
    [self.customPicker.overlayViewCon canOkBtnSelect:YES];
//    [_overlayViewCon canCameraBtnSelect:NO];
//    [_overlayViewCon canOkBtnSelect:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
}

#pragma mark - 预先加载家人和空间列表，为发表页面做准备
- (void)sendRequestForList:(NSNotification*)noti {
    [self sendRequestForFamilyList:nil];
    [self sendRequestForZoneList:nil];
}

#pragma mark - 家人列表
- (void)sendRequestForFamilyList:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=fmembers&perpage=100&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            return ;
        }
//        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//        tmpDict = [Common copyAllDataFromDict:dict];
        [PlistManager deletePlist:PLIST_FAMILY_LIST];
        [PlistManager writePlist:(NSMutableDictionary*)dict forKey:MY_UID plistName:PLIST_FAMILY_LIST];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
    }];
}

#pragma mark - 空间列表
- (void)sendRequestForZoneList:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@do.php?ac=ajax&op=taglist&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            return ;
        }
//        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
//        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
//        tmpDict = [Common copyAllDataFromDict:dict];
//        [PlistManager writePlist:tmpDict forKey:MY_UID plistName:PLIST_ZONE_LIST];
        [PlistManager deletePlist:PLIST_ZONE_LIST];
        [PlistManager writePlist:(NSMutableDictionary*)dict forKey:MY_UID plistName:PLIST_ZONE_LIST];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}











@end
