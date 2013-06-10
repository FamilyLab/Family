//
//  MyTabBarController.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomView.h"
#import "LoadingView.h"
#import "AGImagePickerController+Helper.h"

//@class CameraOverlayViewController;
//@class PostViewController;
@class PostSthViewController;
@class CameraPickerController;

@interface MyTabBarController : UITabBarController <BottomViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) BottomView *tabBarView;

@property (nonatomic, strong) UIView *postContainerView;
@property (nonatomic, strong) BottomView *postBottomView;
@property (nonatomic, strong) UIButton *postBtn;
@property (nonatomic, strong) UIImageView *inPostBtnImgView;

@property (nonatomic, assign) int currIndex;

@property (nonatomic, strong) IBOutlet LoadingView *loadingView;

@property (nonatomic, assign) int dialogNum;
@property (nonatomic, assign) int noticeNum;

//@property (nonatomic, strong) CameraOverlayViewController *overlayViewCon;
@property (nonatomic, strong) CameraPickerController *customPicker;

//@property (nonatomic, strong) PostViewController *postViewCon;
@property (nonatomic, strong) PostSthViewController *postSthViewCon;

@property (nonatomic, strong) AGImagePickerController *agImgPickerCon;
//@property (nonatomic, assign) UIView *cameraBottomView;

@property (nonatomic, assign) BOOL shouldPresentAConToOpenCamera;


- (void)selecteFirstIndexForLogout;
- (void)showCustomCamera:(NSNotification*)noti;
//- (void)hidePostMenu;
- (void)hideCameraBottomBar;

@end
