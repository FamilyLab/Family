//
//  UIView+bounce.m
//  Family
//
//  Created by Aevitx on 13-5-28.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UIView+bounce.h"

@implementation UIView (bounce)

- (IBAction)showAnimation:(id)sender {
    [UIView animateWithDuration:0.2 animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
        self.alpha = 0.5;
    } completion:^(BOOL finished){
        [self bounceOutAnimationStoped];
    }];
}

- (void)bounceOutAnimationStoped {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
        self.alpha = 0.8;
    } completion:^(BOOL finished){
        [self bounceInAnimationStoped];
    }];
}

- (void)bounceInAnimationStoped {
    [UIView animateWithDuration:0.1 animations:^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
        self.alpha = 1.0;
    } completion:^(BOOL finished){
        [self animationStoped];
    }];
}

- (void)animationStoped {
    
}

- (IBAction)hide:(id)sender {
    self.alpha = 0;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
}

@end
