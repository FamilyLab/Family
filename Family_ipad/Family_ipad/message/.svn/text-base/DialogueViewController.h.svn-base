//
//  DialogueViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "HPGrowingTextView.h"
#import "DetailHeaderView.h"
@interface DialogueViewController : UIViewController <UIBubbleTableViewDataSource, UITextViewDelegate, UITextViewDelegate, HPGrowingTextViewDelegate> {
    int currentPage;
    BOOL isFirstShow;
}

@property (nonatomic, strong) IBOutlet UIBubbleTableView *bubbleTable;
@property (nonatomic, strong) NSMutableArray *bubbleData;
@property(nonatomic, retain) NSMutableArray *dataArray;


@property (nonatomic, strong) IBOutlet UIView *theInputView;
@property (nonatomic, strong) IBOutlet HPGrowingTextView *growingTextView;
@property (nonatomic, strong) IBOutlet DetailHeaderView *topView;


@property (nonatomic, copy) NSString *fromUserId;//我自己
@property (nonatomic, copy) NSString *toUserId;//对方

@property (nonatomic, copy) NSString *fromHeadStr;//我自己
@property (nonatomic, copy) NSString *toHeadStr;//对方
- (IBAction)backAction:(id)sender;

@end
