//
//  UIImage+fixOrientation.h
//  Family
//
//  Created by Aevitx on 13-4-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
-(UIImage*)rotate:(UIImageOrientation)orient;

@end
