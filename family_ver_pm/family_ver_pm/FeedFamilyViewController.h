//
//  FeedFamilyViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"

typedef enum {
    feedfamilyDVC      = 1,
    feedfamilysecondVC     = 2,
}FromWhichVC;

@interface FeedFamilyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BackBottomBarViewDelegate>
{
    BackBottomBarView *customBackBottomBarView;
}

@property(nonatomic, assign) FromWhichVC fromWhichVC;
@property(nonatomic, retain) IBOutlet UITableView *feedFamilyTableView;
@property(nonatomic, retain) NSArray *feedFamilyArray;
@property(nonatomic, retain) UILabel *familyApplyCount;

@end
