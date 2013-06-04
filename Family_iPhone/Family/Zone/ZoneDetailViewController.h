//
//  ZoneDetailViewController.h
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BottomView.h"
#import "FeedDetailViewController.h"
//#import "SYPaginator.h"

@interface ZoneDetailViewController : BaseViewController <BottomViewDelegate, UIScrollViewDelegate> {
    int currShownIndex;
    BOOL isSecondViewInCenter;
    BOOL isSwipeLeft;
    int currPageIndex, prevPageIndex, nextPageIndex;
    
    int currentRequestPage;
    int feedNum;
    BOOL isFirstShow;
}

@property (nonatomic, strong) IBOutlet UIScrollView *theScrollView;
@property (nonatomic, strong) FeedDetailViewController *zeroCon;
@property (nonatomic, strong) FeedDetailViewController *firstCon;
@property (nonatomic, strong) FeedDetailViewController *secondCon;
//@property (nonatomic, strong) FeedDetailViewController *thirdCon;

@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) BottomView *bottomView;

@end
