//
//  SomeImgsCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SomeImgsCell.h"
#import "UILabel+VerticalAlign.h"

@implementation SomeImgsCell
@synthesize firstImgView, secondImgView, thirdImgView, imgsNumLbl, describeLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [describeLbl alignTop];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [describeLbl alignTop];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.preContentView.hidden) {
        [self.preContentView layoutSubviews];
    }
    
    CGSize preContentSize = [PreContentView heightForCellWithText:self.preContentView.rightLbl.text andOtherHeight:0 andLblMaxWidth:265 andFont:self.preContentView.rightLbl.font];
    preContentSize.width = preContentSize.width < 280 ? 280 : preContentSize.width;
    self.preContentView.frame = (CGRect){.origin = self.preContentView.frame.origin, .size = preContentSize};
    
    CGFloat preContentH = self.preContentView.hidden ? 0 : self.preContentView.frame.size.height;
    CGSize describeSize = [describeLbl.text sizeWithFont:describeLbl.font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    describeLbl.frame = (CGRect){.origin.x = describeLbl.frame.origin.x, .origin.y = firstImgView.frame.origin.y + firstImgView.frame.size.height + preContentH + 10, .size = describeSize};
    self.comeLbl.frame = (CGRect){.origin.x = self.comeLbl.frame.origin.x, .origin.y = describeLbl.frame.origin.y + describeLbl.frame.size.height, .size = self.comeLbl.frame.size};
    self.typeView.frame = (CGRect){.origin = self.typeView.frame.origin, .size.width = self.typeView.frame.size.width, .size.height = describeLbl.frame.origin.y + describeLbl.frame.size.height + self.comeLbl.frame.size.height};
//    firstImgView.frame = (CGRect){.origin = firstImgView.frame.origin, .size = CGSizeMake(95, 95)};
}

- (void)initData:(NSDictionary *)aDict {
    if (![[aDict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {
        [firstImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai], ypFeedSomeImgs)] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else
        firstImgView.hidden = YES;
    
    if (![[aDict objectForKey:FEED_IMAGE_2] isEqualToString:@""]) {
        [secondImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_2] delLastStrForYouPai], ypFeedSomeImgs)] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else
        secondImgView.hidden = YES;
    
    if (![[aDict objectForKey:FEED_IMAGE_3] isEqualToString:@""]) {
        [thirdImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_3] delLastStrForYouPai], ypFeedSomeImgs)] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    } else {
        thirdImgView.hidden = YES;
        imgsNumLbl.frame = (CGRect){.origin.x = 157, .origin.y = imgsNumLbl.frame.origin.y, .size = imgsNumLbl.frame.size};
    }
    imgsNumLbl.text = [NSString stringWithFormat:@"%@张", [aDict objectForKey:PIC_NUM]];
    describeLbl.text = [aDict objectForKey:MESSAGE];
    
    
    if ([emptystr([aDict objectForKey:OLD_MESSAGE]) isEqualToString:@""]) {
        self.preContentView.hidden = YES;
    } else {
        self.preContentView.hidden = NO;
        self.preContentView.rightLbl.text = [aDict objectForKey:OLD_MESSAGE];
    }
    
    firstImgView.userInteractionEnabled = YES;
    [firstImgView whenTapped:^{
        [self showBigImgWithIndex:0 andDict:aDict];
    }];
    
    secondImgView.userInteractionEnabled = YES;
    [secondImgView whenTapped:^{
        [self showBigImgWithIndex:1 andDict:aDict];
    }];
    
    thirdImgView.userInteractionEnabled = YES;
    [thirdImgView whenTapped:^{
        [self showBigImgWithIndex:2 andDict:aDict];
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
