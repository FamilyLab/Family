//
//  PictureViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-21.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureViewTableCell.h"
#import "HorizontalTableView.h"
#import "BottomBarView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "CommentView.h"
#import "SVProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "UIImageView+AFNetworking.h"
#import "SBToolKit.h"
#import "UIButton+Block.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    currentListPage++;
    [self requestInfoList:currentListPage];
    subScrollViewType = PICTUREVIEW_CONTROLLER;
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回获取图片信息列表的接口URL
- (NSString *)pathOfInfoListRequest
{
    return PM_FEED_API;
}

//返回获取图片信息列表的URL接口参数
- (NSDictionary *)parasOfInfoListRequest:(int)page
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:PMFEED, DO, [NSString stringWithFormat:@"%d", page], PAGE, m_auth, M_AUTH, PHOTOID, IDTYPE, [NSString stringWithFormat:@"%d", PHOTO_FEED_PERPAGE_COUNT], PERPAGE, nil];
    NSLog(@"request infolist 的参数:%@", paraDict);
    return paraDict;
}

//返回用于获取图片详情的接口URL
- (NSString *)pathOfDetailInfoRequest
{
    return PHOTO_DETAIL_API;
}

//获取图片详情需要用到的参数
- (NSDictionary *)parasOfDetailInfoRequest:(int)i
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *photoInfo = [self.infoList objectAtIndex:i];
    NSString *photoID = [photoInfo objectForKey:ID];
    NSString *uid = [photoInfo objectForKey:UID];

    return [NSDictionary dictionaryWithObjectsAndKeys:PHOTO, DO, photoID, ID, uid, UID, m_auth, M_AUTH, nil];
}

#pragma mark - UITableViewDatasource UITableViewDataDelegate

//返回每个滚动页的view
- (UIView *)viewFromDataPage:(int)dataPage
{
    PictureViewTableCell *cell = (PictureViewTableCell *)[self dequeueReuseView];
    if (cell == nil) {
        cell = [[PictureViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        [cell initElement];
        [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
        cell.delegate = self;
    } else {
        [cell reset];
    }

    [self setCell:cell dataFromCellIndex:dataPage];
    
    return cell;
}

//设置cell中各种数据
//数据获取顺序：图片->评论
- (void)setCell:(PictureViewTableCell *)cell dataFromCellIndex:(int)index
{
    [cell setObjectID:[[self.infoList objectAtIndex:index] objectForKey:ID] andIdtype:PHOTOID];
    NSDictionary *photoDetailDict = [self.detailInfoList objectAtIndex:index];
    [cell setDataFromPhotoDetailDict:photoDetailDict withPhotoInfoList:self.infoList atPhotoInfoIndex:index];
}

- (NSString *)returnCommentViewTitle
{
    return @"写下你的评论吧~";
}

//转发图片 重载了父类的同名函数
//- (void)confirmToRepostwithMessage:(NSString *)repostMessage toSpace:(NSString *)tagName
//{
//    [self confirmToRepostwithMessage:repostMessage toSpace:tagName withIDtype:PHOTOID];
//}


@end