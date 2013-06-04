//
//  MyIssueViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"
#import "SSTextView.h"
#import "NIDropDown.h"
#import "MLTableAlert.h"
#import "JTListView.h"

typedef enum
{
    publishphoto      = 0,
    publisharticle    = 1,
}WhatToPublish;

@interface MyIssueViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,NIDropDownDelegate,UIGestureRecognizerDelegate,BackBottomBarViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,JTListViewDataSource,JTListViewDelegate>
{
    BackBottomBarView *customBottomBarView;
    NIDropDown *dropDownBtn;
    UIView *bgrImg;
    UIImageView *indicateImg;
    //NSMutableArray *picArray;
    
    int numWithoutDefaultImage;
    int currIndex;
    int height;
}

@property(nonatomic, assign) WhatToPublish whatToPublish;
@property(nonatomic, retain) JTListView *photoContantView;
@property(nonatomic, retain) UIButton *curBtn;
@property(nonatomic, retain) IBOutlet UIScrollView *theScrollView;
@property(nonatomic, retain) IBOutlet SSTextView *theTextView;
@property(nonatomic, retain) IBOutlet UIView *contantView;
@property(nonatomic, retain) IBOutlet UIButton *spaceBtn;
@property(nonatomic, retain) UIButton *publishBtn;
@property(nonatomic, retain) IBOutlet UILabel *spaceLbl;
@property(nonatomic, retain) MLTableAlert *spaceAlert;
@property(nonatomic, retain) NSMutableArray *spaceArray;
@property(nonatomic, retain) NSMutableArray *photoArray;
@property(nonatomic, retain) NSMutableArray *picIdArray;

@end
