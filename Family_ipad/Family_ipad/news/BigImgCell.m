//
//  BigImgCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BigImgCell.h"
#import "web_config.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+BlocksKit.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#define PIC_SIZE @"!885X600"
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
- (void)initData:(NSDictionary *)aDict {
    [self.picArray removeAllObjects];
    [bigImgView setImageWithURL:[self genreateImgURL:[aDict objectForKey:FEED_IMAGE_1] size:PIC_SIZE] placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    [self.picArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[[aDict objectForKey:FEED_IMAGE_1] delLastStrForYouPai]]]];
    bigImgView.userInteractionEnabled = YES;
    [bigImgView whenTapped:^{
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        //browser.displayActionButton = NO;
        browser.tapToClose = YES;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        [[AppDelegate instance].rootViewController presentModalViewController:nc animated:YES];

    }];
    bigImgLbl.text = [aDict objectForKey:MESSAGE];
    bigImgLbl.font = [UIFont boldSystemFontOfSize:15.0f];
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
