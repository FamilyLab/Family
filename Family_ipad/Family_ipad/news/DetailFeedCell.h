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
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

typedef enum {
    unknownDetailType       = -1,//
    photoDetailType         = 0,//照片
    blogDetailType          = 1,//日志
    videoDetailType         = 2,//视频
    eventDetailType         = 3,//活动
} FeedDetailType;

@interface DetailFeedCell : UITableViewCell <UIWebViewDelegate, MKMapViewDelegate>
{
    BOOL hasEventImage;

}
@property (nonatomic, assign) FeedDetailType feedDetailType;

@property (nonatomic, strong) IBOutlet UILabel *hotLbl;
@property (nonatomic, strong) IBOutlet UILabel *infoLbl;
@property (nonatomic, strong) IBOutlet OperateView *operateView;
@property (nonatomic, strong) IBOutlet UILabel *noCommentLbl;
@property (nonatomic, strong) IBOutlet SimpleInfoView *simpleInfoView;
@property (nonatomic, strong) IBOutlet UIImageView *eventImgView;
@property (nonatomic, strong) IBOutlet UIImageView *mapBoxImgView;

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIButton *replyBtn;

@property (nonatomic, strong) IBOutlet UILabel *dateLbl;
@property (nonatomic, strong) IBOutlet UILabel *locationLbl;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@property (nonatomic, assign) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIImageView *mapImageView;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL isFromZone;
@property (nonatomic, strong) MyAnnotation *myAnnotation;
@property (nonatomic, strong)IBOutlet UIImageView *bgImage;
//@property(nonatomic, copy) NSString *mapTitle;
//@property(nonatomic, copy) NSString *mapSubtitle;
@property (nonatomic, assign) CGFloat nameLblX;
@property (nonatomic, assign) CGFloat nameLblWidth;

@property (nonatomic, assign) int picNum;
@property (nonatomic, assign) BOOL isLoadingFirstCell;

+ (CGFloat)heightForPhotoSubject:(NSString *)text andOtherHeight:(CGFloat)_miniHeight;

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight withNameX:(CGFloat)nameX withNameWidth:(CGFloat)nameWidth ;

- (void)initFirstCellData:(NSDictionary*)aDict;
- (void)initJoinData:(NSDictionary*)aDict;
- (void)initCommentData:(NSDictionary*)aDict;
- (IBAction)showBigMap:(id)sender;
@end
