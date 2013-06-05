//
//  KGModal.m
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "KGModal.h"
#import <QuartzCore/QuartzCore.h>
#import "PostBaseView.h"
CGFloat const kFadeInAnimationDuration = 0.3;
CGFloat const kTransformPart1AnimationDuration = 0.2;
CGFloat const kTransformPart2AnimationDuration = 0.1;
NSString *const KGModalGradientViewTapped = @"KGModalGradientViewTapped";

@interface KGModalGradientView : UIView
@end

@interface KGModalContainerView : UIView
@end

@interface KGModalCloseButton : UIButton
@end

@interface KGModalViewController : UIViewController
@property (unsafe_unretained, nonatomic) KGModalGradientView *styleView;
@end

@interface KGModal()
@property (strong, nonatomic) UIWindow *window;
@property (unsafe_unretained, nonatomic) KGModalViewController *viewController;
@property (unsafe_unretained, nonatomic) KGModalContainerView *containerView;
@property (unsafe_unretained, nonatomic) KGModalCloseButton *closeButton;
@property (unsafe_unretained, nonatomic) UIView *contentView;
@end

@implementation KGModal
- (UIViewController *)getViewController
{
    return self.viewController;
}
+ (id)sharedInstance{
    static id sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    if(!(self = [super init])){
        return nil;
    }
    
    self.tapOutsideToDismiss = YES;
    self.animateWhenDismissed = YES;
    self.showCloseButton = YES;

    return self;
}

- (void)setShowCloseButton:(BOOL)showCloseButton{
    if(_showCloseButton != showCloseButton){
        _showCloseButton = showCloseButton;
        [self.closeButton setHidden:!self.showCloseButton];
    }
}

- (void)showWithContentView:(UIView *)contentView{
    [self showWithContentView:contentView andAnimated:YES];
}
- (void)showWithContentViewInMiddle:(UIView *)contentView andAnimated:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.orginalWindow = [UIApplication sharedApplication].keyWindow;
    self.window.opaque = NO;
    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    if ([contentView isKindOfClass:[PostBaseView class]]){
        ((PostBaseView*) contentView).parent= viewController;
        
    }
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(contentView.bounds, -padding, -padding);
        containerViewRect.origin.x = containerViewRect.origin.y = 0;
        containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds)-CGRectGetMidX(containerViewRect));
        containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds)-CGRectGetMidY(containerViewRect));
    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initWithFrame:containerViewRect];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    contentView.frame = (CGRect){padding, padding, contentView.bounds.size};
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    
    KGModalCloseButton *closeButton = self.closeButton = [[KGModalCloseButton alloc] init];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [viewController.view addSubview:closeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                }];
            }];
        }
    });
}

- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.orginalWindow = [UIApplication sharedApplication].keyWindow;
    self.window.opaque = NO;
    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    if ([contentView isKindOfClass:[ZoneWaterFallView class]]) {
        ((ZoneWaterFallView*) contentView).parent= viewController;
    }
    else if ([contentView isKindOfClass:[PostBaseView class]]){
        ((PostBaseView*) contentView).parent= viewController;

    }

    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initWithFrame:CGRectMake(90, 10, 1024-100, 748)];
   
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];

    KGModalCloseButton *closeButton = self.closeButton = [[KGModalCloseButton alloc] init];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [viewController.view addSubview:closeButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];

    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];

            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                }];
            }];
        }
    });
}
- (void)showWithLoginContentView:(UIView *)contentView andAnimated:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.orginalWindow = [UIApplication sharedApplication].keyWindow;
    self.window.opaque = NO;
    KGModalViewController *viewController = self.viewController = [[KGModalViewController alloc] init];
    self.window.rootViewController = viewController;
    if ([contentView isKindOfClass:[ZoneWaterFallView class]]) {
        ((ZoneWaterFallView*) contentView).parent= viewController;
    }
    else if ([contentView isKindOfClass:[PostBaseView class]]){
        ((PostBaseView*) contentView).parent= viewController;
        
    }
    
    KGModalContainerView *containerView = self.containerView = [[KGModalContainerView alloc] initWithFrame:CGRectMake(90, 10, 1024-100, 748)];
    
    [containerView addSubview:contentView];
    [viewController.view addSubview:containerView];
    
    KGModalCloseButton *closeButton = self.closeButton = [[KGModalCloseButton alloc] init];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setHidden:!self.showCloseButton];
    [viewController.view addSubview:closeButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapCloseAction:)
                                                 name:KGModalGradientViewTapped object:nil];
    
    // The window has to be un-hidden on the main thread
    // This will cause the window to display
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
        
        if(animated){
            viewController.styleView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                viewController.styleView.alpha = 1;
            }];
            
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    containerView.layer.shouldRasterize = NO;
                }];
            }];
        }
    });
}

- (void)closeAction:(id)sender{
    [self hideAnimated:self.animateWhenDismissed];
}

- (void)tapCloseAction:(id)sender{
    if(self.tapOutsideToDismiss){
        [self hideAnimated:self.animateWhenDismissed];
    }
}

- (void)hide{
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated{
    if(!animated){
        [self cleanup];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.viewController.styleView.alpha = 0;
        }];

        self.containerView.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kTransformPart2AnimationDuration animations:^{
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                self.containerView.alpha = 0;
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            } completion:^(BOOL finished2){
                [self cleanup];
            }];
        }];
    });
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.orginalWindow makeKeyAndVisible];
    [self.window endEditing:YES];
    [self.window resignKeyWindow];
    [self.window resignFirstResponder];
    [self.containerView removeFromSuperview];
    [self.window removeFromSuperview];
    
    self.window = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_END" object:nil];
}

@end

@implementation KGModalViewController

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    KGModalGradientView *styleView = self.styleView = [[KGModalGradientView alloc] initWithFrame:self.view.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.opaque = NO;
    [self.view addSubview:styleView];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

@implementation KGModalContainerView

- (id)initWithFrame:(CGRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    return self;
}
- (id)initWithFrameAndAddLayer:(CGRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    
    CALayer *styleLayer = [[CALayer alloc] init];
    styleLayer.cornerRadius = 4;
    styleLayer.shadowColor= [[UIColor blackColor] CGColor];
    styleLayer.shadowOffset = CGSizeMake(0, 0);
    styleLayer.shadowOpacity = 0.5;
    styleLayer.borderWidth = 1;
    styleLayer.borderColor = [[UIColor whiteColor] CGColor];
    styleLayer.backgroundColor = [[UIColor colorWithWhite:0 alpha:0.55] CGColor];
    styleLayer.frame = CGRectInset(self.bounds, 12, 12);
    [self.layer addSublayer:styleLayer];
    
    return self;
}

@end

@implementation KGModalGradientView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalGradientViewTapped object:nil];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if([[KGModal sharedInstance] backgroundDisplayStyle] == KGModalBackgroundDisplayStyleSolid){
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }else{
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

@end

@implementation KGModalCloseButton

- (id)init{
    if(!(self = [super initWithFrame:(CGRect){0, 0, 90, 90}])){
        return nil;
    }
    static UIImage *closeButtonImage;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        closeButtonImage = [UIImage imageNamed:@"closebtn_a.png"];
    });
    [self setBackgroundImage:closeButtonImage forState:UIControlStateNormal];
    return self;
}

- (UIImage *)closeButtonImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();

    //// Color Declarations
    UIColor *topGradient = [UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:0.9];
    UIColor *bottomGradient = [UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:0.9];

    //// Gradient Declarations
    NSArray *gradientColors = @[(id)topGradient.CGColor,
    (id)bottomGradient.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (  CFArrayRef)gradientColors, gradientLocations);

    //// Shadow Declarations
    CGColorRef shadow = [UIColor blackColor].CGColor;
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 3;
    CGColorRef shadow2 = [UIColor blackColor].CGColor;
    CGSize shadow2Offset = CGSizeMake(0, 1);
    CGFloat shadow2BlurRadius = 0;


    //// Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 3, 24, 24)];
    CGContextSaveGState(context);
    [ovalPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(16, 3), CGPointMake(16, 27), 0);
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    CGContextRestoreGState(context);


    //// Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(18.83, 15)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(16, 17.83)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 21.36)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 18.54)];
    [bezierPath addLineToPoint:CGPointMake(13.17, 15)];
    [bezierPath addLineToPoint:CGPointMake(9.64, 11.46)];
    [bezierPath addLineToPoint:CGPointMake(12.46, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(16, 12.17)];
    [bezierPath addLineToPoint:CGPointMake(19.54, 8.64)];
    [bezierPath addLineToPoint:CGPointMake(22.36, 11.46)];
    [bezierPath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2);
    [[UIColor whiteColor] setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);


    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
