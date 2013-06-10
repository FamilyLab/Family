//
//  PostSthViewController.m
//  Family
//
//  Created by Aevitx on 13-6-4.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "PostSthViewController.h"
#import "MyViewCell.h"
#import "MyImagePickerController.h"
#import "UIButton+WebCache.h"
#import "AppDelegate.h"
#import "FamilyListViewController.h"
#import "MapAroundViewController.h"
#import "PlistManager.h"
#import "MyHttpClient.h"
#import "MPNotificationView.h"
#import "MobClick.h"
#import "MyTabBarController.h"
#import "AGImagePickerController.h"
#import "AppDelegate.h"

#define MAX_PHOTO_NUM 3

#define kNotifyForDismissNavigationTime  0.4f//0.4秒后将当前页面消失
#define kNotifyForOpertingTime           0.5f//“后台发送中...”这几个字要显示的时间
#define kNotifyForSuccessOrFailTime      0.8f//发送成功或失败后提示的文字的显示时间

@interface PostSthViewController ()

@end

@implementation PostSthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        photoNumWithoutDefaultImage = 0;
        imgIndex = 0;
        _imagesArray = [[NSMutableArray alloc] init];
        _postSthType = postPhoto;
//        _rePostType = notRePostType;
        isFirstShow = YES;
        _shouldAddDefaultImage = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_dataDict) {
        _postSthType = [self whichRepostType:_idType];
    }
    [self addTopView];
    
    int indexView = 0;
    if (_dataDict) {
        indexView = _postSthType == rePostPhoto ? 0 : (_postSthType == rePostBlog ? 1 : 0);
    } else {
        indexView =  _postSthType == postPhoto ? 0 : (_postSthType == postDiary ? 1 :(_postSthType == postPrivateMsg ? 2 : (_postSthType == postActivity ? 3 : (_postSthType == postWantToSay ? 4 : 0))));
    }
    PostSthView *aView = [[[NSBundle mainBundle] loadNibNamed:@"PostSthView" owner:self options:nil] objectAtIndex:indexView];
    
    aView.frame = (CGRect){.origin.x = 10, .origin.y = 60, .size = DEVICE_SIZE};
    if (_postSthType != postPrivateMsg && _postSthType != postWantToSay) {
        if (aView.describeTextView) {
            aView.describeTextView.inputAccessoryView = self.menuViewForKeyboard;
        }
//        if (aView.firstTextField) {
//            aView.firstTextField.inputAccessoryView = self.menuViewForKeyboard;
//        }
    } else {//发私信和我想说
        [self.menuViewForKeyboard.albumBtn removeFromSuperview];
        [self.menuViewInBottom.albumBtn removeFromSuperview];
        if (aView.describeTextView) {
            aView.describeTextView.inputAccessoryView = self.menuViewForKeyboard;
        }
    }
    aView.postTypeNum = _postSthType;
    self.postSthView = aView;
    [self.view addSubview:aView];
    
    self.menuViewInBottom.frame = (CGRect){.origin.x = 0, .origin. y = DEVICE_SIZE.height -  40, self.menuViewInBottom.frame.size};
    
    [_postSthView.locationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [_postSthView.personsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    SinaWeibo *sinaWiebo = [self sinaweibo];
    if (!sinaWiebo.isAuthValid || sinaWiebo.isAuthorizeExpired) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SHARE_TO_SINA_WEIBO];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _sinaBtn.selected = MY_HAS_BIND_SINA_WEIBO && MY_SHARE_TO_SINA_WEIBO;
    //    tcweiboBtn.selected = MY_HAS_BIND_QQ_WEIBO;
    _weixinBtn.selected = MY_HAS_BIND_WEIXIN;
    
    
    _zonesArray = [[NSMutableArray alloc] init];
    _picIdsArray = [[NSMutableArray alloc] init];
    _withFriendsArray = [[NSMutableArray alloc] init];
    _familyListArray = [[NSMutableArray alloc] init];
    
    [_postSthView.personsBtn addTarget:self action:@selector(personsBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_postSthView.locationBtn addTarget:self action:@selector(locationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initData];
    
    photoNumWithoutDefaultImage = [_imagesArray count];
    //转载
    if (_dataDict && _postSthType == rePostPhoto) {
        if ([_dataDict objectForKey:PIC_LIST]) {//从动态详情进来的
            photoNumWithoutDefaultImage = [[_dataDict objectForKey:PIC_LIST] count];
        } else {//从动态列表进来的
            for (int i = 0; i < 4; i++) {
                NSString *imgKeyStr = $str(@"image_%d", i + 1);
                if (!isEmptyStr([_dataDict objectForKey:imgKeyStr])) {
                    photoNumWithoutDefaultImage++;
                }
            }
        }
    }
    if (_postSthType == postPhoto || _postSthType == rePostPhoto) {
        [self setupHorizontalViewWithType:postPhoto];
        if (iPhone5) {
            CGRect tmpFrame = _postSthView.describeTextView.frame;
            tmpFrame.size.height += 88;
            
        }
    } else if (_postSthType == postDiary) {
        [_postSthView.describeTextView becomeFirstResponder];
    } else if (_postSthType == postPrivateMsg) {
        [_postSthView.pmNameBtn whenTapped:^{
            [self personsBtnPressed:_postSthView.pmNameBtn];
        }];
    } else if (_postSthType == postActivity) {
        //活动图片
        [_postSthView.eventImgBtn whenTapped:^{
            MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
            picker.allowsEditing = NO;
            NSString *destructiveStr = _eventImg ? @"删除此图片" : nil;
            [picker showImagePickerMenu:@"选择图片" buttonTitle:@"打开相机" destructiveTitle:destructiveStr sender:_postSthView.eventImgBtn otherTitle:nil];
            
            [picker.ImagePickerMenu setHandler:^{//删除
                self.eventImg = nil;
                [_postSthView.eventImgBtn setImage:[UIImage imageNamed:@"post_camera_a_v12.png"] forState:UIControlStateNormal];
            } forButtonAtIndex:picker.ImagePickerMenu.destructiveButtonIndex];
            [picker.ImagePickerMenu showInView:self.view];
        }];
        
        //活动时间
        NSTimeInterval secondsPerDay = 3 * 24 * 60 * 60;
        NSDate *threeDay = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];
        [self fillTimeBtnTitleWithDate:threeDay];
        [_postSthView.describeTextView becomeFirstResponder];
//        [_postSthView.firstTextField becomeFirstResponder];
        
        _postSthView.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_postSthView.timeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [_postSthView.timeBtn whenTapped:^{
            _postSthView.timeBtn.selected = !_postSthView.timeBtn.selected;
            [self bgBtnPressed:nil];
            if (_postSthView.timeBtn.selected) {
                [self timeBtnPressed:nil];
            }
        }];
    } else if (_postSthType == postWantToSay) {
        _postSthView.wantToSayTable.delegate = self;
        _postSthView.wantToSayTable.dataSource = self;
        [self getWantToSayTitles];
    }
    
    if (_dataDict) {
        [self initRepostData];
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

    if (_postSthType != rePostPhoto && _postSthType != rePostBlog) {
        NSString *tipStr = _postSthType == postPhoto ? @"发照片" : (_postSthType == postDiary ? @"发日记" :(_postSthType == postPrivateMsg ? @"发起对话" : (_postSthType == postActivity ? @"发活动" : (_postSthType == postWantToSay ? @"我想说" : @""))));
        [topView leftText:tipStr];
    } else {
        [topView leftText:@"转载"];
    }
//    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
    
    //新浪
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn0 setImage:[UIImage imageNamed:@"sina_weibo_a.png"] forState:UIControlStateNormal];
    [btn0 setImage:[UIImage imageNamed:@"sina_weibo_b.png"] forState:UIControlStateHighlighted];
    [btn0 setImage:[UIImage imageNamed:@"sina_weibo_b.png"] forState:UIControlStateSelected];
    btn0.frame = CGRectMake(190, 0, 55, 50);
    [btn0 addTarget:self action:@selector(markWeibo:) forControlEvents:UIControlEventTouchUpInside];
    self.sinaBtn = btn0;
    [topView addSubview:btn0];
    
    //微信
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"weixin_a.png"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"weixin_b.png"] forState:UIControlStateHighlighted];
    [btn1 setImage:[UIImage imageNamed:@"weixin_b.png"] forState:UIControlStateSelected];
    btn1.frame = CGRectMake(250, 0, 55, 50);
    [btn1 addTarget:self action:@selector(markWeibo:) forControlEvents:UIControlEventTouchUpInside];
    self.weixinBtn = btn1;
    [topView addSubview:btn1];
    if (_postSthType != postPrivateMsg && _postSthType != postWantToSay) {
        _sinaBtn.hidden = NO;
        _weixinBtn.hidden = NO;
    } else {//发私信 和 我想说
        _sinaBtn.hidden = YES;
        _weixinBtn.hidden = YES;
    }
    
    if (_postSthType == postWantToSay) {
//        [topView rightBtnTextArray:[[NSArray alloc] initWithObjects:@"我想说...", @"我在", @"天气", @"路上", @"祝福", nil]];
        [topView rightBtnTextArray:[[NSArray alloc] initWithObjects:@"我在", @"天气", @"路上", @"祝福", nil]];
        topView.rightBtnContainerView.frame = (CGRect){.origin.x = 0, .origin.y = 0, .size = topView.rightBtnContainerView.frame.size};
        topView.delegate = self;
//        UIButton *btn = (UIButton*)[topView viewWithTag:kTagBtnInTopBarView];
//        btn.hidden = YES;
//        [self userPressedTheTopViewBtn:topView andButton:btn];
    }
}

- (PostSthType)whichRepostType:(NSString*)typeStr {
    if ([typeStr rangeOfString:FEED_PHOTO_ID].location != NSNotFound) {
        return rePostPhoto;
    } else if ([typeStr rangeOfString:FEED_BLOG_ID].location != NSNotFound) {
        return rePostBlog;
    } else if ([typeStr rangeOfString:FEED_VIDEO_ID].location != NSNotFound) {
        return rePostVideo;
    } else if ([typeStr rangeOfString:FEED_EVENT_ID].location != NSNotFound) {
        return rePostEvent;
    } else {
        return postHitError;
    }
}

//填写转发的数据
- (void)initRepostData {
    if (_postSthView.otherView) {
        [_postSthView.otherView removeFromSuperview];
        _postSthView.otherView = nil;
    }
    switch (_postSthType) {
        case rePostPhoto:
        {
            [self fillPhotoData];
            break;
        }
        case rePostBlog:
        {
            [self fillBlogData];
            break;
        }
        case rePostVideo:
        {
            [self fillVideoData];
            break;
        }
        case rePostEvent:
        {
            [self fillEventData];
            break;
        }
        default:
            break;
    }
}

- (void)initData {
    NSString *zoneNameStr = @"默认空间";
    if (!isEmptyStr([ConciseKit userDefaultsObjectForKey:LAST_ZONE_NAME])) {
        zoneNameStr = [ConciseKit userDefaultsObjectForKey:LAST_ZONE_NAME];
    }
    //当前的空间被删除时，就用得到的空间数组里的第一个
    if ([_zonesArray count] <= 0) {
        [self getZonesWithTipStr:NO];
    }
    if ([_zonesArray count] > 0 && ![_zonesArray containsObject:zoneNameStr]) {
        zoneNameStr = [_zonesArray objectAtIndex:0];
    }
    [self.menuViewForKeyboard.albumBtn setTitle:zoneNameStr forState:UIControlStateNormal];
    [self.menuViewInBottom.albumBtn setTitle:zoneNameStr forState:UIControlStateNormal];
    
    
    if (self.postSthView.describeTextView) {
        self.postSthView.describeTextView.delegate = self;
    }
//    if (self.postSthView.firstTextField) {
//        self.postSthView.firstTextField.delegate = self;
//    }
}

//上面topView的按钮
- (void)userPressedTheTopViewBtn:(TopView *)_topView andButton:(UIButton *)_button {
//    self.wantToSayArray = nil;
    int theTag = _button.tag - kTagBtnInTopBarView + 1;
    switch (theTag) {
        case 0://”我想说“按钮
        {
            break;
        }
        case 1://我在
        {
            _wantToSayArray = [[_wantToSayDict objectForKey:@"wid"] allValues];
            [_postSthView.wantToSayTable reloadData];
            break;
        }
        case 2://天气
        {
            _wantToSayArray = [[_wantToSayDict objectForKey:@"tid"]allValues];
            [_postSthView.wantToSayTable reloadData];
            break;
        }
        case 3://路上
        {
            _wantToSayArray = [[_wantToSayDict objectForKey:@"lid"]allValues];
            [_postSthView.wantToSayTable reloadData];
            break;
        }
        case 4://祝福
        {
            _wantToSayArray = [[_wantToSayDict objectForKey:@"zid"]allValues];
            [_postSthView.wantToSayTable reloadData];
            break;
        }
        default:
            break;
    }
}

#pragma mark JTListView Initialization
- (void)setupHorizontalViewWithType:(PostSthType)postType {
    [_postSthView.describeTextView becomeFirstResponder];
    if (!self.imagesArray) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    if (!_dataDict) {
        photoNumWithoutDefaultImage = [_imagesArray count];
    }
    if (_dataDict) {//转发
        for (int i = 0; i < photoNumWithoutDefaultImage; i++) {
            [_imagesArray addObject:[UIImage imageNamed:@"post_camera_a_v12.png"]];
        }
    } else {//非转发
        if (([_imagesArray count] < MAX_PHOTO_NUM && !isFirstShow) || _shouldAddDefaultImage) {
            [_imagesArray addObject:[UIImage imageNamed:@"post_camera_a_v12.png"]];
            _shouldAddDefaultImage = NO;
        }
        isFirstShow = NO;
    }
    if (self.postSthView.jtListView) {
        [self.postSthView.jtListView removeFromSuperview];
        self.postSthView.jtListView = nil;
    }
    CGRect frameRect;
    if (postType == postPhoto) {
        frameRect = CGRectMake(13, 10, 267, 55);
    }
    JTListView *list = [[JTListView alloc] initWithFrame:frameRect layout:JTListViewLayoutLeftToRight];
    list.scrollEnabled = [_imagesArray count] > MAX_PHOTO_NUM ? YES : NO;//只需要3张图片，所以不需要滑动
	list.delegate = self;
    list.dataSource = self;
	[self.postSthView addSubview:list];
    [list reloadData];
	self.postSthView.jtListView = list;
}

//返回按钮
- (IBAction)backBtnPressed:(id)sender {
    if ([NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:0] class]) isEqualToString:NSStringFromClass([self class])]) {
        [self dismissModalViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

//选择相册空间
- (IBAction)albumBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self getZonesWithTipStr:YES];
    } else {
        [self bgBtnPressed:nil];
    }
}

//选择空间
- (void)getZonesWithTipStr:(BOOL)canShowTipStr {
    if ([PlistManager isPlistFileExists:PLIST_ZONE_LIST] && [[PlistManager readPlist:PLIST_ZONE_LIST] objectForKey:MY_UID]) {
        NSDictionary *dict = [[PlistManager readPlist:PLIST_ZONE_LIST] objectForKey:MY_UID];
        if (dict) {
            [_zonesArray removeAllObjects];
            for (int i = 0; i < [[[dict objectForKey:WEB_DATA] objectForKey:TAG_LIST] count]; i++) {
                NSDictionary *aDict = [[[dict objectForKey:WEB_DATA] objectForKey:TAG_LIST] objectAtIndex:i];
                [_zonesArray addObject:[aDict objectForKey:TAG_NAME]];
            }
            if (canShowTipStr) {
                [self bgBtnPressed:nil];
                [self showPickerView];
            }
        }
    } else {
        if (canShowTipStr) {
            [SVProgressHUD showWithStatus:@"获取空间列表中..."];
        }
        BOOL isForDetectZoneIsExist = !canShowTipStr;
        [self sendRequestForZoneList:nil isForDetectZoneIsExist:isForDetectZoneIsExist];
    }
}

- (void)sendRequestForZoneList:(id)sender isForDetectZoneIsExist:(BOOL)isForDetectZoneIsExist {
    if (!isForDetectZoneIsExist && [_zonesArray count] > 0) {
        [SVProgressHUD dismiss];
        [self bgBtnPressed:nil];
        [self showPickerView];
        return;
    }
    //    [SVProgressHUD showWithStatus:@"获取空间列表中..."];
    NSString *url = [NSString stringWithFormat:@"%@do.php?ac=ajax&op=taglist&m_auth=%@", BASE_URL, [MY_M_AUTH urlencode]];
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        
        [PlistManager deletePlist:PLIST_ZONE_LIST];
        [PlistManager writePlist:(NSMutableDictionary*)dict forKey:MY_UID plistName:PLIST_ZONE_LIST];
        
        for (int i = 0; i < [[[dict objectForKey:WEB_DATA] objectForKey:TAG_LIST] count]; i++) {
            NSDictionary *aDict = [[[dict objectForKey:WEB_DATA] objectForKey:TAG_LIST] objectAtIndex:i];
            [_zonesArray addObject:[aDict objectForKey:TAG_NAME]];
        }
        //        [_zonesArray addObjectsFromArray:[[dict objectForKey:WEB_DATA] objectForKey:TAG_LIST]];
        if (isForDetectZoneIsExist && [_zonesArray count] > 0 && ![_zonesArray containsObject:self.menuViewInBottom.albumBtn.titleLabel.text]) {
            //下面的
            [self.menuViewInBottom.albumBtn setTitle:[_zonesArray objectAtIndex:0] forState:UIControlStateNormal];
            [self.menuViewInBottom.albumBtn setTitle:[_zonesArray objectAtIndex:0] forState:UIControlStateHighlighted];
            [self.menuViewInBottom layoutSubviews];
            
            //键盘上的
            [self.menuViewForKeyboard.albumBtn setTitle:[_zonesArray objectAtIndex:0] forState:UIControlStateNormal];
            [self.menuViewForKeyboard.albumBtn setTitle:[_zonesArray objectAtIndex:0] forState:UIControlStateHighlighted];
            [self.menuViewForKeyboard layoutSubviews];
        }
        if (!isForDetectZoneIsExist) {
            [self bgBtnPressed:nil];
            [self showPickerView];
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@", error);
        if (!isForDetectZoneIsExist) {
            [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
            self.menuViewInBottom.albumBtn.selected = NO;
            self.menuViewForKeyboard.albumBtn.selected = NO;
        }
    }];
}

//选择空间名称
- (void)showPickerView {
//    if (expandView.postType == postPhoto) {
//        [self buildBgBtnOfPostPhoto];
//    }
    UIPickerView *tmpPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    CGSize pickerSize = [tmpPicker sizeThatFits:CGSizeZero];
    tmpPicker.frame = [self pickerFrameWithSize:pickerSize];
    tmpPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    tmpPicker.showsSelectionIndicator = YES;
    [tmpPicker setBackgroundColor:[UIColor clearColor]];
    tmpPicker.delegate = self;
    tmpPicker.dataSource = self;
    
    if ([_zonesArray containsObject:_menuViewInBottom.albumBtn.titleLabel.text]) {
        [tmpPicker selectRow:[_zonesArray indexOfObject:_menuViewInBottom.albumBtn.titleLabel.text] inComponent:0 animated:NO];
    }
    
    self.pickerView = tmpPicker;
    
    [self.view addSubview:tmpPicker];
    
    if (!self.bgImgViewForTouch) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        bgImgView.backgroundColor = [UIColor blackColor];
        bgImgView.alpha = 0.6f;
        bgImgView.userInteractionEnabled = YES;
        [self.view insertSubview:bgImgView belowSubview:tmpPicker];
        [bgImgView whenTapped:^{
            [self removePicker];
        }];
        self.bgImgViewForTouch = bgImgView;
    }
    
    self.menuViewInBottom.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height - tmpPicker.frame.size.height - self.menuViewInBottom.frame.size.height, .size = self.menuViewInBottom.frame.size};
    [self.view bringSubviewToFront:self.menuViewInBottom];
}

- (void)bgBtnPressed:(id)sender {
//    UIButton *tmpBtn = (UIButton*)[self.upPostView viewWithTag:kTagBgBtnOfPostPhot];
//    [tmpBtn removeFromSuperview];
//    tmpBtn = nil;
    
    [Common resignKeyboardInView:self.view];
    [self removePicker];
}

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(0, screenRect.size.height - size.height, size.width, size.height);
	return pickerRect;
}

- (void)removePicker {
    if (_pickerView) {
        [_pickerView removeFromSuperview];
        self.pickerView = nil;
        self.menuViewInBottom.albumBtn.selected = NO;
        self.menuViewForKeyboard.albumBtn.selected = NO;
        [self.bgImgViewForTouch removeFromSuperview];
        self.bgImgViewForTouch = nil;
    }
    if (_datePicker) {
        [_datePicker removeFromSuperview];
        self.datePicker = nil;
        self.postSthView.timeBtn.selected = NO;
        [self.bgImgViewForTouch removeFromSuperview];
        self.bgImgViewForTouch = nil;
    }
    if (self.menuViewInBottom.frame.origin.y != DEVICE_SIZE.height - self.menuViewInBottom.frame.size.height) {
        self.menuViewInBottom.frame = (CGRect){.origin.x = 0, .origin.y = DEVICE_SIZE.height - self.menuViewInBottom.frame.size.height, .size = self.menuViewInBottom.frame.size};
    }
}

#pragma mark - textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self removePicker];
}

#pragma mark  - textview delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self removePicker];
}

#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_zonesArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_zonesArray objectAtIndex:row];// [[_zonesArray objectAtIndex:row] objectForKey:TAG_NAME];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.menuViewInBottom.albumBtn setTitle:[_zonesArray objectAtIndex:row] forState:UIControlStateNormal];
    [self.menuViewInBottom layoutSubviews];
    
    [self.menuViewForKeyboard.albumBtn setTitle:[_zonesArray objectAtIndex:row] forState:UIControlStateNormal];
    [self.menuViewForKeyboard layoutSubviews];
//    [self.downPostView.albumBtn setTitle:[_zonesArray objectAtIndex:row] forState:UIControlStateHighlighted];
}

//和谁在一起、发私信   //进入家人列表
- (IBAction)personsBtnPressed:(id)sender {
    FamilyListViewController *con = [[FamilyListViewController alloc] initWithNibName:@"FamilyListViewController" bundle:nil];
    con.conType = myFamilyListType;
    con.userId = MY_UID;
    if (_postSthView.pmNameBtn && sender == _postSthView.pmNameBtn) {//发私信
        con.isWantToPostPM = YES;
    } else {//选择和谁在一起
        con.canSelect = YES;
        if (con.selectedArray) {
            [con.selectedArray removeAllObjects];
            con.selectedArray = nil;
        } else {
            con.selectedArray = [[NSMutableArray alloc] init];
        }
        con.selectedArray = [[NSMutableArray alloc] initWithArray:_withFriendsArray];
        
        if (!con.dataArray) {
            con.dataArray = [[NSMutableArray alloc] init];
        }
        [con.dataArray addObjectsFromArray:_familyListArray];
    }
    [self.navigationController pushViewController:con animated:YES];
}

- (void)setNameForTogether {
    if ([_withFriendsArray count] <= 0) {
        [self.postSthView.personsBtn setTitle:@"和我在一起的是..." forState:UIControlStateNormal];
        return;
    }
    NSString *nameStr = [[_withFriendsArray objectAtIndex:0] objectForKey:NAME];
    for (int i = 1; i < [_withFriendsArray count]; i++) {
        nameStr = $str(@"%@, %@", nameStr, [[_withFriendsArray objectAtIndex:i] objectForKey:NAME]);
    }
    [self.postSthView.personsBtn setTitle:nameStr forState:UIControlStateNormal];
}

//定位 我在
- (void)locationBtnPressed:(UIButton*)sender {
    //    sender.selected = !sender.selected;
    //    self.downPostView.mapView.showsUserLocation = YES;
    //    self.downPostView.locationBtn.hidden = YES;
    //    self.downPostView.locationLbl.hidden = YES;
    //    self.downPostView.locationBtn.alpha = sender.selected ? 0.0f : 1.0f;
    if (self.locationManager) {
        self.locationManager = nil;
    }
    CLLocationManager *loc = [[CLLocationManager alloc] init];
    self.locationManager = loc;
    if (![CLLocationManager locationServicesEnabled]) {
        [SVProgressHUD showErrorWithStatus:@"您的设备没开启定位功能，或者设备没有定位功能T_T"];
    } else {
        if (!self.ssLoading) {
            SSLoadingView *ss = [[SSLoadingView alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height)];
            ss.textLabel.text = @"定位中...";
            ss.backgroundColor = [UIColor clearColor];
            ss.hidden = NO;
            [sender addSubview:ss];
            [ss.activityIndicatorView startAnimating];
            self.ssLoading = ss;
        } else {
            self.ssLoading.hidden = NO;
            [self.ssLoading.activityIndicatorView startAnimating];
        }
        //设置代理
        [_locationManager setDelegate:self];
        //设置精准度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //发生事件的最小距离间隔
        _locationManager.distanceFilter = 1000.0f;
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - locationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (self.ssLoading) {
        [self.ssLoading.activityIndicatorView stopAnimating];
        self.ssLoading.hidden = YES;
    }
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    NSString *lat = [[NSString alloc] initWithFormat:@"%f", coordinate.latitude];
    NSString *lng = [[NSString alloc] initWithFormat:@"%f", coordinate.longitude];
    
    //更新定位信息方法
    //    NSLog(@"delegate %f,%f", coordinate.latitude, coordinate.longitude);
    self.latStr = lat;
    self.lngStr = lng;
    if ([self.navigationController.viewControllers count] < 2) {
        MapAroundViewController *con = [[MapAroundViewController alloc] initWithNibName:@"MapAroundViewController" bundle:nil];
        con.latStr = lat;
        con.lngStr = lng;
        [self.navigationController pushViewController:con animated:YES];
    }
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
    //        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //        [geocoder reverseGeocodeLocation:newLocation
    //                       completionHandler:^(NSArray *placemarks, NSError *error){
    //                           for (CLPlacemark *place in placemarks) {
    //                               NSLog(@"name,%@",place.name);                       // 位置名
    //                               NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
    //                               NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
    //                               NSLog(@"locality,%@",place.locality);               // 市
    //                               NSLog(@"subLocality,%@",place.subLocality);         // 区
    //                               NSLog(@"country,%@",place.country);                 // 国家
    //                           }
    //
    //                       }];
    //    } else {
    //        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc]initWithCoordinate:coordinate];
    //        geocoder.delegate = self;
    //        if (!geocoder.querying) {
    //            [geocoder start];
    //        }
    //    }
}

//IOS 6.0+
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.ssLoading) {
        [self.ssLoading.activityIndicatorView stopAnimating];
        self.ssLoading.hidden = YES;
    }
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    NSString *lat = [[NSString alloc] initWithFormat:@"%f", coordinate.latitude];
    NSString *lng = [[NSString alloc] initWithFormat:@"%f", coordinate.longitude];
    
    //更新定位信息方法
    self.latStr = lat;
    self.lngStr = lng;
    
    if ([self.navigationController.viewControllers count] < 2) {
        MapAroundViewController *con = [[MapAroundViewController alloc] initWithNibName:@"MapAroundViewController" bundle:nil];
        con.latStr = lat;
        con.lngStr = lng;
        [self.navigationController pushViewController:con animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (self.ssLoading) {
        [self.ssLoading.activityIndicatorView stopAnimating];
        self.ssLoading.hidden = YES;
    }
    //定位失败
    NSLog(@"location error:%@", [error description]);
}

//#pragma mark  - mapview delegate
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    NSString *lat = [NSString stringWithFormat:@"%g", userLocation.coordinate.latitude];
//    NSString *lng = [NSString stringWithFormat:@"%g", userLocation.coordinate.longitude];
//
//    MapAroundViewController *con = [[MapAroundViewController alloc] initWithNibName:@"MapAroundViewController" bundle:nil];
//    con.latStr = lat;
//    con.lngStr = lng;
//    [self.navigationController pushViewController:con animated:YES];
//
////    self.latStr = lat;
////    self.lngStr = lng;
////
////    MKCoordinateSpan span;
////    MKCoordinateRegion region;
////
////    span.latitudeDelta = 0.010;
////    span.longitudeDelta = 0.010;
////    region.span = span;
////    region.center = [userLocation coordinate];
////
////    [self.downPostView.mapView setRegion:[self.downPostView.mapView regionThatFits:region] animated:YES];
//}
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:mapView.userLocation.location.coordinate];
//    reverseGeocoder.delegate = self;
//    if (!reverseGeocoder.querying) {
//        [reverseGeocoder start];
//    }
//}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    //    NSString *subthroung = placemark.subThoroughfare;
    //    NSString *country = placemark.country;//国
    //    NSString *area = placemark.administrativeArea;//省
    NSString *city = placemark.locality;//市
    NSString *subCity = placemark.subLocality;//区
    //    NSString *steet = placemark.thoroughfare;//街道
    //    NSString *subSteet = placemark.subThoroughfare;//门牌号
    self.addressStr = [NSString stringWithFormat:@"%@%@", emptystr(city), emptystr(subCity)];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"reverseGeocoder error:%@", [error description]);
}

#pragma mark - 发布
//ok按钮
- (IBAction)okBtnPressed:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
    if (_menuViewInBottom.albumBtn) {
        [ConciseKit setUserDefaultsWithObject:_menuViewInBottom.albumBtn.titleLabel.text forKey:LAST_ZONE_NAME];
    }
    _index = 0;
    [_picIdsArray removeAllObjects];
    [self dismissCurrentControllerWithDelay];
    switch (_postSthType) {
        case postPhoto: case rePostPhoto:
        {
            if (_dataDict) {
                //                [SVProgressHUD showWithStatus:@"转载照片中..."];
                [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];//转载
                [self postPhoto:nil];
            } else {
                if (photoNumWithoutDefaultImage <= 0) {
                    [SVProgressHUD showErrorWithStatus:@"没有上传图片T_T"];
                    return;
                }
                //                [SVProgressHUD showWithStatus:@"发布照片中..."];
                [AppDelegate app].tabBarCon.shouldPresentAConToOpenCamera = YES;
                [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];
                [self uploadImage:[_imagesArray objectAtIndex:0]];
            }
            break;
        }
        case postDiary: case rePostBlog:
        {
            if (_postSthView.describeTextView.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"没有填写日志内容T_T"];
                return;
            }
            //            NSString *tipStr = _dataDict ? @"转载日志中..." : @"发布日志中...";
            [MPNotificationView notifyWithText:@"后台发送中..." detail:@"" andDuration:kNotifyForOpertingTime];
            //            [SVProgressHUD showWithStatus:tipStr];
            [self postDiary:nil];
            break;
        }
        case postWantToSay:
        {
            if (_postSthView.describeTextView.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"还没有说什么T_T"];
                return;
            }
            [MPNotificationView notifyWithText:@"后台发送中..." detail:@"" andDuration:kNotifyForOpertingTime];
            //            [SVProgressHUD showWithStatus:@"我想说..."];
            [self postWantToSay:nil];
            break;
        }
        case postActivity:
        {
//            if (_postSthView.firstTextField.text.length <= 0) {
//                [SVProgressHUD showErrorWithStatus:@"没有填写活动名称T_T"];
//                return;
//            }
            if (_postSthView.describeTextView.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"没有填写活动名称T_T"];
                return;
            }
            if (_postSthView.timeBtn.titleLabel.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"没有填写活动时间T_T"];
                return;
            }
            //            NSString *tipStr = _dataDict ? @"转载活动中..." : @"发布活动中...";
            //            [SVProgressHUD showWithStatus:tipStr];
            if (_dataDict) {//转载
                [MPNotificationView notifyWithText:@"后台发送中..." detail:@"" andDuration:kNotifyForOpertingTime];
                [self postEvent:nil];
            } else {
                if (self.eventImg) {
                    [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];
                    [self uploadImage:_eventImg];
                } else {
                    [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];
                    [self postEvent:nil];
                }
            }
            break;
        }
        case postPrivateMsg:
        {
            if (_postSthView.describeTextView.text.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"私信内容为空T_T"];
                return;
            }
            if ([_postSthView.pmNameBtn.titleLabel.text isEqualToString:@"选择家人"]) {
                [SVProgressHUD showErrorWithStatus:@"没有选择联系人T_T"];
                return;
            }
            [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];
            //            [SVProgressHUD showWithStatus:@"发送私信中..."];
            [self postPM:nil];
            break;
        }
        default:
            break;
    }
}

- (void)sendToWeiboOrWeixin {
    SinaWeibo *sinaWiebo = [self sinaweibo];
    if (!_sinaBtn.hidden && _sinaBtn.selected && MY_HAS_BIND_SINA_WEIBO && sinaWiebo.isAuthValid && !sinaWiebo.isAuthorizeExpired) {
        [MobClick event:@"sina Forward"];
    }
    
    if (!_weixinBtn.hidden && _weixinBtn.selected) {//微信
        [self performBlock:^(id sender) {
            [self showWeixin];
        } afterDelay:0.3f];
    }
}

- (void)dismissCurrentControllerWithDelay {
    [self performBlock:^(id sender) {
        if (_postSthType == postPhoto) {
            [self.navigationController dismissModalViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:DISMISS_CUSTOM_CAMERA object:nil];
        } else {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        }
    } afterDelay:kNotifyForDismissNavigationTime];
}

//上传单张图片
- (void)uploadImage:(UIImage *)_image
{
    NSString *url = $str(@"%@upload", POST_CP_API);
    NSString *opStr = _postSthType == postDiary ? UPLOAD_PHOTO_ON_DIARY : UPLOAD_PHOTO;
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:opStr, OP, MY_M_AUTH, M_AUTH, nil];
    if (_image.size.width > 1024) {//宽度超过1024要等比压缩
        float scaleSize = (float)1024 / (float)_image.size.width;
        _image = [Common scaleImage:_image toScale:scaleSize];
    }
    
    //超过1M的要压缩一下
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 1048576 * 0.3;//1M = 1024 x 1024 b = 1048576b
    NSData *imageData = (__bridge NSData*)CGDataProviderCopyData(CGImageGetDataProvider(_image.CGImage));//或者用_image.size.width * _image.size.height * 4 也可得出图片的大小
    if (imageData.length > maxFileSize) {
        imageData = UIImagePNGRepresentation(_image);
    }
    while (imageData.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(_image, compression);
    }
    _image = [UIImage imageWithData:imageData];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(_image, 1.0f) name:@"Filedata" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        //        if (_index == 0) {
        //            _postImgString = [[dict objectForKey:WEB_DATA] objectForKey:PIC_ID];
        //        } else {
        //            _postImgString = $str(@"%@|%@", _postImgString, [[dict objectForKey:WEB_DATA] objectForKey:PIC_ID]);
        //        }
        //        NSLog(@"postImgStr:%@", _postImgString);
        _index++;
        
        NSString *picIdStr = $str(@"%d", [[[dict objectForKey:WEB_DATA] objectForKey:PIC_ID] intValue]);
        [_picIdsArray addObject:picIdStr];
        
        if (_index < photoNumWithoutDefaultImage) {
            [self uploadImage:[_imagesArray objectAtIndex:_index]];
        } else {
            if (_postSthType == postPhoto) {
                [self postPhoto:nil];
            } else if (_postSthType == postActivity) {
                [self postEvent:nil];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)pushToFeedDetailWithDict:(NSDictionary*)dict {
    [self sendToWeiboOrWeixin];
}

//发布照片
- (void)postPhoto:(id)sender {
    NSString *reSinaWeibo = _sinaBtn.selected ? ONE : ZERO;
    NSString *reTcWeibo = ZERO;// tcweiboBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"rephoto" : @"photo";
    NSString *url = $str(@"%@%@", POST_CP_API, cpStr);
    
    NSMutableDictionary *para = nil;
    if (!_dataDict) {//非转载
        NSString *toWhom = _topicId ? ZERO : ONE;
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postSthView.describeTextView.text, MESSAGE, [self compoentStrWithArray:_picIdsArray], PIC_ID_S, toWhom, FRIEND, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, emptystr(_latStr), LAT, emptystr(_lngStr), LNG, emptystr(_addressStr), ADDRESS, IPHONE, COME, ONE, MAKE_FEED, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, ONE, PHOTO_SUBMIT, MY_M_AUTH, M_AUTH, emptystr(_topicId), TOPIC_ID, nil];
    } else {//转载
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:emptystr([_dataDict objectForKey:F_ID]), PHOTO_ID, _postSthView.describeTextView.text, MESSAGE, ONE, FRIEND, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, emptystr(_latStr), LAT, emptystr(_lngStr), LNG, emptystr(_addressStr), ADDRESS, IPHONE, COME, ONE, MAKE_FEED, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, ONE, PHOTO_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tipStr = _dataDict ? @"转载照片成功" : @"发布照片成功";
        [MPNotificationView notifyWithText:tipStr detail:nil andDuration:kNotifyForOpertingTime];
        //        [SVProgressHUD showSuccessWithStatus:tipStr];
        [self pushToFeedDetailWithDict:dict];
        //        [self performBlock:^(id sender) {
        //            [self.navigationController dismissModalViewControllerAnimated:YES];
        //        } afterDelay:0.7f];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [MPNotificationView notifyWithText:@"发送失败T_T" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [MPNotificationView notifyWithText:@"发送失败，存入草稿箱中" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//发布日志
- (void)postDiary:(id)sender {
    NSString *reSinaWeibo = _sinaBtn.selected ? ONE : ZERO;
    NSString *reTcWeibo = ZERO;// tcweiboBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"reblog" : @"blog";
    NSString *url = $str(@"%@%@", POST_CP_API, cpStr);
    
    NSMutableDictionary *para = nil;
    if (!_dataDict) {//非转载
        NSString *toWhom = _topicId ? ZERO : ONE;
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postSthView.describeTextView.text, MESSAGE, ONE, BLOG_SUBMIT, MY_M_AUTH, M_AUTH , emptystr(_latStr), LAT,emptystr(_lngStr), LNG, IPHONE, COME, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, emptystr(_addressStr), ADDRESS, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, toWhom, FRIEND, [self compoentStrWithArray:_picIdsArray], PIC_ID_S, ONE, MAKE_FEED, emptystr(_topicId), TOPIC_ID, nil];
    } else {//转载
        //        NSString *tmpStr = _blogDescriStr;
        //        self.blogDescriStr = $str(@"<p>%@</p>\n%@", upPostView.describeTextView.text, tmpStr);
        self.blogDescriStr = _postSthView.describeTextView.text;
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_dataDict objectForKey:F_ID], BLOG_ID, _blogDescriStr, MESSAGE, ONE, BLOG_SUBMIT, MY_M_AUTH, M_AUTH , emptystr(_latStr), LAT, emptystr(_lngStr), LNG, IPHONE, COME, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, emptystr(_postSthView.locationBtn.titleLabel.text), ADDRESS, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, ONE, FRIEND, [self compoentStrWithArray:_picIdsArray], PIC_ID_S, ONE, MAKE_FEED, nil];
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tipStr = _dataDict ? @"转载日志成功" : @"发布日志成功";
        [MPNotificationView notifyWithText:tipStr detail:nil andDuration:kNotifyForOpertingTime];
        //        [SVProgressHUD showSuccessWithStatus:tipStr];
        [self pushToFeedDetailWithDict:dict];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        //        [MPNotificationView notifyWithText:@"发送失败，存入草稿箱中" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        [MPNotificationView notifyWithText:@"发送失败T_T" detail:nil andDuration:kNotifyForSuccessOrFailTime];
    }];
}

//得到我想说的数据内容
- (void)getWantToSayTitles {
    if (_wantToSayDict) {
        _wantToSayArray = [[_wantToSayDict objectForKey:@"wid"] allValues];
        [_postSthView.wantToSayTable reloadData];
        return;
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *url = $str(@"%@cp.php?ac=isay&m_auth=%@", BASE_URL, MY_M_AUTH);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [SVProgressHUD dismiss];
        _wantToSayDict = [dict objectForKey:WEB_DATA];
        _wantToSayArray = [[_wantToSayDict objectForKey:@"wid"] allValues];
        [_postSthView.wantToSayTable reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//发表“我想说”
- (void)postWantToSay:(id)sender {
    NSString *url = $str(@"%@isay", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postSthView.describeTextView.text, MESSAGE, ONE, SAY_SUBMIT, IPHONE, COME, ONE, MAKE_FEED, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"发表“我想说”成功" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showSuccessWithStatus:@"发表我想说的话了"];
        [self performBlock:^(id sender) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        } afterDelay:0.5f];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        //        [MPNotificationView notifyWithText:@"发送失败，存入草稿箱中" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        [MPNotificationView notifyWithText:@"发送失败T_T" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

//发表活动
- (void)postEvent:(id)sender {
    NSString *reSinaWeibo = _sinaBtn.selected ? ONE : ZERO;
    NSString *reTcWeibo = ZERO;//tcweiboBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"reevent" : @"event";
    NSString *url = $str(@"%@%@", POST_CP_API, cpStr);
    
    //    NSString *startTimeStamp = [NSString stringWithFormat:@"%ld", (long)[_datePicker.date timeIntervalSince1970]];
    NSMutableDictionary *para = nil;
    if (!_dataDict) {//非转载
        NSString *toWhom = _topicId ? ZERO : ONE;
        //2个地方要describeTextView
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postSthView.describeTextView.text, TITLE, @"", LOCATION, _postSthView.timeBtn.titleLabel.text, START_TIME, @"1", CLASS_ID, _postSthView.describeTextView.text, DETAIL, [self compoentStrWithArray:_picIdsArray], PIC_ID_S, toWhom, FRIEND, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, ONE, EVENT_SUBMIT, MY_M_AUTH, M_AUTH , emptystr(_latStr), LAT,emptystr(_lngStr), LNG, IPHONE, COME, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, emptystr(_addressStr), ADDRESS, ONE, MAKE_FEED, emptystr(_topicId), TOPIC_ID, nil];
    } else {//转载
        para = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_dataDict objectForKey:F_ID], EVENT_ID, _postSthView.describeTextView.text, TITLE, @"", LOCATION, _postSthView.timeBtn.titleLabel.text, START_TIME, @"1", CLASS_ID, _postSthView.describeTextView.text, DETAIL, [self compoentStrWithArray:_picIdsArray], PIC_ID_S, ONE, FRIEND, _menuViewInBottom.albumBtn.titleLabel.text, TAG_S, [self compoentStrWithArray:_withFriendsArray], FRIEND_S, ONE, EVENT_SUBMIT, MY_M_AUTH, M_AUTH , emptystr(_latStr), LAT,emptystr(_lngStr), LNG, IPHONE, COME, reSinaWeibo, MAKE_SINA_WEIBO, reTcWeibo, MAKE_QQ_WEIBO, emptystr(_addressStr), ADDRESS, ONE, MAKE_FEED, nil];
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        NSString *tipStr = _dataDict ? @"转载活动成功" : @"发布活动成功";
        [MPNotificationView notifyWithText:tipStr detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showSuccessWithStatus:tipStr];
        [self pushToFeedDetailWithDict:dict];
        //        [self performBlock:^(id sender) {
        //            [self.navigationController dismissModalViewControllerAnimated:YES];
        //        } afterDelay:0.7f];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        //        [MPNotificationView notifyWithText:@"发送失败，存入草稿箱中" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        [MPNotificationView notifyWithText:@"发送失败T_T" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

- (void)postPM:(id)sender {
    //    [SVProgressHUD showWithStatus:@"发送中..."];
    NSString *url = $str(@"%@pm&op=send", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postPMUserId, PM_TO_UID, _postSthView.describeTextView.text, MESSAGE, emptystr(_latStr), LAT,emptystr(_lngStr), LNG, emptystr(_addressStr), ADDRESS, IPHONE, COME, ONE, PM_SUBMIT, MY_M_AUTH, M_AUTH, nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParams:url params:para addData:^(id<AFMultipartFormData> formData) {
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [MPNotificationView notifyWithText:@"发送私信成功" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showSuccessWithStatus:@"发送私信成功"];
        [self performBlock:^(id sender) {
            [self.navigationController dismissModalViewControllerAnimated:YES];
        } afterDelay:0.5f];
    } failure:^(NSError *error) {
        NSLog(@"error:%@", [error description]);
        //        [MPNotificationView notifyWithText:@"发送失败，存入草稿箱中" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        [MPNotificationView notifyWithText:@"发送失败T_T" detail:nil andDuration:kNotifyForSuccessOrFailTime];
        //        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}

#pragma mark - 选择活动时间
- (void)timeBtnPressed:(id)sender {
    UIDatePicker *tmpPicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    tmpPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    tmpPicker.datePickerMode = UIDatePickerModeDateAndTime;
    CGSize pickerSize = [tmpPicker sizeThatFits:CGSizeZero];
    tmpPicker.frame = [self pickerFrameWithSize:pickerSize];
    
    [tmpPicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *topViewOfPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 40)];
    topViewOfPicker.barStyle = UIBarStyleBlack;
    //当前时间
    UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered handler:^(id sender) {
        tmpPicker.date = [NSDate date];
        [self valueChange:tmpPicker];
    }];
    //空格
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //    //取消按钮
    //    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
    //        [self removePicker];
    //    }];
    //完成按钮
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [self removePicker];
    }];
    NSArray *btnArray = [NSArray arrayWithObjects:currDateBtn, spaceBtn, doneBtn, nil];
    [topViewOfPicker setItems:btnArray];
    [tmpPicker addSubview:topViewOfPicker];
    self.datePicker = tmpPicker;
    
    [self.view addSubview:tmpPicker];
    
    if (!self.bgImgViewForTouch) {
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        bgImgView.backgroundColor = [UIColor blackColor];
        bgImgView.alpha = 0.6f;
        bgImgView.userInteractionEnabled = YES;
        [self.view insertSubview:bgImgView belowSubview:tmpPicker];
        [bgImgView whenTapped:^{
            [self removePicker];
        }];
        self.bgImgViewForTouch = bgImgView;
    }
}

- (void)valueChange:(id)sender {
    UIDatePicker *currDatePicker = (UIDatePicker*)sender;
    NSDate *selectedDate = [currDatePicker date];
    if ([selectedDate compare:[NSDate date]] == NSOrderedAscending) {
        [SVProgressHUD showErrorWithStatus:@"这个时间已经过去了T_T"];
        return;
    }
    [self fillTimeBtnTitleWithDate:selectedDate];
}

- (void)fillTimeBtnTitleWithDate:(NSDate*)theDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:theDate]];
    [_postSthView.timeBtn setTitle:dateString forState:UIControlStateNormal];
    [_postSthView.timeBtn setTitle:dateString forState:UIControlStateHighlighted];
    [_postSthView.timeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_postSthView.timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _postSthView.timeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_wantToSayArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WantToSayCell *cell;
    static NSString *wantToSayCellId = @"wantToSayCellId";
    cell = [tableView dequeueReusableCellWithIdentifier:wantToSayCellId];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WantToSayCell" owner:self options:nil];
		cell = [array objectAtIndex:0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = bgColor();
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        //        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    cell.textLabel.text = [[_wantToSayArray objectAtIndex:indexPath.row] objectForKey:NAME];
    if ([cell.textLabel.text isEqualToString:_postSthView.describeTextView.text]) {
        cell.textLabel.textColor = [Common theLblColor];
    } else {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_preSelectIndexPath == indexPath)
        return;
    else {
        UITableViewCell *preSelectCell = [tableView cellForRowAtIndexPath:_preSelectIndexPath];
        preSelectCell.textLabel.textColor = [UIColor darkGrayColor];
        _preSelectIndexPath  = indexPath;
    }
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [Common theLblColor];// color(157, 212, 74, 1.0);
    _postSthView.describeTextView.text = selectedCell.textLabel.text;
}

#pragma mark - JTListViewDataSource
- (NSUInteger)numberOfItemsInListView:(JTListView *)listView {
    return [_imagesArray count];
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index {
    MyViewCell *cell = (MyViewCell*)[listView dequeueReusableView];
    
    if (!cell) {
        cell = [[MyViewCell alloc] init];
        
        //选择图片的按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 0, 55, 55);
        if (_dataDict) {
            btn.userInteractionEnabled = NO;
        }
        [btn setImage:[UIImage imageNamed:@"post_camera_a_v12.png"] forState:UIControlStateNormal];
        __block UIButton *blockBtn = btn;
        [btn whenTapped:^{
            self.currBtn = blockBtn;
            NSString *destructiveStr = @"删除此图片";
            if (photoNumWithoutDefaultImage < MAX_PHOTO_NUM && ([_imagesArray count] <= MAX_PHOTO_NUM && blockBtn.tag - kTagBtnOfListViewCell == [_imagesArray count] - 1)) {
                destructiveStr = nil;//取消“删除此图片”功能
            }
            
            MyImagePickerController *picker = [[MyImagePickerController alloc] initWithParent:self];
            picker.allowsEditing = NO;
            [picker showImagePickerMenu:@"上传图片" buttonTitle:@"打开相机" destructiveTitle:destructiveStr sender:blockBtn otherTitle:nil];
            
            [picker.ImagePickerMenu setHandler:^{//删除
                [_imagesArray removeObjectAtIndex:blockBtn.tag - kTagBtnOfListViewCell];
                if (photoNumWithoutDefaultImage == MAX_PHOTO_NUM) {
                    [_imagesArray addObject:[UIImage imageNamed:@"post_camera_a_v12.png"]];
                }
                photoNumWithoutDefaultImage--;
                [_postSthView.jtListView reloadData];
            } forButtonAtIndex:picker.ImagePickerMenu.destructiveButtonIndex];
        
            [picker.ImagePickerMenu showInView:self.view];
        }];
        cell.button = btn;
        [cell addSubview:btn];
    }
    cell.button.tag = kTagBtnOfListViewCell + index;
    if (_dataDict) {//转发的
        if ([_dataDict objectForKey:PIC_LIST]) {//从动态详情进来的
            [cell.button setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[[[_dataDict objectForKey:PIC_LIST] objectAtIndex:index] objectForKey:PIC] delLastStrForYouPai], ypHeadSize)] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
        } else {//从动态列表进来的
            NSString *imgKeyStr = $str(@"image_%d", imgIndex + 1);
            if (!isEmptyStr([_dataDict objectForKey:imgKeyStr])) {
                imgIndex++;
                [cell.button setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[_dataDict objectForKey:imgKeyStr] delLastStrForYouPai], ypHeadSize)] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
            }
        }
    } else {//非转发的
        [cell.button setImage:[_imagesArray objectAtIndex:index] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self performBlock:^(id sender) {
        if (_postSthType == postPhoto) {
            int btnIndex = _currBtn.tag - kTagBtnOfListViewCell;
            if (btnIndex >= [_imagesArray count] - 1) {//最后一个增加图片的按钮
                photoNumWithoutDefaultImage++;
                [_currBtn setImage:image forState:UIControlStateNormal];
                [_imagesArray replaceObjectAtIndex:[_imagesArray count] - 1 withObject:image];
                
                if ([_imagesArray count] < MAX_PHOTO_NUM) {
                    [_imagesArray addObject:[UIImage imageNamed:@"post_camera_a_v12.png"]];
                    [_postSthView.jtListView reloadData];
                    [_postSthView.jtListView goForward:YES];
                }
                
            } else {
                [_imagesArray replaceObjectAtIndex:btnIndex withObject:image];
                [_postSthView.jtListView reloadData];
            }
            self.currBtn = nil;
        } else if (_postSthType == postActivity) {
            self.eventImg = image;
            [_postSthView.eventImgBtn setImage:image forState:UIControlStateNormal];
        }
    } afterDelay:0.2f];
}

#pragma mark - JTListViewDelegate

- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return 65;
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return 55;
}

#pragma mark - 转发 填写数据
//- (void)fillTheSameData {
//    [downPostView.albumBtn setTitle:[[_dataDict objectForKey:TAG] objectForKey:TAG_NAME] forState:UIControlStateNormal];
//    [downPostView.albumBtn setTitle:[[_dataDict objectForKey:TAG] objectForKey:TAG_NAME] forState:UIControlStateHighlighted];
//    self.latStr = [_dataDict objectForKey:LAT];
//    self.lngStr = [_dataDict objectForKey:LNG];
//    self.addressStr = [_dataDict objectForKey:ADDRESS];
//    if (!self.withFriendsArray) {
//        _withFriendsArray = [[NSMutableArray alloc] init];
//    } else if ([_withFriendsArray count] > 0) {
//        [self setAvatarForTogether];
//    }
//    if (self.downPostView.mapView && !isEmptyStr(_latStr) && !isEmptyStr(_lngStr)) {
//        self.downPostView.locationBtn.hidden = YES;
//        self.downPostView.locaiontLbl.hidden = YES;
//
//        MKCoordinateSpan span;
//        MKCoordinateRegion region;
//
//        span.latitudeDelta = 0.010;
//        span.longitudeDelta = 0.010;
//        region.span = span;
//        CLLocationCoordinate2D coordinate;
//        coordinate.latitude = [self.latStr doubleValue];
//        coordinate.longitude = [self.lngStr doubleValue];
//        region.center = coordinate;
//        [self.downPostView.mapView setRegion:[self.downPostView.mapView regionThatFits:region] animated:YES];
//        DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:coordinate addressDictionary:nil];
//        annotation.title = @"我在这里";
////        annotation.subtitle = @"";
//        [self.downPostView.mapView addAnnotation:annotation];
//    }
//}

- (void)fillPhotoData {
    [_postSthView.jtListView reloadData];
    //    upPostView.describeTextView.text = $str(@"\n%@", [_dataDict objectForKey:MESSAGE]);
//#warning tag字段里面没有数据时要做一下判断
//    if (![[_dataDict objectForKey:TAG] isEqual:[NSNull null]]) {
//        self.tagName = emptystr([[_dataDict objectForKey:TAG] objectForKey:TAG_NAME]);
//    } else
//        self.tagName = @"默认空间";
    [_postSthView.describeTextView becomeFirstResponder];
    //将光标定位到首位置
    _postSthView.describeTextView.selectedRange = NSMakeRange(0, 0);
}

- (void)fillBlogData {
    self.blogDescriStr = [_dataDict objectForKey:MESSAGE];
    _postSthView.describeTextView.text = @"";
    [_postSthView.describeTextView becomeFirstResponder];
//    self.tagName = emptystr([[_dataDict objectForKey:TAG] objectForKey:TAG_NAME]);
}

- (void)fillVideoData {
//    self.tagName = emptystr([[_dataDict objectForKey:TAG] objectForKey:TAG_NAME]);
}

- (void)fillEventData {
    BOOL isFromFeedList = isEmptyStr(START_TIME) ? NO : YES;
    
    NSString *titleKeyStr = isFromFeedList ? SUBJECT : TITLE;
    _postSthView.describeTextView.text = [_dataDict objectForKey:titleKeyStr];
//    _postSthView.firstTextField.text = [_dataDict objectForKey:titleKeyStr];
    
    NSString *timeKeyStr = isFromFeedList ? EVENT_START_TIME : START_TIME;
    [_postSthView.timeBtn setTitle:[Common dateConvert:[_dataDict objectForKey:timeKeyStr]] forState:UIControlStateNormal];
    [_postSthView.timeBtn setTitle:[Common dateConvert:[_dataDict objectForKey:timeKeyStr]] forState:UIControlStateHighlighted];
    [_postSthView.timeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_postSthView.timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    if (!isEmptyStr([_dataDict objectForKey:POSTER])) {
        [_postSthView.eventImgBtn setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [emptystr([_dataDict objectForKey:POSTER]) delLastStrForYouPai], ypHeadSize)] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
    }
//    self.tagName = emptystr([[_dataDict objectForKey:TAG] objectForKey:TAG_NAME]);
}

#pragma mark - 分享
- (IBAction)markWeibo:(UIButton*)sender {
    if (sender == _sinaBtn) {
        if (!sender.selected) {
            if (MY_HAS_BIND_SINA_WEIBO) {
                //            if (sinaWiebo.isAuthValid && !sinaWiebo.isAuthorizeExpired ) {
                //                if ((MY_HAS_BIND_SINA_WEIBO && [[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) && sinaWiebo.isAuthValid && !sinaWiebo.isAuthorizeExpired ) {
                sender.selected = !sender.selected;
            } else {
                [self loginSinaWeibo];
            }
        } else {
            sender.selected = !sender.selected;
        }
    } else {
        sender.selected = !sender.selected;
    }
}

- (NSString*)compoentStrWithArray:(NSMutableArray*)array {
    NSString *finalStr = @"";
    if ([array count] < 1) {
        return finalStr;
    }
    
    for (int i = 0; i < [array count]; i++) {
        if (i == 0) {
            if ([[array objectAtIndex:0] isKindOfClass:[NSString class]]) {
                finalStr = [array objectAtIndex:0];//图片的
            } else
                finalStr = [[array objectAtIndex:0] objectForKey:UID];//和谁在一起的
        } else {
            if ([[array objectAtIndex:i] isKindOfClass:[NSString class]]) {
                finalStr = $str(@"%@|%@", finalStr, [array objectAtIndex:i]);//图片的
            } else
                finalStr = $str(@"%@|%@", finalStr, [[array objectAtIndex:i] objectForKey:UID]);//和谁在一起的
        }
    }
    return finalStr;
}

#pragma mark - sina weibo
- (void)loginSinaWeibo {
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SINA_AUTH_DATA]) {
        [sinaweibo logOut];
    } else {
        [sinaweibo logIn];
    }
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate = self;
    return delegate.sinaweibo;
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:SINA_AUTH_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
}
#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_BIND_SINA_WEIBO];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    [self uploadRequestToBindSinaWeibo];
    _sinaBtn.selected = YES;
    //    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SINA_AUTH_DATA];
    if (MY_HAS_LOGIN) {
        [sinaweibo logIn];
    }
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_BIND_SINA_WEIBO];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [self removeAuthData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新浪微博授权已过期，是否重新授权?"];
    [alert addButtonWithTitle:@"重新授权" handler:^{
        [sinaweibo logOut];
    }];
    [alert setCancelButtonWithTitle:@"取消" handler:^{
        return ;
    }];
    [alert show];
}

#pragma mark - 微信
- (void)showWeixin {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否分享至微信?"];
    [alert setCancelButtonWithTitle:@"取消" handler:^{
        return ;
    }];
    [alert addButtonWithTitle:@"是" handler:^{
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"];
            [acSheet addButtonWithTitle:@"分享给微信好友" handler:^{
                _scene = WXSceneSession;
                [self sendContent];
            }];
            if ([[WXApi getWXAppSupportMaxApiVersion] floatValue] > 1.1) {
                [acSheet addButtonWithTitle:@"分享到朋友圈" handler:^{
                    _scene = WXSceneTimeline;
                    [self sendContent];
                }];
            }
            [acSheet setCancelButtonWithTitle:@"取消" handler:^{
                return ;
            }];
            acSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [acSheet showInView:self.view];//[[UIApplication sharedApplication]keyWindow]];
        } else {
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"" message:@"你的iPhone上还没有安装微信，无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"];
            [alView setCancelButtonWithTitle:@"取消" handler:^{
                return ;
            }];
            [alView addButtonWithTitle:@"免费下载微信" handler:^{
                NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
            }];
            [alView show];
        }
    }];
    [alert show];
}

- (void)sendContent {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //文本＋图片
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = @"Family社区";
        
        //        NSString *msgStr = expandView.postType == postActivity ? upPostView.firstTextField.text : upPostView.describeTextView.text;
        message.description = [AppDelegate app].sendToWeixinContent;// msgStr;
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iTunesArtwork" ofType:@"png"]];
        image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.4f)];//SDK协议中对缩略图的大小作了限制，大小不能超过32K
        [message setThumbImage:image];
        
        WXAppExtendObject *ext = [WXAppExtendObject object];
        //        ext.extInfo = @"<xml>test</xml>";
        ext.url = @"https://itunes.apple.com/us/app/family/id538285014?ls=1&mt=8";//若未安装Family，则跳去appstore下载
        
#define BUFFER_SIZE 1024 * 100
        Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
        memset(pBuffer, 0, BUFFER_SIZE);
        NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
        free(pBuffer);
        
        ext.fileData = data;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = _scene;
        
        [WXApi sendReq:req];
    }
}

@end
