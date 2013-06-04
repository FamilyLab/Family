//
//  TapToEnlargeImageView.h
//  family_ver_pm
//
//  Created by pandara on 13-4-12.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapToEnlargeImageViewDelegate.h"
#import "EnlargeImageBottomBar.h"
#import "PinchImageView.h"
#import "EnlargeImageBottomBarDelegate.h"

@interface TapToEnlargeImageView : UIImageView<EnlargeImageBottomBarDelegate>

@property (strong, nonatomic) UIView *enlargeView;
@property (strong, nonatomic) PinchImageView *enlargeImageView;
@property (strong, nonatomic) id<TapToEnlargeImageViewDelegate> delegate;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

- (void)stopActivityView;

@end
