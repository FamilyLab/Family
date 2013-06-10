//
//  TopicViewController.m
//  Family
//
//  Created by Aevitx on 13-3-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicCell.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "FeedDetailViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFromMoreCon = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _tableView.refreshView.hidden = YES;
    [self addTopView];
    [self addBottomView];
    self.view.backgroundColor = bgColor();
    [self.view bringSubviewToFront:_loadingView];
    if (!MY_HAS_LOGIN || !MY_AUTO_LOGIN) {
        [self sendRequest:_tableView];
    }
    if (!_isFromMoreCon) {//启动app时的
        [_loadingView loadingAnimation];
//        [self performBlock:^(id sender) {
//            [_loadingView removeTheLoadingViewInCon:self];
//        } afterDelay:1.2f];
    } else {//更多页面的
        _tableView.frame = (CGRect){.origin = _tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = DEVICE_SIZE.height - 50 - 40};
        [_loadingView removeFromSuperview];
        self.loadingView = nil;
    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_TOPIC_CON object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentPageForNotification:) name:REFRESH_TOPIC_CON object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    self._tableView.frame = CGRectMake(0, 50, DEVICE_SIZE.width, DEVICE_SIZE.height - 50);
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    self._tableView.frame = CGRectMake(0, 50, DEVICE_SIZE.width, DEVICE_SIZE.height - 50);
}

#pragma mark - my method(s)
- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", @"join_topic", nil];
    BottomView *tmpView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                       type:notAboutTheme
                                                  buttonNum:[normalImages count]
                                            andNormalImages:normalImages
                                          andSelectedImages:nil
                                         andBackgroundImage:@"login_bg"];
    tmpView.delegate = self;
    [self.view addSubview:tmpView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0://后退
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 1:
        {
            if (self.topicId) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CUSTOM_CAMERA object:self.topicId];
            }
            break;
        }
        default:
            break;
    }
}

- (void)sendRequest:(id)sender {
    NSString *url = [NSString stringWithFormat:@"%@space.php?do=topic&page=%d&perpage=%d", BASE_URL, currentPage, 5];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self stopLoading:sender];
        if ([JSON isMemberOfClass:[NSDictionary class]] && [[JSON objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[JSON objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[[JSON objectForKey:WEB_DATA] objectForKey:CONTENT] count] <= 0) {
//            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            [SVProgressHUD dismiss];
            currentPage--;
        }
        
//        _isFirstShow = NO;
        
//        [adImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[JSON objectForKey:WEB_DATA] objectForKey:PIC]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
//            NSLog(@"load img error:%@", [error description]);
//        }];
        
        self.topicId = [[JSON objectForKey:WEB_DATA] objectForKey:TOPIC_ID];
        [ConciseKit setUserDefaultsWithObject:_topicId forKey:LAST_TOPIC_ID];
        
        self.topicDescribeStr = [[JSON objectForKey:WEB_DATA] objectForKey:SUBJECT];
        self.topicImgUrlStr = [[JSON objectForKey:WEB_DATA] objectForKey:PIC];
        self.joinType = [[[JSON objectForKey:WEB_DATA] objectForKey:JOIN_TYPE] objectAtIndex:0];
        
        self.firstPicWidth = [emptystr([[[JSON objectForKey:WEB_DATA] objectForKey:IMAGE_SIZE] objectForKey:WIDTH]) floatValue];
        self.firstPicHeight = [emptystr([[[JSON objectForKey:WEB_DATA] objectForKey:IMAGE_SIZE] objectForKey:HEIGHT]) floatValue];
        
        [dataArray addObjectsFromArray:[[JSON objectForKey:WEB_DATA] objectForKey:CONTENT]];
        int arrayCount = [dataArray count];
        for (int i = 0; i < arrayCount; i++) {
            if (isEmptyStr([[dataArray objectAtIndex:i] objectForKey:FEED_IMAGE_1])) {
                [dataArray removeObjectAtIndex:i];
            }
        }
        [_tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
        currentPage--;
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }] start];
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"今日话题"];
    [topView rightLogo];
    [topView rightLine];
    [topView dropShadowWithOffset:CGSizeZero radius:0 color:bgColor() opacity:0 shadowFrame:CGRectZero];//因为有cellHeader，所以这里不用阴影
    [self.view addSubview:topView];
}

#pragma mark -
#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 325;// DEVICE_SIZE.height;
    } else {
        return 220;
//        return [[[[dataArray objectAtIndex:indexPath.row - 1] objectForKey:IMAGE_SIZE] objectForKey:HEIGHT] floatValue] + 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *topicCoverCellId = @"topicCoverCellId";
    static NSString *topicPhotoCellId = @"topicPhotoCellId";
    TopicCell *cell;
    if (indexPath.row == 0) {
        cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:topicCoverCellId];
    } else {
        cell = (TopicCell *)[tableView dequeueReusableCellWithIdentifier:topicPhotoCellId];
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil];
        if (indexPath.row == 0) {
            cell = [array objectAtIndex:0];
        } else
            cell = [array objectAtIndex:1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.indexRow = indexPath.row;
    cell.isFromMoreCon = _isFromMoreCon;
    if (indexPath.row == 0) {
        cell.firstPicWidth = _firstPicWidth;
        cell.firstPicHeight = _firstPicHeight;
//        NSString *picUrl = $str(@"%@%@", [_topicImgUrlStr delLastStrForYouPai], ypFeedDetail);
        NSString *picUrl = [_topicImgUrlStr delLastStrForYouPai];
        picUrl = $str(@"%@%@", picUrl, ypFeedBigImg);
        [cell.imgView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
        cell.describeLbl.text = _topicDescribeStr;
        
        NSString *checkImgStr = MY_WANT_SHOW_TODAY_TOPIC ? @"notChecked.png" : @"checked.png";
        cell.checkImgView.image = [UIImage imageNamed:checkImgStr];
        
        cell.topicId = _topicId;
    } else
        [cell initData:[dataArray objectAtIndex:indexPath.row - 1]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ;
    } else {
//        [self pushToFeedDetailWithDict:[dataArray objectAtIndex:indexPath.row - 1]];
    }
}

- (void)pushToFeedDetailWithDict:(NSDictionary*)dict {
    FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
    con.hidesBottomBarWhenPushed = YES;
    NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
    [idDict setObject:[dict objectForKey:FEED_ID_TYPE] forKey:FEED_ID_TYPE];
    [idDict setObject:[dict objectForKey:ID] forKey:FEED_ID];
    [idDict setObject:[dict objectForKey:ID] forKey:FEED_COMMENT_ID];
    [idDict setObject:[dict objectForKey:UID] forKey:UID];
    [con.idArray addObject:idDict];
//    con.idType = [dict objectForKey:FEED_ID_TYPE];
//    con.feedId = [dict objectForKey:ID];
//    con.feedCommentId = [dict objectForKey:ID];
//    con.userId = [dict objectForKey:UID];
    [self.navigationController pushViewController:con animated:YES];
}


@end
