//
//  FeedViewController.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableController.h"
#import "FeedCell.h"
//#import "LoadingView.h"
#import "BottomView.h"
#import "YIPopupTextView.h"

@interface FeedViewController :TableController <UIActionSheetDelegate, BottomViewDelegate, YIPopupTextViewDelegate> {
    BOOL canRefreshCountNum;
    
    BOOL isFirstShowTopic;
}

@property (nonatomic, assign) BOOL isForMyLoveFeed;
@property (nonatomic, strong) BottomView *bottomView;
//@property (nonatomic, strong) IBOutlet UIButton *tmpBtn;
//@property(nonatomic, retain) NSMutableArray *otherTypeArray;
@property (nonatomic, strong) NSMutableArray *loveArray;

- (void)loveThisWithIndex:(int)indexRow andCell:(FeedCell*)cell;

@end
