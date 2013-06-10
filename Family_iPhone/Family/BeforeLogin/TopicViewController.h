//
//  TopicViewController.h
//  Family
//
//  Created by Aevitx on 13-3-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableController.h"
#import "LoadingView.h"
#import "BottomView.h"

@interface TopicViewController : TableController <BottomViewDelegate>

@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *joinType;
@property (nonatomic, copy) NSString *topicImgUrlStr;
@property (nonatomic, copy) NSString *topicDescribeStr;
@property (nonatomic, assign) CGFloat firstPicWidth;
@property (nonatomic, assign) CGFloat firstPicHeight;

@property (nonatomic, strong) IBOutlet LoadingView *loadingView;

@property (nonatomic, assign) BOOL isFromMoreCon;

@end
