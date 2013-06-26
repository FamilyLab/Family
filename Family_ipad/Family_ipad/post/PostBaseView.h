//
//  PostBaseView.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-9.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "MyImagePickerController.h"
#import "SSTextView.h"
typedef enum {
    zoneName          = 0,
    familyName        = 1
}PickMode;
typedef enum {
    notRePostType   = -1,
    rePostPhoto     = 0,
    rePostBlog      = 1,
    rePostVideo     = 2,
    rePostEvent     = 3
} RePostType;
@class SSLoadingView;
@interface PostBaseView : UIView<CLLocationManagerDelegate,MKMapViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

//ui
@property (nonatomic,strong)IBOutlet UIView *menuView;
@property (nonatomic,strong)IBOutlet UIButton *postDairyButton;
@property (nonatomic,strong)IBOutlet UIButton *postMessageButton;
@property (nonatomic,strong)IBOutlet UIButton *postmoodButton;
@property (nonatomic,strong)IBOutlet UIButton *postActivityButton;
@property (nonatomic,strong)IBOutlet UIButton *postVideoButton;
@property (nonatomic,strong)IBOutlet UIButton *titleButton;
@property (nonatomic,strong)IBOutlet UIButton *topWantToSayBtn;
@property (nonatomic,strong)IBOutlet UIView *downView;
@property (nonatomic,strong)IBOutlet SSTextView *contentTextView;
@property (nonatomic,strong)IBOutlet SSTextView *titleTextView;
@property (nonatomic,strong)IBOutlet UIImageView *postImage;
@property (nonatomic,strong) NSString *currentAction;
@property (nonatomic,strong) NSArray *wantToSayTitiles;
@property (nonatomic,strong) IBOutlet UIView *wanToSayView;
@property (nonatomic,strong) IBOutlet UIView *contentView;
@property (nonatomic,strong) IBOutlet UIView *wantToSayInputView;
@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *preSelectIndexPath;
@property (nonatomic,strong)IBOutlet UITextField *wantToSayInput;
@property (nonatomic,strong)IBOutlet MKMapView *mapView;
@property (nonatomic,strong)IBOutlet UIButton *locationBtn;
@property (nonatomic,assign)UIViewController *parent;
@property (nonatomic,strong)IBOutlet UIButton *zoneBtn;
@property (nonatomic,strong)IBOutlet UIButton *weiboBtn;
@property (nonatomic,strong)IBOutlet UIButton *tencentBtn;
@property (nonatomic,strong)UIPopoverController *zonePickerContainer;
@property (nonatomic,strong)IBOutlet UIImageView *fImageView;
@property (nonatomic,strong)IBOutlet UIImageView *sImageView;
@property (nonatomic,strong)IBOutlet UIImageView *tImageView;
@property (nonatomic,strong)IBOutlet UIImageView *foImageView;
@property (nonatomic,strong)UIButton *selectDateBtn;
@property (nonatomic,strong)IBOutlet UIView *shareView;
@property (nonatomic,strong)IBOutlet UILabel *myLocationLbl;
@property (nonatomic,strong)IBOutlet UIImageView *backgroundImage;
@property (nonatomic,strong)IBOutlet UIButton *expandBtn;
//data
@property (nonatomic,strong)NSMutableArray *withFamilyArray;
@property (nonatomic,strong)NSDictionary *wantToSayDict;
@property (nonatomic,strong)NSArray *wantToSayArray;
@property (nonatomic,copy)NSString *postion;
@property (nonatomic,strong)UIImage *postImg;
@property (nonatomic,copy)NSString *postImgString;
@property (nonatomic,copy)NSString *withSomeoneString;
@property (nonatomic,copy)NSMutableArray *zoneArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic,assign)NSUInteger postImgNum;
@property (nonatomic,assign)NSUInteger index;
@property (nonatomic,copy)NSString *touid;
@property (nonatomic,strong)NSDictionary *dataDict;
@property (nonatomic, assign) RePostType rePostType;
@property (nonatomic,assign)NSString *topicID;
@property (nonatomic, strong) SSLoadingView *ssLoading;
@property (nonatomic,strong)NSMutableArray * draftArray;

@property (nonatomic,strong)CLLocationManager *locationManager;


//control
@property (nonatomic,strong)MyImagePickerController *picker;
@property (nonatomic,assign)PickMode pickerMode;

- (IBAction)expandMenuAction:(id)sender;
- (IBAction)postMenuAction:(id)sender;
- (IBAction)initPostView:(id)sender;
- (IBAction)expandWantToSay:(id)sender;
- (IBAction)switchWantToSay:(id)sender;
- (IBAction)locationBtnPressed:(UIButton*)sender;
- (IBAction)selectFamily:(id)sender;
- (IBAction)okBtnAction:(id)sender;
- (IBAction)markWeibo:(id)sender;
- (void)setAvatarForTogether;
- (void)changePostView;
@end
