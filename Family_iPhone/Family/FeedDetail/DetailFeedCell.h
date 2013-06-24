//
//  DetailFeedCell.h
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperateView.h"
#import "SimpleInfoView.h"
//#import <MapKit/MapKit.h>
//#import "MyAnnotation.h"

typedef enum {
    unknownDetailType       = -1,//
    photoDetailType         = 0,//照片
    blogDetailType          = 1,//日志
    videoDetailType         = 2,//视频
    eventDetailType         = 3//活动
} FeedDetailType;

@interface DetailFeedCell : UITableViewCell <UIWebViewDelegate> {//, MKMapViewDelegate> {
    BOOL hasEventImage;
}

@property (nonatomic, assign) FeedDetailType feedDetailType;

@property (nonatomic, strong) IBOutlet UILabel *comeLbl;

@property (nonatomic, strong) IBOutlet UILabel *hotLbl;
@property (nonatomic, strong) IBOutlet UILabel *infoLbl;
@property (nonatomic, strong) IBOutlet OperateView *operateView;
@property (nonatomic, strong) IBOutlet UILabel *noCommentLbl;
@property (nonatomic, strong) IBOutlet SimpleInfoView *simpleInfoView;


//@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) IBOutlet UIImageView *photoImgView;
@property (nonatomic, strong) IBOutlet UILabel *eachImgViewInfoLbl;
@property (nonatomic, assign) CGFloat picWidth;
@property (nonatomic, assign) CGFloat picHeight;

@property (nonatomic, strong) IBOutlet UIImageView *eventImgView;
//@property (nonatomic, strong) IBOutlet UIImageView *mapBoxImgView;

@property (nonatomic, strong) IBOutlet UIWebView *webView;


@property (nonatomic, strong) IBOutlet UILabel *dateLbl;
@property (nonatomic, strong) IBOutlet UILabel *locationLbl;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@property (nonatomic, copy) NSString *latStr;
@property (nonatomic, copy) NSString *lngStr;
//@property (nonatomic, assign) IBOutlet MKMapView *mapView;
//@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//@property (nonatomic, strong) MyAnnotation *myAnnotation;
//@property(nonatomic, copy) NSString *mapTitle;
//@property(nonatomic, copy) NSString *mapSubtitle;


@property (nonatomic, assign) CGFloat nameLblX;
@property (nonatomic, assign) CGFloat nameLblWidth;

@property (nonatomic, assign) int picNum;
@property (nonatomic, assign) BOOL isLoadingFirstCell;

@property (nonatomic, strong) IBOutlet UIButton *replyCommentBtn;
@property (nonatomic, assign) NSDictionary *commentDict;

+ (CGFloat)heightForPhotoSubject:(NSString *)text andOtherHeight:(CGFloat)_miniHeight;

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight withNameX:(CGFloat)nameX withNameWidth:(CGFloat)nameWidth ;

- (void)initFirstCellData:(NSDictionary*)aDict;
//- (void)initJoinData:(NSDictionary*)aDict;
- (void)initCommentData:(NSDictionary*)aDict;

- (void)initPhotoFirstCellData:(NSDictionary*)aDict;
- (void)initPicsCellData:(NSDictionary*)picDict;
- (void)initOperateViewData:(NSDictionary*)aDict;

@end
