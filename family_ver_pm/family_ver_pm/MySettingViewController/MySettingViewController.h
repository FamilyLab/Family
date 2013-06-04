//
//  MySettingViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"
#import "MyHeadButton.h"

@interface MySettingViewController : UIViewController<UIScrollViewDelegate,BackBottomBarViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BackBottomBarView *customBackBottomBarView;
}

@property(nonatomic, retain) NSMutableDictionary *dataDict;

@property(nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property(nonatomic, retain) IBOutlet MyHeadButton *headBtn;
@property(nonatomic, retain) IBOutlet UIImageView *vipTipImg;
@property(nonatomic, retain) IBOutlet UILabel *nameLbl;
@property(nonatomic, retain) IBOutlet UIButton *nameBtn;
@property(nonatomic, retain) IBOutlet UILabel *phoneLbl;
@property(nonatomic, retain) IBOutlet UILabel *birthLbl;
@property(nonatomic, retain) IBOutlet UIButton *birthBtn;

@property(nonatomic, retain) IBOutlet UIButton *moneyBtn;
@property(nonatomic, retain) IBOutlet UILabel *countMonLbl;
@property(nonatomic, retain) IBOutlet UILabel *countTaskLbl;
@property(nonatomic, retain) IBOutlet UIButton *countTaskBtn;
@property(nonatomic, retain) IBOutlet UIButton *serverBtn;
@property(nonatomic, retain) IBOutlet UIButton *myCollectBtn;
@property(nonatomic, retain) IBOutlet UIButton *aboutBtn;
@property(nonatomic, retain) IBOutlet UIButton *logoutBtn;
@end
