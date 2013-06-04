//
//  ActivityViewTableCell.h
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableCell.h"
#import <MapKit/MapKit.h>
#import "TitleBarView.h"
#import "CommentView.h"
#import "FlowLayoutLabel.h"
#import "MyTableCell.h"

@interface ActivityViewTableCell : MyTableCell<UIWebViewDelegate> {
    CGFloat lat;
    CGFloat lng;
}

@property (strong, nonatomic) FlowLayoutLabel *timeLable;
@property (strong, nonatomic) FlowLayoutLabel *locationLable;
@property (strong, nonatomic) UILabel *introduceLable;
@property (strong, nonatomic) UIWebView *introduceView;
@property (strong, nonatomic) TitleBarView *titleBarView;
@property (strong, nonatomic) CommentView *commentView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *showMapBtn;

- (void)initElement;
- (void)reset;
- (void)setDataFromEventDetailDict:(NSDictionary *)eventDetailDict
                 withEventInfoList:(NSArray *)eventInfoList
                  atEventInfoIndex:(int)index;

@end
