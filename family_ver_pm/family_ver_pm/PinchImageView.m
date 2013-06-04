//
//  PinchImageView.m
//  PinchImageView
//
//  Created by pandara on 13-3-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "PinchImageView.h"

@implementation PinchImageView

CGFloat lastScale = 1.0;
#define MAX_TIME 10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.frame = frame;
        self.imageView.image = [UIImage imageNamed:@"img0.JPG"];
        self.imageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
        self.imageView.userInteractionEnabled = YES;
        pinchGesture.delegate = self;
        [self.imageView addGestureRecognizer:pinchGesture];
        originalImageFrame = frame;
        
        [self addSubview:self.imageView];
        self.contentSize = frame.size;
    }
    return self;
}
//#define DEVICE_SIZE CGSizeMake(320, 480)
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    static CGFloat xRate;
    static CGFloat yRate;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            
           // NSLog([NSString stringWithFormat:@"touch point %f %f", touchPoint.x, touchPoint.y]);
            xRate = (self.contentOffset.x + touchPoint.x) / self.imageView.frame.size.width;
            yRate = (self.contentOffset.y + touchPoint.y) / self.imageView.frame.size.height;
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            lastScale = 1.0;
            if (self.imageView.frame.size.width < originalImageFrame.size.width) {
                [self scaleToMin];
            } else if (self.imageView.frame.size.width > originalImageFrame.size.width * MAX_TIME) {
                [self scaleToMaxWithXRate:xRate yRate:yRate];
            }
            return;
        }
        default:
            break;
    }
    
    CGFloat scale = sender.scale;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width * (1 + (scale - lastScale)), self.imageView.frame.size.height * (1 + (scale - lastScale)));
    self.contentSize = self.imageView.frame.size;

    self.contentOffset = CGPointMake(self.imageView.frame.size.width * xRate - touchPoint.x, self.imageView.frame.size.height * yRate - touchPoint.y);
    
    lastScale = scale;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    touchPoint = [touch locationInView:self];
//    touchPoint = CGPointMake(touchPoint.x - self.contentOffset.x, touchPoint.y - self.contentOffset.y);
////    NSLog([NSString stringWithFormat:@"begin touch %f %f", touchPoint.x, touchPoint.y]);
//}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer numberOfTouches] == 2) {
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        CGPoint touchPoint1 = [gestureRecognizer locationOfTouch:0 inView:keyWindow];
        CGPoint touchPoint2 = [gestureRecognizer locationOfTouch:1 inView:keyWindow];
        touchPoint = CGPointMake((touchPoint1.x + touchPoint2.x) / 2, (touchPoint1.y + touchPoint2.y) / 2);
        NSLog(@"%f, %f", touchPoint.x, touchPoint.y);
    }
    
    return YES;
}

- (void)scaleToMin
{
    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.frame = originalImageFrame;
        self.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)scaleToMaxWithXRate:(CGFloat)xRate yRate:(CGFloat)yRate
{
    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.frame = CGRectMake(0, 0, originalImageFrame.size.width * MAX_TIME, originalImageFrame.size.height * MAX_TIME);
        //self.contentSize = CGSizeMake(originalImageFrame.size.width * 2, originalImageFrame.size.height * 2);
        self.contentOffset = CGPointMake(originalImageFrame.size.width * MAX_TIME * xRate - touchPoint.x, originalImageFrame.size.height * MAX_TIME *yRate - touchPoint.y);
    } completion:^(BOOL finished) {
        if (finished) {
            self.contentSize = CGSizeMake(originalImageFrame.size.width * MAX_TIME, originalImageFrame.size.height * MAX_TIME);//???????
        }
    }];
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
