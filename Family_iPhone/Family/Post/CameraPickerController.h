//
//  CameraPickerController.h
//  Family
//
//  Created by Aevitx on 13-6-4.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CameraOverlayViewController.h"

@interface CameraPickerController : UIImagePickerController

@property (nonatomic, strong) CameraOverlayViewController *overlayViewCon;

@end
