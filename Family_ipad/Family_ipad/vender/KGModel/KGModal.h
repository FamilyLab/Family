//
//  KGModal.h
//  KGModal
//
//  Created by David Keegan on 10/5/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoneWaterFallView.h"

NS_ENUM(NSUInteger, KGModalBackgroundDisplayStyle){
    KGModalBackgroundDisplayStyleGradient,
    KGModalBackgroundDisplayStyleSolid
};

@interface KGModal : NSObject

// Determines if the modal should dismiss if the user taps outside of the modal view
// Defaults to YES
@property (nonatomic) BOOL tapOutsideToDismiss;

// Determins if the close button or tapping outside the modal should animate the dismissal
// Defaults to YES
@property (nonatomic) BOOL animateWhenDismissed;

// Determins if the close button is shown
// Defaults to YES
@property (nonatomic) BOOL showCloseButton;
@property (nonatomic,assign)BOOL beforeLogin;
// The background display style, can be a transparent radial gradient or a transparent black
// Defaults to gradient, this looks better but takes a bit more time to display on the retina iPad
@property (nonatomic) enum KGModalBackgroundDisplayStyle backgroundDisplayStyle;

@property (nonatomic,retain) UIWindow *orginalWindow;
// The shared instance of the modal
+ (id)sharedInstance;

// Set the content view to display in the modal and display with animations
- (void)showWithContentView:(UIView *)contentView;

// Set the content view to display in the modal and whether the modal should animate in
- (void)showWithContentView:(UIView *)contentView andAnimated:(BOOL)animated;

// Hide the modal with animations
- (void)hide;

// Hide the modal and whether the modal should animate away
- (void)hideAnimated:(BOOL)animated;
- (void)closeAction:(id)sender;
- (void)showWithContentViewInMiddle:(UIView *)contentView andAnimated:(BOOL)animated;
- (void)showWithLoginContentView:(UIView *)contentView andAnimated:(BOOL)animated;
- (UIViewController *)getViewController;
@end
