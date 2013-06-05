//
//  LoadingView.m
//  Family
//
//  Created by Aevitx on 13-3-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+BlocksKit.h"
#import "Common.h"
#import "AppDelegate.h"
#import "RootViewController.h"  
#import "StackScrollViewController.h"
#import "ConciseKit.h"
#import "web_config.h"
#define delayTimeToLoadingAnimation     0.5f
#define delayTimeToRemoveLoadingView    2.0f - delayTimeToLoadingAnimation
#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = DEVICE_BOUNDS;
        UIImageView *bgImgView = (UIImageView*)[self.subviews objectAtIndex:0];
        bgImgView.frame = DEVICE_BOUNDS;
        bgImgView.image = [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:350];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.frame = DEVICE_BOUNDS;
        UIImageView *bgImgView = (UIImageView*)[self.subviews objectAtIndex:0];
        bgImgView.frame = DEVICE_BOUNDS;
        bgImgView.image = [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:350];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)loadingAnimation {
//    [self performBlock:^(id sender) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotationAnimation.delegate = self;
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
        rotationAnimation.duration = 0.5f;
        rotationAnimation.repeatCount = MAXFLOAT;
//        rotationAnimation.repeatCount = 3;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [rotationAnimation setValue:@"rotationAnimation"forKey:@"MyAnimationType"];
        [_loadingImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//    } afterDelay:delayTimeToLoadingAnimation];
    
    [self performBlock:^(id sender) {
        [[AppDelegate instance]setUpRootView];

        UIViewController *con = (UIViewController*)[Common viewControllerOfView:self];
        [self removeTheLoadingViewInCon:con];
    } afterDelay:delayTimeToRemoveLoadingView];
}

- (void)removeTheLoadingViewInCon:(UIViewController*)con {
    [self performBlock:^(id sender) {

    } afterDelay:0.1f];
    
    [UIView beginAnimations:@"Curl"context:nil];
    [UIView setAnimationDuration:1.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:con.view cache:YES];
    NSUInteger loadingIndex = [[con.view subviews] indexOfObject:self];
    [con.view exchangeSubviewAtIndex:loadingIndex withSubviewAtIndex:loadingIndex-1];
    [UIView setAnimationDelegate:self];
    [self removeFromSuperview];
    [UIView commitAnimations];
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
