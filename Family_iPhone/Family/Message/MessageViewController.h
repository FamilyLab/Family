//
//  MessageViewController.h
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "TopView.h"

@interface MessageViewController : TableController <UIScrollViewDelegate, TopViewDelegate, UIActionSheetDelegate> {
    BOOL isFirstShow;
//    int tmp;
}

@property (nonatomic, strong) TopView *topView;
//@property (nonatomic, assign) int noticeNum;
@property (nonatomic, assign) BOOL isFromPushForPM;
@property (nonatomic, assign) BOOL isFromPushForNotice;

@property (nonatomic, strong) UIButton *postPMBtn;

- (void)setBadgeNumWithBtnTag:(int)btnTag andBadgeNum:(NSString*)badgeNum;

- (void)sendRequestToDialogue:(id)sender;
- (void)sendRequestToNotice:(id)sender;

@end
