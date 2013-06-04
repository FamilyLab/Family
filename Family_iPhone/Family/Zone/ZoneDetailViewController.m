//
//  ZoneDetailViewController.m
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ZoneDetailViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"

#define kFirstLoadNum   5
#define kTagPEPageView  500

//static const int totalNum = 5;
static const int scrollViewWidth = 320;
#define VIEWCONTROLLER_NUM  3

@interface ZoneDetailViewController ()

@end

@implementation ZoneDetailViewController
@synthesize theScrollView, zeroCon, firstCon, secondCon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currShownIndex = 0;
        currPageIndex = 1;
        isSecondViewInCenter = NO;
        currentRequestPage = 1;
        isFirstShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = DEVICE_BOUNDS;
    self.theScrollView.frame = DEVICE_BOUNDS;
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width * 3, DEVICE_SIZE.height);
//    for (int i = 0; i < 3; i++) {
//        FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
//        con.view.tag = kTagConViewInZoneDetail + i;
//        [con.bottomView removeFromSuperview];
//        con.bottomView = nil;
//        con.view.frame = CGRectMake(DEVICE_SIZE.width * i, 0, DEVICE_SIZE.width, DEVICE_SIZE.height);
//        con._tableView.frame = (CGRect){.origin = con._tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = DEVICE_SIZE.height - 40};
//        [theScrollView addSubview:con.view];
//        if (i == 0) {
//            self.zeroCon = con;
//        } else if (i == 1) {
//            self.firstCon = con;
//        } else if (i == 2) {
//            self.secondCon = con;
//        }
//    }
    [self addBottomView];
    [self sendRequestToDetail:-1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addBottomView {
//    NSString *fourthBtnImageStr = [_idType isEqualToString:FEED_EVENT_ID] ? @"joinevent" : @"menu_comment";
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", @"menu_repost", @"feed_detail_love_a", fourthBtnImageStr, @"menu_face", nil];
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", @"menu_repost", @"feed_detail_love_a", @"menu_comment", @"menu_face", nil];
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:nil
                                       andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    aView.hidden = NO;
    self.bottomView = aView;
    [self.view addSubview:aView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0://后退
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        //下面的都不用到了
        case 1://转发
        {
            break;
        }
        case 2://收藏
        {
            break;
        }
        case 3://评论
        {
            break;
        }
        case 4://表情
        {
            break;
        }
        default:
            break;
    }
}


- (void)sendRequestToDetail:(int)whichCon {
    NSString *url;
    int perpage = isFirstShow ? 3 : 1;
    if (isFirstShow) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    if (_userId) {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspace&tagid=%@&uid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, _userId, currentRequestPage, perpage, [MY_M_AUTH urlencode]];
    } else {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspace&tagid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, currentRequestPage, perpage, [MY_M_AUTH urlencode]];
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        _bottomView.hidden = YES;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        
        feedNum = [[[dict objectForKey:WEB_DATA] objectForKey:FEED_NUM] intValue];
        if (isFirstShow) {
            theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width * fminf(3, feedNum), DEVICE_SIZE.height);
            for (int i = 0; i < fminf(3, feedNum); i++) {
                FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                
                con.isFromZone = YES;
//                if ([[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] count] > 0) {
                    [self changeFeedData:[[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] objectAtIndex:i] inCon:con];
//                }
                
                con.view.tag = kTagConViewInZoneDetail + i;
//                [con.bottomView removeFromSuperview];
//                con.bottomView = nil;
                con.view.frame = CGRectMake(DEVICE_SIZE.width * i, 0, DEVICE_SIZE.width, DEVICE_SIZE.height);
//                con._tableView.frame = (CGRect){.origin = con._tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = DEVICE_SIZE.height - 40};
                
                [theScrollView addSubview:con.view];
                if (i == 0) {
                    self.zeroCon = con;
                } else if (i == 1) {
                    self.firstCon = con;
                } else if (i == 2) {
                    self.secondCon = con;
                }
            }
            currentRequestPage = fminf(3, feedNum);
            isFirstShow = NO;
        } else {
            FeedDetailViewController *con = whichCon == 0 ? zeroCon : (whichCon == 1 ? firstCon : secondCon);
//            con.dataDict = nil;
//            [con.dataArray removeAllObjects];
//            [con._tableView reloadData];
//            if ([[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] count] > 0) {
                [self changeFeedData:[[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] objectAtIndex:0] inCon:con];
//            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
    }];
}

- (void)changeFeedData:(NSDictionary*)dict inCon:(FeedDetailViewController*)con {
//    con.idType = [dict objectForKey:FEED_ID_TYPE];
//    con.feedId = [dict objectForKey:ID];
//    con.feedCommentId = [dict objectForKey:F_ID];
//    con.userId = [dict objectForKey:UID];
    if (!isFirstShow) {
//        [con sendRequest:nil];
    }
}

#pragma makr scrollview delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

//- (void)changeTheShortLabel:(int)_currShowPhotoIndex {
//    CGFloat length = (_currShowPhotoIndex + 1) * (320 / feedNum);
//    [UIView animateWithDuration:0.3f
//                     animations:^{
////                         shortLabel.frame = CGRectMake(0, 433, length, 3);
//                     }];
//}

- (void)loadPageWithId:(int)_index onPage:(int)_page isDragToLeft:(BOOL)_isDragToLeft {
//    if (_index == 0) {
//        [self changeFrame:self.zeroCon toPage:_page];
//    } else if (_index == 1) {
//        [self changeFrame:self.firstCon toPage:_page];
//    } else if (_index == 2) {
//        [self changeFrame:self.secondCon toPage:_page];
//    }
    FeedDetailViewController *con = _index == 0 ? zeroCon : (_index == 1 ? firstCon : secondCon);
    [self changeFrame:con toPage:_page isDragToLeft:_isDragToLeft];
}

- (void)changeFrame:(FeedDetailViewController*)_con toPage:(int)_page isDragToLeft:(BOOL)_isDragToLeft {
    _con.view.frame = (CGRect){.origin.x = DEVICE_SIZE.width * _page, .origin.y = 0, .size = _con.view.frame.size};

//    int p = _isDragToLeft ? 2 : 0;
//    if (_page == p) {
//        [self afterScroll];
//    }
}

//- (void)afterScroll {
//    int zero, first, second;
//    for (int i=0; i<3; i++) {
//        FeedDetailViewController *con = i == 0 ? zeroCon : (i == 1 ? firstCon : secondCon);
//        if (con.view.frame.origin.x == 0) {
//            zero = con.view.tag - kTagConViewInZoneDetail;
//        } else if (con.view.frame.origin.x == 320) {
//            first = con.view.tag - kTagConViewInZoneDetail;
//        } else if (con.view.frame.origin.x == 640) {
//            second = con.view.tag - kTagConViewInZoneDetail;
//        }
//    }
//    NSLog(@"                %d  %d  %d", zero, first, second);
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _bottomView.hidden = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _bottomView.hidden = YES;
    CGFloat offsetX = theScrollView.contentOffset.x;
    if ((offsetX > scrollViewWidth && currShownIndex == feedNum - 1) || (offsetX < scrollViewWidth && currShownIndex == 0)) {
        return;  //当向左滑动，且当前显示的照片是最后一张。或当向右滑动，且当前显示的照片是第一张。则不执行其他操作。
    }
    //向左滑动
    if(offsetX > scrollViewWidth) {
        if (currShownIndex == feedNum - 2) {
            currShownIndex++;
            NSLog(@"curr showing view:%d", currShownIndex);
//            [self afterScroll];
//            [self changeTheShortLabel:currShownIndex];
            return;   //当前显示的为倒数第二张照片，且继续向左滑动时，这时不用再给另外两个(前面和后面的view)赋新的数据了，所以直接return;
        }
        [self loadPageWithId:currPageIndex onPage:0 isDragToLeft:YES];
        currPageIndex = (currPageIndex >= VIEWCONTROLLER_NUM - 1) ? 0 : currPageIndex + 1;
        [self loadPageWithId:currPageIndex onPage:1 isDragToLeft:YES];
        nextPageIndex = (currPageIndex >= VIEWCONTROLLER_NUM - 1) ? 0 : currPageIndex + 1;
        [self loadPageWithId:nextPageIndex onPage:2 isDragToLeft:YES];
        currShownIndex++;
        currentRequestPage = currShownIndex + 1;
        
        for (UIView *aView in theScrollView.subviews) {
            if (aView.frame.origin.x == 640) {
                currentRequestPage++;
                [self sendRequestToDetail:aView.tag - kTagConViewInZoneDetail];
//                if (aView.tag - kTagConViewInZoneDetail == 0) {
////                    NSLog(@"self.zeroCon加载下一页(currShownIndex++)的数据)");
//                } else if (aView.tag - kTagConViewInZoneDetail == 1) {
////                    NSLog(@"self.firstCon加载下一页(currShownIndex++)的数据");
//                } else if (aView.tag - kTagConViewInZoneDetail == 2) {
////                    NSLog(@"self.secondCon加载下一页(currShownIndex++)的数据");
//                }
            }
        }
    }
    //向右滑动
    else if(offsetX < scrollViewWidth) {
        if (currShownIndex == 1) {
            currShownIndex--;
            NSLog(@"curr showing view:%d", currShownIndex);
//            [self afterScroll];
//            [self changeTheShortLabel:currShownIndex];
            return;   //当前显示的为第二张照片，且继续向右滑动时，这时不用再给另外两个(前面和后面的view)赋新的数据了，所以直接return;
        }
        [self loadPageWithId:currPageIndex onPage:2 isDragToLeft:NO];
        currPageIndex = (currPageIndex == 0) ? VIEWCONTROLLER_NUM - 1 : currPageIndex - 1;
        [self loadPageWithId:currPageIndex onPage:1 isDragToLeft:NO];
        prevPageIndex = (currPageIndex == 0) ? VIEWCONTROLLER_NUM - 1 : currPageIndex - 1;
        [self loadPageWithId:prevPageIndex onPage:0 isDragToLeft:NO];
        currShownIndex--;
        currentRequestPage = currShownIndex + 1;
        
        for (UIView *aView in theScrollView.subviews) {
            if (aView.frame.origin.x == 0) {
                currentRequestPage--;
                [self sendRequestToDetail:aView.tag - kTagConViewInZoneDetail];
//                if (aView.tag - kTagConViewInZoneDetail == 0) {
////                    NSLog(@"self.zeroCon加载上一页(currShownIndex--)的数据)");
//                    currentRequestPage--;
//                    [self sendRequestToDetail:0];
//                } else if (aView.tag - kTagConViewInZoneDetail == 1) {
////                    NSLog(@"self.firstCon加载上一页(currShownIndex--)的数据");
//                    currentRequestPage--;
//                    [self sendRequestToDetail:1];
//                } else if (aView.tag - kTagConViewInZoneDetail == 2) {
////                    NSLog(@"self.secondCon加载上一页(currShownIndex--)的数据");
//                    currentRequestPage--;
//                    [self sendRequestToDetail:2];
//                }
            }
        }
    } else {
        if(currShownIndex == 0) {
            currShownIndex++;
        }
        else if(currShownIndex == feedNum - 1) {
            currShownIndex--;
        }
    }
    NSLog(@"curr showing view:%d", currShownIndex);
    [theScrollView scrollRectToVisible:CGRectMake(DEVICE_SIZE.width, 0, DEVICE_SIZE.width, DEVICE_SIZE.height) animated:NO];
//    [self changeTheShortLabel:currShownIndex];
}

/*
- (void)sendRequestToDetail:(int)PEPageViewTag {
    PEPageView *pePageView = (PEPageView*)[self.paginatorView pageForIndex:PEPageViewTag];
//    PEPageView *pePageView =  (PEPageView*)[self.view viewWithTag:kTagPEPageView + currPageIndex];
    NSString *url;
    int perpage = isFirstShow ? kFirstLoadNum : 1;
    if (isFirstShow) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    if (_userId) {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspace&tagid=%@&uid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, _userId, currentRequestPage, perpage, [MY_M_AUTH urlencode]];
    } else {
        url = [NSString stringWithFormat:@"%@space.php?do=familyspace&tagid=%@&page=%d&perpage=%d&m_auth=%@", BASE_URL, _tagId, currentRequestPage, perpage, [MY_M_AUTH urlencode]];
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        _bottomView.hidden = YES;
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [self changeFeedData:[[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] objectAtIndex:PEPageViewTag] inCon:pePageView.feedDetailCon];
        
//        feedNum = [[[dict objectForKey:WEB_DATA] objectForKey:FEED_NUM] intValue];
//        if (isFirstShow) {
////            theScrollView.contentSize = CGSizeMake(320 * fminf(3, feedNum), DEVICE_SIZE.height);
//            for (int i = 0; i < fminf(kFirstLoadNum, feedNum); i++) {
//                FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
//                
//                con.isFromZone = YES;
//                //                if ([[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] count] > 0) {
//                [self changeFeedData:[[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] objectAtIndex:i] inCon:con];
//                //                }
//                
//                con.view.tag = kTagConViewInZoneDetail + i;
//                //                [con.bottomView removeFromSuperview];
//                //                con.bottomView = nil;
//                con.view.frame = CGRectMake(DEVICE_SIZE.width * i, 0, DEVICE_SIZE.width, DEVICE_SIZE.height);
//                //                con._tableView.frame = (CGRect){.origin = con._tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = DEVICE_SIZE.height - 40};
//                
//                [theScrollView addSubview:con.view];
//                if (i == 0) {
//                    self.zeroCon = con;
//                } else if (i == 1) {
//                    self.firstCon = con;
//                } else if (i == 2) {
//                    self.secondCon = con;
//                }
//            }
//            currentRequestPage = fminf(3, feedNum);
//            isFirstShow = NO;
//        } else {
//            FeedDetailViewController *con = whichCon == 0 ? zeroCon : (whichCon == 1 ? firstCon : secondCon);
//            //            con.dataDict = nil;
//            [con.dataArray removeAllObjects];
//            //            [con._tableView reloadData];
//            //            if ([[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] count] > 0) {
//            [self changeFeedData:[[[dict objectForKey:WEB_DATA] objectForKey:FEED_LIST] objectAtIndex:0] inCon:con];
//            //            }
//        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
    }];
}

- (void)changeFeedData:(NSDictionary*)dict inCon:(FeedDetailViewController*)con {
    con.idType = [dict objectForKey:FEED_ID_TYPE];
    con.feedId = [dict objectForKey:ID];
    con.feedCommentId = [dict objectForKey:F_ID];
    con.userId = [dict objectForKey:UID];
    if (!isFirstShow) {
        [con sendRequest:nil];
    }
}

#pragma mark - SYPaginatorViewDataSource

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView {
	return kFirstLoadNum;
}

- (SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex {
	static NSString *identifier = @"identifier";
	
	PEPageView *view = (PEPageView *)[paginatorView dequeueReusablePageWithIdentifier:identifier];
	if (!view) {
		view = [[PEPageView alloc] initWithReuseIdentifier:identifier];
	}
    view.tag = kTagPEPageView + pageIndex;
	return view;
}

-(void)paginatorView:(SYPaginatorView *)paginatorView
     willDisplayView:(UIView *)view
             atIndex:(NSInteger)pageIndex{
    NSLog(@"will display view at index: %i", pageIndex + 1);
    [self sendRequestToDetail:pageIndex + 1];
}

- (void)paginatorView:(SYPaginatorView *)paginatorView didScrollToPageAtIndex:(NSInteger)pageIndex {
    [self sendRequestToDetail:pageIndex];
}
*/

@end
