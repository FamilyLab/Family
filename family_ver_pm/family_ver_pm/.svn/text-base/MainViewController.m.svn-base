//
//  MainViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-3-18.
//  Copyright (c) 2013年 pandara. All rights reserved.

#import "MainViewController.h"
#import "PictureViewController.h"
#import "MainCell.h"
#import "DailyViewController.h"
#import "ActivityViewController.h"
#import "VideoViewController.h"
#import "SpaceViewController.h"
#import "LoadingView.h"
#import "SVProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SBKeycahin.h"
#import "JSONKit.h"
#import "SBToolKit.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        // Custom initialization
        self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MAIN_PAGE_HEAD_SIZE.height, DEVICE_SIZE.width, DEVICE_SIZE.height - MAIN_PAGE_HEAD_SIZE.height)];
        self.mainTableView.dataSource = self;
        self.mainTableView.delegate = self;
        self.mainTableView.showsHorizontalScrollIndicator = NO;
        self.mainTableView.showsVerticalScrollIndicator = NO;
        self.mainTableView.backgroundColor = color(232, 232, 232, 1);
        self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.viewControllName = [NSArray arrayWithObjects:@"PictureViewController", @"DailyViewController", @"ActivityViewController", @"VideoViewController", @"DialogueListViewController", @"SpaceViewController", @"FeedFamilyViewController", @"MySettingViewController", @"MyIssueViewController", nil];
        [self.view addSubview:self.mainTableView];
        
        //self.feedCountDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:0, ADDVIDEO, 0, ADDEVENT, 0, ADDBLOG, 0, ADDPHOTO, 0, PMCOUNT, 0, APPLYCOUNT, 0, NOTECOUNT, nil];
        self.feedCountDict = nil;
        
        //获取动态计数
        [self requestFeedCount];
    }
    return self;
}

- (void)requestFeedCount
{
//    [SVProgressHUD show];
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
//    NSMutableString *authName = [NSMutableString stringWithString:userName];
//    [authName appendString:KEY_AUTH];
//    NSString *m_auth = [SBKeycahin getPassWordForName:authName];
    NSString *m_auth = [SBToolKit getMAuth];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:FEED_COUNT_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:ELDER, DO, m_auth, M_AUTH, nil]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"sent %lld of %lld in getting feed count", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [(NSData *)responseObject objectFromJSONData];
        int errorNo = [(NSNumber *)[resultDict objectForKey:ERROR] intValue];
        
        if (errorNo == 0) {
            NSDictionary *data = [resultDict objectForKey:DATA];
//            [self.feedCountDict setObject:(NSNumber *)[data objectForKey:ADDVIDEO] forKey:ADDVIDEO];
            self.feedCountDict = [NSMutableDictionary dictionaryWithDictionary:data];
            
            NSLog(@"getting feed count successfully with request:%@", request);
            [self.mainTableView reloadData];
//            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:@" "];
        } else {
            NSLog(@"error occur when getting feed count %@", resultDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getting feed count operation failure %@", error);
//        [SVProgressHUD showErrorWithStatus:@"网络不好！"];
    }];
    [operation start];
}

- (void)reflesh
{
    [self requestFeedCount];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //注册通知，返回主界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToMainViewController) name:NOTIFI_POP_TO_MAINVIEW object:nil];
    //注册通知，提供family apply count
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnFamilyFeedCount) name:NOTIFI_REQUEST_FAMILYAPPLY_COUNT object:nil];
    
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(WEATHER_VIEW_ORIGIN.x, WEATHER_VIEW_ORIGIN.y, WEATHER_VIEW_SIZE.width, WEATHER_VIEW_SIZE.height)];
    self.weatherView.delegate = self;
    [self.view addSubview:self.weatherView];
}

- (void)returnFamilyFeedCount
{
    int feedCount = [[self.feedCountDict objectForKey:APPLYCOUNT] intValue];
    NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", feedCount] forKey:@"familyapplycount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_RETURN_FAMILYAPPLY_COUNT object:nil userInfo:userInfoDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回MainViewController
- (void)popToMainViewController
{
    [self.navigationController popToViewController:self animated:YES];
    [self.mainTableView reloadData];
    [self requestFeedCount];
}

#pragma mark UITableViewDelegate UITableDataSource
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAIN_CELL_COUNT;
}

//选中某cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainCell *selectedCell = (MainCell *)[tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelectedStyle:indexPath];
    
    NSString *className = [self.viewControllName objectAtIndex:indexPath.row];
    if ([className isEqualToString:@"none"]) {
        return;
    }
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:[self.viewControllName objectAtIndex:indexPath.row] bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
//    switch (indexPath.row) {
//        case 0://图片
//        {
//            PictureViewController *pictureViewControl = [[PictureViewController alloc] initWithNibName:@"PictureViewController" bundle:nil];
//            pictureViewControl.delegate = self;
////            UIViewController *viewController = [[UIViewController alloc] initWithNibName:@"PictureViewController" bundle:nil];
////            [self.navigationController pushViewController:viewController animated:YES];
//            [self.navigationController pushViewController:pictureViewControl animated:YES];
//            break;
//        }
//        case 1:
//        {
//            DailyViewController *dailyViewControl = [[DailyViewController alloc] initWithNibName:@"DailyViewController" bundle:nil];
//            dailyViewControl.delegate = self;
//            [self.navigationController pushViewController:dailyViewControl animated:YES];
//            break;
//        }
//        case 2:
//        {
//            ActivityViewController *activityViewController = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
//            activityViewController.delegate = self;
//            [self.navigationController pushViewController:activityViewController animated:YES];
//            break;
//        }
//        case 3:
//        {
//            VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
//            videoViewController.delegate = self;
//            [self.navigationController pushViewController:videoViewController animated:YES];
//            break;
//        }
//        case 4:
//        {
//            break;
//        }
//        case 5:
//        {
//            SpaceViewController *spaceViewController = [[SpaceViewController alloc] initWithNibName:@"SpaceViewController" bundle:nil];
//            spaceViewController.delegate = self;
//            [self.navigationController pushViewController:spaceViewController animated:YES];
//            break;
//        }
//        case 6:
//        {
//            break;
//        }
//        case 7:
//        {
//            break;
//        }
//        case 8:
//        {
//            break;
//        }
//        default:
//            break;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainCell *cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier:MAIN_CELL_ID];

    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
        [cell configCellStyle];
    }
    [cell configCellApparence:indexPath];
    
    if (indexPath.row > 6) {
        return cell;
    }
    
    NSArray *cellNameArray = [[NSArray alloc] initWithObjects:ADDPHOTO, ADDBLOG, ADDEVENT, ADDVIDEO, PMCOUNT, @"foobar", APPLYCOUNT, nil];
    int feedCount = [(NSNumber *)[self.feedCountDict objectForKey:[cellNameArray objectAtIndex:indexPath.row]] intValue];
//    NSLog(@"%@ with index.row(%d) : %d", [cellNameArray objectAtIndex:indexPath.row], indexPath.row, feedCount);
    if (feedCount != 0) {
        cell.feedCount.alpha = 1;
        cell.feedCount.text = [NSString stringWithFormat:@"%d", feedCount];
    }
    
    return cell;
}

//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 8) {
        return 80;
    }
    return 70;
}

@end







