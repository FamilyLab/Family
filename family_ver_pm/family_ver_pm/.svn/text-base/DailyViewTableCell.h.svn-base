//
//  DailyViewTable.h
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "HorizontalTableCell.h"
#import "TitleBarView.h"
#import "CommentView.h"
#import "MyTableCell.h"

@interface DailyViewTableCell : MyTableCell<UIWebViewDelegate>;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) TitleBarView *titleBarView;
@property (strong ,nonatomic) CommentView *commentView;

- (void)setCellStyle:(HorizontalTableCell *)cell;
- (void)initElement;
- (void)reset;
- (void)setDataFromBlogDetailDict:(NSDictionary *)blogDetailDict
                 withBlogInfoList:(NSArray *)blogInfoList
                  atBlogInfoIndex:(int)index;
@end
