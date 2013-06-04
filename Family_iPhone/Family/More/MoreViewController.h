//
//  MoreViewController.h
//  Family
//
//  Created by Aevitx on 13-1-18.
//  Copyright (c) 2013年 apple. All rights reserved.
//

//#import "BaseViewController.h"
#import "TableController.h"
#import "TopView.h"
#import "FamilyListViewController.h"
#import "MyHeadButton.h"
#import "MWPhotoBrowser.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
//#import "EMHint.h"

@interface MoreViewController : TableController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, MWPhotoBrowserDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate> {
//    EMHint *_hint;
}

//@property (nonatomic, strong) IBOutlet UIScrollView *theScrollView;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn;
//@property (nonatomic, strong) IBOutlet UIButton *logoutBtn;

@property (nonatomic, strong) IBOutlet UIView *tableHeader;
@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *birthDayLbl;
@property (nonatomic, strong) IBOutlet UIView *tableFooter;
@property (nonatomic, strong) IBOutlet UIButton *birthdayBtn;

@property (nonatomic, strong) NSDictionary *dataDict;



//@property (nonatomic, strong) NSDictionary *tipsDict;
@property (nonatomic, strong) NSArray *sectionTitleArray;
@property (nonatomic, strong) NSArray *tipsArray;

@property (nonatomic, retain) NSMutableArray *photosArray;

@end
