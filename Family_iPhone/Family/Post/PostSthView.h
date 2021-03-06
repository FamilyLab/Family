//
//  PostSthView.h
//  Family
//
//  Created by Aevitx on 13-6-5.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"
#import "JTListView.h"

@interface PostSthView : UIView

@property (nonatomic, strong) IBOutlet SSTextView *describeTextView;
@property (nonatomic, strong) IBOutlet JTListView *jtListView;
//@property (nonatomic, strong) IBOutlet UIImageView *photoImgView;
//@property (nonatomic, strong) IBOutlet UIButton *photoBtn;

//@property (nonatomic, strong) IBOutlet UILabel *tipLbl;

//@property (nonatomic, strong) IBOutlet UITextField *firstTextField;
@property (nonatomic, strong) IBOutlet UITextField *secondTextField;
@property (nonatomic, strong) IBOutlet UIButton *eventImgBtn;
@property (nonatomic, strong) IBOutlet UIButton *timeBtn;
//
//@property (nonatomic, strong) IBOutlet UIButton *albumBtn;
@property (nonatomic, strong) IBOutlet UIButton *locationBtn;
@property (nonatomic, strong) IBOutlet UIButton *personsBtn;
//@property (nonatomic, strong) IBOutlet UIImageView *locaiontImgView;
@property (nonatomic, strong) IBOutlet UILabel *locationLbl;
//@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *myLocationLbl;
@property (nonatomic, strong) IBOutlet UIImageView *firstImgView;
@property (nonatomic, strong) IBOutlet UIImageView *secondImgView;
@property (nonatomic, strong) IBOutlet UIImageView *thirdImgView;
@property (nonatomic, strong) IBOutlet UIImageView *fourthImgView;

@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;

@property (nonatomic, strong) IBOutlet UITableView *wantToSayTable;

@property (nonatomic, strong) IBOutlet UIButton *pmNameBtn;

@property (nonatomic, strong) IBOutlet UIView *otherView;

@property (nonatomic, assign) int postTypeNum;

@end
