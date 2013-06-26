//
//  WaterFallViewController.m
//  Family_ipad
//
//  Created by walt.chan on 13-3-27.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "WaterFallViewController.h"
#import "PSBroView.h"
#import "DetailViewController.h"
#import "MyHttpClient.h"
#import "DetailViewController.h"
#import "FeedCell.h"
#import "LoginViewController.h"
#define PER_PAGE_NUM 15

@interface WaterFallViewController ()

@end

@implementation WaterFallViewController
-(void)dealloc{
    [_collectionView release];
    [dataArray release];
    [super dealloc];
}
- (void)backAction:(id)sender
{
    LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:con animated:YES];
}
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
   
    NSString * requestStr;
    if ([sender intValue]== ZONE_TYPE&&_tagID)
        if (!_userid)
            requestStr = $str(@"%@space.php?do=familyspace&m_auth=%@&perpage=%d&page=%d&tagid=%@",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage,_tagID);
        else
            requestStr = $str(@"%@space.php?do=familyspace&m_auth=%@&perpage=%d&page=%d&tagid=%@&uid=%@",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage,_tagID,_userid);
    
        else
            requestStr = $str(@"%@space.php?do=topic&m_auth=%@&perpage=%d&page=%d",BASE_URL,GET_M_AUTH,PER_PAGE_NUM,currentPage);
    
    [[MyHttpClient sharedInstance] commandWithPathAndNoHUD:requestStr
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
                                          }
                                          [self dataSourceDidLoad];
                                          
                                      }
                                           failure:^(NSError *error) {
                                               currentPage--;
                                           }];

}

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
    self.dataArray = [NSMutableArray array];
    self.currentPage = 1;
    self.view.backgroundColor = [UIColor lightGrayColor];

    self.collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(90, 0, self.view.frame.size.width-100, self.view.frame.size.height)];
    //self.collectionView.backgroundColor = [UIColor clearColor];

    [self.view insertSubview:self.collectionView belowSubview:self.btn];
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    self.collectionView.pullDelegate = self;
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.numColsPortrait = 3;
    self.collectionView.numColsLandscape = 4;
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"加载中";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.backgroundColor = [UIColor clearColor];
    self.collectionView.loadingView = loadingLabel;
    
    //    [self loadDataSource];
    if(!self.collectionView.pullTableIsRefreshing) {
        self.collectionView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable:) withObject:$int(self.contentType) afterDelay:0];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    [self.parent presentModalViewController:detailViewController animated:YES];
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
