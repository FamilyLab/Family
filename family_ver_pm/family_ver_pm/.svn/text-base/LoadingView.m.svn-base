//
//  LoadingView.m
//  family_ver_pm
//
//  Created by pandara on 13-3-26.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
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
- (void)loadAnimation
{
    [self performSelector:@selector(beginAnimation) withObject:self];
    //[self performSelector:@selector(endingAnimation) withObject:self afterDelay:LOADING_ANIMATION_DUR * LOADING_ANIMATION_COUNT];
    //[self performSelector:@selector(completeAnimation) withObject:self afterDelay:LOADING_ANIMATION_DUR * LOADING_ANIMATION_COUNT + END_LOADING_ANIMATION_DUR];
}

- (void)beginAnimation
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = LOADING_ANIMATION_DUR;
    rotationAnimation.repeatCount = LOADING_ANIMATION_COUNT;
    [rotationAnimation setValue:@"rotationAnimation" forKey:@"MyAnimationType"];
    [self.loadingIcon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)endingAnimation
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = END_LOADING_ANIMATION_DUR;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromBottom;
    [self.layer addAnimation:animation forKey:@"animation"];
    self.alpha = 0;
}

- (void)completeAnimation
{
    [self removeFromSuperview];
}

@end











