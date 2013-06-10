//
//  LocationCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "LocationCell.h"
#import "Common.h"
#import "UILabel+VerticalAlign.h"
#import "SDWebImageManager.h"

//有图片的情况
#define aSubjectFrame   CGRectMake(114, 0, 176, 21)
#define aDateFrame      CGRectMake(114, 26, 176, 24)
#define aLocationFrame  CGRectMake(114, 50, 176, 24)
#define aDescribeFrame  CGRectMake(114, 71, 176, 68)

//无图片的情况
#define bSubjectFrame   CGRectMake(7, 0, 283, 21)
#define bDateFrame      CGRectMake(7, 26, 283, 24)
#define bLocationFrame  CGRectMake(7, 50, 283, 24)
#define bDescribeFrame  CGRectMake(7, 71, 283, 68)

@implementation LocationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [_describeLbl alignTop];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [_describeLbl alignTop];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_leftImgView.image) {//无图片
        _subjectLbl.frame = bSubjectFrame;
        _dateLbl.frame = bDateFrame;
        _locationLbl.frame = bLocationFrame;
//        _describeLbl.frame = bDescribeFrame;
    } else {//有图片
        _subjectLbl.frame = aSubjectFrame;
        _dateLbl.frame = aDateFrame;
        _locationLbl.frame = aLocationFrame;
//        _describeLbl.frame = aDescribeFrame;
    }
    
    CGFloat maxWidth = _leftImgView.image ? 176 : 283;
    CGFloat describeX = _leftImgView.image ? 114 : 7;
    CGSize describeSize = [_describeLbl.text sizeWithFont:_describeLbl.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    describeSize.height = describeSize.height > 68 ? 68 : describeSize.height;
    _describeLbl.frame = (CGRect){.origin.x = describeX, .origin.y = _locationLbl.frame.origin.y + _locationLbl.frame.size.height, .size = describeSize};
    
    CGFloat comeLblY = _leftImgView.image ? _leftImgView.frame.origin.y + _leftImgView.frame.size.height : _describeLbl.frame.origin.y + _describeLbl.frame.size.height;
    self.comeLbl.frame = (CGRect){.origin.x = self.comeLbl.frame.origin.x, .origin.y = comeLblY, .size = self.comeLbl.frame.size};
    
    CGFloat typeViewH = _leftImgView.image ? 172 : self.comeLbl.frame.origin.y + self.comeLbl.frame.size.height;
    self.typeView.frame = (CGRect){.origin = self.typeView.frame.origin, .size.width = self.typeView.frame.size.width, .size.height = typeViewH};
}

- (void)initData:(NSDictionary *)aDict {
    NSString *imgUrlStr = emptystr([aDict objectForKey:FEED_IMAGE_1]);
    if (![imgUrlStr isEqualToString:@""]) {
        if ([imgUrlStr rangeOfString:ypUrlStr].length > 0) {
            [_leftImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [imgUrlStr delLastStrForYouPai], ypFeedForImgAndText)] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        } else {
            __block UIImageView *blockLeft = _leftImgView;
            [_leftImgView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"pic_default.png"] success:^(UIImage *image) {
                //200x280
                if (image.size.width > 200) {
                    blockLeft.contentMode = UIViewContentModeScaleAspectFill;
                    blockLeft.clipsToBounds = YES;
                    float scaleSize = (float)200 / (float)image.size.width;
                    blockLeft.image = [Common scaleImage:image toScale:scaleSize];
                }
            } failure:^(NSError *error) {
                ;
            }];
//            [_leftImgView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        }
//        [_leftImgView setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else {
        _leftImgView.image = nil;
    }
    _subjectLbl.text = emptystr([aDict objectForKey:SUBJECT]);
    if (isEmptyStr([aDict objectForKey:EVENT_START_TIME])) {
        _dateLbl.text = [NSString stringWithFormat:@"时间："];
    } else
        _dateLbl.text = [NSString stringWithFormat:@"时间：%@", [Common dateConvert:[aDict objectForKey:EVENT_START_TIME]]];
    if (!isEmptyStr([aDict objectForKey:FEED_EVENT_LOCATION])) {
        _locationLbl.text = [NSString stringWithFormat:@"地点：%@", emptystr([aDict objectForKey:FEED_EVENT_LOCATION])];
    } else
        _locationLbl.text = [NSString stringWithFormat:@"地点：%@", emptystr([aDict objectForKey:ADDRESS])];
    _describeLbl.text = [NSString stringWithFormat:@"介绍：%@", emptystr([aDict objectForKey:EVENT_DETAIL])];//[Common dateConvert:[aDict objectForKey:SUBJECT]]];
//    [_describeLbl alignTop];
    
    _leftImgView.userInteractionEnabled = YES;
    [_leftImgView whenTapped:^{
        [self showBigImgWithIndex:0 andDict:aDict];
    }];
}

- (void)showBigImgWithIndex:(int)index andDict:(NSDictionary*)aDict {
    if (!self.photosArray) {
        self.photosArray = [[NSMutableArray alloc] init];
    }
    [self.photosArray removeAllObjects];
    for (int i = 0; i < [self.picArray count]; i++) {
        [self.photosArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[self.picArray objectAtIndex:i] delLastStrForYouPai]]]];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.wantsFullScreenLayout = YES;
    browser.displayActionButton = YES;
    [browser setInitialPageIndex:index];
    
    browser.dataDict = (NSMutableDictionary*)aDict;
    browser.idType = [aDict objectForKey:FEED_ID_TYPE];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    nav.navigationBarHidden = YES;
    presentAConInView(self, nav);
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosArray.count)
        return [self.photosArray objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photosArray objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return captionView;
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
