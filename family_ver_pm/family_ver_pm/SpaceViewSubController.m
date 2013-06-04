//
//  SpaceViewSubController.m
//  family_ver_pm
//
//  Created by pandara on 13-4-2.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "SpaceViewSubController.h"
#import "PictureViewTableCell.h"
#import "DailyViewTableCell.h"
#import "ActivityViewTableCell.h"
#import "VideoViewTableCell.h"
#import "BottomBarView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "SBToolKit.h"

@interface SpaceViewSubController ()

@end

@implementation SpaceViewSubController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isSpaceView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToHere) name:NOTIFI_POP_FROM_SHOWMAPVIEW object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToHere
{
    [self.navigationController popToViewController:self animated:YES];
}

//设置自己的空间ID
- (void)setSpaceID:(NSString *)spaceID
{
    self.tagID = spaceID;
}

- (void)beginRequest
{
    currentListPage++;
    [self requestSpaceInfoList:currentListPage];
}

//获取列表信息的URL
- (NSString *)pathOfInfoListRequest
{
    return SPACE_LIST_API;
}

//获取列表信息的URL参数
- (NSDictionary *)parasOfInfoListRequest:(int)page
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:FAMILYSPACESIMPLE, DO, [NSString stringWithFormat:@"%d", page], PAGE, m_auth, M_AUTH, [NSString stringWithFormat:@"%d", PHOTO_FEED_PERPAGE_COUNT], PERPAGE, self.tagID, TAGID, nil];
    NSLog(@"获取信息列表请求的参数：%@", paraDict);
    return paraDict;
}

//返回用于获取详情的接口URL
- (NSString *)pathOfDetailInfoRequest
{
    return SPACE_DETAIL_API;
}

//获取详情需要用到的参数
- (NSDictionary *)parasOfDetailInfoRequest:(int)i
{
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSDictionary *spaceItemInfo = [self.infoList objectAtIndex:i];
    NSString *spaceItemID = [spaceItemInfo objectForKey:ID];
    NSString *spaceItemUid = [spaceItemInfo objectForKey:UID];
    NSString *idtype = [spaceItemInfo objectForKey:IDTYPE];
    
    NSString *doStr;
    if ([idtype isEqualToString:PHOTOID] || [idtype isEqualToString:REPHOTOID]) {
        doStr = PHOTO;
    } else if ([idtype isEqualToString:BLOGID] || [idtype isEqualToString:REBLOGID]) {
        doStr = BLOG;
    } else if ([idtype isEqualToString:EVENTID] || [idtype isEqualToString:REEVENTID]) {
        doStr = EVENT;
    } else if ([idtype isEqualToString:VIDEOID] || [idtype isEqualToString:REVIDEOID]) {
        doStr = VIDEO;
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:doStr, DO, spaceItemID, ID, spaceItemUid, UID, m_auth, M_AUTH, nil];
}

- (UIView *)viewFromDataPage:(int)dataPage
{
    NSString *idtype = [[self.infoList objectAtIndex:dataPage] objectForKey:IDTYPE];
    
    if ([idtype isEqualToString:PHOTOID] || [idtype isEqualToString:REPHOTOID]) {
        PictureViewTableCell *cell = (PictureViewTableCell *)[self dequeueReuseViewWithReuseID:PHOTO];
        if (cell == nil) {
            cell = [[PictureViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
            [cell initElement];
            [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
            cell.delegate = self;
        } else {
            [cell reset];
        }
        
        [cell setObjectID:[[self.infoList objectAtIndex:dataPage] objectForKey:ID] andIdtype:idtype];
        NSDictionary *photoDetailDict = [self.detailInfoList objectAtIndex:dataPage];
        [cell setDataFromPhotoDetailDict:photoDetailDict withPhotoInfoList:self.infoList atPhotoInfoIndex:dataPage];
        
        return cell;
    }
    
    if ([idtype isEqualToString:EVENTID] || [idtype isEqualToString:REEVENTID]) {
        ActivityViewTableCell *cell = (ActivityViewTableCell *)[self dequeueReuseViewWithReuseID:EVENT];
        if (cell == nil) {
            cell = [[ActivityViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
            [cell initElement];
            [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
        } else {
            [cell reset];
        }
        
        [cell setObjectID:[[self.infoList objectAtIndex:dataPage] objectForKey:ID] andIdtype:idtype];
        NSDictionary *photoDetailDict = [self.detailInfoList objectAtIndex:dataPage];
        [cell setDataFromEventDetailDict:photoDetailDict withEventInfoList:self.infoList atEventInfoIndex:dataPage];
        
        return cell;
    }
    
    if ([idtype isEqualToString:BLOGID] || [idtype isEqualToString:REBLOGID]) {
        DailyViewTableCell *cell = (DailyViewTableCell *)[self dequeueReuseViewWithReuseID:BLOG];
        if (cell == nil) {
            cell = [[DailyViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
            [cell initElement];
            [cell.commentView setTitle:COMMENT_VIEW_TITLE_COMMENT];
        } else {
            [cell reset];
        }
        
        [cell setObjectID:[[self.infoList objectAtIndex:dataPage] objectForKey:ID] andIdtype:idtype];
        NSDictionary *blogDetailDict = [self.detailInfoList objectAtIndex:dataPage];
        [cell setDataFromBlogDetailDict:blogDetailDict withBlogInfoList:self.infoList atBlogInfoIndex:dataPage];
        
        return cell;
    }
    
    if ([idtype isEqualToString:VIDEOID] || [idtype isEqualToString:REVIDEOID]) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


- (void)backToRoot
{
    [self.spaceViewDelegate.navigationController popToViewController:self.spaceViewDelegate animated:YES];
    [self.spaceViewDelegate.tableView reloadData];
}
@end
