//
//  PinchImageView.h
//  PinchImageView
//
//  Created by pandara on 13-3-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchImageView : UIScrollView<UIGestureRecognizerDelegate> {
    CGPoint touchPoint;
    CGRect originalImageFrame;
}

@property (strong, nonatomic) UIImageView *imageView;

- (void)scaleImage:(UIPinchGestureRecognizer *)sender;
- (void)scaleToMin;
- (void)scaleToMaxWithXRate:(CGFloat)xRate yRate:(CGFloat)yRate;
@end
