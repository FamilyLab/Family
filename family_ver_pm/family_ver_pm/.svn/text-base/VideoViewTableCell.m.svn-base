//
//  VideoViewTableCell.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "VideoViewTableCell.h"

@implementation VideoViewTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.reuseID = VIDEO;
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
    //config scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    [self addSubview:self.scrollView];
    
    //config commentView
    self.commentView = [[CommentView alloc] initWithFrame:COMMENT_VIEW_DEFAULT_FRAME];
    [self.scrollView addSubview:self.commentView];
    
    //config titlebar
    self.titleBarView = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, TITLE_BAR_DEFAULT_SIZE.width, TITLE_BAR_DEFAULT_SIZE.height)];
    [self.scrollView addSubview:self.titleBarView];
    
    //config contentView
    self.content = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.x, PICTURE_VIEW_CONTENT_DEFAULT_ORIGIN.y, 100, 100)];
    [self.scrollView addSubview:self.content];
    
    self.scrollView.contentSize = CGSizeMake(self.commentView.frame.size.width, self.commentView.frame.origin.y + self.commentView.frame.size.height + BOTTOM_BAR_SIZE.height);
}

//cell的重设
- (void)reset
{
    //重设commentView
    [self.commentView reset];
}

//刷新内容布局
- (void)refleshContentLayout
{
//    self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.titleBarView.frame.size.height, self.webView.frame.size.width, self.webView.frame.size.height);
}

//刷新commentView的frame
- (void)refleshCommentLayout
{
    CGRect rect = self.commentView.frame;
    self.commentView.frame = CGRectMake(rect.origin.x, self.content.frame.origin.y + self.content.frame.size.height, rect.size.width, rect.size.height);
}

//刷新布局
- (void)refleshLayout
{
    [self refleshCommentLayout];
    [self refleshScrollViewContentSize];
}

- (void)refleshScrollViewContentSize
{
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, self.commentView.frame.origin.y + self.commentView.frame.size.height + BOTTOM_BAR_SIZE.height);
}

//设置数据
- (void)setDataFromVideoDetailDict:(NSDictionary *)videoDetailDict
                 withVideoInfoList:(NSArray *)videoInfoList
                  atVideoInfoIndex:(int)index
{
    //设置标题
    NSString *author = [videoDetailDict objectForKey:NAME];
    NSString *title = [videoDetailDict objectForKey:SUBJECT];
    NSString *dateTime = [SBToolKit dateSinceNow:[videoDetailDict objectForKey:DATELINE]];
    NSLog(@"获取到的视频发布时间：%@", [videoDetailDict objectForKey:DATELINE]);
    [self.titleBarView setTitleLabelMaxWidth:TITLE_TEXT_MAX_WIDTH maxLine:2 font:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
    [self.titleBarView setTitle:title];
    [self.titleBarView setAuthor:author];
    [self.titleBarView setDate:dateTime];
    
    //设置内容
    NSString *content = [(NSString *)[videoDetailDict objectForKey:MESSAGE] isEqualToString:@""]? PICTURE_VIEW_CONTENT_EMPTY_TEXT:[videoDetailDict objectForKey:MESSAGE];
    [self.content setMaxWidth:DEVICE_SIZE.width maxLine:0 font:[UIFont systemFontOfSize:PICTURE_VIEW_CONTENT_FONT_SIZE]];
    [self.content setTextContent:content];
    [self refleshLayout];
    
    //设置评论
    [self.commentView requestCommentListFromObjectID:[videoDetailDict objectForKey:VIDEOID]
                                           andIDtype:VIDEOID
                                              atPage:1
                                    withSuccessBlock:^(id sender) {
                                        [self refleshLayout];
                                    }];
}

@end
