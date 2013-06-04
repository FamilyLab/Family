//
//  DailyViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-24.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "DailyViewController.h"
#import "BottomBarView.h"
#import "HorizontalTableView.h"
#import "DailyViewTableCell.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "TitleBarView.h"
#import "CommentView.h" 
#import "SBToolKit.h"

@interface DailyViewController ()

@end

@implementation DailyViewController

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
    subScrollViewType = DAILYVIEW_CONTROLLER;
    currentListPage++;
    [self requestInfoList:currentListPage];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重载父类函数

//日志列表api URL
- (NSString *)pathOfInfoListRequest
{
    return PM_FEED_API;
}

//日志列表URL 参数
- (NSDictionary *)parasOfInfoListRequest:(int)page
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:PMFEED, DO, [NSString stringWithFormat:@"%d", page], PAGE, m_auth, M_AUTH, BLOGID, IDTYPE, [NSString stringWithFormat:@"%d", PHOTO_FEED_PERPAGE_COUNT], PERPAGE, nil];
}

//日志详情接口 URL
- (NSString *)pathOfDetailInfoRequest
{
    return BLOG_DETAIL_API;
}

//日志详情接口 参数
- (NSDictionary *)parasOfDetailInfoRequest:(int)i
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *blogInfo = [self.infoList objectAtIndex:i];
    NSString *blogID = [blogInfo objectForKey:ID];
    NSString *uid = [blogInfo objectForKey:UID];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:BLOG, DO, blogID, ID, uid, UID, m_auth, M_AUTH, nil];
}

//返回对应页码的view
- (UIView *)viewFromDataPage:(int)dataPage
{
    DailyViewTableCell *cell = (DailyViewTableCell *)[self dequeueReuseView];
    if (cell == nil) {
        cell = [[DailyViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        [cell initElement];
        [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
    } else {
        [cell reset];
    }
    
    [self setCell:cell dataFromCellIndex:(int)dataPage];
    
    return cell;
}

- (void)setCell:(DailyViewTableCell *)cell dataFromCellIndex:(int)index
{
//{    [cell setDataFromPhotoDetailDict:photoDetailDict withPhotoInfoList:self.infoList atPhotoInfoIndex:index];
    [cell setObjectID:[[self.infoList objectAtIndex:index] objectForKey:ID] andIdtype:BLOGID];
    NSDictionary *blogDetailDict = [self.detailInfoList objectAtIndex:index];
    [cell setDataFromBlogDetailDict:blogDetailDict withBlogInfoList:self.infoList atBlogInfoIndex:index];
}

- (NSString *)returnCommentViewTitle
{
    return @"写下你的评论吧~";
}

//- (void)confirmToRepostwithMessage:(NSString *)repostMessage toSpace:(NSString *)tagName
//{
//    [self confirmToRepostwithMessage:repostMessage toSpace:tagName withIDtype:BLOGID];
//}

@end
