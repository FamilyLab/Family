//
//  PostSthViewController.h
//  Family
//
//  Created by Aevitx on 13-6-4.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TopView.h"
#import "JTListView.h"
#import "SSTextView.h"
#import "PostSthView.h"
#import "SSLoadingView.h"
#import "WantToSayCell.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "WXApi.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "SSLoadingView.h"
#import "SVProgressHUD.h"
#import "MenuViewForPost.h"

typedef enum {
    postHitError    = -1,
    postPhoto       = 0,
    postDiary       = 1,
    postPrivateMsg  = 2,
    postActivity    = 3,
    postVideo       = 4,
    postWantToSay   = 5,
    
    rePostPhoto     = 6,
    rePostBlog      = 7,
    rePostVideo     = 8,
    rePostEvent     = 9
} PostSthType;

//typedef enum {
//    notRePostType   = -1,
//    rePostPhoto     = 0,
//    rePostBlog      = 1,
//    rePostVideo     = 2,
//    rePostEvent     = 3
//} RePostSthType;

@interface PostSthViewController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, WXApiDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, JTListViewDataSource, JTListViewDelegate, TopViewDelegate> {
    int photoNumWithoutDefaultImage;
    int imgIndex;
    enum WXScene _scene;
    BOOL isFirstShow;
}

@property (nonatomic, assign) PostSthType postSthType;
@property (nonatomic, strong) PostSthView *postSthView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SSLoadingView *ssLoading;

@property (nonatomic, strong) IBOutlet MenuViewForPost *menuViewInBottom;
@property (nonatomic, strong) IBOutlet MenuViewForPost *menuViewForKeyboard;
//@property (nonatomic, strong) IBOutlet UIView *menuViewWithAlbum;
//@property (nonatomic, strong) IBOutlet UIView *menuViewWithoutAlbum;
//@property (nonatomic, strong) IBOutlet UIButton *albumBtn;

@property (nonatomic, strong) IBOutlet UIButton *sinaBtn;
@property (nonatomic, strong) IBOutlet UIButton *tcweiboBtn;
@property (nonatomic, strong) IBOutlet UIButton *weixinBtn;

@property (nonatomic, strong) UIButton *currBtn;
@property (nonatomic, strong) NSMutableArray *imagesArray;

//活动
@property (nonatomic, strong) UIImage *eventImg;

@property (nonatomic, strong) NSDictionary *dataDict;
//@property (nonatomic, assign) RePostSthType rePostType;
@property (nonatomic, copy) NSString *idType;

@property (nonatomic, strong) NSMutableArray *withFriendsArray;
@property (nonatomic, strong) NSMutableArray *familyListArray;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *zonesArray;

@property (nonatomic, strong) NSMutableArray *picIdsArray;
@property (nonatomic, assign) int index;

@property (nonatomic, copy) NSString *postPMUserId;

@property (nonatomic, copy) NSString *latStr;
@property (nonatomic, copy) NSString *lngStr;
@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIImageView *bgImgViewForTouch;

@property (nonatomic, copy) NSString *topicId;//参加今日话题的
//@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *blogDescriStr;

@property (nonatomic, strong) NSDictionary *wantToSayDict;
@property (nonatomic, strong) NSArray *wantToSayArray;
@property (nonatomic, strong) NSIndexPath *preSelectIndexPath;

@property (nonatomic, assign) BOOL shouldAddDefaultImage;

- (void)setNameForTogether;

- (void)setupHorizontalViewWithType:(PostSthType)postType;


@end
