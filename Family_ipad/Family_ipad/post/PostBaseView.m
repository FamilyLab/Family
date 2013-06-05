//
//  PostBaseView.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-9.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "PostBaseView.h"
#import "MyHttpClient.h"
#import "ZoneTableViewController.h"
#import "DetailBaseViewController.h"
#import "UIView+BlocksKit.h"
#import "UIBarButtonItem+BlocksKit.h"
#import "UIImageView+AFNetworking.h"
#import "UIActionSheet+BlocksKit.h"
#import "NSString+ConciseKit.h"
#import "Common.h"
#import "KGModal.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MapAroundViewController.h"
#import "SSLoadingView.h"
#import "MPNotificationView.h"
#define TEXT_WIDTH 345
#define TEXT_HEIGHT 82
#define FRIENDBUTTON_WIDTH 175
#define FRIENDBUTTON_HEIGHT 45
#define kBASEFRIEND_TAG     10000
#define kBASEPOSTIMG_TAG    100000

#define WANTOSAYFRAME_A   CGRectMake(77,33,399,45)
#define WANTOSYAFRAME_B   CGRectMake(377,33,91,45)
#define ADD_PHOTO_FRAME   CGRectMake(275,34,82,82)
#define MUTILPLE_ADD_PHOTO_FRAME CGRectMake(13,29,82,82)
#define POST_ACT_TITLE_FRAME    CGRectMake(13,34,248,82)
#define ADDIMAGE_X  13
#define ADDIMAGE_Y  29
#define ypHeadSize          @"!120X120"
#define TEXT_HODLER     @"写点什么吧..."
#define ISAY            @"我在"
#define WEATHER            @"天气"
#define ONWAY            @"路上"
#define BLESS            @"祝福"
#define WANTTOSAY       @"我想说"
#define POST_DIRARY     @"发日记"
#define POST_PHOTO      @"发照片"
#define POST_ACT        @"发活动"
#define POST_PM         @"发私信"
#define POST_VIDEO       @"发视频"
#define UPLOAD_PHOTO    @"uploadphoto"
#define UPLOAD_PIC      @"uploadpic"
#define MAKEFEEDCON     @"1"
#define kTagTogetherImgViewOfPostView   210
#define kNotifyForOpertingTime           0.5f//“后台发送中...”这几个字要显示的时间

@implementation PostBaseView
- (void)postFailHander:(NSDictionary *)dict
{
    [MPNotificationView notifyWithText:@"发送失败" detail:@"存入草稿箱.." andDuration:kNotifyForOpertingTime];
    [self saveToDraft:dict];
}
- (void)saveToDraft:(NSDictionary *)dict
{
    _draftArray =  [ConciseKit userDefaultsObjectForKey:DRAFT];
    if (_draftArray==nil) {
        _draftArray = $marrnew;
    }
    [_draftArray addObject:dict];
    [ConciseKit setUserDefaultsWithObject:_draftArray forKey:DRAFT];
    
}
- (void)showDetail:(NSString *)idtype
           feed_id:(NSString *)feed_id
           user_id:(NSString *)user_id
     feedCommentId:(NSString *)feedCommentId
{
    [MPNotificationView notifyWithText:@"发送成功" detail:nil andDuration:kNotifyForOpertingTime];

    if (!self.backgroundImage.hidden) {
        REMOVEDETAIL;
        
//        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//        detailViewController.idType = idtype;
//        detailViewController.feedId = feed_id;
//        detailViewController.userId = MY_UID;
//        detailViewController.feedCommentId = feedCommentId;
//        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:nil isStackStartView:FALSE];
    }else{
        [self.parent dismissModalViewControllerAnimated:YES];
    }
    
    
}
- (IBAction)markWeibo:(UIButton *)sender
{
    sender.selected = !sender.selected;
}
- (void)uploadImage:(NSString *)op
             _image:(UIImage *)_image
         _pic_title:(NSString *)_pic_title
{
    NSString *url = $str(@"%@upload", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:op, OP, POST_M_AUTH, M_AUTH, nil];
    if (_image.size.width > 1024) {//宽度超过1024要等比压缩
        float scaleSize = (float)1024 / (float)_image.size.width;
        _image = [Common scaleImage:_image toScale:scaleSize];
    }
    
    //超过1M的要压缩一下
    CGFloat compression = 0.7f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 1024*300;//1M = 1024 x 1024 b = 1048576b
    NSData *imageData = (__bridge NSData*)CGDataProviderCopyData(CGImageGetDataProvider(_image.CGImage));//或者用_image.size.width * _image.size.height * 4 也可得出图片的大小
    if (imageData.length > maxFileSize) {
        imageData = UIImageJPEGRepresentation(_image,1.0f);
    }
    while (imageData.length > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(_image, compression);
    }
    //_image = [UIImage imageWithData:imageData];

    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        if (_index == 0) {
            _postImgString = [[dict objectForKey:WEB_DATA] objectForKey:PICID];
        }
        else {
            _postImgString = $str(@"%@|%@",_postImgString,[[dict objectForKey:WEB_DATA] objectForKey:PICID]);
        }
        _index++;
        if (_index<[_imagesArray count]){
            [self uploadImage:UPLOAD_PHOTO _image:[_imagesArray objectAtIndex:_index]  _pic_title:@""];
        }
        else{
            if ([_titleButton.titleLabel.text isEqualToString:POST_PHOTO])
                if (!_topicID)
                    [self postPhoto:nil];
                else
                    [self postPhoto:_topicID];
                else if ([_titleButton.titleLabel.text isEqualToString:POST_DIRARY])
                    [self postDiary:nil];
                else if ([_titleButton.titleLabel.text isEqualToString:POST_ACT])
                    [self postAct:nil];
            
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
    }];
}
- (void)postAct:(id)sender
{
    NSString * reWeibo = _weiboBtn.selected?ONE:ZERO;
    NSString *reTcWeibo = _tencentBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"reevent" : @"event";
    
    NSString *url = $str(@"%@%@", POST_CP_API,cpStr);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_titleTextView.text, AD_TITLE,_titleTextView.text, DETAIL, ONE, EVENT_SUBMIT, POST_M_AUTH,M_AUTH ,MY_LATITUDE,LAT,MY_LONGITUDE,LNG,COME_VERSION,COME,reWeibo,MAKE_WEIBO,reTcWeibo,MAKE_QQ_WEIBO,_postion,ADDRESS,[self compoentStrWithArray:_withFamilyArray],FRIENDS,$str(@"%@",_zoneBtn.titleLabel.text),TAGS,ONE,FRIEND,_titleTextView.text,AD_TITLE,MAKEFEEDCON,MAKE_FEED,_contentTextView.text,START_TIME, ONE, CLASS_ID,_postImgString,PICIDS,nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [self showDetail:EVENT_ID feed_id:[[dict objectForKey:WEB_DATA] objectForKey:ID_] user_id:[[dict objectForKey:WEB_DATA] objectForKey:UID] feedCommentId:[[dict objectForKey:WEB_DATA] objectForKey:ID_]];    } failure:^(NSError *error) {
            [self postFailHander:para];

        }];
}
- (void)postDiary:(id)sender
{
    
    NSString * reWeibo = _weiboBtn.selected?ONE:ZERO;
    NSString *reTcWeibo = _tencentBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"reblog" : @"blog";
    
    NSString *url = $str(@"%@%@", POST_CP_API,cpStr);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_contentTextView.text, MESSAGE, _contentTextView.text,SUBJECT,ONE, BLOG_SUBMIT, POST_M_AUTH,M_AUTH ,MY_LATITUDE,LAT,MY_LONGITUDE,LNG,COME_VERSION,COME,reWeibo,MAKE_WEIBO,reTcWeibo,MAKE_QQ_WEIBO,_postion,ADDRESS,[self compoentStrWithArray:_withFamilyArray],FRIENDS,$str(@"%@",_zoneBtn.titleLabel.text),TAGS,ONE,FRIEND,_postImgString,PICIDS,MAKEFEEDCON,MAKE_FEED,nil];
    if (_dataDict) {
        [para setObject:[_dataDict objectForKey:F_ID] forKey:BLOG_ID];
        if ([_contentTextView.text length]>0) {
            [para setObject:$str(@"<p>%@</p>\n%@", _contentTextView.text, [_dataDict objectForKey:MESSAGE]) forKey:MESSAGE];
        }
        
    }

    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        [self showDetail:BLOG_ID feed_id:[[dict objectForKey:WEB_DATA] objectForKey:ID_] user_id:[[dict objectForKey:WEB_DATA] objectForKey:UID] feedCommentId:[[dict objectForKey:WEB_DATA] objectForKey:ID_]];
    } failure:^(NSError *error) {
        [self postFailHander:para];

    }];
}
- (void)postPhoto:(id)sender
{
    NSString * reWeibo = _weiboBtn.selected?ONE:ZERO;
    NSString *reTcWeibo = _tencentBtn.selected ? ONE : ZERO;
    NSString *cpStr = _dataDict ? @"rephoto" : @"photo";
    
    NSString *url = $str(@"%@%@", POST_CP_API,cpStr);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_contentTextView.text, MESSAGE, ONE, PHOTO_SUBMIT, POST_M_AUTH,M_AUTH ,MY_LATITUDE,LAT,MY_LONGITUDE,LNG,COME_VERSION,COME,reWeibo,MAKE_WEIBO,reTcWeibo,MAKE_QQ_WEIBO,_postion,ADDRESS,[self compoentStrWithArray:_withFamilyArray],FRIENDS,$str(@"%@",_zoneBtn.titleLabel.text),TAGS,ONE,FRIEND,_postImgString,PICIDS,MAKEFEEDCON,MAKE_FEED,nil];
    if (_dataDict) {
        [para removeObjectForKey:PICIDS];
        if ([_dataDict objectForKey:PHOTO_ID]) {
            [para setObject:[_dataDict objectForKey:PHOTO_ID] forKey:PHOTO_ID];
        }else if ([_dataDict objectForKey:F_ID])
            [para setObject:[_dataDict objectForKey:F_ID] forKey:PHOTO_ID];
        
    }
    if (sender) {
        [para setObject:ZERO forKey:FRIEND];
        [para setObject:sender forKey:@"topicid"];
    }
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        
        [self showDetail:PHOTO_ID feed_id:[[dict objectForKey:WEB_DATA] objectForKey:ID_] user_id:[[dict objectForKey:WEB_DATA] objectForKey:UID] feedCommentId:[[dict objectForKey:WEB_DATA] objectForKey:ID_]];
    } failure:^(NSError *error) {
        [self postFailHander:para];
    }];
}
- (void)postPM:(id)sender
{
    NSString *url = $str(@"%@pm&op=send", POST_CP_API);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_contentTextView.text, MESSAGE,_touid,PM_TO_UID,ONE, PM_SUBMIT, POST_M_AUTH,M_AUTH ,MY_LATITUDE,LAT,MY_LONGITUDE,LNG,COME_VERSION,COME,_postion,ADDRESS,nil];
    [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
        ;
    } onCompletion:^(NSDictionary *dict) {
        if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
            return ;
        }
        REMOVEDETAIL;
    } failure:^(NSError *error) {
    }];
}
- (IBAction)okBtnAction:(id)sender
{
    [MPNotificationView notifyWithText:@"后台发送中..." detail:nil andDuration:kNotifyForOpertingTime];
    //NSString *url = $str(@"%@upload", POST_API);
    // NSString * reWeibo = _weiboBtn.selected?ONE:ZERO;
    if ([_titleButton.titleLabel.text isEqualToString:WANTTOSAY]) {
        NSString *url = $str(@"%@isay", POST_CP_API);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:_wantToSayInput.text, MESSAGE, ONE, SAY_SUBMIT,POST_M_AUTH,M_AUTH,COME_VERSION,COME,ONE,MAKE_FEED,nil];
        [[MyHttpClient sharedInstance] commandWithPathAndParamsAndNoHUD:url params:para addData:^(id<AFMultipartFormData> formData) {
            ;
        } onCompletion:^(NSDictionary *dict) {
            if ([[dict objectForKey:WEB_ERROR] intValue] != 0) {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:WEB_MSG]];
                return ;
            }
            REMOVEDETAIL;
        } failure:^(NSError *error) {
        }];
        
    }
    else if ([_titleButton.titleLabel.text isEqualToString:POST_DIRARY]){
        if ([_imagesArray count] == 0)
            [self postDiary:nil];
        else{
            _index = 0;
            ;
            [self uploadImage:UPLOAD_PIC _image:[_imagesArray objectAtIndex:_index] _pic_title:_contentTextView.text];
        }
    }
    else if([_titleButton.titleLabel.text isEqualToString:POST_PHOTO]){
        _index = 0;
        ;
        if ([_imagesArray count]>0)
            [self uploadImage:UPLOAD_PHOTO _image:[_imagesArray objectAtIndex:_index]  _pic_title:_contentTextView.text];
        else
            [SVProgressHUD showErrorWithStatus:@"请上传至少一张图片"];
        
    }
    else if([_titleButton.titleLabel.text isEqualToString:POST_ACT]){
        if ([_imagesArray count] == 0)
            [self postAct:nil];
        else{
            _index = 0;
            [self uploadImage:UPLOAD_PHOTO _image:[_imagesArray objectAtIndex:_index] _pic_title:@""];
        }
        
    }
    else if ([_currentAction isEqualToString:POST_PM]){
        [self postPM:nil];
        
    }
    
}
- (IBAction)selectFamily:(UIButton *)sender
{
    //    self.pickerMode = familyName;
    //    [self getFriend:sender];
    [_withFamilyArray  removeAllObjects];
    
    DetailBaseViewController *con = [[DetailBaseViewController alloc]initWithNibName:@"DetailBaseViewController" bundle:nil];
    con.modalPresentationStyle = UIModalPresentationFormSheet;
    if (sender.tag<kBASEFRIEND_TAG)
        con.allowmutilpleSelect = YES;
    else con.allowmutilpleSelect = NO;
    con.parent = self;
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:self.parent isStackStartView:FALSE];
}
- (void)showZonePicker:(UIButton *)sender;
{
    UIPickerView *zonePicker = [[UIPickerView alloc] init];
    zonePicker.showsSelectionIndicator = YES;
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    zonePicker.dataSource = self;
    zonePicker.delegate = self;
    //    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, zonePicker.frame.size.width, 44)];
    //    toolbar.barStyle = UIBarStyleBlack;
    //    //        UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered target:self action:@selector(currDateBtnPressed)];
    //    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
    //        [_zonePickerContainer dismissPopoverAnimated:YES];
    //    }];
    //    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //
    //    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
    //
    //
    //        [_zonePickerContainer dismissPopoverAnimated:YES];
    //
    //    }];
    //    NSArray *btnArray = [NSArray arrayWithObjects:spaceBtn, cancleBtn, doneBtn, nil];
    //    [toolbar setItems:btnArray];
    //datePicker.center = self.view.center;
    //add this picker to our view controller, initially hidden
    //build our custom popover view
    UIViewController* popoverContent = [[UIViewController alloc]                                            init];
    UIView* popoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    zonePicker.frame = CGRectMake(0, 0, 320, 300);
    // [popoverView addSubview:toolbar];
    [popoverView addSubview:zonePicker];
    popoverContent.view = popoverView;        //resize the popover view shown        //in the current view to the view&apos;s size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 200);        //create a popover controller
    _zonePickerContainer = [[UIPopoverController alloc]                                  initWithContentViewController:popoverContent];       //present the popover view non-modal with a        //refrence to the button pressed within the current view
    CGRect rect = CGRectMake(sender.frame.origin.x/2, sender.frame.origin.y-150, 320, 300) ;
    
    [_zonePickerContainer presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)selectAlbumn:(UIButton *)sender
{
    self.pickerMode = zoneName;
    [self getZoneName:sender];
    //    ZoneTableViewController *detailViewController = [[ZoneTableViewController alloc]initWithNibName:@"ZoneTableViewController" bundle:nil];
    //    detailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    //    //detailViewController.isFromZone = YES;
    //    detailViewController.isFromPost = YES;
    //    detailViewController.parent = self;
    //    [self.parent presentModalViewController:detailViewController animated:YES];
    //    detailViewController.view.superview.frame = CGRectMake(0, 0, 480, 768);//it's important to do this after
    //    detailViewController.view.superview.center = CGPointMake(1024/2, 768/2);
    
}
/**
 * 获取设备的经纬度信息
 * @param 无
 * @return 无
 */
- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 100;
    
    [_locationManager startUpdatingLocation];
}

- (void)onlyContentView
{
    if (_contentView.hidden) {
        _contentView.hidden = NO;
        _wantToSayInputView.hidden = YES;
    }
    _titleTextView.hidden = YES;
    _contentTextView.frame = CGRectMake(13, 34, TEXT_WIDTH, TEXT_HEIGHT*2);
}
- (void)titleAndContentView
{
    if (_contentView.hidden) {
        _contentView.hidden = NO;
        _wantToSayInputView.hidden = YES;
        
    }
    _titleTextView.frame = CGRectMake(13, 34, TEXT_WIDTH, TEXT_HEIGHT);
    _titleTextView.hidden = NO;
    _contentTextView.frame = CGRectMake(13, 124, TEXT_WIDTH, TEXT_HEIGHT);
}

- (void)loadFriendList
{
    UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendButton setBackgroundImage: [UIImage imageNamed:@"post_pmbg.png"] forState:UIControlStateNormal];
    friendButton.tag = kBASEFRIEND_TAG;
    [friendButton setTitle:@"选择家人" forState:UIControlStateNormal];
    friendButton.frame = CGRectMake(30, 137, FRIENDBUTTON_WIDTH, FRIENDBUTTON_HEIGHT);
    [friendButton addTarget:self action:@selector(getFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:friendButton belowSubview:_menuView];
}
- (void)removeFriendList
{
    for (UIButton *btn in [self subviews]) {
        if (btn.tag>= kBASEFRIEND_TAG) {
            [btn removeFromSuperview];
        }
    }
}
- (IBAction)switchWantToSay:(UIButton *)sender
{
    _wantToSayArray =nil;
    if ([sender.titleLabel.text isEqualToString:ISAY])
        _wantToSayArray = [[_wantToSayDict objectForKey:@"wid"]allValues];
    else if ([sender.titleLabel.text isEqualToString:WEATHER])
        _wantToSayArray = [[_wantToSayDict objectForKey:@"tid"]allValues];
    else if ([sender.titleLabel.text isEqualToString:ONWAY])
        _wantToSayArray = [[_wantToSayDict objectForKey:@"lid"]allValues];
    else if ([sender.titleLabel.text isEqualToString:BLESS])
        _wantToSayArray = [[_wantToSayDict objectForKey:@"zid"]allValues];
    
    [_tableView reloadData];
}
- (void)setAvatarForTogether {
    for (int i = 0; i < 4; i++) {
        UIImageView *imgView = (UIImageView*)[self viewWithTag:kTagTogetherImgViewOfPostView + i];
        imgView.image = nil;
    }
    for (int i = 0; i < [_withFamilyArray count]; i++) {
        UIImageView *imgView = (UIImageView*)[self viewWithTag:kTagTogetherImgViewOfPostView + i];
        [imgView setImageWithURL:[NSURL URLWithString:[[_withFamilyArray objectAtIndex:i] objectForKey:AVATER]]];
        
    }
}
- (void)getFriend:(UIButton *)sender
{
    _zoneArray = [ConciseKit userDefaultsObjectForKey:FAMILY_LIST];
    _pickerMode = familyName;
    [self showZonePicker:sender];
    //do.php?ac=ajax&op=getfriend
    //    [[MyHttpClient sharedInstance]commandWithPath:$str(@"%@do.php?ac=ajax&op=getfriend&m_auth=%@",BASE_URL,GET_M_AUTH) onCompletion:^(NSDictionary *dict) {
    //        _zoneArray = [[dict objectForKey:WEB_DATA]objectForKey:FIRENDLIST];
    //        _pickerMode = familyName;
    //        [self showZonePicker:sender];
    //        //     [self setWithFamilyImg:_zoneArray];
    //    } failure:^(NSError *error) {
    //        ;
    //    }];
}
- (void)getZoneName:(UIButton *)sender;
{
    if ([ConciseKit userDefaultsObjectForKey:TAGLIST]) {
        _zoneArray = [ConciseKit userDefaultsObjectForKey:TAGLIST];
        [self showZonePicker:sender];
    }
    else{
        [[MyHttpClient sharedInstance]commandWithPath:$str(@"%@do.php?ac=ajax&op=taglist&m_auth=%@",BASE_URL,GET_M_AUTH) onCompletion:^(NSDictionary *dict) {
            [ConciseKit setUserDefaultsWithObject:[[dict objectForKey:WEB_DATA]objectForKey:TAGLIST] forKey:TAGLIST];
            _zoneArray = [[dict objectForKey:WEB_DATA]objectForKey:TAGLIST];
            [self showZonePicker:sender];
        } failure:^(NSError *error) {
            ;
        }];
    }
    
}
- (void)getActivityClassid{
    [[MyHttpClient sharedInstance]commandWithPath:@"http://www.familyday.com.cn/dapi/cp.php?ac=event&op=eventclass" onCompletion:^(NSDictionary *dict) {
        [_tableView reloadData];
    } failure:^(NSError *error) {
        ;
    }];
}
- (void)getWantToSayTitiles
{
    //http://www.familyday.com.cn/dapi/cp.php?ac=isay        "m_auth" = 6e63kALEKEzHdrVaYfD3ifISbbOdmxAvVPiBFMZQFFDFlfaxcHd78IXFfMjp59qqJzLjAMfIY83fdmyyTYtU;
    NSLog(@"want to say:%@", $str(@"http://www.familyday.com.cn/dapi/cp.php?ac=isay&m_auth=%@",GET_M_AUTH));
    [[MyHttpClient sharedInstance]commandWithPath:$str(@"http://www.familyday.com.cn/dapi/cp.php?ac=isay&m_auth=%@",GET_M_AUTH) onCompletion:^(NSDictionary *dict) {
        _wantToSayDict =[dict objectForKey:WEB_DATA];
        if ([_wantToSayDict isKindOfClass:[NSDictionary class]]) {
            _wantToSayArray = [[_wantToSayDict objectForKey:@"wid"]allValues];

        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        ;
    }];
}
- (void)choosedDate:(UIDatePicker *)sender
{
    NSDate *selectedDate = [sender date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
    _contentTextView.text=dateString;
}
- (void)selectDate:(UIButton *)sender
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    //note we are using CGRectZero for the dimensions of our picker view,
    //this is because picker views have a built in optimum size,
    //you just need to set the correct origin in your view.
    //
    //position the picker at the bottom
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(choosedDate:) forControlEvents:UIControlEventValueChanged];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, datePicker.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlack;
    //        UIBarButtonItem *currDateBtn = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleBordered target:self action:@selector(currDateBtnPressed)];
    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel handler:^(id sender) {
        [_zonePickerContainer dismissPopoverAnimated:YES];
    }];
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        
        NSDate *selectedDate = [datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:selectedDate]];
        _contentTextView.text=dateString;
        [_zonePickerContainer dismissPopoverAnimated:YES];
        
    }];
    NSArray *btnArray = [NSArray arrayWithObjects:spaceBtn, cancleBtn, doneBtn, nil];
    [toolbar setItems:btnArray];
    //datePicker.center = self.view.center;
    //add this picker to our view controller, initially hidden
    //build our custom popover view
    UIViewController* popoverContent = [[UIViewController alloc]                                            init];
    UIView* popoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    datePicker.frame = CGRectMake(0, 0, 320, 300);
    //[popoverView addSubview:toolbar];
    [popoverView addSubview:datePicker];
    popoverContent.view = popoverView;        //resize the popover view shown        //in the current view to the view&apos;s size
    popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 200);        //create a popover controller
    _zonePickerContainer = [[UIPopoverController alloc]                                  initWithContentViewController:popoverContent];        //present the popover view non-modal with a        //refrence to the button pressed within the current view
    CGRect rect = CGRectMake(sender.frame.origin.x/2, sender.frame.origin.y-200, 320, 300) ;
    
    [_zonePickerContainer presentPopoverFromRect:rect inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)changePostView
{
    if ([self.tableView respondsToSelector:@selector(backgroundView)])
        self.tableView.backgroundView = nil;
    [_selectDateBtn removeFromSuperview];
    _selectDateBtn = nil;
    _contentTextView.userInteractionEnabled = YES;
    _titleTextView.userInteractionEnabled = YES;
    _zoneBtn.hidden = NO;
    if ( [ConciseKit userDefaultsObjectForKey:@"lastSelectZone"]) {
        [_zoneBtn setTitle:[ConciseKit userDefaultsObjectForKey:@"lastSelectZone"] forState:UIControlStateNormal];
    }
    _postImage.hidden = YES;
    _shareView.hidden = NO;
    _downView.hidden = NO;
    for (UIImageView *img in _contentView.subviews) {
        if (img.tag>=kBASEPOSTIMG_TAG) {
            [img removeFromSuperview];
        }
    }
    [_imagesArray removeAllObjects];
    [_titleButton setTitle:_currentAction forState:UIControlStateNormal];
    
    if ([_currentAction isEqualToString:POST_DIRARY]) {
        [self onlyContentView];
        _contentTextView.placeholder = TEXT_HODLER;
    }
    else if ([_currentAction isEqualToString:POST_ACT]){
        [self titleAndContentView];
        _titleTextView.frame = POST_ACT_TITLE_FRAME;
        _postImage.hidden = NO;
        _postImage.frame = ADD_PHOTO_FRAME;
        _titleTextView.placeholder = @"名称";
        _contentTextView.placeholder = @"时间";
        _contentTextView.userInteractionEnabled = NO;
        _selectDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectDateBtn.frame = _contentTextView.frame;
        [_contentView addSubview:_selectDateBtn];
        [_selectDateBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([_currentAction isEqualToString:POST_PM]){
        [self titleAndContentView];
        _shareView.hidden =YES;
        _downView.hidden = YES;
        _zoneBtn.hidden = YES;
        [self loadFriendList];
        _titleTextView.userInteractionEnabled = NO;
        _contentTextView.placeholder = TEXT_HODLER;
    }
    else if ([_currentAction isEqualToString:WANTTOSAY]){
        _wantToSayDict = nil;
        _contentView.hidden = YES;
        _wantToSayInputView.hidden = NO;
        [self getWantToSayTitiles];
        
    }
    else if ([_currentAction isEqualToString:POST_PHOTO]){
        [self onlyContentView];
        _contentTextView.placeholder = @"给图片加点描述吧...";
        _postImage.hidden = NO;
        _contentTextView.frame = CGRectMake(13, 124, TEXT_WIDTH, TEXT_HEIGHT);
        _postImage.frame = MUTILPLE_ADD_PHOTO_FRAME;
        
    }
    else if ([_currentAction isEqualToString:POST_VIDEO]){
        [self titleAndContentView];
        _titleTextView.placeholder = @"视频介绍";
        _contentTextView.placeholder = @"黏贴网址";
    }
}
- (IBAction)postMenuAction:(UIButton *)sender
{
    _postImage.hidden = YES;
    _titleTextView.placeholder = nil;
    _contentTextView.placeholder = nil;
    [self removeFriendList];
    [_titleButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [sender setTitle:_currentAction forState:UIControlStateNormal];
    _currentAction = [NSMutableString stringWithString:_titleButton.titleLabel.text];
    [self expandMenuAction:nil];
    [self changePostView];
    
    
    
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
#pragma mark - 转发 填写数据
- (void)fillTheSameData {
    if ( [ConciseKit userDefaultsObjectForKey:@"lastSelectZone"]) {
        [_zoneBtn setTitle:[ConciseKit userDefaultsObjectForKey:@"lastSelectZone"] forState:UIControlStateNormal];
    }
//    if ([[_dataDict objectForKey:TAG]isKindOfClass:[NSDictionary class]]) {
//        [_zoneBtn setTitle:[[_dataDict objectForKey:TAG] objectForKey:TAG_NAME] forState:UIControlStateNormal];
//        [_zoneBtn setTitle:[[_dataDict objectForKey:TAG] objectForKey:TAG_NAME] forState:UIControlStateHighlighted];
//    }
    else
    {
        [_zoneBtn setTitle:@"默认空间" forState:UIControlStateNormal];
    }
    
}

- (void)fillPhotoData {
    NSArray *imageList = [_dataDict objectForKey:PIC_LIST];
    if ([imageList isKindOfClass:[NSArray class]]) {
        if (imageList) {
            for (int i =0; i<[imageList count]; i++) {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:_postImage.frame];
                [imgView setImageWithURL:$str(@"%@%@",[[[imageList objectAtIndex:i] objectForKey:PIC] delLastStrForYouPai],ypHeadSize) placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
                [_imagesArray addObject:imgView.image];
            }
            [self adjustAddImageBtnFrame];
        }
        
    }
    else{
        for (int i = 0; i < 4; i++) {
            NSString *imgKeyStr = $str(@"image_%d", i + 1);
            if (!isEmptyStr([_dataDict objectForKey:imgKeyStr])) {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:_postImage.frame];
                [imgView setImageWithURL:$str(@"%@%@",[[_dataDict objectForKey:imgKeyStr] delLastStrForYouPai],ypHeadSize) placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
                [_imagesArray addObject:imgView.image];
            }
        }
        [self adjustAddImageBtnFrame];
    }
    if (_imagesArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"没有图片"];
        return;
    }
    
    
    _contentTextView.text = [_dataDict objectForKey:MESSAGE];
    
    
}

- (void)fillBlogData {
    _contentTextView.text = @"";
}

- (void)fillVideoData {
    _titleTextView.text = [_dataDict objectForKey:MESSAGE];
    _contentTextView.text = [_dataDict objectForKey:VIDEO_URL];
}

- (void)fillEventData {
    _titleTextView.text = [_dataDict objectForKey:AD_TITLE];
    NSString *timeStr = [_dataDict objectForKey:START_TIME];
    if (timeStr)
        _contentTextView.text = [Common dateConvert:timeStr];
    else
        _contentTextView.text = [Common dateConvert:[_dataDict objectForKey:EVENT_START_TIME]];
    NSString *titleStr = [_dataDict objectForKey:AD_TITLE];
    if (titleStr) {
        _titleTextView.text = titleStr;
    }
    else
        _titleTextView.text = [_dataDict objectForKey:SUBJECT];
    if (!emptystr([_dataDict objectForKey:POSTER])) {
        [_postImage setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [$emptystr([_dataDict objectForKey:POSTER]) delLastStrForYouPai], ypHeadSize)] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
        _postImgString = [_dataDict objectForKey:PICIDS];
    }
}

- (IBAction)initPostView:(id)sender
{
    
   // _draftArray = [ConciseKit userDefaultsObjectForKey:DRAFT];
    _weiboBtn.enabled = [[[PDKeychainBindings sharedKeychainBindings] objectForKey:SINA_UID]boolValue];
    //_tencentBtn.enabled =[[[PDKeychainBindings sharedKeychainBindings] objectForKey:QQ_UID]boolValue];
    if (self.dataDict == nil) {
        [self onlyContentView];
        _contentTextView.placeholder = @"给图片加点描述吧...";
        _postImage.hidden = NO;
        _contentTextView.frame = CGRectMake(13, 124, TEXT_WIDTH, TEXT_HEIGHT);
        
        if ([self.tableView respondsToSelector:@selector(backgroundView)])
            self.tableView.backgroundView = nil;
        //_mapView.delegate = self;
        [_postImage whenTapped:^{
            //更改头像
            _picker = [[MyImagePickerController alloc]initWithParent:self];
            [_picker showImagePickerMenu:@"本地图库" buttonTitle:@"拍一张照片" sender:sender];
        }];
    }
    else{
        if (_dataDict) {//转发的才有这个
            switch (_rePostType) {
                case rePostPhoto:
                {
                    _currentAction = [NSMutableString stringWithString:POST_PHOTO];
                    [self changePostView];
                    [self fillPhotoData];
                    
                    break;
                }
                case rePostBlog:
                {
                    _currentAction = [NSMutableString stringWithString:POST_DIRARY];
                    [self changePostView];
                    [self fillBlogData];
                    break;
                }
                case rePostVideo:
                {
                    _currentAction = [NSMutableString stringWithString:POST_VIDEO];
                    [self changePostView];
                    [self fillVideoData];
                    break;
                }
                case rePostEvent:
                {
                    _currentAction = [NSMutableString stringWithString:POST_ACT];
                    [self changePostView];
                    [self fillEventData];
                    break;
                }
                default:
                    break;
            }
            _downView.hidden = YES;
            
            [self fillTheSameData];
            
        }
        
    }
    
}

- (IBAction)expandMenuAction:(UIButton *)sender
{
    if (_dataDict) {
        return;
    }
    if(_menuView.frame.size.height!=1)
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _menuView.frame = CGRectMake(_menuView.frame.origin.x,_menuView.frame.origin.y, 150, 1);
                         }
                         completion:^(BOOL finished) {
                             if (![_currentAction isEqualToString:WANTTOSAY])
                                 [UIView animateWithDuration:0.3f
                                                  animations:^{
                                                      _wanToSayView.frame = WANTOSYAFRAME_B;
                                                  }];
                             else
                                 [UIView animateWithDuration:0.3f
                                                  animations:^{
                                                      _wanToSayView.frame = WANTOSAYFRAME_A;
                                                  }];
                             
                         }];
    else
    {
        if (sender) {
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 _menuView.frame = CGRectMake(_menuView.frame.origin.x,_menuView.frame.origin.y, 150, 371);
                             }
                             completion:^(BOOL finished) {
                                 [self bringSubviewToFront:_menuView];
                             }];
        }
        
    }
    
}
- (IBAction)expandWantToSay:(UIButton *)sender
{
    //_wanToSayView.frame = WANTOSYAFRAME_B;
    if (sender == _topWantToSayBtn)
    {
        UIButton *replaceBtn;
        for (UIButton *btn in [_menuView subviews]) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if ([btn.titleLabel.text isEqualToString:WANTTOSAY]) {
                    replaceBtn = btn;
                }
            }
            
        }
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _wanToSayView.frame = WANTOSAYFRAME_A;
                         }];
        [self postMenuAction:replaceBtn];
        return;
    }
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _currentAction = [NSMutableString stringWithString:POST_PHOTO];
        _wantToSayTitiles = [[NSArray alloc] initWithObjects:@"我想说...", ISAY, WEATHER, ONWAY, BLESS, nil];
        _preSelectIndexPath = nil;
        _withFamilyArray = $marrnew;
        _imagesArray = $marrnew;
        _draftArray = $marrnew;
        _wantToSayArray = nil;
        _wantToSayDict = nil;
        _postion = @"";
        _withSomeoneString = @"";
        _postImgString = @"";
        _index = 0;
        [ConciseKit setUserDefaultsWithObject:$double(0.0) forKey:LATITUDE];
        [ConciseKit setUserDefaultsWithObject:$double(0.0) forKey:LONGITUDE];
        
        
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
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_wantToSayArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"wantosaycellid";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor colorWithRed:0.980392 green:0.980392 blue:0.980392 alpha:1];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    cell.textLabel.text = [[_wantToSayArray objectAtIndex:indexPath.row] objectForKey:NAME];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_preSelectIndexPath == indexPath)
        return;
    else
    {
        UITableViewCell *preSelectCell = [tableView cellForRowAtIndexPath:_preSelectIndexPath];
        preSelectCell.textLabel.textColor = [UIColor darkGrayColor];
        _preSelectIndexPath  = indexPath;
    }
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = color(157, 212, 74, 1.0);
    _wantToSayInput.text = selectedCell.textLabel.text;
    
    
    
}

//定位
- (IBAction)locationBtnPressed:(UIButton*)sender {
    //    sender.selected = !sender.selected;
    _locationBtn.enabled = NO;
    if (self.locationManager) {
        self.locationManager = nil;
    }
    CLLocationManager *loc = [[CLLocationManager alloc] init];
    self.locationManager = loc;
    if (![CLLocationManager locationServicesEnabled]) {
        [SVProgressHUD showErrorWithStatus:@"定位不可用T_T"];
    } else {
        if (!self.ssLoading) {
            SSLoadingView *ss = [[SSLoadingView alloc] initWithFrame:CGRectMake(sender.frame.size.width/2-55, sender.frame.size.height/2-15, 110, 30)];
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
    
    //    self.downPostView.locationBtn.alpha = sender.selected ? 0.0f : 1.0f;
    
}
#pragma mark  CLLocationManagerDelegate
// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _locationBtn.enabled = YES;
    if (self.ssLoading) {
        [self.ssLoading.activityIndicatorView stopAnimating];
        self.ssLoading.hidden = YES;
    }
    [ConciseKit setUserDefaultsWithObject:$double(newLocation.coordinate.latitude) forKey:LATITUDE];
    [ConciseKit setUserDefaultsWithObject:$double(newLocation.coordinate.longitude) forKey:LONGITUDE];
    if ([AppDelegate instance].rootViewController.stackScrollViewController.viewControllersStack.count==2) {
        MapAroundViewController *locationListView = [[MapAroundViewController alloc]initWithNibName:@"MapAroundViewController" bundle:nil];
        locationListView.latStr = MY_LATITUDE;
        locationListView.lngStr = MY_LONGITUDE;
        locationListView.parent = self;
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:locationListView invokeByController:self.parent isStackStartView:FALSE];
    }
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _locationBtn.enabled = YES;
    
    if (self.ssLoading) {
        [self.ssLoading.activityIndicatorView stopAnimating];
        self.ssLoading.hidden = YES;
    }
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = [newLocation coordinate];
    
    
    //更新定位信息方法
    [ConciseKit setUserDefaultsWithObject:$double(coordinate.latitude) forKey:LATITUDE];
    [ConciseKit setUserDefaultsWithObject:$double(coordinate.longitude) forKey:LONGITUDE];
    if ([AppDelegate instance].rootViewController.stackScrollViewController.viewControllersStack.count==2) {
        MapAroundViewController *locationListView = [[MapAroundViewController alloc]initWithNibName:@"MapAroundViewController" bundle:nil];
        locationListView.latStr = MY_LATITUDE;
        locationListView.lngStr = MY_LONGITUDE;
        locationListView.parent = self;
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:locationListView invokeByController:self.parent isStackStartView:FALSE];
    }
    
}
#pragma mark  - mapview delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSString *lat = [NSString stringWithFormat:@"%g", userLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%g", userLocation.coordinate.longitude];
    
    [ConciseKit setUserDefaultsWithObject:lat forKey:LATITUDE];
    [ConciseKit setUserDefaultsWithObject:lng forKey:LONGITUDE];
    
    
    MapAroundViewController *locationListView = [[MapAroundViewController alloc]initWithNibName:@"MapAroundViewController" bundle:nil];
    locationListView.latStr = MY_LATITUDE;
    locationListView.lngStr = MY_LONGITUDE;
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:locationListView invokeByController:nil isStackStartView:FALSE];
    //    MKCoordinateSpan span;
    //    MKCoordinateRegion region;
    //    span.latitudeDelta = 0.010;
    //    span.longitudeDelta = 0.010;
    //    region.span = span;
    //    region.center = [userLocation coordinate];
    //
    //    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
}

//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:mapView.userLocation.location.coordinate];
//    reverseGeocoder.delegate = self;
//    if (!reverseGeocoder.querying) {
//        [reverseGeocoder start];
//    }
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
//    //    NSString *subthroung = placemark.subThoroughfare;
//    //    NSString *country = placemark.country;//国
//    //    NSString *area = placemark.administrativeArea;//省
//    NSString *city = placemark.locality;//市
//    NSString *subCity = placemark.subLocality;//区
//    //    NSString *steet = placemark.thoroughfare;//街道
//    //    NSString *subSteet = placemark.subThoroughfare;//门牌号
//    _postion = [NSString stringWithFormat:@"%@", city];
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
//}

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        [_picker.pickerContainer dismissPopoverAnimated:YES];
    else
        [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *myThemeImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self performSelector:@selector(saveImage:) withObject:myThemeImage afterDelay:0.3f];
}
- (void)adjustAddImageBtnFrame
{
    CGFloat x;
    if ([_currentAction isEqualToString:POST_PHOTO]) {
        x = ADDIMAGE_X;
        if ([_imagesArray count]==3)
            _postImage.hidden = YES;
        else
            _postImage.hidden = NO;
    }
    else{
        x = 275;
        if ([_imagesArray count]==1)
            _postImage.hidden = YES;
        else
            _postImage.hidden = NO;
    }
    for (UIImageView *imgView in _contentView.subviews) {
        if (imgView.tag>=kBASEPOSTIMG_TAG) {
            [imgView removeFromSuperview];
        }
    }
    for (int i =0; i<=[_imagesArray count]; i++) {
        CGRect rect = CGRectMake(x+100*i, _postImage.frame.origin.y, _postImage.frame.size.width, _postImage.frame.size.height);
        if (i == [_imagesArray count]){
            _postImage.frame = rect;
        }
        else{
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[_imagesArray objectAtIndex:i]];
            imgView.userInteractionEnabled = YES;
            [imgView whenTapped:^{
                UIActionSheet *ac = [[UIActionSheet alloc]initWithTitle:@""];
                [ac addButtonWithTitle:@"删除图片" handler:^{
                    [imgView removeFromSuperview];
                    [_imagesArray removeObject:[_imagesArray objectAtIndex:i]];
                    [self adjustAddImageBtnFrame];
                }];
                [ac showInView:self];
            }];
            imgView.tag = kBASEPOSTIMG_TAG+[_imagesArray count];
            imgView.frame = rect;
            [_contentView addSubview:imgView];
        }
    }
    
}
- (void)saveImage:(UIImage*)_image {
    [_imagesArray addObject:_image];
    
    
    // [_contentView addSubview:postImage];
    [self adjustAddImageBtnFrame];
}

#pragma mark -
#pragma mark 处理方法
// 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_zoneArray count];
}
// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerMode == zoneName)
        return [[_zoneArray objectAtIndex:row] objectForKey:TAG_NAME];
    else
        return [[_zoneArray objectAtIndex:row] objectForKey:NAME];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSString *result = [pickerView pickerView:pickerView titleForRow:row forComponent:component];
    NSString  *result = nil;
    if (_pickerMode == zoneName) {
        result = [[_zoneArray objectAtIndex:row] objectForKey:TAG_NAME];
        [_zoneBtn setTitle:result forState:UIControlStateNormal];
        [ConciseKit setUserDefaultsWithObject:result forKey:@"lastSelectZone"];
    }
    else{
        result = [[_zoneArray objectAtIndex:row] objectForKey:NAME];
        [((UIButton *)[self viewWithTag:kBASEFRIEND_TAG]) setTitle:result forState:UIControlStateNormal];
    }
}
@end
