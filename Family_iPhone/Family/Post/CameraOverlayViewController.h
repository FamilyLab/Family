//
//  CameraOverlayViewController.h
//  Family
//
//  Created by Aevitx on 13-5-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGImagePickerController+Helper.h"

typedef void(^MorePicBtnPressedBlock)(UIButton *morePicBtn);//定义块类型morePicBtnPressedBlock: 点击按钮时的回调

@class SelectedButton;

@interface CameraOverlayViewController : UIViewController <AGImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, assign) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *selectedPicArray;
@property (nonatomic, strong) IBOutlet UIButton *cameraBtn;
@property (nonatomic, strong) IBOutlet UIButton *okBtn;

@property (nonatomic, strong) IBOutlet UIButton *backBtn;
@property (nonatomic, assign) UIButton *retakeBtn;
@property (nonatomic, assign) UIButton *doneBtn;
@property (nonatomic, strong) IBOutlet UIButton *morePicBtn;

@property (nonatomic, assign) UIViewController *theCon;

@property (nonatomic, assign) int countNum;

@property (nonatomic, assign) BOOL hasTakePicture;

@property (nonatomic, assign) AGImagePickerController *agImgPickerCon;

@property (nonatomic, copy) MorePicBtnPressedBlock morePicBtnPressedBlock;

@property (nonatomic, assign) UIView *bottomBar;

- (void)buildMorePicBtnBlock:(MorePicBtnPressedBlock)actionBlock;
- (void)canCameraBtnSelect:(BOOL)canSelect;
- (void)canOkBtnSelect:(BOOL)canSelect;

@end
