//
//  ZoneViewController.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ZoneViewController.h"
#import "TopView.h"
#import "ZoneCell.h"
#import "CellHeader.h"
#import "ZoneDetailViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
//#import "UIButton+WebCache.h"
#import "PostViewController.h"
#import "AddFriendsViewController.h"
#import "AddChildViewController.h"
#import "MyTabBarController.h"
#import "UIImage+fixOrientation.h"

#define ALL_DEFAULT_SAPCE_IMAGE_NUM 4

@interface ZoneViewController ()

@end

@implementation ZoneViewController
@synthesize isMyself, infoDict, memberArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isMyself = YES;
        _isOnlyShowMyZone = NO;
        offsetY = 0;
        isShowingThemeImage = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopView];
//    infoDict = [[NSMutableDictionary alloc] init];
    if (!_isOnlyShowMyZone) {//不只是显示空间列表时，即是我自己的空间时
        memberArray = [[NSMutableArray alloc] init];
//        [self showImagViewWhenDoNothingInTimes:5.0f];
    }
    if (self.userId || _isOnlyShowMyZone) {//别人的空间
        [self addBottomView];
        self._tableView.frame = (CGRect){.origin = self._tableView.frame.origin, .size.width = DEVICE_SIZE.width, .size.height = 477};
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    isCurrShowViewCon = YES;
    [self startCountTimeWhenDoNothingInTimes:5.0f];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    isCurrShowViewCon = NO;
    [self stopShowingTheThemeImage];
}

//定时器在viewwillappear、点击了self.kenView后、滑动结束后、下拉刷新数据完成后重新计数。在viewdisappear取消定时器
- (void)startCountTimeWhenDoNothingInTimes:(NSTimeInterval)timerInterval {
    if (isShowingThemeImage) {
        return;
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    isShowingThemeImage = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                   block:^(NSTimeInterval time) {
                                                       if (_tableView.contentOffset.y == offsetY) {
                                                           if (_kenView.alpha != 1.0f) {
                                                               [self showTheThemeImage];
                                                           }
                                                       } else {
                                                           offsetY = _tableView.contentOffset.y;
                                                       }
                                                   } repeats:YES];
}

//自己移动的主题图片，开始移动
- (void)showTheThemeImage {
    if (self.kenView) {
        [self.kenView removeFromSuperview];
        self.kenView = nil;
    }
    KenBurnsView *tmpView = [[KenBurnsView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    tmpView.delegate = self;
    tmpView.backgroundColor = bgColor();
    self.kenView = tmpView;
    tmpView.alpha = 0;
    MyTabBarController *con = (MyTabBarController*)myTabBarController;
    [con.view addSubview:_kenView];
    
#define timeHeight 100
    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, DEVICE_SIZE.height - timeHeight - 10, 300, timeHeight)];
    timeLbl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.textAlignment = UITextAlignmentCenter;
    timeLbl.font = [UIFont boldSystemFontOfSize:60.0f];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    timeLbl.text = [formatter stringFromDate:[NSDate date]];
    
    UIImage *spaceImg = [Common getImgFromUserDefaultForKey:SPACE_IMAGE];
    BOOL isLandScape;
    if (spaceImg.imageOrientation == UIImageOrientationUp || spaceImg.imageOrientation == UIImageOrientationDown) {
        isLandScape = YES;
    } else {
        isLandScape = NO;
        spaceImg = [spaceImg imageRotatedByDegrees:90];
    }
    [self.kenView animateWithImages:[NSArray arrayWithObjects:spaceImg, nil]
                 transitionDuration:15
                               loop:YES
                        isLandscape:isLandScape];
    [_kenView buildMyCustomViewOnTheImageView:timeLbl];
    
    [self.kenView whenTapped:^{
        [UIView animateWithDuration:1.f animations:^{
            self.kenView.alpha = 0;
        } completion:^(BOOL finished) {
            [self stopShowingTheThemeImage];
            [self startCountTimeWhenDoNothingInTimes:5.0f];
        }];
    }];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.kenView.alpha = 1.0f;
                     }];
}

//停止移动
- (void)stopShowingTheThemeImage {
    if (isShowingThemeImage == NO) {
        return;
    }
    isShowingThemeImage = NO;
    if (self.kenView) {
        [self.kenView removeFromSuperview];
        self.kenView = nil;
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self stopShowingTheThemeImage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startCountTimeWhenDoNothingInTimes:5.0f];
}

- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    int btnTag = _button.tag - kTagBottomButton;
    switch (btnTag) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"空间"];
    [topView rightLogo];
    [topView rightLine];
    [topView dropShadowWithOffset:CGSizeZero radius:0 color:bgColor() opacity:0 shadowFrame:CGRectZero];//因为有cellHeader，所以这里不用阴影
    [self.view addSubview:topView];
}

//更改主题
- (void)configureViews {
    for (id obj in [self.view subviews]) {
        if ([obj isKindOfClass:[TopView class]]) {
            TopView *topView = (TopView*)obj;
            [topView changeTheme];
        }
    }
    [self._tableView reloadData];
}

- (void)sendRequest:(id)sender {
//    [SVProgressHUD showWithStatus:@"加载中..."];
    if (currentPage == 1) {
        _tableView.pullTableIsRefreshing = YES;
    }
    NSString *url;// = $str(@"%@space.php?m_auth=%@&page=%d&uid=%@", BASE_URL, [MY_M_AUTH urlencode], currentPage, self.userId);
    if (!_userId) {//我自己的空间
        url = $str(@"%@space.php?m_auth=%@&page=%d&perpage=10", BASE_URL, [MY_M_AUTH urlencode], currentPage); 
    } else {//别人的空间
        url = $str(@"%@space.php?m_auth=%@&page=%d&perpage=10&uid=%@", BASE_URL, [MY_M_AUTH urlencode], currentPage, _userId);
    }
//    [self stopShowingTheThemeImage];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if (isCurrShowViewCon) {
            [self startCountTimeWhenDoNothingInTimes:5.0f];
        }
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
            [infoDict removeAllObjects];
            self.infoDict = nil;
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[[dict objectForKey:WEB_DATA] objectForKey:SPACE_LIST] count] <=0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
            return;
        }
 //        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        [self addTheInfoDict:[dict objectForKey:WEB_DATA]];
        [memberArray removeAllObjects];
        [memberArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:FAMILY_LIST]];
        [dataArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:SPACE_LIST]];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error%@",error);
        [self stopLoading:sender];
        if (isCurrShowViewCon) {
            [self startCountTimeWhenDoNothingInTimes:5.0f];
        }
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        currentPage--;//加载更多时，若网络不好，因为currentPage有加1了，所以重新请求时currentPage要减1才行
    }];
}

- (void)addTheInfoDict:(NSMutableDictionary*)_aDict {
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    [_aDict objectForKey:UID], @"uid",
    [_aDict objectForKey:NAME], @"name",
    [_aDict objectForKey:AVATAR], @"avatar",
    [_aDict objectForKey:BIRTHDAY], @"birthday",
    [_aDict objectForKey:FAMILY_FEEDS], @"feeds",
    [_aDict objectForKey:FAMILY_MEMBERS], @"fmembers", nil];
    self.infoDict = tmpDict;
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isOnlyShowMyZone) {
        return 1;
    } else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isOnlyShowMyZone) {
        return [dataArray count];
    }
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        int membersNum = [memberArray count];
        if (membersNum > 0) {
            if (membersNum % NUM_PER_ROW == 0) {
                return membersNum / NUM_PER_ROW;
            } else {
                return (membersNum / NUM_PER_ROW + 1) ;
            }
        } else {
            return 1;
        }
    } else {
        return [dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isOnlyShowMyZone) {
        return 120;
    }
    
    if (indexPath.section == 0) {
        return 380;
    } else if (indexPath.section == 1) {
        if ([memberArray count] > 0) {
            return 50;
        } else
            return 125;
    } else
        return 120;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isOnlyShowMyZone) {
        return nil;
    }
    if (section == 0 && !_isOnlyShowMyZone) {
        return nil;
    }
    CellHeader *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CellHeader" owner:self options:nil] objectAtIndex:0];
//    headerView.leftImgView = YES;
    headerView.leftImgView.frame = CGRectMake(10, 10, 119, 40);
    headerView.leftImgView.contentMode = UIViewContentModeBottom;
    NSString *leftImgStr = section == 1 ? @"families" : section == 2 ? @"space" : @"";
    
//    if (_isOnlyShowMyZone) {
//        leftImgStr = @"space";
//        [headerView.rightBtn addTarget:self action:@selector(addZoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    } else {
        if (section == 1) {
            [headerView.rightBtn addTarget:self action:@selector(addFamilyMemberBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        } else if (section == 2) {
            [headerView.rightBtn addTarget:self action:@selector(addZoneBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
//    }
    headerView.leftImgView.image = ThemeImage(leftImgStr);
    [headerView.rightBtn setImage:ThemeImage(@"space_add_more_a") forState:UIControlStateNormal];
    [headerView.rightBtn setImage:ThemeImage(@"space_add_more_b") forState:UIControlStateHighlighted];
    return headerView;
}

- (void)addFamilyMemberBtnPressed:(id)sender {
    AddFriendsViewController *con = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
    con.topViewType = notLoginOrSignIn;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)addZoneBtnPressed:(id)sender {
    AddChildViewController *con = [[AddChildViewController alloc] initWithNibName:@"AddChildViewController" bundle:nil];
    con.isAddAZone = YES;
    con.topViewType = notLoginOrSignIn;
    con.myHeadUrl = MY_HEAD_AVATAR_URL;
    con.myNameStr = MY_NAME;
    [self.navigationController pushViewController:con animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isOnlyShowMyZone) {
        return 0;
    }
    
    if (section == 0) {
        return 0;
    } else
        return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZoneCell *cell;
    static NSString *photoCellId = @"photoCellId";
    static NSString *memberCellId = @"memberCellId";
    static NSString *albumCellId = @"albumCellId";
    if (_isOnlyShowMyZone) {
        cell = [tableView dequeueReusableCellWithIdentifier:albumCellId];
    } else {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:photoCellId];
        } else if (indexPath.section == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:memberCellId];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:albumCellId];
        }
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZoneCell" owner:self options:nil];
        if (_isOnlyShowMyZone) {
            cell = [array objectAtIndex:2];
        } else
            cell = [array objectAtIndex:indexPath.section];
    }
    cell.indexSection = indexPath.section;
    cell.indexRow = indexPath.row;
    if (!_isOnlyShowMyZone) {
        if (indexPath.section == 0) {
            UIImage *spaceImg = [Common getImgFromUserDefaultForKey:SPACE_IMAGE];
//            CGRect rect = CGRectMake(0, 0, cell.photoImgView.frame.size.width, cell.photoImgView.frame.size.height);
//            spaceImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([spaceImg CGImage], rect) scale:1.0f orientation:UIImageOrientationUp];
            cell.photoImgView.image = spaceImg;
            
            NSString *infoStr = $str(@"%d个家人，%d个动态", [[infoDict objectForKey:FAMILY_MEMBERS] intValue], [[infoDict objectForKey:FAMILY_FEEDS] intValue]);
            cell.simpleInfoView.isFamilyList = NO;
            cell.simpleInfoView.isFromZone = YES;
            cell.simpleInfoView.userId = [infoDict objectForKey:UID];
            [cell.simpleInfoView.headBtn setVipStatusWithStr:emptystr([infoDict objectForKey:VIP_STATUS]) isSmallHead:YES];
            [cell.simpleInfoView initInfoWithHeadUrlStr:[infoDict objectForKey:AVATAR]
                                                nameStr:[infoDict objectForKey:NAME]
                                            noteNameStr:@""
                                                infoStr:infoStr
                                       andRightImgPoint:CGPointMake(225, 13)
                                               rightImg:@"cake.png"
                                               rightStr:[infoDict objectForKey:BIRTHDAY]];
        } else if (indexPath.section == 1) {
            cell.memberArray = self.memberArray;
            [cell initFamilyMemberHeadBtn];
        } else {
            [cell initData:[dataArray objectAtIndex:indexPath.row]];
        }
    } else
        [cell initData:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isOnlyShowMyZone) {//只显示空间
        [self pushToZoneDetailConWithIndexRow:indexPath.row isMyZone:NO];
    } else {
        if (indexPath.section == 0) {
            MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
            picker.allowsEditing = NO;
            [picker showImagePickerMenu:@"更换封面" buttonTitle:@"打开相机" destructiveTitle:nil sender:self.view otherTitle:@"随机更换", nil];
            
            int preNum = 3 + picker.ImagePickerMenu.destructiveButtonIndex;//3为destrutiveBtn、打开相册、本地图库3个按钮。没有destructiveButton的话，destructiveButtonIndex = -1
            [picker.ImagePickerMenu setHandler:^{
                int randomNum = arc4random() % ALL_DEFAULT_SAPCE_IMAGE_NUM;
                while (_lastRandomNum == randomNum) {//防止现在跟上一个随机数相同
                    _lastRandomNum = randomNum;
                    randomNum = arc4random() % ALL_DEFAULT_SAPCE_IMAGE_NUM;
                }
                _lastRandomNum = randomNum;
                UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:$str(@"default_space_%d", randomNum) ofType:@"jpg"]];
                [self saveImage:image];
            } forButtonAtIndex:preNum];
            
            
            MyTabBarController *tabBarCon = (MyTabBarController*)self.parentViewController;
            [picker.ImagePickerMenu showFromTabBar:tabBarCon.tabBar];
            return;
        }
        if (indexPath.section == 2) {
            [self pushToZoneDetailConWithIndexRow:indexPath.row isMyZone:YES];
        }
    }
}

- (void)pushToZoneDetailConWithIndexRow:(int)indexRow isMyZone:(BOOL)isMyZone {
    NSDictionary *aDict = [dataArray objectAtIndex:indexRow];
    
    if ([[aDict objectForKey:BLOG_NUM] intValue] == 0 && [[aDict objectForKey:PHOTO_NUM] intValue] == 0 && [[aDict objectForKey:EVENT_NUM] intValue] == 0 && [[aDict objectForKey:VIDEO_NUM] intValue] == 0) {
        if (isMyZone) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"空间内容为空" message:@"给这个空间发个图片吧?"];
            [alert setCancelButtonWithTitle:@"取消" handler:^{
                return ;
            }];
            [alert addButtonWithTitle:@"确定" handler:^{
                PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
                nav.navigationBarHidden = YES;
                [self presentModalViewController:nav animated:YES];
                [con.downPostView.albumBtn setTitle:[aDict objectForKey:TAG_NAME] forState:UIControlStateNormal];
                [con.downPostView.albumBtn setTitle:[aDict objectForKey:TAG_NAME] forState:UIControlStateHighlighted];
            }];
            [alert show];
        } else {
            [SVProgressHUD showErrorWithStatus:@"空间内容为空T_T"];
        }
        return;
    }
    
//    ZoneDetailViewController *con = [[ZoneDetailViewController alloc] initWithNibName:@"ZoneDetailViewController" bundle:nil];
    FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
    con.hidesBottomBarWhenPushed = YES;
    con.tagId = [aDict objectForKey:TAG_ID];
    con.userId = [aDict objectForKey:UID];
    con.isFromZone = YES;
    [self.navigationController pushViewController:con animated:YES];
}

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
}

- (void)saveImage:(UIImage*)_image {
    [Common saveImage:_image withQuality:1.0f saveKey:SPACE_IMAGE];
    [_tableView reloadData];
//    NSData *data = UIImagePNGRepresentation(_image);
//    UIImage *tempImage = [UIImage imageWithData:data];
//    UIImage *fixedOrientationImage = [UIImage imageWithCGImage:tempImage.CGImage
//                                                         scale:_image.scale
//                                                   orientation:_image.imageOrientation];
//    initialImage = fixedOrientationImage;
    
//    NSData *spaceImgData = UIImageJPEGRepresentation(_image, 1.0);
//    NSData *encodeSpaceImgData = [NSKeyedArchiver archivedDataWithRootObject:spaceImgData];
//    [ConciseKit setUserDefaultsWithObject:encodeSpaceImgData forKey:SPACE_IMAGE];
}

#pragma mark cell action

#pragma KenBurnsViewDelegate
- (void)didShowImageAtIndex:(NSUInteger)index {
//    NSLog(@"Finished image: %d", index);
}

- (void)didFinishAllAnimations {
//    NSLog(@"Yay all done!");
}


@end
