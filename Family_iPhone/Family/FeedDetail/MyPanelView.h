//
//  MyPanelView.h
//  Family
//
//  Created by Aevitx on 13-3-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "CellHeader.h"
//#import "PanelView.h"
#import "PullTableView.h"
#import "SSLoadingView.h"
#import "MWPhotoBrowser.h"

//typedef enum {
//    unknownDetailType       = -1,//
//    photoDetailType         = 0,//照片
//    blogDetailType          = 1,//日志
//    videoDetailType         = 2,//视频
//    eventDetailType         = 3//活动
//} FeedDetailType;

//@protocol MyPanelViewDelegate;

@interface MyPanelView : UIView <PullTableViewDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) CellHeader *cellHeader;

@property (nonatomic, copy) NSString *idType;
@property (nonatomic, copy) NSString *feedId;
@property (nonatomic, copy) NSString *feedCommentId;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) PullTableView *pullTable;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL needRemoveObjects;

@property (nonatomic, assign) BOOL isFirstShow;
//@property (nonatomic, strong) NSMutableArray *picListArray;

@property (nonatomic, strong) UIWebView *theWebView;
@property (nonatomic, assign) BOOL hasLoaded;

//@property (nonatomic, strong) NSMutableArray *joinMemberArray;
//@property (nonatomic, assign) BOOL isShowingComment;

@property (nonatomic, assign) int indexRow;
@property (nonatomic, assign) int indexRowInFeedList;

@property (nonatomic, assign) BOOL isFromZone;
@property (nonatomic, assign) BOOL isFirstShownComment;

@property (nonatomic, assign) BOOL isRefreshDataFromNet;
@property (nonatomic, assign) BOOL isLoadMoreDataFromNet;

@property (nonatomic, strong) SSLoadingView *ssLoading;

//@property (nonatomic, assign) id<MyPanelViewDelegate>delegate;


@property (nonatomic, retain) NSMutableArray *photosArray;

- (void)sendRequest:(id)sender;
- (void)stopLoading:(id)sender;
- (void)addPullTableView;
- (void)fillDataForDetail;
- (void)sendRequestToDetail:(id)sender;
- (void)sendRequestToComment:(id)sender;

@end

//@protocol MyPanelViewDelegate <NSObject>
//
//- (void)sendRequestForTableViewInMyPanelView:(id)sender;
//
//@end




