//
//  FeedViewController.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "FeedViewController.h"
#import "TopView.h"
#import "ImageAndLabelView.h"
#import "BigImgCell.h"
#import "SomeImgsCell.h"
#import "ImgAndTextCell.h"
#import "OnlyTextCell.h"
#import "LocationCell.h"
#import "OtherHasImgCell.h"
#import "OtherNoImgCell.h"
#import "FeedDetailViewController.h"
#import "MyHttpClient.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "ZoneDetailViewController.h"
#import "FamilyCardViewController.h"
#import "MyTabBarController.h"
#import "DDAlertPrompt.h"
#import "JMImageCache.h"
//#import "PostViewController.h"
#import "PostSthViewController.h"
#import "MPNotificationView.h"
#import "YIPopupTextView.h"
#import "TopicView.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
//@synthesize tmpBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        canRefreshCountNum = YES;
        _isForMyLoveFeed = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = DEVICE_BOUNDS;
    [self addTopView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentForNotification:) name:REFRESH_FEED_LIST object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LOVE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoveNumForNotification:) name:REFRESH_FEED_LOVE_NUM object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LIST_FOR_DELETE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListForDelete:) name:REFRESH_FEED_LIST_FOR_DELETE object:nil];
    
    [self addBottomView];
    
    _loveArray = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LIST object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LOVE_NUM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_FEED_LIST_FOR_DELETE object:nil];
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
    NSString *tipStr = _isForMyLoveFeed ? @"收藏" : @"动态";
    [topView leftText:tipStr];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

//- (IBAction)tmpBtnPressed:(id)sender {
//    NSString *themeStr = [currentTheme isEqualToString:AUTUMN_THEME] ? DEFAULT_THEME : AUTUMN_THEME;
//    [[ThemeManager sharedThemeManager] setTheme:themeStr];
//}

//更改主题
- (void)configureViews {
    for (id obj in [self.view subviews]) {
        if ([obj isKindOfClass:[TopView class]]) {
            TopView *topView = (TopView*)obj;
            [topView changeTheme];
        }
    }
    [self fillMultiType];
    [self._tableView reloadData];
}

- (void)addBottomView {
    _tableView.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = _tableView.frame.size.width, .size.height = DEVICE_SIZE.height - 50};
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", nil];
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:nil
                                       andBackgroundImage:@"login_bg"];
    aView.delegate = self;
    
    UIButton *loveBtn = (UIButton*)[aView viewWithTag:kTagBottomButton + 2];
    [loveBtn setImage:[UIImage imageNamed:@"feed_detail_love_b"] forState:UIControlStateHighlighted];
    [loveBtn setImage:[UIImage imageNamed:@"feed_detail_love_b"] forState:UIControlStateSelected];
    
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
        default:
            break;
    }
}

- (void)uploadREquestToGetNewFeedNum {
    NSString *url = $str(@"%@space.php?do=feednew&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        MyTabBarController *myTab = (MyTabBarController*)myTabBarController;
        [myTab setBadgeNumWithBtnTag:0 andBadgeNum:emptystr([[dict objectForKey:DATA] objectForKey:NEW_FEED_NUM])];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
    }];
}

- (void)sendRequest:(id)sender {
    [self uploadREquestToGetNewFeedNum];
    if (canRefreshCountNum && !_isForMyLoveFeed) {
        [self performBlock:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MESSAGE_NUM object:REFRESH_COUNT_NUM];//调用统计接口
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_FAMILY_AND_ZONE_LIST object:nil];//预加载发表界面的空间列表和家人列表接口
            canRefreshCountNum = NO;
        } afterDelay:0.3f];//延迟0.3s防止卡顿
    }
    
    if (currentPage == 1) {
        _tableView.pullTableIsRefreshing = YES;
    }
    NSString *url = @"";
    if (_isForMyLoveFeed) {//我收藏的
        url = $str(@"%@space.php?do=lovefeed&m_auth=%@&page=%d&perpage=%d", BASE_URL, [MY_M_AUTH urlencode], currentPage, 15);
    } else {//首页的动态
        url = $str(@"%@space.php?do=home&m_auth=%@&page=%d&perpage=%d", BASE_URL, [MY_M_AUTH urlencode], currentPage, 15);
    }
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            [_tableView reloadData];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:WEB_DATA] count] <=0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
        }
        
        [dataArray addObjectsFromArray:[dict objectForKey:WEB_DATA]];
        UIImageView *noneFeedImgView = (UIImageView*)[self.view viewWithTag:kTagNoneFeed];
        if ([dataArray count] > 3) {
            if (noneFeedImgView) {
                [noneFeedImgView removeFromSuperview];
                noneFeedImgView = nil;
            }
        } else {
            if (!noneFeedImgView && !_isForMyLoveFeed) {
                UIImage *noneFeedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"none_feed" ofType:@"png"]];
                noneFeedImgView = [[UIImageView alloc] initWithImage:noneFeedImage];
                noneFeedImgView.tag = kTagNoneFeed;
                noneFeedImgView.center = self.view.center;
                noneFeedImgView.frame = (CGRect){.origin.x = noneFeedImgView.frame.origin.x + 20, .origin.y = DEVICE_SIZE.height - noneFeedImage.size.height - 50 - 5, .size = noneFeedImgView.frame.size};//50为customTabBar的高度
                [self.view addSubview:noneFeedImgView];
            }
        }
        [self fillMultiType];
        [_tableView reloadData];
        
//        if (!_isForMyLoveFeed) {
//            [self performBlock:^(id sender) {
//                TopicView *aView = [[[NSBundle mainBundle] loadNibNamed:@"TopicView" owner:self options:nil] objectAtIndex:0];
//                MyTabBarController *tabBarCon = (MyTabBarController*)myTabBarController;
//                [tabBarCon.view addSubview:aView];
//                [aView sendRequest:nil];
//            } afterDelay:0.3f];
//        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
        currentPage--;
    }];
}

//- (void)sendRequestForMyLoveFeed:(id)sender {
//    
//}

- (NSString*)buildAllText:(int)index {
//    NSDictionary *aDict = [dataArray objectAtIndex:index];
//    NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:aDict];
    NSMutableDictionary *feedDict = [dataArray objectAtIndex:index];
    NSString *allText = @"";
    NSString *subjectStr = [self buildSubjectText:index];
    if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
        if ([feedDict objectForKey:COMMENT]) {
            NSDictionary *commentDict = [[feedDict objectForKey:COMMENT] objectAtIndex:0];
            NSString *otherStr = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? @"参与了" : @"评论了";
            allText = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", emptystr([commentDict objectForKey:COMMENT_AUTHOR_NAME]), otherStr, emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
        }
    } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
        allText = [NSString stringWithFormat:@"%@ 和 %@ 成为了一家人", [feedDict objectForKey:NAME], [feedDict objectForKey:F_NAME]];
    } else {//其他，如 xxx说了句xxx等
        allText = [NSString stringWithFormat:@"%@ %@ %@", emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
    }
    return allText;
}

- (NSString*)buildSubjectText:(int)index {
    NSMutableDictionary *feedDict = [dataArray objectAtIndex:index];
    NSString *subjectStr = @"";
    if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
        if ([feedDict objectForKey:COMMENT]) {
            NSString *key = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? SUBJECT : MESSAGE;
            subjectStr = [emptystr([feedDict objectForKey:key]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:key];
            if (subjectStr.length > 12) {
                subjectStr = [subjectStr substringToIndex:12];
                subjectStr = $str(@"%@...", subjectStr);
            }
        }
    } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
        subjectStr = @"";
    } else {//其他，如 xxx说了句xxx，更新了资料，更新了头像，创建了家等。其中只有 xxx说了句xxx有message
        subjectStr = ([emptystr([feedDict objectForKey:MESSAGE]) isEqualToString:@""] && [[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:@"isayid"]) ? @"无标题" : [feedDict objectForKey:MESSAGE];
    }
    return subjectStr;
}

- (void)fillMultiType {
    for (int i = 0; i < [dataArray count]; i++) {
        NSDictionary *aDict = [dataArray objectAtIndex:i];
        FeedCellType type = [FeedViewController whichType:aDict];
        if (type == otherHasImgType || type == otherNoImgType) {
            NSString *allText = [self buildAllText:i];
            NSString *subjectStr = [self buildSubjectText:i];
            NSMutableDictionary *feedDict = [[NSMutableDictionary alloc] initWithDictionary:aDict];
//            NSString *allText = @"";
//            NSString *subjectStr = @"";
            NSMutableArray *namesArray = [[NSMutableArray alloc] init];
            NSMutableArray *otherArray = [[NSMutableArray alloc] init];
            if ([[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0) {//评论的行为动态
                if ([feedDict objectForKey:COMMENT]) {
//                    subjectStr = [emptystr([feedDict objectForKey:SUBJECT]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:SUBJECT];
                    NSDictionary *commentDict = [[feedDict objectForKey:COMMENT] objectAtIndex:0];
                    NSString *otherStr = [[feedDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0 ? @"参与了" : @"评论了";//活动的要改为“参与了”
//                    allText = [NSString stringWithFormat:@"%@ %@ %@%@ %@", emptystr([commentDict objectForKey:COMMENT_AUTHOR_NAME]), otherStr, emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
                    if (!isEmptyStr([commentDict objectForKey:COMMENT_AUTHOR_NAME])) {
                        [namesArray addObject:[commentDict objectForKey:COMMENT_AUTHOR_NAME]];
                    }
                    if (!isEmptyStr([feedDict objectForKey:NAME])) {
                        [namesArray addObject:[feedDict objectForKey:NAME]];
                    }
                    [otherArray addObject:otherStr];
                    if (!isEmptyStr([feedDict objectForKey:TITLE])) {
                        [otherArray addObject:[feedDict objectForKey:TITLE]];
                    }
                }
            } else if ([[feedDict objectForKey:FEED_ID_TYPE] isEqualToString:FRIEND]) {//AA和BB成为了一家人
//                allText = [NSString stringWithFormat:@"%@ 和 %@ 成为了一家人", [feedDict objectForKey:NAME], [feedDict objectForKey:F_NAME]];
                if (!isEmptyStr([feedDict objectForKey:NAME])) {
                    [namesArray addObject:[feedDict objectForKey:NAME]];
                }
                if (!isEmptyStr([feedDict objectForKey:F_NAME])) {
                    [namesArray addObject:[feedDict objectForKey:F_NAME]];
                }
                [otherArray addObject:@"和"];
                [otherArray addObject:@"成为了一家人"];
            } else {
//                subjectStr = [emptystr([feedDict objectForKey:MESSAGE]) isEqualToString:@""] ? @"无标题" : [feedDict objectForKey:MESSAGE];
//                allText = [NSString stringWithFormat:@"%@ %@ %@", emptystr([feedDict objectForKey:NAME]), emptystr([feedDict objectForKey:TITLE]), subjectStr];
                if (!isEmptyStr([feedDict objectForKey:NAME])) {
                    [namesArray addObject:[feedDict objectForKey:NAME]];
                }
                if (!isEmptyStr([feedDict objectForKey:F_NAME])) {
                    [namesArray addObject:[feedDict objectForKey:F_NAME]];
                }
                if (!isEmptyStr([feedDict objectForKey:TITLE])) {
                    [otherArray addObject:[feedDict objectForKey:TITLE]];
                }
            }
            [feedDict setObject:[self fillMultiTypeWithStr:namesArray inText:allText withColor:[Common theLblColor] withSize:14.0f isBold:YES msgStr:subjectStr otherStr:otherArray] forKey:MULTI_TYPE_TEXT];
            [dataArray replaceObjectAtIndex:i withObject:feedDict];
        }
    }
}

//名字根据主题变色，msgStr为红色，otherStr为默认灰色
- (NSMutableAttributedString*)fillMultiTypeWithStr:(NSMutableArray*)nameArray inText:(NSString*)aText withColor:(UIColor*)aColor withSize:(CGFloat)aSize isBold:(BOOL)isBold msgStr:(NSString*)msgStr otherStr:(NSMutableArray*)otherStrArray {
    /**(1)** Build the NSAttributedString *******/
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:aText];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    CGFloat theSize = aSize ? aSize : 15.0f;
    BOOL theBold = isBold ? isBold : YES;
    
    NSString *tmpStr = aText;//若前后的名字有相同的，防止只匹配到前面，而后面的就不匹配到了。解决方法是每一个名字变色后，都把该名字从aText里去掉（用tmpStr保存）,记得range需要变化
    NSRange preRange = NSMakeRange(0, 0);
    NSRange currRange;
    for (int i = 0; i < [nameArray count]; i++) {
        NSRange theRange = [tmpStr rangeOfString:[nameArray objectAtIndex:i]];
        currRange = theRange;//
        theRange.location += preRange.length;//
        preRange = theRange;//
        UIColor *theColor = aColor ? aColor : [Common theLblColor];
        [attrStr setTextColor:theColor range:theRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:theRange];
        tmpStr = [tmpStr stringByReplacingCharactersInRange:currRange withString:@""];//currRange
    }
    
    //不需要变色的文字
    for (int i = 0; i < [otherStrArray count]; i++) {
        NSRange otherRange = [aText rangeOfString:[otherStrArray objectAtIndex:i]];
        [attrStr setTextColor:[UIColor lightGrayColor] range:otherRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:otherRange];
    }
//    NSString *otherStr = [aText stringByReplacingOccurrencesOfString:aStr withString:@""];
//    NSMutableAttributedString *otherAttrStr = [NSMutableAttributedString attributedStringWithString:otherStr];
//    NSRange otherRange = [aText rangeOfString:otherStr];
//    [attrStr setTextColor:[UIColor darkGrayColor] range:otherRange];
//    [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:otherRange];

    //红色
    if (!isEmptyStr(msgStr)) {
        NSRange theRange = [aText rangeOfString:msgStr];
        UIColor *theColor = color(229, 113, 116, 1);
        [attrStr setTextColor:theColor range:theRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:theRange];
    }
    
    /**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
//    self.contentLbl.attributedText = attrStr;
//    self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    self.contentLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
    [attrStr release];
#endif
    return attrStr;
}

- (void)buildLoveArrayWithIndex:(int)index {
    [_loveArray removeAllObjects];
    NSDictionary *aDict = [dataArray objectAtIndex:index];
    for (int i = 0; i < [[aDict objectForKey:LOVE_USER] count]; i++) {
        [_loveArray addObject:[[[aDict objectForKey:LOVE_USER] objectAtIndex:i] objectForKey:NAME]];
    }
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCellType type = [FeedViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    if (type == otherHasImgType) {
//        return 85;
        NSString *allText = [self buildAllText:indexPath.row];
        return [FeedCell heightForCellWithText:allText andOtherHeight:65 andLblMaxWidth:192];
    }
    if (type == otherNoImgType) {
        NSString *allText = [self buildAllText:indexPath.row];
        return [FeedCell heightForCellWithText:allText andOtherHeight:65 andLblMaxWidth:235];
    }
    CGFloat noCommentHeight = 0;
    switch (type) {
        case bigImgType:
            noCommentHeight = 360;
            break;
        case someImgsType:
            noCommentHeight = 230;
            break;
        case imgAndTextType:
            noCommentHeight = 280;//225;
            break;
        case onlyTextType:
            noCommentHeight = 126;//160;
            break;
        case locationType:
            noCommentHeight = 285;//225;
            break;
        default:
            break;
    }
    NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
//    NSLog(@"msg:%@", emptystr([aDict objectForKey:MESSAGE]));
    if (type == bigImgType || type == someImgsType || type == onlyTextType) {
        NSString *keyStr = type == bigImgType ? OLD_SUBJECT : OLD_MESSAGE;
        CGFloat preContentH = [FeedCell heightForCellWithText:emptystr([aDict objectForKey:keyStr]) andOtherHeight:0 andLblMaxWidth:265 andFont:nil];
        noCommentHeight += preContentH;
//        if (type == someImgsType || type == onlyTextType) {
            CGFloat describeH = [FeedCell heightForCellWithText:emptystr([aDict objectForKey:MESSAGE])andOtherHeight:10 andLblMaxWidth:280 andFont:[UIFont systemFontOfSize:14.0f]];
            noCommentHeight += describeH;
//        }
    } else if (type == imgAndTextType) {
        if ([[aDict objectForKey:FEED_ID_TYPE] isEqualToString:@"reblogid"]) {
            CGFloat describeH = [FeedCell heightForCellWithText:emptystr([aDict objectForKey:MESSAGE]) andOtherHeight:0 andLblMaxWidth:280 andFont:nil];
            noCommentHeight += describeH;
        }
    } else if (type == locationType) {
        if ([emptystr([aDict objectForKey:FEED_IMAGE_1]) isEqualToString:@""]) {//无图片
            CGFloat describeH = [FeedCell heightForCellWithText:emptystr([aDict objectForKey:EVENT_DETAIL]) andOtherHeight:-10 andLblMaxWidth:283 andFont:[UIFont systemFontOfSize:14.0f]];
            describeH = describeH > 68 ? 68 : describeH;
            noCommentHeight = 285 - 68 + describeH;
        }
    }
    [self buildLoveArrayWithIndex:indexPath.row];
//    loveArray = [NSMutableArray arrayWithObjects:@"林子文", @"曾宝仪", @"杨峰", @"朱涛", @"郑小新", @"吴盛潮", @"Aevit", @"vitwei", @"temmu", @"干露露", @"李连杰", @"黄飞鸿", nil];
#warning 接口里，转载的帖子的replynum一直为0
    int theCommentNum = fmaxf([[aDict objectForKey:FEED_REPLY_NUM] intValue], [[aDict objectForKey:COMMENT] count]);
    if ([_loveArray count] == 0 && theCommentNum == 0) {
        return noCommentHeight;
    }
    
    NSString *contentStr = @"";
    if ([_loveArray count] > 0) {
        contentStr = [_loveArray objectAtIndex:0];
        for (int i = 1; i < [_loveArray count]; i++) {
            contentStr = $str(@"%@，%@", contentStr, [_loveArray objectAtIndex:i]);
        }
    }
//FUCK_NUM_0、FUCK_NUM_1、FUCK_NUM_2（FUCK_NUM_1和FUCK_NUM_2的值一样）都改为0，再将评论的背景图片_commentBgImgView改为：@"feed_comment_bg_v12.png"(@"feed_comment_bg_short_v12.png"的为短的)，就可以让评论的那背景框宽度为300。
//#define FUCK_NUM_2  33
    CGFloat loverH = [_loveArray count] == 0 ? 0 : [FeedCell heightForCellWithText:contentStr andOtherHeight:20 andLblMaxWidth:LOVE_MAX_WIDTH - FUCK_NUM_1 andFont:[UIFont systemFontOfSize:14.0f]];
        
    CGFloat commentH = 0;
    for (int i = 0; i < [[aDict objectForKey:COMMENT] count]; i++) {
        contentStr = [[[aDict objectForKey:COMMENT] objectAtIndex:i] objectForKey:MESSAGE];
        commentH += [FeedCell heightForCellWithText:contentStr andOtherHeight:20 andLblMaxWidth:COMMENT_MAX_WIDTH - FUCK_NUM_1 andFont:[UIFont systemFontOfSize:14.0f]];
    }
    if (theCommentNum > 2) {
        commentH += 25;//25为下面的“共x条”评论的label高度
    }
    if (theCommentNum > 0 || [_loveArray count] > 0) {
        commentH += 10;//10为背景图片上面的那个箭头高度
    }
    return noCommentHeight + loverH + commentH;
//    int theCommentNum = [[[dataArray objectAtIndex:indexPath.row] objectForKey:COMMENT] count];
//    int theCommentNum = fminf(2, [[[dataArray objectAtIndex:indexPath.row] objectForKey:FEED_REPLY_NUM] intValue]);//取两者中最小值
//    theCommentNum = theCommentNum == 0 ? 1 : theCommentNum;//没有评论时加”给你的家人评论一下吧～“这一句
//    CGFloat h = noCommentHeight + 55 * theCommentNum;
    
//    CGFloat h = theCommentNum == 0 ? (noCommentHeight + kNoCommentHeight) : (noCommentHeight + 55 * theCommentNum);
//    if (theCommentNum >= 2) {
//        h += 5;
//    }
//    return h + 13;
}

+ (FeedCellType)whichType:(NSDictionary*)dict {
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
            return imgAndTextType;//图文、...
    } else if ([idType rangeOfString:FEED_EVENT_ID].location != NSNotFound) {//@"eventid"或"reeventid"
        return locationType;
    } else if ([[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {//idtype里除了照片、日记、视频、活动及其转采的
        return otherNoImgType;//右边没有图片
    } else
        return otherHasImgType;//右边有图片
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell;
    static NSString *bigImgCellId = @"bigImgCellId";
    static NSString *someImgsCellId = @"someImgsCellId";
    static NSString *imgAndTextCellId = @"imgAndTextCellId";
    static NSString *onlyTextCellId = @"onlyTextCellId";
    static NSString *locationCellId = @"locationCellId";
    static NSString *otherHasImgCellId = @"otherHasImgCellId";
    static NSString *otherNoImgCellId = @"otherNoImgCellId";
    FeedCellType type = [FeedViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    switch (type) {
        case bigImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:bigImgCellId];
            break;
        case someImgsType:
            cell = [tableView dequeueReusableCellWithIdentifier:someImgsCellId];
            break;
        case imgAndTextType:
            cell = [tableView dequeueReusableCellWithIdentifier:imgAndTextCellId];
            break;
        case onlyTextType:
            cell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellId];
            break;
        case locationType:
            cell = [tableView dequeueReusableCellWithIdentifier:locationCellId];
            break;
        case otherHasImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:otherHasImgCellId];
            break;
        case otherNoImgType:
            cell = [tableView dequeueReusableCellWithIdentifier:otherNoImgCellId];
            break;
        default:
            break;
    }
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FeedCell" owner:self options:nil];
		cell = [array objectAtIndex:type];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.cellType = type;
    NSString *idType = [[dataArray objectAtIndex:indexPath.row] objectForKey:FEED_ID_TYPE];
    if ([idType hasPrefix:@"re"]) {
        cell.isRepost = YES;
    } else
        cell.isRepost = NO;
    cell.indexRow = indexPath.row;
    cell.authorUserId = [[dataArray objectAtIndex:indexPath.row] objectForKey:UID];
    
    if (type == otherNoImgType || type == otherHasImgType) {//行为动态的
        cell.allText = [self buildAllText:indexPath.row];
        cell.subjectStr = [self buildSubjectText:indexPath.row];
    } else {//非行为动态
#warning 记得填上loveuser这个字段的数组
        [self buildLoveArrayWithIndex:indexPath.row];
        cell.loveArray = self.loveArray;
//        cell.loveArray = [NSMutableArray arrayWithObjects:@"林子文", @"曾宝仪", @"杨峰", @"朱涛", @"郑小新", @"吴盛潮", @"Aevit", @"vitwei", @"temmu", @"干露露", @"李连杰", @"黄飞鸿", nil];
        [cell initCommonData:[dataArray objectAtIndex:indexPath.row]];//公共部分
        //转采
        [cell.albumView.repostBtn whenTapped:^{
            NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
            if ([[dict objectForKey:UID] isEqualToString:MY_UID]) {
                [SVProgressHUD showErrorWithStatus:@"不能转载自己的东西T_T"];
                return;
            }
            NSDictionary *tmpDict = [dataArray objectAtIndex:indexPath.row];
            if ([[tmpDict objectForKey:FEED_ID_TYPE] rangeOfString:@"event"].length > 0) {
                [SVProgressHUD showErrorWithStatus:@"活动不能转载T_T"];
            } else if ([[tmpDict objectForKey:FEED_ID_TYPE] rangeOfString:@"video"].length > 0) {
                [SVProgressHUD showErrorWithStatus:@"视频不能转载T_T"];
            } else {
                PostSthViewController *con = [[PostSthViewController alloc] initWithNibName:@"PostSthViewController" bundle:nil];
                con.shouldAddDefaultImage = YES;
//                PostViewController *con = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
                con.dataDict = (NSMutableDictionary*)dict;
                con.idType = [dict objectForKey:FEED_ID_TYPE];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
                nav.navigationBarHidden = YES;
                [self presentModalViewController:nav animated:YES];
            }
        }];
        //收藏
//        __block FeedCell *blockCell = cell;
        [cell.albumView.likeitBtn whenTapped:^{
            [self loveThisWithIndex:indexPath.row andCell:cell];
        }];
        //评论
        [cell.albumView.commentBtn whenTapped:^{
            MyYIPopupTextView *popupTextView = [[MyYIPopupTextView alloc] initWithMaxCount:0];
            popupTextView.delegate = self;
            [popupTextView showInView:self.view];
            [popupTextView.acceptButton whenTapped:^{
                if ([[[dataArray objectAtIndex:indexPath.row] objectForKey:FEED_ID_TYPE] isEqualToString:FEED_EVENT_ID]) {
                    popupTextView.text = @"参与了活动";
                } else {
                    if (popupTextView.text.length == 0) {
                        [SVProgressHUD showErrorWithStatus:@"评论内容太短T_T"];
                        return ;
                    }
                }
                NSMutableDictionary *currDict = [dataArray objectAtIndex:indexPath.row];
                NSString *commentIdType = [currDict objectForKey:FEED_ID_TYPE];
                commentIdType = [commentIdType stringByReplacingOccurrencesOfString:@"re" withString:@""];
                NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[currDict objectForKey:F_ID], ID, commentIdType, FEED_ID_TYPE, popupTextView.text, MESSAGE, MY_M_AUTH, M_AUTH, nil];
                [self uploadRequestToComment:para withMsg:popupTextView.text andIndexRow:indexPath.row];
                [popupTextView dismiss];
            }];
        }];
    }
    if (!cell.picArray) {
        cell.picArray = [[NSMutableArray alloc] init];
    }
    [cell.picArray removeAllObjects];
    NSDictionary *theDict = [dataArray objectAtIndex:indexPath.row];
    for (int i = 0; i < 4; i++) {
        NSString *currImgKey = $str(@"image_%d", i + 1);
        if ([theDict objectForKey:currImgKey] && ![[theDict objectForKey:currImgKey] isEqualToString:@""]) {
            [cell.picArray addObject:[theDict objectForKey:currImgKey]];
        }
    }
    [cell initData:theDict];//由具体的子类去实现
    return cell;
}

- (void)loveThisWithIndex:(int)indexRow andCell:(FeedCell*)cell {
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexRow]];
    BOOL hasLoved = [[currDict objectForKey:MY_LOVE] boolValue];//1为我已收藏，0为我未收藏
    
    NSString *tips1 = hasLoved ? @"取消收藏中..." : @"收藏中...";
    [MPNotificationView notifyWithText:tips1 detail:nil andDuration:0.5f];
    //            [SVProgressHUD showWithStatus:tips1];
    NSString *url = $str(@"%@feedlove", POST_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[currDict objectForKey:ID], ID, [currDict objectForKey:FEED_ID_TYPE], FEED_ID_TYPE, $str(@"%d", !hasLoved), TYPE, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tips2 = hasLoved ? @"取消收藏成功" : @"收藏成功";
        [MPNotificationView notifyWithText:tips2 detail:nil andDuration:0.5f];
        //                [SVProgressHUD showSuccessWithStatus:tips2];
        
        //更新收藏状态
        MyButton *btn = (MyButton*)cell.albumView.likeitBtn;
        btn.selected = !btn.selected;
        //我是否已经收藏
        [currDict setObject:[NSNumber numberWithBool:btn.selected] forKey:MY_LOVE];
        //收藏的名字数组、数目
        NSMutableArray *loveUser = [[NSMutableArray alloc] initWithArray:[currDict objectForKey:LOVE_USER]];
        if (btn.selected) {
            NSMutableDictionary *loveDict = [[NSMutableDictionary alloc] init];
            [loveDict setObject:MY_UID forKey:UID];
            [loveDict setObject:MY_NAME forKey:NAME];
            [loveDict setObject:MY_HEAD_AVATAR_URL forKey:AVATAR];
            [loveDict setObject:MY_VIP_STATUS forKey:VIP_STATUS];
            [loveUser insertObject:loveDict atIndex:0];
        } else {
            for (int i = 0; i < [loveUser count]; i++) {
                if ([[[loveUser objectAtIndex:i] objectForKey:UID] isEqualToString:MY_UID]) {
                    [loveUser removeObjectAtIndex:i];
                }
            }
        }
        [currDict setObject:loveUser forKey:LOVE_USER];
        
        int loveNum = [[currDict objectForKey:FEED_LOVE_NUM] intValue];
        loveNum = btn.selected ? loveNum + 1 : loveNum - 1;
        [currDict setObject:[NSString stringWithFormat:@"%d", loveNum] forKey:FEED_LOVE_NUM];
        [dataArray replaceObjectAtIndex:indexRow withObject:currDict];
        
        //                [blockCell.albumView.likeitBtn changeLblWithText:[NSString stringWithFormat:@"%d", loveNum] andColor:[UIColor whiteColor] andSize:12.0f theX:25];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        NSString *tips2 = hasLoved ? @"取消收藏失败T_T" : @"收藏失败T_T";
        [MPNotificationView notifyWithText:tips2 detail:nil andDuration:0.5f];
        //                [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

#pragma mark - 上行接口
- (void)uploadRequestToComment:(NSMutableDictionary*)para withMsg:(NSString*)msg andIndexRow:(int)indexRow {
    [MPNotificationView notifyWithText:@"发送评论中..." detail:nil andDuration:0.5f];
//    [SVProgressHUD showWithStatus:@"发送评论中..."];
    NSString *url = $str(@"%@comment", POST_API);
    
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"评论成功" detail:nil andDuration:0.5f];
//        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        
        //更新当前页面的评论数据
        NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
        [aDict setObject:MY_UID forKey:COMMENT_AUTHOR_ID];
        [aDict setObject:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]] forKey:DATELINE];
        [aDict setObject:msg forKey:MESSAGE];
        [aDict setObject:MY_NAME forKey:COMMENT_AUTHOR_NAME];
        [aDict setObject:[NSNumber numberWithInt:indexRow] forKey:@"indexRow"];
        [self refreshCommentWithDict:aDict];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [MPNotificationView notifyWithText:@"评论失败T_T" detail:nil andDuration:0.5f];
//        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)refreshCommentForNotification:(NSNotification*)noti {
    NSMutableDictionary *aDict = (NSMutableDictionary*)[noti object];
    [self refreshCommentWithDict:aDict];
}

- (void)refreshCommentWithDict:(NSMutableDictionary*)aDict {
    int indexRow = [[aDict objectForKey:@"indexRow"] intValue];
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexRow]];
    [aDict removeObjectForKey:@"indexRow"];
    NSMutableArray *commentArray;
    if ([currDict objectForKey:COMMENT]) {
        commentArray = [[NSMutableArray alloc] initWithArray:[currDict objectForKey:COMMENT]];
        if ([commentArray count] >= 2) {
            [commentArray removeObjectAtIndex:1];
        }
        [commentArray insertObject:aDict atIndex:0];
    } else {
        commentArray = [[NSMutableArray alloc] init];
        [commentArray addObject:aDict];
    }
    [currDict setObject:commentArray forKey:COMMENT];
    int replyNum = [[currDict objectForKey:FEED_REPLY_NUM] intValue] + 1;
    [currDict setObject:[NSString stringWithFormat:@"%d", replyNum] forKey:FEED_REPLY_NUM];
    [dataArray replaceObjectAtIndex:indexRow withObject:currDict];
    [_tableView reloadData];
}

- (void)refreshLoveNumForNotification:(NSNotification*)noti {
    NSMutableDictionary *aDict = (NSMutableDictionary*)[noti object];
    int indexRow = [[aDict objectForKey:@"indexRow"] intValue];
    
    NSMutableDictionary *currDict = [[NSMutableDictionary alloc] initWithDictionary:[dataArray objectAtIndex:indexRow]];
    
    BOOL hasLoved = [[aDict objectForKey:MY_LOVE] boolValue];
    //收藏状态
    [currDict setObject:[NSNumber numberWithBool:hasLoved] forKey:MY_LOVE];
    
    //收藏数目
    int loveNum = [[currDict objectForKey:FEED_LOVE_NUM] intValue];
    loveNum = hasLoved ? loveNum + 1 : loveNum - 1;
    [currDict setObject:[NSString stringWithFormat:@"%d", loveNum] forKey:FEED_LOVE_NUM];
    [dataArray replaceObjectAtIndex:indexRow withObject:currDict];
    [_tableView reloadData];
}

- (void)refreshListForDelete:(NSNotification*)noti {
    int indexRow = [[noti object] intValue];
    [self.dataArray removeObjectAtIndex:indexRow];
    [self._tableView reloadData];
}

#pragma mark cell action
//- (void)sendRequestToDetail:(id)sender aDict:(NSDictionary*)dict {
//}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FeedCellType type = [FeedViewController whichType:[dataArray objectAtIndex:indexPath.row]];
    if (type == otherHasImgType || type == otherNoImgType) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择"];
        as.delegate = self;
        
//        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        if ([dict objectForKey:COMMENT]) {
            NSDictionary *commentDict = [[dict objectForKey:COMMENT] objectAtIndex:0];
            if (!isEmptyStr([commentDict objectForKey:COMMENT_AUTHOR_NAME])) {
                [as addButtonWithTitle:[commentDict objectForKey:COMMENT_AUTHOR_NAME] handler:^{
                    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                    con.isMyFamily = YES;
                    con.userId = [commentDict objectForKey:COMMENT_AUTHOR_ID];
                    [self.navigationController pushViewController:con animated:YES];
                }];
            }
        }
        if (!isEmptyStr([dict objectForKey:NAME])) {
            [as addButtonWithTitle:[dict objectForKey:NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.isMyFamily = YES;
                con.userId = [dict objectForKey:UID];
                [self.navigationController pushViewController:con animated:YES];
            }];
        }
        if (!isEmptyStr([dict objectForKey:F_NAME])) {
            [as addButtonWithTitle:[dict objectForKey:F_NAME] handler:^{
                FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
                con.isMyFamily = YES;
                con.userId = [dict objectForKey:F_UID];
                [self.navigationController pushViewController:con animated:YES];
            }];
        }
//        if (!isEmptyStr([dict objectForKey:TITLE])) {
//            [as addButtonWithTitle:[dict objectForKey:TITLE] handler:^{
//                ;
//            }];
//        }
        NSString *idType = [dict objectForKey:FEED_ID_TYPE];
        if ([idType isEqualToString:FEED_PHOTO_ID] || [idType isEqualToString:FEED_BLOG_ID] || [idType isEqualToString:FEED_EVENT_ID] || [idType isEqualToString:FEED_VIDEO_ID] || [idType rangeOfString:COMMENT].length > 0) {
            [as addButtonWithTitle:@"进入详情" handler:^{
                FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
                con.hidesBottomBarWhenPushed = YES;
                NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
                NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
                NSString *idType = [aDict objectForKey:FEED_ID_TYPE];
                idType = [idType stringByReplacingOccurrencesOfString:COMMENT withString:ID];
                [idDict setObject:idType forKey:FEED_ID_TYPE];
                [idDict setObject:[aDict objectForKey:ID] forKey:FEED_ID];
                [idDict setObject:[aDict objectForKey:F_ID] forKey:FEED_COMMENT_ID];
                [idDict setObject:[aDict objectForKey:UID] forKey:UID];
                con.indexRow = indexPath.row;
                [con.idArray addObject:idDict];
                [self.navigationController pushViewController:con animated:YES];
            }];
        }
//        if (!([[dict objectForKey:FEED_ID_TYPE] isEqualToString:@"isayid"] && !isEmptyStr([dict objectForKey:MESSAGE])) || ([[dict objectForKey:FEED_ID_TYPE] rangeOfString:COMMENT].length > 0 && ![[dict objectForKey:FEED_IMAGE_1] isEqualToString:@""])) {
//            [as addButtonWithTitle:@"进入详情" handler:^{
//                FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
//                NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
//                NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
//                NSString *idType = [aDict objectForKey:FEED_ID_TYPE];
//                idType = [idType stringByReplacingOccurrencesOfString:COMMENT withString:ID];
//                [idDict setObject:idType forKey:FEED_ID_TYPE];
//                [idDict setObject:[aDict objectForKey:ID] forKey:FEED_ID];
//                [idDict setObject:[aDict objectForKey:F_ID] forKey:FEED_COMMENT_ID];
//                [idDict setObject:[aDict objectForKey:UID] forKey:UID];
//                con.indexRow = indexPath.row;
//                [con.idArray addObject:idDict];
//                [self.navigationController pushViewController:con animated:YES];
//            }];
//        }
        [as addButtonWithTitle:@"取消" handler:^{
            return ;
        }];
        as.cancelButtonIndex = as.numberOfButtons - 1;
        [as sizeToFit];
        MyTabBarController *tabBarCon = (MyTabBarController*)self.parentViewController;
        [as showFromTabBar:tabBarCon.tabBar];
        return;
    }
    FeedDetailViewController *con = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
    con.hidesBottomBarWhenPushed = YES;
//    con.detailType = bigImgType;
//    con.dataDict = [dataArray objectAtIndex:indexPath.row];
    
    NSDictionary *aDict = [dataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *idDict = [[NSMutableDictionary alloc] init];
    
    [idDict setObject:[aDict objectForKey:FEED_ID_TYPE] forKey:FEED_ID_TYPE];
    [idDict setObject:[aDict objectForKey:ID] forKey:FEED_ID];
    [idDict setObject:[aDict objectForKey:F_ID] forKey:FEED_COMMENT_ID];
    [idDict setObject:[aDict objectForKey:UID] forKey:UID];
    con.indexRow = indexPath.row;
//    [idDict setObject:[NSNumber numberWithInteger:indexPath.row] forKey:INDEX_ROW];
    [con.idArray addObject:idDict];
//    con.idType = [aDict objectForKey:FEED_ID_TYPE];
//    con.feedId = [aDict objectForKey:ID];
//    con.feedCommentId = [aDict objectForKey:F_ID];
//    con.userId = [aDict objectForKey:UID];
//    con.indexRow = indexPath.row;
//    con.hasLoved = [[aDict objectForKey:MY_LOVE] boolValue];//等接口改了这里
    [self.navigationController pushViewController:con animated:YES];
}
/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHAttributedLabel Delegate Method
/////////////////////////////////////////////////////////////////////////////

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([[UIApplication sharedApplication] canOpenURL:linkInfo.extendedURL])
    {
        return YES;
    }
    else
    {
        // Unsupported link type (especially phone links are not supported on Simulator, only on device)
        [UIAlertView alertViewWithTitle:@"打开链接" message:[NSString stringWithFormat:@"%@", linkInfo.extendedURL]];
        return NO;
    }
}



@end
