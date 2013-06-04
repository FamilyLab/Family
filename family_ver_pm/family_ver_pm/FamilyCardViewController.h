//
//  FamilyCardViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-4-1.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"
#import "TopBarView.h"
#import "MyHeadButton.h"
#import "FamilyCardViewControllerDelegate.h"

@interface FamilyCardViewController : UIViewController<UIScrollViewDelegate,BackBottomBarViewDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    BackBottomBarView *customBackBottomBarView;
    TopBarView *customTopBarView;
}

@property(nonatomic, retain) id<FamilyCardViewControllerDelegate> delegate;

@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSMutableDictionary *dataDict;

@property(nonatomic, retain) IBOutlet UIScrollView *theScrollView;

@property(nonatomic, retain) IBOutlet MyHeadButton *headBtn;
@property(nonatomic, retain) IBOutlet UIImageView *vipTipImg;
@property(nonatomic, retain) IBOutlet UILabel *nameLbl;
@property(nonatomic, retain) IBOutlet UILabel *nicknameLbl;
@property(nonatomic, retain) IBOutlet UILabel *phoneLbl;
@property(nonatomic, retain) IBOutlet UILabel *birthLbl;

@property(nonatomic, retain) IBOutlet UIView *detailsView;
@property(nonatomic, retain) IBOutlet UILabel *tipsLbl;
@property(nonatomic, retain) IBOutlet UILabel *countPerLbl;
@property(nonatomic, retain) IBOutlet UIButton *countPerBtn;
@property(nonatomic, retain) IBOutlet UILabel *countSpaceLbl;
@property(nonatomic, retain) IBOutlet UIButton *countSpaceBtn;
@property(nonatomic, retain) IBOutlet UIButton *settingBtn;

@property(nonatomic, retain) IBOutlet UIView *appendView;
@property(nonatomic, retain) IBOutlet UIButton *callBtn;
@property(nonatomic, retain) IBOutlet UIButton *messageBtn;
@property(nonatomic, retain) IBOutlet UILabel *lastLoginLbl;

@end
