//
//  MyLikeViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-5-21.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MyLikeViewController.h"
#import "PictureViewTableCell.h"
#import "ActivityViewTableCell.h"
#import "DailyViewTableCell.h"

@interface MyLikeViewController ()

@end

@implementation MyLikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currentListPage++;
    [self requestInfoList:currentListPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取列表信息的URL
- (NSString *)pathOfInfoListRequest
{
    return MY_LIKE_API;
}

//获取列表信息的URL参数
- (NSDictionary *)parasOfInfoListRequest:(int)page
{ 
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:LOVEFEEDPM, DO, [SBToolKit getMAuth], M_AUTH, [NSString stringWithFormat:@"%d", PERPAGE_COUNT], PERPAGE, [NSString stringWithFormat:@"%d", page], PAGE, nil];
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
    
    NSDictionary *mylikeItemInfo = [self.infoList objectAtIndex:i];
    NSString *mylikeItemID = [mylikeItemInfo objectForKey:ID];
    NSString *mylikeItemUid = [mylikeItemInfo objectForKey:UID];
    NSString *idtype = [mylikeItemInfo objectForKey:IDTYPE];
    
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
    
    return [NSDictionary dictionaryWithObjectsAndKeys:doStr, DO, mylikeItemID, ID, mylikeItemUid, UID, m_auth, M_AUTH, nil];
}

- (UIView *)viewFromDataPage:(int)dataPage
{
    NSLog(@"请求view的datapage:%d", dataPage);
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
    POST_NOTI(NOTIFI_POP_TO_MYSETTINGVIEW);
}

@end













