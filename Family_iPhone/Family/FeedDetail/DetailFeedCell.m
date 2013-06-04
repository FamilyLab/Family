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
#import "ShowMapViewController.h"

//#define kOperatorViewHeight 35

//#define kSmallMapViewX  226
//#define kBigMapViewX    10

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
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}

//评论的
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight withNameX:(CGFloat)nameX withNameWidth:(CGFloat)nameWidth {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont boldSystemFontOfSize:14.0f] constrainedToSize:CGSizeMake(DEVICE_SIZE.width - 15 - nameX - nameWidth - 5, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    operateView.albumBtn.btnLbl.textAlignment = UITextAlignmentCenter;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//	operateView.albumBtn.btnLbl.textAlignment = UITextAlignmentCenter;
//#else
//	operateView.albumBtn.btnLbl.textAlignment = NSTextAlignmentCenter;
//#endif
    operateView.albumBtn.btnLbl.frame = (CGRect){.origin.x = 22, .origin.y = 7, .size = CGSizeMake(78, 20)};
    if (_feedDetailType == photoDetailType) {
        if (_eachImgViewInfoLbl) {
            _photoImgView.frame = (CGRect){.origin.x = (DEVICE_SIZE.width - _picWidth) / 2, .origin.y = _photoImgView.frame.origin.y, .size.width = _picWidth, .size.height = _picHeight};
            CGSize eachSubjSize = [_eachImgViewInfoLbl.text sizeWithFont:_eachImgViewInfoLbl.font constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            _eachImgViewInfoLbl.frame = (CGRect){.origin.x = _eachImgViewInfoLbl.frame.origin.x, .origin.y = _photoImgView.frame.origin.y + _photoImgView.frame.size.height + 3, .size = eachSubjSize};
        }
        if (_infoLbl) {
            CGSize infoSize = [_infoLbl.text sizeWithFont:_infoLbl.font constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            
            _infoLbl.frame = (CGRect){.origin.x = _infoLbl.frame.origin.x, .origin.y = _infoLbl.frame.origin.y, .size = infoSize};//30为第一张图片的Y值，200为一张图片的高度，kPhotoSnap为图片间的间隔
//            _infoLbl.frame = (CGRect){.origin.x = _infoLbl.frame.origin.x, .origin.y = kFirstPhotoY + _picNum * (200 + 15), .size = infoSize};//30为第一张图片的Y值，200为一张图片的高度，kPhotoSnap为图片间的间隔
            operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = _infoLbl.frame.origin.y + _infoLbl.frame.size.height, .size = operateView.frame.size};
        }
    } else if (_feedDetailType == videoDetailType) {
        CGSize infoSize = [_infoLbl.text sizeWithFont:_infoLbl.font constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        _infoLbl.frame = (CGRect){.origin.x = _infoLbl.frame.origin.x, .origin.y = _webView.frame.origin.y + _webView.frame.size.height + 5, .size = infoSize};//30为webview的Y值，290为webview的高度
        operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = _infoLbl.frame.origin.y + _infoLbl.frame.size.height, .size = operateView.frame.size};
    } else if (_feedDetailType == blogDetailType) {
        for (UIView *obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[UIWebView class]]) {
                UIWebView *web = (UIWebView*)obj;
                operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = web.frame.origin.y + web.frame.size.height + 5, .size = operateView.frame.size};
                break;
            }
        }
    } else if (_feedDetailType == eventDetailType) {
        for (UIView *obj in self.contentView.subviews) {
            if ([obj isKindOfClass:[UIWebView class]]) {
                UIWebView *web = (UIWebView*)obj;
                web.frame = (CGRect){.origin = CGPointMake(15, 100), .size = web.frame.size};
                operateView.frame = (CGRect){.origin.x = operateView.frame.origin.x, .origin.y = web.frame.origin.y + web.frame.size.height + 5, .size = operateView.frame.size};
                break;
            }
//            _mapBoxImgView.frame = CGRectMake(245, 30, 60, 60);
//            _mapView.frame = CGRectMake(249, 34, 52, 52);
        }
    }
    if (self.simpleInfoView) {
        [self.simpleInfoView layoutSubviews];
    }
}

- (void)initPhotoFirstCellData:(NSDictionary*)aDict {
    //来自
    self.comeLbl.text = $str(@"来自：%@", emptystr([aDict objectForKey:COME]));
    NSString *rePostNum = @"rephotonum";
    rePostNum = [rePostNum isEqualToString:@""] ? @"见鬼了" : rePostNum;
    if (aDict) {
        self.hotLbl.text = [NSString stringWithFormat:@"转发(%@) 收藏(%@) 评论(%@)", [aDict objectForKey:rePostNum], [aDict objectForKey:FEED_LOVE_NUM], [aDict objectForKey:FEED_REPLY_NUM]];
    } else {
        self.hotLbl.text = @"转发(0) 收藏(0) 评论(0)";
    }
}

- (void)initPicsCellData:(NSDictionary*)picDict {
    NSString *picUrlStr = $str(@"%@%@", [[picDict objectForKey:PIC] delLastStrForYouPai], ypFeedDetail);
    [_photoImgView setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    _eachImgViewInfoLbl.text = emptystr([picDict objectForKey:TITLE]);
    self.picWidth = [[picDict objectForKey:WIDTH] intValue];
    self.picHeight = [[picDict objectForKey:HEIGHT] intValue];
    if (_picWidth > KPhotoWidth) {
        _picHeight = (float)(KPhotoWidth / _picWidth) * (float)_picHeight;
        _picWidth = KPhotoWidth;
    }
}

- (void)initOperateViewData:(NSDictionary*)aDict {
    NSString *tagName = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";
    self.operateView.albumBtn.btnLbl.text = tagName;
    _infoLbl.text = [aDict objectForKey:MESSAGE];
}

- (void)initFirstCellData:(NSDictionary*)aDict {
    //来自
    self.comeLbl.text = $str(@"来自：%@", emptystr([aDict objectForKey:COME]));
    
    if (aDict) {
        NSString *rePostNum = _feedDetailType == photoDetailType ? @"rephotonum" : (_feedDetailType == blogDetailType ? @"reblognum" : (_feedDetailType == videoDetailType ? @"revideonum" : (_feedDetailType == eventDetailType ? @"reeventnum" : @"")));
        rePostNum = [rePostNum isEqualToString:@""] ? @"见鬼了" : rePostNum;
        self.hotLbl.text = [NSString stringWithFormat:@"转发(%@) 收藏(%@) 评论(%@)", [aDict objectForKey:rePostNum], [aDict objectForKey:FEED_LOVE_NUM], [aDict objectForKey:FEED_REPLY_NUM]];
    } else {
        self.hotLbl.text = @"转发(0) 收藏(0) 评论(0)";
    }
    
    //空间
    NSString *tagName = [[aDict objectForKey:TAG] isKindOfClass:[NSDictionary class]] ? [[aDict objectForKey:TAG] objectForKey:TAG_NAME] : @"";
    self.operateView.albumBtn.btnLbl.text = tagName;
    switch (_feedDetailType) {
//        case photoDetailType:
//        {
//            if (![[aDict objectForKey:PIC_LIST] isEqual:[NSNull null]]) {
//                NSArray *picArray = [aDict objectForKey:PIC_LIST];
//                for (int i = 0; i < _picNum; i++) {
//                    int firstIndexOfAllImageView = [self.contentView.subviews count] - _picNum;
//                    if ([[[self.contentView subviews] objectAtIndex:i + firstIndexOfAllImageView] isKindOfClass:[UIImageView class]]) {
//                        UIImageView *photoImgView = (UIImageView*)[[self.contentView subviews] objectAtIndex:i + firstIndexOfAllImageView];
//                        NSString *picUrlStr = $str(@"%@%@", [[[picArray objectAtIndex:i] objectForKey:PIC] delLastStrForYouPai], ypFeedDetail);
//                        [photoImgView setImageWithURL:[NSURL URLWithString:picUrlStr] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
//                    }
//                }
//            }
//            _infoLbl.text = [aDict objectForKey:MESSAGE];
//            break;
//        }
        case blogDetailType:
        {
//            _webView.hidden = YES;
//            [_webView setScalesPageToFit:NO];
//            [_webView loadHTMLString:[aDict objectForKey:MESSAGE] baseURL:nil];
            _infoLbl.text = @"加载中...";
            _infoLbl.font = [UIFont boldSystemFontOfSize:14.0f];
            _infoLbl.textColor = [UIColor lightGrayColor];
            _infoLbl.textAlignment = UITextAlignmentCenter;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//            _infoLbl.textAlignment = UITextAlignmentCenter;
//#else
//            _infoLbl.textAlignment = NSTextAlignmentCenter;
//#endif
            _infoLbl.frame = CGRectMake(0, 120, DEVICE_SIZE.width, 30);
            [self.contentView bringSubviewToFront:_infoLbl];
            break;
        }
        case videoDetailType:
        {//http://v.youku.com/v_show/id_XMjM2NjYyMjAw.html [aDict objectForKey:VIDEO_URL]
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[aDict objectForKey:VIDEO_URL]]]];
            _webView.backgroundColor = [UIColor lightGrayColor];
            _infoLbl.text = [aDict objectForKey:MESSAGE];
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
            _dateLbl.text = [NSString stringWithFormat:@"时间：%@", emptystr([Common dateConvert:[aDict objectForKey:START_TIME]])];
            _locationLbl.text = [NSString stringWithFormat:@"地点：%@", emptystr([aDict objectForKey:FEED_EVENT_LOCATION])];
//            _describeLbl.text = [NSString stringWithFormat:@"介绍：%@", emptystr([aDict objectForKey:FEED_EVENT_DETAIL])];
            
            //地图
            self.latStr = [aDict objectForKey:LAT];
            self.lngStr = [aDict objectForKey:LNG];
//            _coordinate.latitude = [[aDict objectForKey:LAT] doubleValue];
//            _coordinate.longitude = [[aDict objectForKey:LNG] doubleValue];
//            
//            float zoomLevel = 0.018;
//            MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
//            [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
//            
//            //大头针
//            MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:_coordinate];
//            annotation.title = @"我在这里";
////            annotation.subtitle = @"";
//            self.myAnnotation = annotation;
//            [_mapView removeAnnotations:_mapView.annotations];
//            [_mapView addAnnotation:_myAnnotation];
            
            break;
        }
        default:
            break;
    }
}

- (void)initCommentData:(NSDictionary*)aDict {
    if (!aDict) {
        self.simpleInfoView.hidden = YES;
        self.noCommentLbl.hidden = NO;
        self.noCommentLbl.text = _isLoadingFirstCell ? @"加载中..." : @"评论一下吧...";
    } else {
        self.simpleInfoView.hidden = NO;
        self.noCommentLbl.hidden = YES;
        self.simpleInfoView.isFamilyList = NO;
        self.simpleInfoView.userId = [aDict objectForKey:NOTICE_AUTHOR_ID];
        [self.simpleInfoView.headBtn setVipStatusWithStr:emptystr([aDict objectForKey:VIP_STATUS]) isSmallHead:YES];
        [self.simpleInfoView initInfoWithHeadUrlStr:[aDict objectForKey:AVATAR]
                                            nameStr:[aDict objectForKey:COMMENT_AUTHOR_NAME]
                                        noteNameStr:@""
                                            infoStr:[aDict objectForKey:MESSAGE]
                                   andRightImgPoint:CGPointMake(66, 34)
                                           rightImg:@"time.png"
                                           rightStr:[Common dateSinceNow:[aDict objectForKey:DATELINE]]];
    }
}

- (IBAction)mapBtnPressed:(id)sender {
    ShowMapViewController *con = [[ShowMapViewController alloc] initWithNibName:@"ShowMapViewController" bundle:nil];
    con.latStr = _latStr;
    con.lngStr = _lngStr;
    pushAConInView(self, con);
}

//- (void)initJoinData:(NSDictionary*)aDict {
//    if (!aDict) {
//        self.simpleInfoView.hidden = YES;
//        self.noCommentLbl.hidden = NO;
//        self.noCommentLbl.text = _isLoadingFirstCell ? @"加载中..." : @"";
//    } else {
//        self.simpleInfoView.hidden = NO;
//        self.noCommentLbl.hidden = YES;
//        self.simpleInfoView.isFamilyList = NO;
//        self.simpleInfoView.userId = [aDict objectForKey:UID];
//        [self.simpleInfoView initInfoWithHeadUrlStr:[aDict objectForKey:AVATAR]
//                                            nameStr:[aDict objectForKey:NAME]
//                                        noteNameStr:@""
//                                            infoStr:@"参与了活动"
//                                   andRightImgPoint:CGPointMake(66, 34)
//                                           rightImg:@"time.png"
//                                           rightStr:@"等接口"];
//    }
//}

//#pragma mark - mapview
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    if (!hasEventImage) {
//        [_mapView selectAnnotation:_myAnnotation animated:YES];
//    }
//}

@end
