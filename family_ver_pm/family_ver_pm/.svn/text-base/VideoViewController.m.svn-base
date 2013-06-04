//
//  VideoViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "VideoViewController.h"
#import "BottomBarView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "VideoViewTableCell.h"
#import "TitleBarView.h"
#import "CommentView.h"
#import "SBToolKit.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isVideoView = YES;
    
    currentListPage++;
    [self requestInfoList:currentListPage];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//列表信息接口API
- (NSString *)pathOfInfoListRequest
{
    return PM_FEED_API;
}

//返回获取视频信息列表的URL接口参数
- (NSDictionary *)parasOfInfoListRequest:(int)page
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:PMFEED, DO, [NSString stringWithFormat:@"%d", page], PAGE, m_auth, M_AUTH, VIDEOID, IDTYPE, [NSString stringWithFormat:@"%d", VIDEO_FEED_PERPAGE_COUNT], PERPAGE, nil];
}

//返回用于获取视频详情的接口URL
- (NSString *)pathOfDetailInfoRequest
{
    return VIDEO_DETAIL_API;
}

//获取视频详情需要用到的参数
- (NSDictionary *)parasOfDetailInfoRequest:(int)i
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *videoInfo = [self.infoList objectAtIndex:i];
    NSString *videoID = [videoInfo objectForKey:ID];
    NSString *uid = [videoInfo objectForKey:UID];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:VIDEO, DO, videoID, ID, uid, UID, m_auth, M_AUTH, nil];
}

//返回每个滚动页的view
- (UIView *)viewFromDataPage:(int)dataPage
{
    VideoViewTableCell *cell = (VideoViewTableCell *)[self dequeueReuseView];
    if (cell == nil) {
        cell = [[VideoViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        [cell initElement];
        [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
    } else {
        [cell reset];
    }
    
    [self setCell:cell dataFromCellIndex:dataPage];
    
    return cell;
}
//
//设置cell中各种数据
- (void)setCell:(VideoViewTableCell *)cell dataFromCellIndex:(int)index
{
    [cell setObjectID:[[self.infoList objectAtIndex:index] objectForKey:ID] andIdtype:VIDEOID];
    NSDictionary *videoDetailDict = [self.detailInfoList objectAtIndex:index];
    [cell setDataFromVideoDetailDict:videoDetailDict withVideoInfoList:self.infoList atVideoInfoIndex:index];
}
- (NSString *)returnCommentViewTitle
{
    return @"写下你的评论吧~";
}

#pragma mark BottomViewDelegate
- (void)reblog
{
    
}

- (void)comment
{
    
}

- (void)like
{
    
}

@end
