//
//  FeedDetailViewController.h
//  Family
//
//  Created by Aevitx on 13-1-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "TopView.h"
#import "BottomView.h"
#import "FeedCell.h"
#import "CellHeader.h"
#import "HPGrowingTextView.h"
#import "JTListView.h"
#import "MyPanelView.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "SinaWeiboRequest.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "MyYIPopupTextView.h"

@interface FeedDetailViewController : BaseViewController <BottomViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, JTListViewDataSource, JTListViewDelegate, UIActionSheetDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, WXApiDelegate, YIPopupTextViewDelegate> {
    CGFloat offsetYOfJoin;
    CGFloat offsetYOfComment;
    //    BOOL isCommentCell;
    BOOL isOperatViewBtnPressed;
    BOOL isFirstShownComment;
    enum WXScene _scene;
}

//@property (nonatomic, assign) FeedCellType detailType;
//@property (nonatomic, strong) TopView *topView;
//@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;
@property (nonatomic, strong) BottomView *bottomView;

//@property (nonatomic, copy) NSString *idType;
//@property (nonatomic, copy) NSString *feedId;
//@property (nonatomic, copy) NSString *feedCommentId;
//@property (nonatomic, copy) NSString *userId;

//@property (nonatomic, strong) NSMutableDictionary *dataDict;
//@property (nonatomic, assign) BOOL isFirstShow;
//@property (nonatomic, strong) NSMutableArray *picListArray;

//@property (nonatomic, strong) UIWebView *theWebView;
@property (nonatomic, assign) BOOL hasLoaded;

//@property (nonatomic, strong) NSMutableArray *joinMemberArray;
//@property (nonatomic, assign) BOOL isShowingComment;

@property (nonatomic, assign) int indexRow;

@property (nonatomic, assign) BOOL isFromZone;
@property (nonatomic, assign) BOOL isFirstShowFromZone;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) int currRequestPageToGetIdArray;
@property (nonatomic, assign) int allFeedNum;


//@property (nonatomic, assign) BOOL hasLoved;

@property (nonatomic, strong) IBOutlet UIView *theInputView;
@property (nonatomic, strong) IBOutlet HPGrowingTextView *growingTextView;

@property (nonatomic, strong) IBOutlet UIView *faceView;

@property (nonatomic, strong) NSMutableArray *faceArray;

@property (nonatomic, strong) JTListView *theListView;
@property (nonatomic, strong) MyPanelView *panelView;
@property (nonatomic, strong) NSMutableArray *idArray;
//@property (nonatomic, strong) NSMutableArray *dataDictArray;
//@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) IBOutlet UIButton *goBackBtn;
@property (nonatomic, strong) IBOutlet UIButton *goForwardBtn;

@property (nonatomic, copy) NSString *replyWhoseNameStr;
//@property (nonatomic, copy) NSString *urlForRepost;

- (void)uploadRequestToLove;
- (void)showCommentInputView:(BOOL)isReplyAComment;

@end
