//
//  PostViewController.h
//  Family
//
//  Created by Aevitx on 13-1-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "TopView.h"
#import "BottomView.h"
#import "ExpandView.h"
#import "PostView.h"
#import "WantToSayCell.h"
#import "JTListView.h"
#import "MyViewCell.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "WXApi.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "SSLoadingView.h"

typedef enum {
    notRePostType   = -1,
    rePostPhoto     = 0,
    rePostBlog      = 1,
    rePostVideo     = 2,
    rePostEvent     = 3
} RePostType;

@interface PostViewController : BaseViewController <TopViewDelegate, BottomViewDelegate, ExpandViewDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, JTListViewDataSource, JTListViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, SinaWeiboDelegate, SinaWeiboRequestDelegate, WXApiDelegate, CLLocationManagerDelegate> {
    
    BOOL canShowDeleteBtn;
    
    int photoNumWithoutDefaultImage;
    
    int imgIndex;
    
    enum WXScene _scene;
//    BOOL canShowDetail;
}

@property (nonatomic, strong) IBOutlet ExpandView *expandView;
@property (nonatomic, strong) TopView *topView;

@property (nonatomic, strong) IBOutlet UIButton *sinaBtn;
@property (nonatomic, strong) IBOutlet UIButton *tcweiboBtn;
@property (nonatomic, strong) IBOutlet UIButton *weixinBtn;

@property (nonatomic, strong) PostView *upPostView;
@property (nonatomic, strong) PostView *downPostView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SSLoadingView *ssLoading;

@property (nonatomic, strong) JTListView *horizontalView;
@property (nonatomic, strong) UIButton *currBtn;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, copy) NSString *latStr;
@property (nonatomic, copy) NSString *lngStr;
@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, strong) NSMutableArray *withFriendsArray;
@property (nonatomic, strong) NSMutableArray *familyListArray;

//@property (nonatomic, strong) IBOutlet UILabel *addressLbl;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *zonesArray;
//@property (nonatomic, strong) NSMutableArray *togetherArray;


//@property (nonatomic, copy) NSString *postImgString;
@property (nonatomic, strong) NSMutableArray *picIdsArray;
@property (nonatomic, assign) int index;

//@property (nonatomic, copy) NSString *withFriendsStr;

@property (nonatomic,strong) NSDictionary *wantToSayDict;
@property (nonatomic,strong) NSArray *wantToSayArray;
@property (nonatomic,strong) NSIndexPath *preSelectIndexPath;

@property (nonatomic, strong) UIImage *eventImg;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) NSString *postPMUserId;


@property (nonatomic, strong) NSMutableDictionary *dataDict;//转发的才有这个
@property (nonatomic, assign) RePostType rePostType;
@property (nonatomic, copy) NSString *idType;


@property (nonatomic, copy) NSString *topicId;//参加今日话题的

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *blogDescriStr;
//@property (nonatomic, assign) NSDictionary *detailIdDict;


@property (nonatomic, assign) PostType thePostType;

- (void)setAvatarForTogether;

@end
