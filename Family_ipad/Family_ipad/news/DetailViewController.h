//
//  DetailViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "TableController.h"
#import "DetailHeaderView.h"
#import "YIPopupTextView.h"
#import "DetailFeedCell.h"
#import "MWPhotoBrowser.h"

@class CellHeader;
@interface DetailViewController : TableController< UIWebViewDelegate,UIScrollViewDelegate,YIPopupTextViewDelegate,MWPhotoBrowserDelegate> {
    CGFloat offsetYOfJoin;
    CGFloat offsetYOfComment;
    BOOL isOperatViewBtnPressed;
    IBOutlet UIButton *commentBtn;
    IBOutlet UIButton *joinBtn;
    IBOutlet UIImageView *delter_image;
}
//view
@property (nonatomic, strong)IBOutlet DetailHeaderView *topView;
@property (nonatomic, strong)IBOutlet UIButton *loveButton;
@property (nonatomic, strong)IBOutlet CellHeader *cellHeader;
@property (nonatomic, copy) NSString *idType;
@property (nonatomic, copy) NSString *feedId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong)NSMutableDictionary *dataDict;
@property (nonatomic, copy) NSString *feedCommentId;
@property (nonatomic, strong)IBOutlet UIView *faceView;
@property (nonatomic, strong)IBOutlet UIView *toolView;
@property (nonatomic, strong)UIPopoverController *faceContainer;
@property (nonatomic, assign)BOOL hasLoved;
@property (nonatomic, assign) BOOL isFirstShow;
//@property (nonatomic, strong) NSMutableArray *picListArray;

@property (nonatomic, strong) UIWebView *theWebView;
@property (nonatomic, assign) BOOL hasLoaded;
@property (nonatomic, assign) int indexRow;

@property (nonatomic, strong) NSMutableArray *joinMemberArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, assign) BOOL isFromZone;

//switch comment
- (IBAction)faceBtnForClickPressed:(UIButton*)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)swicthComment:(UIButton *)sender;
- (IBAction)loveAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)rePostBtnPressed:(UIButton*)sender;
- (IBAction)willShowFaceView:(id )sender;
- (IBAction)showActionSheet:(id)sender;
+ (FeedDetailType)whichDetailType:(NSString*)typeStr;
@end
