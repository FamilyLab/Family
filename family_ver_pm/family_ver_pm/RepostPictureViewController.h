//
//  RepostPictureViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-5-29.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "RepostViewController.h"
#import "MyToolBarDelegate.h"

@interface RepostPictureViewController : RepostViewController<UIAlertViewDelegate, MyToolBarDelegate>

@property (strong, nonatomic) UITextField *repostPictureAlertViewTextField;

@end
