//
//  CameraOverlayViewController.h
//  Family
//
//  Created by Aevitx on 13-5-29.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGImagePickerController+Helper.h"
#import "JTListView.h"

typedef void(^MorePicBtnPressedBlock)(UIButton *morePicBtn);//定义块类型morePicBtnPressedBlock: 点击按钮时的回调

@class SelectedButton;

@interface CameraOverlayViewController : UIViewController <AGImagePickerControllerDelegate, JTListViewDelegate, JTListViewDataSource>

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *selectedPicArray;
@property (nonatomic, strong) IBOutlet UIButton *cameraBtn;
@property (nonatomic, strong) IBOutlet UIButton *okBtn;

@property (nonatomic, assign) UIImagePickerController *pickerController;

@property (nonatomic, strong) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) UIButton *retakeBtn;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) IBOutlet UIButton *morePicBtn;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) AGImagePickerController *agImgPickerCon;

@property (nonatomic, strong) UIViewController *theCon;

@property (nonatomic, assign) int countNum;

@property (nonatomic, assign) BOOL hasTakePicture;


@property (nonatomic, copy) MorePicBtnPressedBlock morePicBtnPressedBlock;


@property (nonatomic, strong) IBOutlet JTListView *jtListView;

@property (nonatomic, strong) NSMutableArray *assetsArray;

- (void)buildMorePicBtnBlock:(MorePicBtnPressedBlock)actionBlock;
- (void)canCameraBtnSelect:(BOOL)canSelect;
- (void)canOkBtnSelect:(BOOL)canSelect;
+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
