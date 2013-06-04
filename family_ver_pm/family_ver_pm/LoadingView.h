//
//  LoadingView.h
//  family_ver_pm
//
//  Created by pandara on 13-3-26.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *loadingIcon;

- (void)loadAnimation;

@end
