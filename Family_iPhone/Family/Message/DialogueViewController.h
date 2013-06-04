//
//  DialogueViewController.h
//  Family
//
//  Created by Aevitx on 13-1-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
//#import "BaseViewController.h"
#import "UIBubbleTableViewDataSource.h"
#import "CellHeader.h"
#import "TopView.h"
#import "SSTextView.h"
#import "HPGrowingTextView.h"

@interface DialogueViewController : BaseViewController <UIBubbleTableViewDataSource, UITextViewDelegate, UITextViewDelegate, HPGrowingTextViewDelegate> {
    int currentPage;
    BOOL isFirstShow;
    BOOL isFromPushWhenAppNotStart;
}

@property (nonatomic, strong) IBOutlet UIBubbleTableView *bubbleTable;
@property (nonatomic, strong) NSMutableArray *bubbleData;
@property(nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;
@property (nonatomic, strong) IBOutlet UIView *theInputView;
@property (nonatomic, strong) IBOutlet HPGrowingTextView *growingTextView;

@property (nonatomic, strong) TopView *topView;

@property (nonatomic, copy) NSString *pmId;//当前对话的id

@property (nonatomic, copy) NSString *fromUserId;//我自己
@property (nonatomic, copy) NSString *toUserId;//对方

@property (nonatomic, copy) NSString *fromHeadStr;//我自己
@property (nonatomic, copy) NSString *toHeadStr;//对方

@property (nonatomic, copy) NSString *fromVipStatus;//我自己
@property (nonatomic, copy) NSString *toVipStatus;//对方

@property (nonatomic, assign) int indexRow;

@property (nonatomic, assign) BOOL isLastRequestFinished;
//@property (nonatomic, assign) CGFloat theInputViewY;

@end
