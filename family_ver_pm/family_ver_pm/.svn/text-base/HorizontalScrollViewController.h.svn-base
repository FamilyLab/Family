//
//  HorizontalScrollViewController.h
//  HorizontalScrollView
//
//  Created by pandara on 13-4-23.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableCell.h"

@interface HorizontalScrollViewController : UIViewController<UIScrollViewDelegate> {
    int totalScrollPage;
    int totalDataPage;//单独测试时使用，正式使用时用numberOfDataPage代替
    int currentDataPage;
    int originDataPage;
    int originScrollPage;
    CGPoint originalContentOffset;
    int totalDataPageFromURLAPI;
    
    BOOL didScrollToFirst;
    BOOL loadPrevPageLock;
    BOOL loadNextPageLock;
    BOOL loadFirstPageLock;
    BOOL lastPage;
    BOOL firstPage;
    BOOL receiveScrollEvent;
}

@property (strong, nonatomic) NSMutableArray *infoList;
@property (strong, nonatomic) NSMutableArray *detailInfoList;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *subViews;
@property (strong, nonatomic) NSMutableArray *reuseViewQueue;

- (int)numberOfDataPage;
- (int)numberOfTotalDataPage;
- (void)refreshBaseData;
- (void)reloadData;
- (void)backToFirstPage;
- (void)initElementWithScrollViewFrame:(CGRect)frame;
- (void)loadNextPage;
- (int)currentScrollPage;
- (MyTableCell *)dequeueReuseView;
- (MyTableCell *)dequeueReuseViewWithReuseID:(NSString *)reuseID;
- (void)reloadDataFromDataPage:(int)page;
- (void)setOriginDataPage;

//子类需要实现
- (UIView *)viewFromDataPage:(int)dataPage;
- (void)scrollPageDidChange:(int)currentScrollPage;
- (void)scrollToLastPage;
@end
