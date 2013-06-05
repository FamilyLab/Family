    //
//  ZoneWaterFallView.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "ZoneWaterFallView.h"
#import "PSBroView.h"
#import "MyHttpClient.h"
#import "DetailViewController.h"
#import "FeedCell.h"
#import "KGModal.h"
#define PER_PAGE_NUM 10
@implementation ZoneWaterFallView
@synthesize dataArray,needRemoveObjects,currentPage;
- (FeedCellType)whichType:(NSDictionary*)dict {
    NSString *idType = [dict objectForKey:FEED_ID_TYPE];
    if ([idType rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {//@"photoid"或@"rephotoid"
        if ([[dict objectForKey:FEED_IMAGE_2] isEqualToString:@""]) {
            return bigImgType;//只有一张图片
        } else
            return someImgsType;//>1张图片
    } else if (([idType rangeOfString:FEED_BLOG_ID].location != NSNotFound) || ([idType rangeOfString:FEED_VIDEO_ID].location != NSNotFound)) {//@"blogid"或@"reblogid"或"videoid"或"revideoid"
        if ([[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {
            return onlyTextType;//没有图片
        } else
            return imgAndTextType;//
    } else if ([idType rangeOfString:FEED_EVENT_ID].location != NSNotFound) {//@"eventid"或"reeventid"
        return locationType;
    } else if ([[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {//idtype里除了照片、日记、视频、活动及其转采的
        return otherNoImgType;//右边没有图片
    } else
        return otherHasImgType;//右边有图片
}
- (void)loadDataSource:(NSNumber *)sender {
    // Request
    //    NSString *URLPath = [NSString stringWithFormat:@"http://imgur.com/gallery.json"];
    //    NSURL *URL = [NSURL URLWithString:URLPath];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    //
    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    //
    //        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    //
    //        if (!error && responseCode == 200) {
    //            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //            if (res && [res isKindOfClass:[NSDictionary class]]) {
    //                self.dataArray = [res objectForKey:@"gallery"];
    //                [self dataSourceDidLoad];
    //            } else {
    //                [self dataSourceDidError];
    //            }
    //        } else {
    //            [self dataSourceDidError];
    //        }
    //    }];
    NSString * requestStr;
    if ([sender intValue]== ZONE_TYPE&&_tagID)
        if (!_userid)
            requestStr = $str(@"%@space.php?do=familyspace&m_auth=%@&perpage=%d&page=%d&tagid=%@",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage,_tagID);
        else
            requestStr = $str(@"%@space.php?do=familyspace&m_auth=%@&perpage=%d&page=%d&tagid=%@&uid=%@",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage,_tagID,_userid);

    else
        requestStr = $str(@"%@space.php?do=topic&m_auth=%@&perpage=%d&page=%d",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage);
    
    [[MyHttpClient sharedInstance] commandWithPath:requestStr
                                      onCompletion:^(NSDictionary *dict) {
                                          self.collectionView.pullTableIsLoadingMore = NO;

                                          if (needRemoveObjects == YES) {
                                              [dataArray removeAllObjects];
                                              needRemoveObjects = NO;
                                          }
                                          NSMutableArray *resultArr;
                                          if ([sender intValue]== ZONE_TYPE )
                                              resultArr = [[dict objectForKey:WEB_DATA] objectForKey:@"feedlist"];
                                          else
                                          {
                                              resultArr = [[dict objectForKey:WEB_DATA] objectForKey:@"content"];
                                              
                                          }
                                        
                                          [dataArray addObjectsFromArray:resultArr];
                                          if ([sender intValue]== TODAY_TOPIC&&currentPage == 1) {
                                              NSDictionary *imagesize = [[dict objectForKey:WEB_DATA] objectForKey:@"imagesize"];
                                              NSMutableDictionary *topicDict = [[NSMutableDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[[dict objectForKey:WEB_DATA]objectForKey:@"pic"],[[dict objectForKey:WEB_DATA]objectForKey:MESSAGE],[[dict objectForKey:WEB_DATA]objectForKey:@"topicid"],nil] forKeys:[NSArray arrayWithObjects:@"image_1",MESSAGE,@"topicid", nil]];
                                              [topicDict setObject:imagesize forKey:@"imagesize"];
                                              
                                              if ([dataArray count]>=3) {
                                                  [dataArray insertObject:topicDict atIndex:3];
                                              }else{
                                                  [dataArray insertObject:topicDict atIndex:0];

                                              }
                                          }
                                          if ([resultArr count]==0&&currentPage ==1&&dataArray.count==0) {
                                              [SVProgressHUD showSuccessWithStatus:@"空间还没有图片呢。"];
                                              [[KGModal sharedInstance]closeAction:nil];
                                          }
                                          [self dataSourceDidLoad];

                                      }
                                           failure:^(NSError *error) {
                                               currentPage--;
                                           }];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataArray = [NSMutableArray array];
        self.currentPage = 1;
        self.backgroundColor = [UIColor clearColor];
        
        self.collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.collectionView];
        self.collectionView.collectionViewDelegate = self;
        self.collectionView.collectionViewDataSource = self;
        self.collectionView.pullDelegate = self;
        
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.collectionView.numColsPortrait = 3;
        self.collectionView.numColsLandscape = 4;
       
        
//        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
//        loadingLabel.text = @"Loading...";
//        loadingLabel.textAlignment = UITextAlignmentCenter;
//        loadingLabel.backgroundColor = [UIColor clearColor];
//        self.collectionView.loadingView = loadingLabel;
        
       // [self loadDataSource];

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
- (void)dataSourceDidLoad {
    [self.collectionView reloadData];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}

#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.dataArray count];
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.dataArray objectAtIndex:index];
    
    PSBroView *v = (PSBroView *)[self.collectionView dequeueReusableView];
    if (!v) {
        v = [[PSBroView alloc] initWithFrame:CGRectZero];
    }
    
    [v fillViewWithObject:item];
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    NSDictionary *item = [self.dataArray objectAtIndex:index];
    
    return [PSBroView heightForViewWithObject:item  inColumnWidth:self.collectionView.colWidth];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    NSDictionary *item = [self.dataArray objectAtIndex:index];
    if ([item objectForKey:@"topicid"]) {
        return;
    }
    FeedCellType type = [self whichType:item];
    if (type == otherHasImgType || type == otherNoImgType) {
        return;
    }
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    //    con.detailType = bigImgType;
    //    con.dataDict = [dataArray objectAtIndex:indexPath.row];
    
    NSDictionary *aDict = item;
    detailViewController.idType = [aDict objectForKey:FEED_ID_TYPE];
    detailViewController.feedId = [aDict objectForKey:ID_];
    detailViewController.userId = [aDict objectForKey:UID];
    detailViewController.feedCommentId = [aDict objectForKey:F_ID];
    // You can do something when the user taps on a collectionViewCell here
    detailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    detailViewController.isFromZone = YES;
    [self.parent.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
    detailViewController.view.superview.frame = CGRectMake(0, 0, 480, 768);//it's important to do this after
    detailViewController.view.superview.center = CGPointMake(1024/2, 768/2);


}
- (void) refreshTable:(NSNumber *)sender
{
    /*
     
     Code to actually refresh goes here.
     
     */
    needRemoveObjects = YES;
    currentPage = 1;
    [self loadDataSource:sender];
    

    self.collectionView.pullLastRefreshDate = [NSDate date];
    self.collectionView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable:(NSNumber *)sender
{
    currentPage ++;
    [self loadDataSource:sender];

    /*
     
     Code to actually load more data goes here.
     
     */
    //    [self loadDataSource];
    //[self.dataArray addObjectsFromArray:self.dataArray];
 //   [self.collectionView reloadData];
}
#pragma mark - PullTableViewDelegate

- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(refreshTable:) withObject:$int(self.contentType) afterDelay:0.0f];
}

- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable:) withObject:$int(self.contentType) afterDelay:0.0f];
}
@end
