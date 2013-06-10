//
//  TopicView.h
//  Family
//
//  Created by Aevitx on 13-6-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIButton *bgBtn;
@property (nonatomic, strong) IBOutlet UIImageView *topicImgView;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *contentLbl;
@property (nonatomic, strong) IBOutlet UIButton *joinBtn;


@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *topicTitleStr;
@property (nonatomic, copy) NSString *topicDescribeStr;
@property (nonatomic, copy) NSString *topicImgUrlStr;
@property (nonatomic, copy) NSString *joinType;

@property (nonatomic, assign) BOOL isFromMoreCon;

- (void)fillData;
- (IBAction)showOrHideAnimation:(id)sender isShow:(BOOL)_isShow;
- (void)sendRequest:(id)sender;

@end
