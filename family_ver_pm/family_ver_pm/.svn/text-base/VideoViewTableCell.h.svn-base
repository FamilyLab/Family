//
//  VideoViewTableCell.h
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableCell.h"
#import "CommentView.h"
#import "TitleBarView.h"
#import "MyTableCell.h"
#import "FlowLayoutLabel.h"

@interface VideoViewTableCell : MyTableCell

@property (strong, nonatomic) FlowLayoutLabel *content;
@property (strong, nonatomic) CommentView *commentView;
@property (strong, nonatomic) TitleBarView *titleBarView;
@property (strong, nonatomic) UIScrollView *scrollView;


- (void)setCellStyle:(HorizontalTableCell *)cell;
- (void)initElement;
- (void)reset;
- (void)setDataFromVideoDetailDict:(NSDictionary *)videoDetailDict
                 withVideoInfoList:(NSArray *)videoInfoList
                   atVideoInfoIndex:(int)index;

@end
