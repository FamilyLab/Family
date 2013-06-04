//
//  ActivityViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "ActivityViewController.h"
#import "BottomBarView.h"
#import "TitleBarView.h"
#import "ActivityViewTableCell.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "CommentView.h"
#import "SBToolKit.h"
#import "ShowMapViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToHere) name:NOTIFI_POP_FROM_SHOWMAPVIEW object:nil];
    
    currentListPage++;
    [self requestInfoList:currentListPage];
    subScrollViewType = ACTIVITYVIEW_CONTROLLER;
    
    UIImage *joinBtnImg = [UIImage imageNamed:@"joinevent.png"];
    [self.bottomBar.commentBtn setImage:joinBtnImg forState:UIControlStateNormal];
    CGRect rect = self.bottomBar.commentBtn.frame;
    self.bottomBar.commentBtn.frame = CGRectMake(rect.origin.x, rect.origin.y - 3, rect.size.width, rect.size.width / joinBtnImg.size.width * joinBtnImg.size.height);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popToHere
{
    [self.navigationController popToViewController:self animated:YES];
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
    
    return [NSDictionary dictionaryWithObjectsAndKeys:PMFEED, DO, [NSString stringWithFormat:@"%d", page], PAGE, m_auth, M_AUTH, EVENTID, IDTYPE, [NSString stringWithFormat:@"%d", EVENT_FEED_PERPAGE_COUNT], PERPAGE, nil];
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
    
    NSDictionary *eventInfo = [self.infoList objectAtIndex:i];
    NSString *eventID = [eventInfo objectForKey:ID];
    NSString *uid = [eventInfo objectForKey:UID];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:EVENT, DO, eventID, ID, uid, UID, m_auth, M_AUTH, nil];
}

#pragma mark - UITableViewDatasource UITableViewDataDelegate

//返回每个滚动页的view
- (UIView *)viewFromDataPage:(int)dataPage
{
    ActivityViewTableCell *cell = (ActivityViewTableCell *)[self dequeueReuseView];
    if (cell == nil) {
        cell = [[ActivityViewTableCell alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        [cell initElement];
        [cell.commentView setTitle:COMMENT_VIEW_TITLE_JOIN];
    } else {
        [cell reset];
    }
    
    [self setCell:cell dataFromCellIndex:dataPage];
    
    return cell;
}

//设置cell中各种数据
- (void)setCell:(ActivityViewTableCell *)cell dataFromCellIndex:(int)index
{
    [cell setObjectID:[[self.infoList objectAtIndex:index] objectForKey:ID] andIdtype:EVENTID];
    NSDictionary *photoDetailDict = [self.detailInfoList objectAtIndex:index];
    [cell setDataFromEventDetailDict:photoDetailDict withEventInfoList:self.infoList atEventInfoIndex:index];
}

#pragma mark BottomBarViewDelegate
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
