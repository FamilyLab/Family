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

@class CameraOverlayViewController;
@class PostViewController;

@interface MyTabBarController : UITabBarController <BottomViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BottomView *tabBarView;

@property (nonatomic, strong) UIView *postContainerView;
@property (nonatomic, strong) BottomView *postBottomView;
@property (nonatomic, strong) UIButton *postBtn;
@property (nonatomic, strong) UIImageView *inPostBtnImgView;

@property (nonatomic, assign) int currIndex;

@property (nonatomic, strong) IBOutlet LoadingView *loadingView;

@property (nonatomic, assign) int dialogNum;
@property (nonatomic, assign) int noticeNum;

@property (nonatomic, strong) CameraOverlayViewController *cameraViewController;
@property (nonatomic, strong) UIImagePickerController *customPicker;

@property (nonatomic, strong) PostViewController *postViewCon;

@property (nonatomic, assign) AGImagePickerController *agImgPickerCon;
@property (nonatomic, assign) UIView *cameraBottomView;

- (void)selecteFirstIndexForLogout;

@end
