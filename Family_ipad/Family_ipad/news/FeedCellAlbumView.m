//
//  FeedCellAlbumView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCellAlbumView.h"

@implementation FeedCellAlbumView
@synthesize dataDict, containerView, albumBtn, albumLeft, repostBtn, likeitBtn, commentBtn, showMoreBtn, isShowing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isShowing = NO;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)showMoreBtnPressed:(id)sender {
    [self.showMoreBtn setImage:[UIImage imageNamed:@"showmore.png"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGFloat theX = isShowing ? 15 : -220;
                         containerView.frame = CGRectMake(theX, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height);
                     }];
    isShowing = !isShowing;
    NSString *imgStr = isShowing ? @"showmore_back.png" : @"showmore.png";
    [self.showMoreBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
}

//- (void)initAlbumViewData:(NSDictionary *)_aDict {
//    self.dataDict = _aDict;
//    [self.albumBtn setImage:ThemeImage(@"album_bg_a") forState:UIControlStateNormal];
//    [self.albumBtn setImage:ThemeImage(@"album_bg_b") forState:UIControlStateHighlighted];
//    [self.albumBtn changeLblWithText:@"创意BB杂锦" andColor:[UIColor whiteColor] andSize:11.0f theX:25];
//    self.albumLeft.image = ThemeImage(@"album");
//    
//    [self.likeitBtn setImage:[UIImage imageNamed:@"likeit_a.png"] forState:UIControlStateNormal];
//    [self.likeitBtn setImage:[UIImage imageNamed:@"likeit_b.png"] forState:UIControlStateHighlighted];
//    [self.likeitBtn setImage:[UIImage imageNamed:@"likeit_b.png"] forState:UIControlStateSelected];
//    [self.repostBtn changeLblWithText:@"15" andColor:[UIColor whiteColor] andSize:12.0f theX:25];
//    [self.likeitBtn changeLblWithText:@"20" andColor:[UIColor whiteColor] andSize:12.0f theX:25];
//    [self.commentBtn changeLblWithText:@"25" andColor:[UIColor whiteColor] andSize:12.0f theX:25];
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
