//
//  BigImgCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BigImgCell.h"
//#import "UIImageView+WebCache.h"
#import "MyHttpClient.h"
//#import "ShowBigImageController.h"

@implementation BigImgCell
@synthesize bigImgView, bigImgLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    bigImgLbl.frame = (CGRect){.origin.x = bigImgLbl.frame.origin.x, .origin.y = bigImgView.frame.origin.y + bigImgView.frame.size.height + preContentH, .size = bigImgLbl.frame.size};
    self.comeLbl.frame = (CGRect){.origin.x = self.comeLbl.frame.origin.x, .origin.y = bigImgLbl.frame.origin.y + bigImgLbl.frame.size.height, .size = self.comeLbl.frame.size};
    self.typeView.frame = (CGRect){.origin = self.typeView.frame.origin, .size.width = self.typeView.frame.size.width, .size.height = bigImgLbl.frame.origin.y + bigImgLbl.frame.size.height + self.comeLbl.frame.size.height};
    bigImgView.frame = (CGRect){.origin = bigImgView.frame.origin, .size = CGSizeMake(280, 200)};
}

- (void)initData:(NSDictionary *)aDict {
    [bigImgView setImageWithURL:[NSURL URLWithString:$str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai], ypFeedBigImg)] placeholderImage:[UIImage imageNamed:@"head_220.png"]];
    bigImgLbl.text = [aDict objectForKey:SUBJECT];
    
    if ([emptystr([aDict objectForKey:OLD_SUBJECT]) isEqualToString:@""]) {
        self.preContentView.hidden = YES;
    } else {
        self.preContentView.hidden = NO;
        self.preContentView.rightLbl.text = [aDict objectForKey:OLD_SUBJECT];
    }
//    bigImgView.userInteractionEnabled = YES;
//    [bigImgView whenTapped:^{
//        ShowBigImageController *con = [[ShowBigImageController alloc] initWithNibName:@"ShowBigImageController" bundle:nil];
//        con.thumbImgStr = $str(@"%@%@", [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai], ypFeedBigImg);
//        con.fullImgStr = [[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai];
//        presentAConInView(self, con);
//    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
