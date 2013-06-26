//
//  DetailFeedCell.m
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "DetailFeedCell.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "MyHttpClient.h"
#import "NSString+ConciseKit.h"
#import "UIView+BlocksKit.h"
#import "KGModal.h"
#define kFirstPhotoY    30
#define kPhotoSnap      20
#define kPhotoX         20
#define kPhotoHeight    300
#define KPhotoWidth     450
#define PIC_SIZE        @"!900"
#define kSmallMapViewX  345
#define kBigMapViewX    15
//
//#define kOperatorViewHeight 35

@implementation DetailFeedCell
@synthesize hotLbl, operateView, simpleInfoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//照片的
+ (CGFloat)heightForPhotoSubject:(NSString *)text andOtherHeight:(CGFloat)_miniHeight {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(436, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}

//评论的
//评论的
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight withNameX:(CGFloat)nameX withNameWidth:(CGFloat)nameWidth {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(380 - 15 - nameX - nameWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    

//    operateView.albumBtn.btnLbl.textAlignment = UITextAlignmentCenter;
//    operateView.albumBtn.btnLbl.frame = (CGRect){.origin.x = 22, .origin.y = 7, .size = CGSizeMake(78, 20)};
    self.bgImage.image = [self.bgImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];

    if (_bgImage) {
        CGRect frame = self.bgImage.frame;
        frame.size = self.frame.size;
        self.bgImage.frame = frame;

    }
    if (_feedDetailType == photoDetailType) {
        if (1) {
            CGSize infoSize = [_infoLbl.text sizeWithFont:_infoLbl.font constrainedToSize:CGSizeMake(436, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            CGFloat lastPicYAndHeight = 0;
            for (int i = 0; i < _picNum; i++) {
                int firstIndexOfAllImageView = [self.contentView.subviews count] - _picNum;
                if ([[[self.contentView subviews] objectAtIndex:i + firstIndexOfAllImageView] isKindOfClass:[UIImageView class]]) {
                    UIImageView *photoImgView = (UIImageView*)[[self.contentView subviews] objectAtIndex:i + firstIndexOfAllImageView];
                    if (i == _picNum - 1) {
                        lastPicYAndHeight = photoImgView.frame.origin.y + photoImgView.frame.size.height;
                    }
                }
            }
            if (lastPicYAndHeight<25) {
                lastPicYAndHeight = 30;
            }
//#define kFirstPhotoY    30
//#define kPhotoSnap      15
//#define kPhotoHeight    200
           // _infoLbl.frame = (CGRect){.origin.x = _infoLbl.frame.origin.x, .origin.y = lastPicYAndHeight + 5, .size = infoSize};//30为第一张图片的Y值，200为一张图片的高度，15为图片间的间隔
            operateView.frame = (CGRect){.origin.x = 0, .origin.y =lastPicYAndHeight + 5, .size = operateView.frame.size};
        }
    } else if (_feedDetailType == videoDetailType) {
        CGSize infoSize = [_infoLbl.text sizeWithFont:_infoLbl.font constrainedToSize:CGSizeMake(436, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        _infoLbl.frame = (CGRect){.origin.x = kPhotoX, .origin.y = _webView.frame.origin.y + _webView.frame.size.height + 5, .size = infoSize};//30为webview的Y值，290为webview的高度
        operateView.frame = (CGRect){.origin.x = 0, .origin.y = _infoLbl.frame.origin.y + _infoLbl.frame.size.height, .size = operateView.frame.size};
    } else if (_feedDetailType == blogDetailType) {
        for (UIView *obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[UIWebView class]]) {
                UIWebView *web = (UIWebView*)obj;
                operateView.frame = (CGRect){.origin.x = 0, .origin.y = web.frame.origin.y + web.frame.size.height + 5, .size = operateView.frame.size};
            }
        }
    } else if (_feedDetailType == eventDetailType) {
        for (UIView *obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[UIWebView class]]) {
                UIWebView *web = (UIWebView*)obj;
                web.frame = (CGRect){.origin = CGPointMake(15, 108), .size = web.frame.size};
                operateView.frame = (CGRect){.origin.x = 0, .origin.y = web.frame.origin.y + web.frame.size.height + 5, .size = operateView.frame.size};
                break;
            }
            _mapBoxImgView.frame = CGRectMake(397, 38, 68, 68);
            _mapView.frame = CGRectMake(402, 42, 60, 60);
        }
//        CGSize describeSize = [_describeLbl.text sizeWithFont:_describeLbl.font constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//        _describeLbl.frame = (CGRect){.origin = _describeLbl.frame.origin, .size = describeSize};
//        if (hasEventImage) {
//            _eventImgView.hidden = NO;
//            _eventImgView.frame = (CGRect){.origin.x = _eventImgView.frame.origin.x, .origin.y = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + 5, .size = _eventImgView.frame.size};
//            _mapView.frame = (CGRect){.origin.x = kSmallMapViewX, .origin.y = _eventImgView.frame.origin.y + _eventImgView.frame.size.height - 120, .size = CGSizeMake(120, 120)};
//     
//            operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = _mapView.frame.origin.y + _mapView.frame.size.height + 3, .size = operateView.frame.size};
//            
//        } else {
//            _eventImgView.hidden = YES;
//            _mapView.frame = (CGRect){.origin.x = kBigMapViewX, .origin.y = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + 5, .size = CGSizeMake(450, 130)};
//            operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = _mapView.frame.origin.y + _mapView.frame.size.height + 3, .size = operateView.frame.size};
//        }

    }
    if (self.simpleInfoView) {
        [self.simpleInfoView layoutSubviews];
    }
}

- (void)initFirstCellData:(NSDictionary*)aDict {
    //照片
    NSString *tagName = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";
//    self.operateView.albumBtn.type = ZONE_BTN;
//    if (!_isFromZone) {
//        self.operateView.albumBtn.identify = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_ID] : @"";
//
//    }
//    self.operateView.albumBtn.extraInfo = [aDict objectForKey:UID];
//
//    [self.operateView.albumBtn setTitle:tagName forState:UIControlStateNormal];
    if (aDict) {
        switch (_feedDetailType) {
            case photoDetailType:
            {
                if (![[aDict objectForKey:PIC_LIST] isEqual:[NSNull null]]) {
                    NSArray *picArray = [aDict objectForKey:PIC_LIST];
                    for (int i = 0; i < _picNum; i++) {
                        if ([[[self.contentView subviews] objectAtIndex:i + 2] isKindOfClass:[UIImageView class]]) {
                            UIImageView *photoImgView = (UIImageView*)[[self.contentView subviews] objectAtIndex:i + 2];
                            NSString *imgURL = $str(@"%@%@",[[[picArray objectAtIndex:i] objectForKey:PIC] delLastStrForYouPai],PIC_SIZE);
                            [photoImgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
                        }
                    }
                }
                self.operateView.infoLabel.text = [aDict objectForKey:MESSAGE];
                self.operateView.timeLabel.text =$str(@"%@   来自: %@",[Common dateSinceNow:[aDict objectForKey:DATELINE]],[aDict objectForKey:COME]);

                break;
            }
            case blogDetailType:
            {
                //            _webView.hidden = YES;
                //            [_webView setScalesPageToFit:NO];
                //            [_webView loadHTMLString:[aDict objectForKey:MESSAGE] baseURL:nil];
                _infoLbl.text = @"加载中...";
                _infoLbl.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
                _infoLbl.textColor = [UIColor lightGrayColor];
                _infoLbl.textAlignment = UITextAlignmentCenter;
                _infoLbl.frame = CGRectMake(0, 120, 436, 30);
                [self.contentView bringSubviewToFront:_infoLbl];
                break;
            }
            case videoDetailType:
            {//http://v.youku.com/v_show/id_XMjM2NjYyMjAw.html [aDict objectForKey:VIDEO_URL]
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[aDict objectForKey:PIC]]]];
                [_webView setScalesPageToFit:YES];
                
                _webView.backgroundColor = [UIColor lightGrayColor];
                self.operateView.infoLabel.text = [aDict objectForKey:MESSAGE];
                self.operateView.timeLabel.text =$str(@"%@   来自: %@",[Common dateSinceNow:[aDict objectForKey:DATELINE]],[aDict objectForKey:COME]);
                break;
            }
            case eventDetailType:
            {
                if (![emptystr([aDict objectForKey:POSTER]) isEqualToString:@""]) {
                    hasEventImage = YES;
                    [_eventImgView setImageWithURL:[NSURL URLWithString:[aDict objectForKey:POSTER]] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
                } else {
                    hasEventImage = NO;
                    _eventImgView.image = nil;
                }
                _dateLbl.text = [NSString stringWithFormat:@"时间：%@", $emptystr([Common dateConvert:[aDict objectForKey:START_TIME]])];
                _locationLbl.text = [NSString stringWithFormat:@"地点：%@", $emptystr([aDict objectForKey:FEED_EVENT_LOCATION])];
                _describeLbl.text = [NSString stringWithFormat:@"介绍：%@", $emptystr([aDict objectForKey:FEED_EVENT_DETAIL])];
                self.operateView.timeLabel.text =$str(@"%@   来自: %@",[Common dateSinceNow:[aDict objectForKey:DATELINE]],[aDict objectForKey:COME]);

                _coordinate.latitude = [[aDict objectForKey:LAT] doubleValue];
                _coordinate.longitude = [[aDict objectForKey:LNG] doubleValue];
                _mapImageView.userInteractionEnabled = YES;
                float zoomLevel = 0.001;
                MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
                
                //大头针
                MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:_coordinate];
                annotation.title = @"活动地点";
                annotation.subtitle = @"";
                self.myAnnotation = annotation;
                
                [_mapView removeAnnotations:_mapView.annotations];
                [_mapView addAnnotation:_myAnnotation];
                [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
                [_mapImageView whenTapped:^{
                    _mapView.frame = [UIScreen mainScreen].bounds;
                    [[KGModal sharedInstance] showWithContentViewInMiddle:_mapView andAnimated:YES];
                    
                }];
                
                break;
            }
            default:
                break;
        }

    }
}
- (IBAction)showBigMap:(id)sender
{
   
    _mapView.frame = [UIScreen mainScreen].bounds;
    [[KGModal sharedInstance] showWithContentViewInMiddle:_mapView andAnimated:YES];
}
- (void)initCommentData:(NSDictionary*)aDict {
    if (!aDict) {        self.simpleInfoView.hidden = YES;

        self.noCommentLbl.hidden = NO;
        self.noCommentLbl.text = _isLoadingFirstCell ? @"加载中..." : @"评论一下吧...";
    } else {
        self.simpleInfoView.headBtn.type = HEAD_BTN;
        
        [self.simpleInfoView.headBtn setVipStatusWithStr:[aDict objectForKey:VIPSTATUS] isSmallHead:YES];

       self.simpleInfoView.headBtn.identify = [aDict objectForKey:AUTHOR_ID];
        self.simpleInfoView.hidden = NO;
        self.noCommentLbl.hidden = YES;
        self.simpleInfoView.isFamilyList = NO;
        self.simpleInfoView.userId = [aDict objectForKey:UID];
        [self.simpleInfoView initInfoWithHeadUrlStr:[aDict objectForKey:AVATER]
                                            nameStr:[aDict objectForKey:COMMENT_AUTHOR_NAME]
                                        noteNameStr:@""
                                            infoStr:[aDict objectForKey:MESSAGE]
                                   andRightImgPoint:CGPointMake(66, 34)
                                           rightImg:@"time.png"
                                           rightStr:[Common dateSinceNow:[aDict objectForKey:DATELINE]]];
    }
}

- (void)initJoinData:(NSDictionary*)aDict {
    if (!aDict) {
        self.simpleInfoView.hidden = YES;
        self.noCommentLbl.hidden = NO;
        self.noCommentLbl.text = _isLoadingFirstCell ? @"加载中..." : @"";
    } else {
        self.simpleInfoView.hidden = NO;
        self.noCommentLbl.hidden = YES;
        self.simpleInfoView.isFamilyList = NO;
        self.simpleInfoView.userId = [aDict objectForKey:UID];
        [self.simpleInfoView initInfoWithHeadUrlStr:[aDict objectForKey:AVATER]
                                            nameStr:[aDict objectForKey:NAME]
                                        noteNameStr:@""
                                            infoStr:@"参与了活动"
                                   andRightImgPoint:CGPointMake(66, 34)
                                           rightImg:@"time.png"
                                           rightStr:@"等接口"];
    }
}

#pragma mark - mapview
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [_mapView selectAnnotation:_myAnnotation animated:YES];
}

@end
