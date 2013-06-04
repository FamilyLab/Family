//
//  DialogueListViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
#import "BackBottomBarView.h"
#import "MyTableViewController.h"

@interface DialogueListViewController :MyTableViewController<BackBottomBarViewDelegate>
{
    TopBarView *customTopBarView;
    BackBottomBarView *customBackBottomBarView;
}



@end
