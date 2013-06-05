//
//  SomeImgsCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SomeImgsCell.h"
#import "UIView+BlocksKit.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#define PIC_SIZE @"!285X285"
@implementation SomeImgsCell
@synthesize firstImgView, secondImgView, thirdImgView, imgsNumLbl, describeLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setTapAction:(UIImageView *)sender
                 url:(NSURL *)url
               index:(NSUInteger)index
{
    sender.userInteractionEnabled = YES;
    [self.picArray addObject:[MWPhoto photoWithURL:url]];
    [sender whenTapped:^{
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.tapToClose = YES;

        [browser setInitialPageIndex:index];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [[AppDelegate instance].rootViewController presentModalViewController:nc animated:YES];
        
    }];

}
- (void)initData:(NSDictionary *)aDict {
    imgsNumLbl.hidden = NO;
    if (![[aDict objectForKey:FEED_IMAGE_1] isEqualToString:@""]) {

        firstImgView.hidden = NO;
        [firstImgView setImageWithURL:[self genreateImgURL:[aDict objectForKey:FEED_IMAGE_1] size:PIC_SIZE]placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        [self setTapAction:firstImgView url:[NSURL URLWithString:[aDict objectForKey:FEED_IMAGE_1]] index:0];
    } else
        firstImgView.hidden = YES;
    
    if (![[aDict objectForKey:FEED_IMAGE_2] isEqualToString:@""]) {
        secondImgView.hidden = NO;
        
        [secondImgView setImageWithURL:[self genreateImgURL:[aDict objectForKey:FEED_IMAGE_2] size:PIC_SIZE]placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        [self setTapAction:secondImgView url:[NSURL URLWithString:[aDict objectForKey:FEED_IMAGE_2]] index:1];

    } else
        secondImgView.hidden = YES;
    
    if (![[aDict objectForKey:FEED_IMAGE_3] isEqualToString:@""]) {
        thirdImgView.hidden = NO;
        imgsNumLbl.frame = (CGRect){.origin.x = 400, .origin.y = imgsNumLbl.frame.origin.y, .size = imgsNumLbl.frame.size};

        [thirdImgView setImageWithURL:[self genreateImgURL:[aDict objectForKey:FEED_IMAGE_3] size:PIC_SIZE]placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
        [self setTapAction:thirdImgView url:[NSURL URLWithString:[aDict objectForKey:FEED_IMAGE_3]] index:2];

    } else {
        thirdImgView.hidden = YES;
       imgsNumLbl.frame = (CGRect){.origin.x = 254, .origin.y = imgsNumLbl.frame.origin.y, .size = imgsNumLbl.frame.size};

    }
    
    imgsNumLbl.text = [NSString stringWithFormat:@"%@张", [aDict objectForKey:PIC_NUM]];
   
    describeLbl.text = [aDict objectForKey:MESSAGE];
}
@end
