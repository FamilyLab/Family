//
//  DailyViewTable.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "DailyViewTableCell.h"
#import "TitleBarView.h"
#import "SBToolKit.h"

@implementation DailyViewTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.reuseID = BLOG;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setCellStyle:(HorizontalTableCell *)cell
{
}

- (void)initElement
{
    //config scroll view
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    self.scrollView.contentSize = DAILY_VIEW_DEFAULT_CONTENT_SIZE;
    [self addSubview:self.scrollView];
    
    //config titlebar
    self.titleBarView = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, TITLE_BAR_DEFAULT_SIZE.width, TITLE_BAR_DEFAULT_SIZE.height)];
    [self.scrollView addSubview:self.titleBarView];
    
    //config webview
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.titleBarView.frame.size.height, DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.width, DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.height)];
    self.webView.delegate = self;
    [self.scrollView addSubview:self.webView];
    
    //config comment view
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, self.webView.frame.origin.y + self.webView.frame.size.height, COMMENT_VIEW_SIZE.width, COMMENT_VIEW_SIZE.height)];
    [self.scrollView addSubview:self.commentView];
}

//cell的重设
- (void)reset
{
    //重设webView
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.width, DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.height);
    [self.webView loadHTMLString:@" " baseURL:nil];
    
    //重设commentView
    [self.commentView reset];
}

//刷新内容布局
- (void)refleshContentLayout
{
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.titleBarView.frame.size.height, self.webView.frame.size.width, self.webView.frame.size.height);
}

//刷新mainScrollView的contentSize
- (void)refleshScrollViewContentSize
{
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, self.titleBarView.frame.size.height + self.webView.frame.size.height + self.commentView.frame.size.height + BOTTOM_BAR_SIZE.height);
}

//刷新commentView的frame
- (void)refleshCommentLayout
{
    self.commentView.frame = CGRectMake(0, self.webView.frame.origin.y + self.webView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);
}

//刷新布局
- (void)refleshLayout
{
    [self refleshScrollViewContentSize];
    [self refleshCommentLayout];
}

//设置数据
//    [cell setDataFromPhotoDetailDict:photoDetailDict withPhotoInfoList:self.infoList atPhotoInfoIndex:index];
- (void)setDataFromBlogDetailDict:(NSDictionary *)blogDetailDict
                 withBlogInfoList:(NSArray *)blogInfoList
                  atBlogInfoIndex:(int)index
{
    //设置标题
    NSString *author = [blogDetailDict objectForKey:NAME];
    NSString *title = [blogDetailDict objectForKey:SUBJECT];
    NSString *dateTime = [SBToolKit dateSinceNow:[blogDetailDict objectForKey:DATELINE]];
    [self.titleBarView setTitleLabelMaxWidth:TITLE_TEXT_MAX_WIDTH maxLine:2 font:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
    [self.titleBarView setTitle:title];
    [self.titleBarView setAuthor:author];
    [self.titleBarView setDate:dateTime];
    
    //设置内容
    [self refleshContentLayout];
    NSString *blogHTML = [blogDetailDict objectForKey:MESSAGE];
    [self.webView loadHTMLString:blogHTML baseURL:nil];
    
    //设置评论
    NSString *itemID = [blogDetailDict objectForKey:BLOGID];
    if (itemID == nil) {
        itemID = [blogDetailDict objectForKey:ID];
    }
    [self.commentView requestCommentListFromObjectID:itemID
                                           andIDtype:BLOGID
                                              atPage:1
                                    withSuccessBlock:^(id sender) {
                                        [self refleshLayout];
                                    }];
}

//webview加载完成之后刷新布局
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置webView的Frame
    UIScrollView *scrollView = [SBToolKit getScrollFromWebview:self.webView];
    if (scrollView != nil) {
        if (scrollView.contentSize.height > DAILY_VIEW_DEFAULT_WEBVIEW_SIZE.height) {
            CGRect webViewRect = self.webView.frame;
            self.webView.frame = CGRectMake(webViewRect.origin.x, webViewRect.origin.y, webViewRect.size.width, scrollView.contentSize.height);
        }
    }
    
    [self refleshLayout];
}

@end
