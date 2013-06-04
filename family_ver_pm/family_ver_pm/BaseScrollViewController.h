//
//  BaseScrollViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-4-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalScrollViewController.h"
#import "MainViewController.h"
#import "BottomBarViewDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "BottomBarView.h"
#import "PreviousButton.h"
#import "NextButton.h"

@interface BaseScrollViewController : HorizontalScrollViewController<BottomBarViewDelegate, UIAlertViewDelegate> {
    BOOL shouldShowHUD;             //页面加载时显示HUD吗？
    BOOL isPullingData;             //是否正在下载数据：infoList 或者 detailInfoList
    BOOL shouldShowNextDetailHUD;
    int currentListPage;
    int currentDetailIndex;
    BOOL reloadTableInRequest;//
    BOOL isSpaceView;
    BOOL isMyLoveView;
    BOOL isVideoView;
    int subScrollViewType;
    
    BOOL hasDismissPrevBtn;
    BOOL hasDismissNextBtn;
}

//@property (strong, nonatomic) NSString *commentViewPlaceHolder;
@property (strong, nonatomic) NSString *commentSuccessTib;
@property (strong, nonatomic) NSString *commentAlertViewTitle;

@property (strong, nonatomic) MainViewController *delegate;
@property (strong, nonatomic) UIView *blankView;//起始空白页
@property (strong, nonatomic) NSMutableArray *operationQueue;
@property (strong, nonatomic) BottomBarView *bottomBar;
@property (strong, nonatomic) NSMutableArray *likeFeedList;

@property (strong, nonatomic) PreviousButton *prevBtn;
@property (strong, nonatomic) NextButton *nextBtn;


- (void)requestInfoList:(int)page;
- (void)requestSpaceInfoList:(int)page;
- (void)requestMyLikeList:(int)page;
- (AFHTTPRequestOperation *)requestInfoListOperation:(int)page;
- (AFHTTPRequestOperation *)requestSpaceInfoListOperation:(int)page;
- (void)requestDetailInfo:(int)i fromPath:(NSString *)path;
- (void)pushRequestOperation:(AFHTTPRequestOperation *)operation;
- (int)numberOfTotalDataPage;
- (void)comment:(NSString *)comment
     toObjectID:(NSString *)objectID
     withIDType:(NSString *)idtype;
- (void)pressCommentBtn;
- (void)pressLikeBtn;
- (void)pressRepostBtn;
- (void)confirmToRepostwithMessage:(NSString *)repostMessage
                           toSpace:(NSString *)tagName;//需要在子controller中重载
- (void)confirmToRepostwithMessage:(NSString *)repostMessage
                           toSpace:(NSString *)tagName
                        withIDtype:(NSString *)idtype;
- (NSString *)messageToBeRepost;
//子类需要实现
- (void (^)(id sender))commentPostSuccessBlock;//提交评论成功后

- (UIView *)viewFromDataPage:(int)dataPage;

- (NSString *)pathOfInfoListRequest;
- (NSDictionary *)parasOfInfoListRequest:(int)page;

- (NSString *)pathOfDetailInfoRequest;
- (NSDictionary *)parasOfDetailInfoRequest:(int)i;
- (NSString *)returnCommentViewTitle;

- (void)reblog;
- (void)like;

@end
