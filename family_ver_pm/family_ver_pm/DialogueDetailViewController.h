//
//  DialogueDetailViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewCell.h"
#import "SSTextView.h"

@interface DialogueDetailViewController : UIViewController<UIBubbleTableViewDataSource,UIGestureRecognizerDelegate>
{
    UIBubbleTableViewCell *bubleCell;
    int currentPage;
    BOOL isFirstShow;
    
}


@property(nonatomic, retain) IBOutlet UIBubbleTableView *bubbleTableView;
@property(nonatomic, retain) IBOutlet UIView *containView;
@property(nonatomic, retain) IBOutlet UIButton *backBtn;
@property(nonatomic, retain) IBOutlet UIButton *faceBtn;
@property(nonatomic, retain) IBOutlet SSTextView *theTextView;
@property(nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property(nonatomic, retain) IBOutlet UILabel *speakerLbl;
@property(nonatomic, retain) IBOutlet UIImageView *theTextViewImg;

@property(nonatomic, retain) NSMutableArray *bubbleData;
@property(nonatomic, retain) NSMutableArray *dataArray;

@property(nonatomic, retain) NSString *PMId;
@property(nonatomic, retain) NSString *fromUserId;
@property(nonatomic, retain) NSString *toUserId;
@property(nonatomic, retain) NSString *fromHeadStr;
@property(nonatomic, retain) NSString *toHeadStr;


@end
