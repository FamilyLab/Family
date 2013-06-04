//
//  AddChildViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BottomView.h"
#import "TopView.h"
#import "CellHeader.h"
#import "MyImagePickerController.h"

@interface AddChildViewController : BaseViewController <BottomViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) TopViewType topViewType;
@property (nonatomic, strong) BottomView *bottomView;

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UILabel *birthdayLbl;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
//@property (nonatomic, strong) IBOutlet UITextField *birthdayField;

@property (nonatomic, strong) UIImage *theImage;

@property (nonatomic, copy) NSString *myHeadUrl;
@property (nonatomic, strong) UIImage *myHeadImage;
@property (nonatomic, copy) NSString *myNameStr;


@property (nonatomic, strong) IBOutlet UIImageView *birthdayImgView;
@property (nonatomic, assign) BOOL isAddAZone;

@property (nonatomic, assign) BOOL isShowChildInfo;

//@property (nonatomic, assign) BOOL hasChangeButNotPressedOkBtn;
@property (nonatomic, assign) BOOL canEditChildInfo;

@property (nonatomic, copy) NSString *babyId;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *picId;

@property (nonatomic, copy) NSString *preNameStr;
@property (nonatomic, copy) NSString *preSexStr;
@property (nonatomic, copy) NSString *preBirthdayStr;

@property (nonatomic, copy) NSString *picUrlForAddZone;


- (void)fillChildInfo:(NSDictionary*)dict;

@end
