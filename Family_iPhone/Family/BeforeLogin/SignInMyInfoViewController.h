//
//  SignInMyInfoViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BottomView.h"
#import "TopView.h"

@interface SignInMyInfoViewController : BaseViewController <BottomViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    BOOL isHeadChanged;
    BOOL isNameChanged;
    BOOL isFirstShow;
}

@property (nonatomic, assign) TopViewType topViewType;
@property (nonatomic, strong) BottomView *bottomView;

@property (nonatomic,strong) IBOutlet UITextField *nameField;
@property (nonatomic,strong) UIImage *theImage;
@property (nonatomic, copy) NSString *nameStr;

@end
