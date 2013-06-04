//
//  RepostViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-5-10.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseScrollViewController.h"
#import "PickerViewWithToolBarDelegate.h"
#import "PickerViewWithToolBar.h"

@interface RepostViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, PickerViewWithToolBarDelegate, UITextFieldDelegate> {
    BOOL isPullingData;
    BOOL hasShowPicker;
    BOOL hasShowHUD;
}

@property (strong, nonatomic) IBOutlet UITextField *repostTextField;
@property (strong, nonatomic) IBOutlet UIButton *selectSpaceBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *tagName;
@property (strong, nonatomic) BaseScrollViewController *delegate;
@property (strong, nonatomic) PickerViewWithToolBar *pickerView;
@property (strong, nonatomic) NSMutableArray *tagNameList;

- (IBAction)selectSpace:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)confirm:(id)sender;
- (void)dismissPicker;

@end
