//
//  BaseScrollViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-4-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "BaseScrollViewController.h"
#import "BottomBarView.h"
#import "PreviousButton.h"
#import "NextButton.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SBToolKit.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "BlocksKit.h"
#import "RepostViewController.h"
#import "RepostPictureViewController.h"
#import "UIButton+Block.h"
#import "MyIssueViewController.h"

#define ALERTVIEW_COMMENT 0
#define ALERTVIEW_TURN_TO_POST 1
#define ALERTVIEW_BACKTOFIRST 2

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //config attribute
        shouldShowHUD = YES;
        shouldShowNextDetailHUD = NO;
        currentListPage = 0;
        currentDetailIndex = 0;
        reloadTableInRequest = YES;
        isSpaceView = NO;
//        isMyLoveView= NO;
        isVideoView = NO;
        totalDataPageFromURLAPI = -1;
        self.commentSuccessTib = @"评论成功！";
        self.commentAlertViewTitle = @"我要评论~";
        
        //config queue
        self.operationQueue = [[NSMutableArray alloc] init];
        
        //config likeFeedList
        self.likeFeedList = [[NSMutableArray alloc] init];
        
        //config bottombar
        self.bottomBar = [[BottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - BOTTOM_BAR_SIZE.height, BOTTOM_BAR_SIZE.width, BOTTOM_BAR_SIZE.height)];
        self.bottomBar.delegate = self;
        [self.bottomBar.backBtn addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.bottomBar];
        
        //config previous button
        self.prevBtn = [[PreviousButton alloc] initWithFrame:CGRectMake(0, (DEVICE_SIZE.height - PREV_BTN_SIZE.height)/2, PREV_BTN_SIZE.width, PREV_BTN_SIZE.height)];
        [self.prevBtn addTarget:self action:@selector(prevPage) forControlEvents:UIControlEventTouchUpInside];
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPrevBtn:)];
        longPressGesture.minimumPressDuration = 0.8f;
        [self.prevBtn addGestureRecognizer:longPressGesture];
        [self.view addSubview:self.prevBtn];
        [self dismissPrevBtn];
        
        //config next button
        self.nextBtn = [[NextButton alloc] initWithFrame:CGRectMake(DEVICE_SIZE.width - NEXT_BTN_SIZE.width, (DEVICE_SIZE.height - NEXT_BTN_SIZE.height)/2, NEXT_BTN_SIZE.width, NEXT_BTN_SIZE.height)];
        [self.nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.nextBtn];
        
        //注册转发消息，当用户点击enlargeImageView上的转发按钮时触发消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressRepostBtn) name:NOTIFI_REPOST_IAMGE object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    [self.scrollView addSubview:self.blankView];
    self.blankView.backgroundColor = [UIColor whiteColor];
    
//    currentListPage++;
//    [self requestInfoList:currentListPage];
    
    isPullingData = NO;
    
    self.infoList = nil;
    self.detailInfoList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//长按前一页按钮
- (void)longPressPrevBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"要回到第一页吗？"
                                                            message:nil
                                                           delegate:self cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = ALERTVIEW_BACKTOFIRST;
        [alertView show];
    }
}

//返回第一页
- (void)backToTheFirstPage
{
    [super backToFirstPage];
}

//上一页
- (void)prevPage
{
    [self setOriginDataPage];
    if (currentDataPage != 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(([self currentScrollPage] - 1) * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }
}

//下一页
- (void)nextPage
{
    [self setOriginDataPage];
    
    if (currentDataPage == 0 && [self numberOfTotalDataPage] >= 2 &&
        [self numberOfDataPage] >= 2 && totalScrollPage == 1) {
                [self loadNextPage];
    }
    
    if ([self currentScrollPage] < totalScrollPage - 1) {
        [self.scrollView scrollRectToVisible:CGRectMake(([self currentScrollPage] + 1) * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    }
}

//滚动页改变
- (void)scrollPageDidChange:(int)currentScrollPage
{
    if (totalDataPageFromURLAPI != -1 && currentDataPage >= totalDataPageFromURLAPI - 1) {
        [self dismissNextBtn];
    } else {
        [self showNextBtn];
    }
    
    if (currentDataPage == 0) {
        [self dismissPrevBtn];
    } else {
        [self showPrevBtn];
    }
    
    [self setLikeButton];
}

//设置喜欢按钮状态
- (void)setLikeButton
{
    NSLog(@"currentDataPage%d and [self.likefeedlist count] - 1%d", currentDataPage, [self.likeFeedList count] - 1);
    int likeFeedListCount = [self.likeFeedList count] - 1;
    if (currentDataPage > likeFeedListCount) {//likeFeedList里面没有记录
        if ([self checkIfIloveThisFeed]) {
            [self setLikeButtonLike];
            [self.likeFeedList addObject:[NSNumber numberWithBool:YES]];
        } else {
            [self setLikeButtonUnlike];
            [self.likeFeedList addObject:[NSNumber numberWithBool:NO]];
        }
    } else {//likeFeedList里面有数据
        if ([(NSNumber *)[self.likeFeedList objectAtIndex:currentDataPage] boolValue]) {
            [self setLikeButtonLike];
        } else {
            [self setLikeButtonUnlike];
        }
    }
}

- (void)setLikeButtonLike
{
    [self.bottomBar.likeBtn setImage:[UIImage imageNamed:@"like_red.png"] forState:UIControlStateNormal];
}

- (void)setLikeButtonUnlike
{
    [self.bottomBar.likeBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
}

//检测是否喜欢本详情
- (BOOL)checkIfIloveThisFeed
{
//    NSLog(@"the detailinfolist%@", [self.detailInfoList objectAtIndex:currentDataPage]);
    if ([[[self.detailInfoList objectAtIndex:currentDataPage] objectForKey:MYLOVE] intValue] == 1) {
        return YES;
    }
    return NO;
}

//请求我喜欢的帖子列表
//- (void)requestMyLikeList:(int)page
//{
//    isPullingData = YES;
//    
//    if (shouldShowHUD) {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//    }
//    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
//    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:MY_LIKE_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:LOVEFEED, DO, [SBToolKit getMAuth], M_AUTH, [NSString stringWithFormat:@"%d", page], PAGE, [NSString stringWithFormat:@"%d", PERPAGE_COUNT], PERPAGE, nil]];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *resultDict = [responseObject objectFromJSONData];
//        
//        if ([[resultDict objectForKey:ERROR] intValue] == 0) {
//            NSArray *dataArray = [resultDict objectForKey:DATA];
//            if ([dataArray count] < PERPAGE_COUNT) {
//                totalDataPageFromURLAPI = (page - 1) * PERPAGE_COUNT + [dataArray count];//一页数据不足perpagecount，证明数据已经取完
//                if (currentDataPage == totalDataPageFromURLAPI - 1) {//第一页就是最后一页时条件为真
//                    [self dismissNextBtn];
//                }
//            }
//            
//            if ([dataArray count] > 0) {
//                [self.detailInfoList addObjectsFromArray:dataArray];
//            } else {
//                [self dismissNextBtn];
//                [SVProgressHUD showErrorWithStatus:@"没有更多数据了。。"];
//            }
//            
//            if (self.blankView != nil) {
//                [self.blankView removeFromSuperview];
//                self.blankView = nil;
//            }
//            
//            if (currentDataPage == 0) {
//                [self reloadDataFromDataPage:0];
//                [self setLikeButton];
//            }
//        
//            //执行队列中的请求
//            if ([self.operationQueue count] > 0) {
//                [self.operationQueue makeObjectsPerformSelector:@selector(start)];
//                [self.operationQueue removeAllObjects];
//            }
//            
//            isPullingData = NO;
//            
//            if (shouldShowHUD) {
//                [SVProgressHUD dismiss];
//            }
//            
//        } else {
//            NSLog(@"请求我喜欢的帖子错误：%@", resultDict);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:API_FAIL_MSG];
//        NSLog(@"请求我喜欢的帖子失败：%@", error);
//    }];
//    [operation start];
//}

- (void)requestSpaceInfoList:(int)page
{
    NSLog(@"要开始取spaceInfoList数据了，page：%d", page);
    isPullingData = YES;
    if (shouldShowHUD) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    AFHTTPRequestOperation *operation = [self requestSpaceInfoListOperation:page];
    [operation start];
}

- (UIAlertView *)returnAlertViewTurnToPost
{
    UIAlertView *alertViewTurnToPost = [[UIAlertView alloc] initWithTitle:@"还没有数据" message:@"暂时还没有数据哦！现在去发表一些吧~" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"好啊！", nil];
    alertViewTurnToPost.tag = ALERTVIEW_TURN_TO_POST;
    return alertViewTurnToPost;
}

//取空间列表信息的operation
- (AFHTTPRequestOperation *)requestSpaceInfoListOperation:(int)page
{
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[self pathOfInfoListRequest] parameters:[self parasOfInfoListRequest:page]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];

        //取数据列表
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSDictionary *dataDict = (NSDictionary *)[resultDict objectForKey:DATA];
            //这个空间还没有数据
            if (currentListPage == 1 && [[dataDict objectForKey:FEEDLIST]count] == 0) {
                [SVProgressHUD dismiss];
                [[self returnAlertViewTurnToPost] show];
                return;
            }
            
            if (self.infoList == nil) {
                self.infoList = [NSMutableArray arrayWithArray:[dataDict objectForKey:FEEDLIST]];
            } else {
                [self.infoList addObjectsFromArray:[NSMutableArray arrayWithArray:[dataDict objectForKey:FEEDLIST]]];
            }

            //取详细信息
            NSLog(@"取详细信息，从:%d", (page - 1) * PHOTO_FEED_PERPAGE_COUNT);

            [self requestDetailInfo:(page - 1) * PHOTO_FEED_PERPAGE_COUNT fromPath:PHOTO_DETAIL_API];
        } else {
            NSLog(@"requesting list error %@", resultDict);
            [SVProgressHUD showErrorWithStatus:@"拉取数据失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request list failure %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常!"];
    }];
    
    return operation;
}

- (void)requestInfoList:(int)page
{
    NSLog(@"要开始取infoList数据了，page：%d", page);
    isPullingData = YES;
    if (shouldShowHUD) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    
    AFHTTPRequestOperation *operation = [self requestInfoListOperation:page];
    [operation start];
}

//取列表信息的operation
- (AFHTTPRequestOperation *)requestInfoListOperation:(int)page
{
    return [self requestInfoListOperation:page withDataKey:DATA];
}

- (AFHTTPRequestOperation *)requestInfoListOperation:(int)page withDataKey:(NSString *)dataKey
{
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[self pathOfInfoListRequest] parameters:[self parasOfInfoListRequest:page]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
//        NSLog(@"取到的详细空间Item信息%@", resultDict);
        //取数据列表
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSArray *dataArray = [resultDict objectForKey:dataKey];
            if (currentListPage == 1 && [dataArray count] == 0) {
                [SVProgressHUD dismiss];
                [[self returnAlertViewTurnToPost] show];
                return;
            }
            
            if ([dataArray count] < PERPAGE_COUNT) {
                totalDataPageFromURLAPI = (page - 1) * PERPAGE_COUNT + [dataArray count];//一页数据不足perpagecount，证明数据已经取完
                if (currentDataPage == totalDataPageFromURLAPI - 1) {//第一页就是最后一页时条件为真
                    [self dismissNextBtn];
                }
            }
            
            if ([dataArray count] != 0) {
                if (self.infoList == nil) {
                    self.infoList = [[NSMutableArray alloc] initWithArray:[resultDict objectForKey:dataKey]];
                } else {
                    [self.infoList addObjectsFromArray:[resultDict objectForKey:dataKey]];
                }
                //取详细信息
    //            NSLog(@"info list:%@", resultDict);
    //            NSLog(@"request:%@", request);
                
                NSLog(@"取详细信息，从:%d", (page - 1) * PHOTO_FEED_PERPAGE_COUNT);
            } else {
                [self dismissNextBtn];
                [SVProgressHUD showErrorWithStatus:@"没有更多数据了。。"];
            }
//            [self requestDetailInfo:currentDetailIndex fromPath:[self pathOfDetailInfoRequest]];
            [self requestDetailInfo:(page - 1) * PHOTO_FEED_PERPAGE_COUNT fromPath:PHOTO_DETAIL_API];
        } else {
//            NSLog(@"requesting list error %@", resultDict);
            [SVProgressHUD showErrorWithStatus:@"拉取数据失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request list failure %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常!"];
    }];

    return operation;
}

//取详细信息
- (void)requestDetailInfo:(int)i fromPath:(NSString *)path
{
    if (i == 1) {
        if (self.blankView != nil) {
            [self.blankView removeFromSuperview];
            self.blankView = nil;
        }
//        [self initElementWithScrollViewFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        [self setLikeButton];
//        [self refreshBaseData];
        [self reloadDataFromDataPage:0];
        //        if (reloadTableInRequest) {
        //            [self reloadData];
        ////        } else if ([self currentScrollPage] == totalScrollPage - 1){
        ////            [self loadNextPage];
        //        }
        
        if (shouldShowHUD) {
            [SVProgressHUD dismiss];
        }
    }
    
    if (i >= [self.infoList count]) {
        if ([self.operationQueue count] > 0) {
            [self.operationQueue makeObjectsPerformSelector:@selector(start)];
            [self.operationQueue removeAllObjects];
        }
        
        isPullingData = NO;
        
//        if (shouldShowHUD) {
//            [SVProgressHUD dismiss];
//        }
        
//        NSLog(@"requesting photo loop is finish with %d loops", i);
        return;
    }
    
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:[self parasOfDetailInfoRequest:i]];
//    NSLog(@"取详细数据的参数：%@", [self parasOfDetailInfoRequest:i]);
//    NSLog(@"取详细数据的URL：%@", path);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getting data loop %d with currentListPage:%d", i, currentListPage);
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
//        NSLog(@"取到的详细信息%@", resultDict);
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            [self.detailInfoList addObject:[resultDict objectForKey:DATA]];
            
            //如果在刚添加detailInfoItem之前，显示到了最后一页，则应该在刚刚添加了新的item之后，加载下一页
            if (currentListPage > 1 && currentDataPage == [self numberOfDataPage] - 2) {
                [self loadNextPage];
            }

            [self requestDetailInfo:i+1 fromPath:path];
            currentDetailIndex++;
            //若由于viewFromDataPage中数据没有及时取回
            if (shouldShowNextDetailHUD) {
                [SVProgressHUD dismiss];
                shouldShowHUD = NO;
            }
        } else {
            NSLog(@"request detail error in pictureviewcontroller%@\nwith requst:%@", resultDict, request);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request detail faild in pictureviewcontroller%@", error);
        [SVProgressHUD showErrorWithStatus:@"网络不好。。"];
    }];
    
    [operation start];
}

- (void)pushRequestOperation:(AFHTTPRequestOperation *)operation
{
    [self.operationQueue addObject:operation];
}

//bottom bar
- (void) backToRoot
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_POP_TO_MAINVIEW object:self];
}

//简略信息（infoList）总数
- (int)numberOfTotalDataPage
{
    return [self.infoList count];
}

//详细信息（detailInfoList）的总数
- (int)numberOfDataPage
{
    return [self.detailInfoList count];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    //滚动到中间页时
    if (currentDataPage == currentListPage * PHOTO_FEED_PERPAGE_COUNT - 2) {
        shouldShowHUD = NO;
        reloadTableInRequest = NO;
        if (!isPullingData) {
            currentListPage++;
            NSLog(@"滚动到了中间页，直接开请求，currentDataPage:%d, totaoDataPage:%d, currentListPage:%d", currentDataPage, [self numberOfTotalDataPage], currentListPage);
            if (isSpaceView) {
                [self requestSpaceInfoList:currentListPage];
                NSLog(@"请求空间页面相关数据");
//            } else if (isMyLoveView){
//                [self requestMyLikeList:currentListPage];
                NSLog(@"请求收藏页面相关数据");
            } else {
                [self requestInfoList:currentListPage];
                NSLog(@"请求普通页面相关数据");
            }
        } else if ([self.operationQueue count] == 0){
            //如果没有判断，若中间页的后一页仍在下载中，用户不断滑动此页时会造成重复push
            currentListPage++;
            NSLog(@"还没到了中间页，push请求，currentDataPage:%d, totaoDataPage:%d, currentListPage:%d", currentDataPage, [self numberOfTotalDataPage], currentListPage);
            if (!isSpaceView) {
                [self pushRequestOperation:[self requestInfoListOperation:currentListPage]];
            } else {
                [self pushRequestOperation:[self requestSpaceInfoListOperation:currentListPage]];
            }
        }
    };
    
    //拉取数据并且滚动到滚动页2时，显示菊花；否则让菊花消失
    if (self.scrollView.contentOffset.x > self.scrollView.frame.size.width * (totalScrollPage - 1)
        && isPullingData
        && currentDataPage >= [self.detailInfoList count] - 1) {
        [SVProgressHUD show];
        shouldShowNextDetailHUD = YES;//请求一个图片详情完毕会检查，是否要dismiss
    } else if ( currentDataPage < [self.detailInfoList count] - 1 && shouldShowNextDetailHUD){
        [SVProgressHUD dismiss];
        shouldShowNextDetailHUD = NO;
    }
}

- (void)loadMore
{
    NSLog(@"需要家在更多数据");
    if (isPullingData) {
        [SVProgressHUD show];
    }
}

//返回带评论输入框的alertView
- (UIAlertView *)getCommentAlertView
{
    if (subScrollViewType == ACTIVITYVIEW_CONTROLLER) {
        self.commentSuccessTib = @"参加成功";
        self.commentAlertViewTitle = @"我要参加~";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.commentAlertViewTitle message:@"\n\n\n\n\n" delegate:self cancelButtonTitle:@"还是不了" otherButtonTitles:@"好了！", nil];
    alertView.tag = ALERTVIEW_COMMENT;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 245, 110)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    if (subScrollViewType == ACTIVITYVIEW_CONTROLLER) {
        textField.text = @"参加了这个活动";
    }
    
    [alertView addSubview:textField];
    [textField becomeFirstResponder];
    return alertView;
}

//获取评论框中的评论文字
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERTVIEW_COMMENT:
        {
            if (buttonIndex == 1) {
                for (id subView in [alertView subviews]) {
                    NSString *itemID;
                    NSString *idtype;
                    
                    itemID = [[self.infoList objectAtIndex:currentDataPage] objectForKey:ID];
                    idtype = [[self.infoList objectAtIndex:currentDataPage] objectForKey:IDTYPE];
                    
                    if ([[subView class] isSubclassOfClass:[UITextField class]]) {
                        [self comment:((UITextField *)subView).text
                           toObjectID:itemID
                           withIDType:idtype];
                    }
                }
            }
            break;
        }
        case ALERTVIEW_TURN_TO_POST:
        {
            if (buttonIndex == 1) {
                MyIssueViewController *myIssueViewController = [[MyIssueViewController alloc] initWithNibName:@"MyIssueViewController" bundle:nil];
                [self.navigationController pushViewController:myIssueViewController animated:YES];
            }
        }
        break;
        case ALERTVIEW_BACKTOFIRST:
        {
            if (buttonIndex == 1) {
                [self backToTheFirstPage];
            }
        }
        break;
    }
}

//按下评论按钮
- (void)pressCommentBtn
{
    if ([self.infoList count] == 0) {
        [SVProgressHUD showErrorWithStatusNoAutoDismiss:@"操作失败！当前没有数据！"];
        [self performBlock:^(id sender) {
            [SVProgressHUD dismiss];
        } afterDelay:2.0f];
        return;
    }
    
    UIAlertView *alertView = [self getCommentAlertView];
    [alertView show];
}

//评论提交
- (void)comment:(NSString *)comment
     toObjectID:(NSString *)objectID
     withIDType:(NSString *)idtype
{
    NSString *m_auth = [SBToolKit getMAuth];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSString *trueIdtype = [SBToolKit convertReidtypeToidtype:idtype];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:COMMENT_POST_API
                                                                   parameters:nil
                                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                        [formData appendPartWithFormData:[m_auth dataUsingEncoding:NSUTF8StringEncoding] name:M_AUTH];
                                                        [formData appendPartWithFormData:[objectID dataUsingEncoding:NSUTF8StringEncoding] name:ID];
                                                        [formData appendPartWithFormData:[trueIdtype dataUsingEncoding:NSUTF8StringEncoding] name:IDTYPE];
                                                        [formData appendPartWithFormData:[comment dataUsingEncoding:NSUTF8StringEncoding] name:MESSAGE];
                                                    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"comment post request%@", request);
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
        NSLog(@"提交评论之后获得的resultDict:%@", resultDict);
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:self.commentSuccessTib];

            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_REFRESH_COMMENT object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:objectID, ID, trueIdtype, IDTYPE, nil]];//刷新评论
            NSLog(@"刷新评论的request:%@", request);
            NSLog(@"objectID:%@, idtype:%@, \n%@", objectID, trueIdtype, resultDict);
        } else {
            NSLog(@"评论错误, %@", resultDict);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                                message:[resultDict objectForKey:MSG]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
            [alertView show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论失败, %@", error);
    }];
    [operation start];
}

//收藏feed
- (void)pressLikeBtn
{
    if ([self.infoList count] == 0) {
        [SVProgressHUD showErrorWithStatusNoAutoDismiss:@"操作失败！当前没有数据！"];
        [self performBlock:^(id sender) {
            [SVProgressHUD dismiss];
        } afterDelay:2.0f];
        return;
    }
    
    int type = [[self.likeFeedList objectAtIndex:currentDataPage] boolValue]? 0:1;
    [self likeFeedApi:type];
}

- (void)likeFeedApi:(int)type
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:LIKE_API
                                                                   parameters:nil
                                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                        [formData appendPartWithFormData:[[SBToolKit getMAuth] dataUsingEncoding:NSUTF8StringEncoding] name:M_AUTH];
                                                        NSLog(@"%@", [SBToolKit getMAuth]);
                                                        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d", type] dataUsingEncoding:NSUTF8StringEncoding] name:TYPE];
                                                        NSLog(@"%d", type);
                                                        
                                                        //区分收藏帖子以及非收藏帖子取ID的情况
                                                        NSString *idtype;
                                                        idtype = [[self.infoList objectAtIndex:currentDataPage] objectForKey:IDTYPE];
                                                        idtype = [SBToolKit convertReidtypeToidtype:idtype];
                                                        [formData appendPartWithFormData:[idtype dataUsingEncoding:NSUTF8StringEncoding] name:IDTYPE];
                                                        NSLog(@"%@", [[self.infoList objectAtIndex:currentDataPage] objectForKey:IDTYPE]);
                                                        
                                                        //区分收藏帖子以及非收藏帖子取ID的情况
                                                        NSString *itemId;
                                                        itemId = [[self.infoList objectAtIndex:currentDataPage] objectForKey:ID];
                                                        [formData appendPartWithFormData:[itemId dataUsingEncoding:NSUTF8StringEncoding] name:ID];
                                                        NSLog(@"%@", [[self.infoList objectAtIndex:currentDataPage] objectForKey:ID]);
                                                    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            NSDictionary *dataDict = [resultDict objectForKey:DATA];
            
            if ([(NSNumber *)[dataDict objectForKey:RETURN] intValue] == 1) {
                //todo： 保存现时收藏状态
                BOOL likeType = ((type == 1)? YES:NO);
                [self.likeFeedList replaceObjectAtIndex:currentDataPage withObject:[NSNumber numberWithBool:likeType]];
                [self setLikeButton];
            } else {
                NSLog(@"like feed error:%@ with request:%@", resultDict, request);
            }
        } else {
            NSLog(@"like feed error:%@ with request:%@", resultDict, request);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"like feed fail%@", error);
    }];
    [operation start];
}

//按下转发按钮
- (void)pressRepostBtn
{
    if ([self.infoList count] == 0) {
        [SVProgressHUD showErrorWithStatusNoAutoDismiss:@"操作失败！当前没有数据！"];
        [self performBlock:^(id sender) {
            [SVProgressHUD dismiss];
        } afterDelay:2.0f];
        return;
    }
    
    if (subScrollViewType == ACTIVITYVIEW_CONTROLLER) {
        [SVProgressHUD showErrorWithStatus:@"不能转发活动"];
        return;
    }
    
    if (isVideoView) {
        [SVProgressHUD showErrorWithStatus:@"不能转发视频"];
        return;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:UID] isEqualToString:[[self.infoList objectAtIndex:currentDataPage] objectForKey:UID]]) {
        [SVProgressHUD showErrorWithStatusNoAutoDismiss:@"不能转发自己的内容哦！"];
        [self performBlock:^(id sender) {
            [SVProgressHUD dismiss];
        } afterDelay:2.0f];
        return;
    }
    
    RepostViewController *repostViewController;
    if (subScrollViewType == PICTUREVIEW_CONTROLLER) {
        repostViewController = [[RepostPictureViewController alloc] initWithNibName:@"RepostViewController" bundle:nil];
    } else {
        repostViewController = [[RepostViewController alloc] initWithNibName:@"RepostViewController" bundle:nil];
    }
    repostViewController.delegate = self;
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self presentViewController:repostViewController animated:YES completion:^{}];
    } else {
        [self presentModalViewController:repostViewController animated:YES];
    }
}

//调用转发接口 当在转发页面按下确定键时被调用
- (void)confirmToRepostwithMessage:(NSString *)repostMessage
                           toSpace:(NSString *)tagName
{
//    NSString *itemID;
    NSString *idtype;
    idtype = [[self.infoList objectAtIndex:currentDataPage] objectForKey:IDTYPE];
    repostMessage = [NSString stringWithFormat:@"%@\n\n%@", repostMessage, [[self.detailInfoList objectAtIndex:currentDataPage] objectForKey:MESSAGE]];
    [self confirmToRepostwithMessage:repostMessage
                             toSpace:tagName
                          withIDtype:idtype];
}

//确定要转发
- (void)confirmToRepostwithMessage:(NSString *)repostMessage
                           toSpace:(NSString *)tagName
                        withIDtype:(NSString *)idtype
{
    [SVProgressHUD showWithStatus:@"稍等哈~"];
    NSString *re_ac;
    NSString *submit_type;
    if ([idtype isEqualToString:PHOTOID] || [idtype isEqualToString:REPHOTOID]) {
        re_ac = REPHOTO;
        submit_type = PHOTOSUBMIT;
    } else if ([idtype isEqualToString:EVENTID] || [idtype isEqualToString:REEVENTID]) {
        re_ac = REEVENT;
        submit_type = EVENTSUBMIT;
    } else if ([idtype isEqualToString:BLOGID] || [idtype isEqualToString:REBLOGID]) {
        re_ac = REBLOG;
        submit_type = BLOGSUBMIT;
    } else if ([idtype isEqualToString:VIDEOID] || [idtype isEqualToString:REEVENTID]) {
        re_ac = REVIDEO;
        submit_type = VIDEOSUBMIT;
    }

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:REPOST_API
                                                                   parameters:[NSDictionary dictionaryWithObject:re_ac forKey:AC]
                                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                       [formData appendPartWithFormData:[[SBToolKit getMAuth] dataUsingEncoding:NSUTF8StringEncoding] name:M_AUTH];
                                                       [formData appendPartWithFormData:[[[self.infoList objectAtIndex:currentDataPage] objectForKey:ID] dataUsingEncoding:NSUTF8StringEncoding] name:IDTYPE];
                                                       [formData appendPartWithFormData:[repostMessage dataUsingEncoding:NSUTF8StringEncoding] name:MESSAGE];
                                                       [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:submit_type];
                                                       [formData appendPartWithFormData:[tagName dataUsingEncoding:NSUTF8StringEncoding] name:TAGS];
                                                       [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:FRIEND];
                                                       [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:MAKEFEED];
                                                   }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
//        NSLog(@"转发之后取得的结果：%@", resultDict);
        if ([(NSNumber *)[resultDict objectForKey:ERROR] intValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:@"转发成功~"];
            
            if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self dismissModalViewControllerAnimated:YES];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[resultDict objectForKey:MSG]];
            NSLog(@"转发错误！%@", resultDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好！"];
        NSLog(@"转发失败！%@", error);
    }];
    [operation start];
}

//test 需要在子controller中重载
//- (void):(NSString *)repostMessage toSpace:(NSString *)tagName
//{
//    NSLog(@"repostMessage:%@ and tagName:%@", repostMessage, tagName);
//}
- (NSString *)messageToBeRepost
{
    NSString *message = [[self.detailInfoList objectAtIndex:currentDataPage] objectForKey:MESSAGE];
    return message;
}

- (void)dismissNextBtn
{
    self.nextBtn.alpha = 0;
    hasDismissNextBtn = YES;
}

- (void)showNextBtn
{
    if (hasDismissNextBtn) {
        self.nextBtn.alpha = 1;
    }
}

- (void)dismissPrevBtn
{
    self.prevBtn.alpha = 0;
    hasDismissPrevBtn = YES;
}

- (void)showPrevBtn
{
    if (hasDismissPrevBtn) {
        self.prevBtn.alpha = 1;
    }
}

@end
