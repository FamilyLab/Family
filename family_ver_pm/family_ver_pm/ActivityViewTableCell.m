//
//  ActivityViewTableCell.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "ActivityViewTableCell.h"
#import "SBToolKit.h"
#import "ShowMapViewController.h"

@implementation ActivityViewTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.reuseID = EVENT;
    }
    return self;
}

- (void)initElement
{
    //设置scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, DEVICE_SIZE.height + 10);
    [self addSubview:self.scrollView];
    
    //设置标题
    self.titleBarView = [[TitleBarView alloc] initWithFrame:CGRectMake(0, 0, TITLE_BAR_DEFAULT_SIZE.width, TITLE_BAR_DEFAULT_SIZE.height)];
    [self.titleBarView.titleLabel setMaxWidth:TITLE_TEXT_MAX_WIDTH maxLine:2 font:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
    [self.scrollView addSubview:self.titleBarView];
    
    //设置活动属性
    const int showMapButtonWidth = 60;
    const int interval = 10;
    
    UIColor *textColor = [UIColor grayColor];
    self.timeLable = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(EVENT_VIEW_DEFAULT_PRO_ORIGN.x, self.titleBarView.frame.size.height + EVENT_PROPERTY_INTERVAL, EVENT_VIEW_DEFAULT_PRO_SIZE.width, EVENT_VIEW_DEFAULT_PRO_SIZE.height)];
    [self.timeLable setMaxWidth:EVENT_VIEW_DEFAULT_PRO_SIZE.width maxLine:0 font:EVENT_VIEW_DEFAULT_FONT];
    self.timeLable.textColor = textColor;
    [self.scrollView addSubview:self.timeLable];
    
    self.locationLable = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(EVENT_VIEW_DEFAULT_PRO_ORIGN.x, self.timeLable.frame.origin.y + self.timeLable.frame.size.height + EVENT_PROPERTY_INTERVAL, EVENT_VIEW_DEFAULT_PRO_SIZE.width - showMapButtonWidth - interval * 2, EVENT_VIEW_DEFAULT_PRO_SIZE.height)];
    [self.locationLable setMaxWidth:EVENT_VIEW_DEFAULT_PRO_SIZE.width - showMapButtonWidth maxLine:0 font:EVENT_VIEW_DEFAULT_FONT];
    self.locationLable.textColor = textColor;
    [self.scrollView addSubview:self.locationLable];
    
    self.showMapBtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_SIZE.width - showMapButtonWidth - interval - 5, self.locationLable.frame.origin.y, showMapButtonWidth + 10, self.locationLable.frame.size.height)];
    [self.showMapBtn setTitle:@"查看地图" forState:UIControlStateNormal];
    [self.showMapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showMapBtn setBackgroundImage:[UIImage imageNamed:@"background_green.png"] forState:UIControlStateNormal];
    self.showMapBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.showMapBtn addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.showMapBtn];
    
    self.introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(EVENT_VIEW_DEFAULT_PRO_ORIGN.x, self.locationLable.frame.origin.y + self.locationLable.frame.size.height, EVENT_VIEW_DEFAULT_PRO_SIZE.width, EVENT_VIEW_DEFAULT_PRO_SIZE.height)];
    self.introduceLable.text = @"介绍";
    self.introduceLable.textColor = textColor;
    self.introduceLable.font = EVENT_VIEW_DEFAULT_FONT;
    [self.scrollView addSubview:self.introduceLable];
    
    //设置内容视图
    self.introduceView = [[UIWebView alloc] initWithFrame:CGRectMake(5, self.introduceLable.frame.origin.x + self.introduceLable.frame.size.height, DEVICE_SIZE.width - 10, 100)];
    self.introduceView.delegate = self;
    [self.scrollView addSubview:self.introduceView];
    
    //设置参加者
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + EVENT_PROPERTY_INTERVAL, COMMENT_VIEW_SIZE.width, COMMENT_VIEW_SIZE.height)];
    [self.scrollView addSubview:self.commentView];
}

- (void)showMap
{
    ShowMapViewController *showMapViewController = [[ShowMapViewController alloc] initWithNibName:@"ShowMapViewController" bundle:nil];
    [showMapViewController setRegionWithLat:lat lng:lng];
    [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] pushViewController:showMapViewController animated:YES];
}

//重置cell
- (void)reset
{
    self.introduceView.frame = CGRectMake(5, self.introduceLable.frame.origin.x + self.introduceLable.frame.size.height, DEVICE_SIZE.width - 10, 100);
    [self.introduceView loadHTMLString:@" " baseURL:nil];
    
    [self.commentView reset];
}

- (void)refleshLayout
{
    //设置各种属性的layout
    CGRect rect = self.timeLable.frame;
    self.timeLable.frame = CGRectMake(rect.origin.x,
                                      self.titleBarView.frame.origin.y + self.titleBarView.frame.size.height + EVENT_PROPERTY_INTERVAL,
                                      rect.size.width, rect.size.height);
    
    rect = self.locationLable.frame;
    self.locationLable.frame = CGRectMake(rect.origin.x,
                                          self.timeLable.frame.origin.y + self.timeLable.frame.size.height + EVENT_PROPERTY_INTERVAL,
                                          rect.size.width, rect.size.height);
    
    rect = self.showMapBtn.frame;
    self.showMapBtn.frame = CGRectMake(rect.origin.x, self.locationLable.frame.origin.y, rect.size.width, self.locationLable.frame.size.height);
    
    rect = self.introduceLable.frame;
    self.introduceLable.frame = CGRectMake(rect.origin.x, self.locationLable.frame.origin.y + self.locationLable.frame.size.height + EVENT_PROPERTY_INTERVAL, rect.size.width, rect.size.height);
    
    //设置introduceView
    rect = self.introduceView.frame;
    self.introduceView.frame = CGRectMake(rect.origin.x, self.introduceLable.frame.origin.y + self.introduceLable.frame.size.height, rect.size.width, rect.size.height);
    
    //设置commentView的layout
    rect = self.commentView.frame;
    self.commentView.frame = CGRectMake(rect.origin.x, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + EVENT_PROPERTY_INTERVAL, rect.size.width, rect.size.height);
    
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, self.commentView.frame.origin.y + self.commentView.frame.size.height + BOTTOM_BAR_SIZE.height);
}

//设置数据
- (void)setDataFromEventDetailDict:(NSDictionary *)eventDetailDict
                 withEventInfoList:(NSArray *)eventInfoList
                  atEventInfoIndex:(int)index
{
    //设置标题
    NSString *author = [eventDetailDict objectForKey:NAME];
    NSString *dateTime = [SBToolKit dateSinceNow:[eventDetailDict objectForKey:DATELINE]];
    NSString *subject = [eventDetailDict objectForKey:TITLE];
    [self.titleBarView setAuthor:author];
    [self.titleBarView setDate:dateTime];
    [self.titleBarView setTitle:subject];
    
    //设置活动属性
    lat = [[eventDetailDict objectForKey:@"lat"] floatValue];
    lng = [[eventDetailDict objectForKey:@"lng"] floatValue];
    [self.timeLable setTextContent:[self getStartTime:[SBToolKit dateFromTimesp:[eventDetailDict objectForKey:STARTTIME]]]];
    [self.locationLable setTextContent:[self getLocation:[eventDetailDict objectForKey:LOCATION]]];
    [self.introduceView loadHTMLString:[eventDetailDict objectForKey:DETAIL] baseURL:nil];
    
    //设置评论
    NSString *itemID = [eventDetailDict objectForKey:EVENTID];
    if (itemID == nil) {
        itemID = [eventDetailDict objectForKey:ID];
    }
    [self.commentView requestCommentListFromObjectID:itemID
                                           andIDtype:EVENTID
                                              atPage:1
                                    withSuccessBlock:^(id sender) {
                                        [self refleshLayout];
                                    }];
    [self refleshLayout];
}

//返回对应格式的活动属性
- (NSString *)getStartTime:(NSString *)startTime
{
    return [NSString stringWithFormat:@"%@:%@", EVENT_TIME, startTime];
}

- (NSString *)getLocation:(NSString *)location
{
    return [NSString stringWithFormat:@"%@:%@", EVENT_LOCATION, location];
}

- (NSString *)getIntroduce:(NSString *)introduce
{
    return [NSString stringWithFormat:@"%@:%@", EVENT_INTRODUCE, introduce];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [SVProgressHUD showErrorWithStatus:@"网络不好"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIScrollView *scrollView = [SBToolKit getScrollFromWebview:webView];
    CGRect rect = webView.frame;
    NSLog(@"scrollView.ContentSize.height:%f, scrollView.frame.size.height:%f", scrollView.contentSize.height, webView.frame.size.height);
    if (scrollView != nil) {
        if (scrollView.contentSize.height > rect.size.height) {
           webView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, scrollView.contentSize.height);
            [self refleshLayout];
        }
    }
}

@end







