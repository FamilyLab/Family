//
//  MoreViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableController.h"
#import "MyImagePickerController.h"
#import "SinaWeibo.h"
@class HeaderView;
@interface MoreViewController : TableController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,SinaWeiboDelegate>
@property (nonatomic,strong)IBOutlet HeaderView *header;
@property (nonatomic,strong)IBOutlet UIView *tableFooter;
@property (nonatomic,strong)IBOutlet UIButton *familyNewsButton;
@property (nonatomic,strong)IBOutlet UIButton *applyFamilyButton;
@property (nonatomic,strong)IBOutlet UIButton *inviteFamilyButton;
@property (nonatomic,strong)IBOutlet UIButton *childButton;
@property (nonatomic,strong)IBOutlet UIButton *addChildButton;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *contentArray;
@property (nonatomic, strong) IBOutlet UIView *tableHeader;
@property (nonatomic, strong) IBOutlet UIButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *birthDayLbl;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSDictionary *tipsDict;
@property (nonatomic,strong)MyImagePickerController *picker;
@property (nonatomic,strong)UIPopoverController *datePickerContainer;
- (IBAction)familyNewsAction:(id)sender;
- (IBAction)headBtnPressed:(id)sender;
- (IBAction)nameBtnPressed:(id)sender;
- (IBAction)phoneBtnPressed:(id)sender;
@end
