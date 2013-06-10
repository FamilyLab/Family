//
//  ImgAndTextCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ImgAndTextCell.h"
#import "UILabel+VerticalAlign.h"

@implementation ImgAndTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.preContentView.rightLbl.numberOfLines = 6;
        [self.preContentView.rightLbl alignTop];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.preContentView.rightLbl.numberOfLines = 6;
        [self.preContentView.rightLbl alignTop];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    return;
    if (!self.preContentView.hidden) {
        [self.preContentView layoutSubviews];
    }
    CGSize preContentSize = [PreContentView heightForCellWithText:self.preContentView.rightLbl.text andOtherHeight:0 andLblMaxWidth:160 andFont:self.preContentView.rightLbl.font];
    preContentSize.width = preContentSize.width < 180 ? 180 : preContentSize.width;
    preContentSize.height = preContentSize.height >= 116 ? 116 : preContentSize.width;
    self.preContentView.frame = (CGRect){.origin = self.preContentView.frame.origin, .size = preContentSize};
    
    CGSize describeSize = [_describeLbl.text sizeWithFont:_describeLbl.font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    if (!_describeLbl.hidden) {
        _describeLbl.frame = (CGRect){.origin.x = _describeLbl.frame.origin.x, .origin.y = self.comeLbl.frame.origin.y + self.comeLbl.frame.size.height + 2, .size = describeSize};
    }
    CGFloat describeH = _describeLbl.hidden ? 0 : _describeLbl.frame.size.height;
//    if (!self.preContentView.hidden) {
//        self.preContentView.frame = (CGRect){.origin.x = self.preContentView.frame.origin.x, .origin.y = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + 3, .size = self.preContentView.frame.size};
//    }
    self.typeView.frame = (CGRect){.origin = self.typeView.frame.origin, .size.width = self.typeView.frame.size.width, .size.height = self.comeLbl.frame.origin.y + self.comeLbl.frame.size.height + describeH};
}

- (void)initData:(NSDictionary *)aDict {
    if ([[aDict objectForKey:FEED_IMAGE_1] rangeOfString:ypUrlStr].length > 0) {//是又拍云上的图片
        [_leftImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai], ypFeedForImgAndText)] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    } else {//不是又拍云上的图片，如直接在网站上找包含有图片的帖子复制进来的
        UIImage *placeholder = [UIImage imageNamed:@"pic_default.png"];
        if ((self.frame.size.width >= placeholder.size.width && self.frame.size.height >= placeholder.size.height) || self.frame.size.width == 0 || self.frame.size.height == 0) {
            [self setContentMode:UIViewContentModeCenter];
        }
        __block UIImageView *blockLeft = _leftImgView;
        [_leftImgView setImageWithURL:[NSURL URLWithString:[aDict objectForKey:FEED_IMAGE_1]] placeholderImage:placeholder success:^(UIImage *image) {
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
    }
//    _titleLbl.text = [aDict objectForKey:SUBJECT];
//    _describeLbl.text = [aDict objectForKey:MESSAGE];
    
    if ([emptystr([aDict objectForKey:OLD_MESSAGE]) isEqualToString:@""]) {//非转载
        _titleLbl.text = [aDict objectForKey:SUBJECT];
        self.preContentView.rightLbl.text = [aDict objectForKey:MESSAGE];
        _describeLbl.hidden = YES;
    } else {//转载
        _titleLbl.text = [aDict objectForKey:OLD_SUBJECT];
        self.preContentView.rightLbl.text = [aDict objectForKey:OLD_MESSAGE];
        _describeLbl.hidden = NO;
        _describeLbl.text = [aDict objectForKey:MESSAGE];
    }
    
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
    browser.indexRow = self.indexRow;
    browser.cell = self;
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
