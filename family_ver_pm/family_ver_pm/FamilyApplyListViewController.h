//
//  FamilyApplyListViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-4-4.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopBarView.h"
#import "BackBottomBarView.h"
#import "MyTableViewController.h"
#import "FamilyApplyListCell.h"

typedef enum
{
    familyapplylistviewcontroller      = 0,
    familysearchlistviewcontroller     = 1,
}WhichTypeVC;

@interface FamilyApplyListViewController : MyTableViewController<UITextFieldDelegate, BackBottomBarViewDelegate, FamilyApplyListCellDelegate>
{
    TopBarView *customTopBarView;
    BackBottomBarView *customBackBottomBarView;
    BOOL isFirstShow;
}

@property(nonatomic, assign) WhichTypeVC whichTypeVC;

@property(nonatomic, retain) IBOutlet UIView *contantView;
@property(nonatomic, retain) IBOutlet UIButton *searchBtn;
@property(nonatomic, retain) IBOutlet UIButton *cancelBtn;
@property(nonatomic, retain) IBOutlet UITextField *searchTextView;



@end
