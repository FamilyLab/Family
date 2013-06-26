//
//  Common.h
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (void)resignKeyboardInView:(UIView *)view ;
+ (UIImage*)convertImageColor:(UIImage *)i red:(int)R green:(int)G blue:(int)B;
+ (UIImage*)compressImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage*)captureAImage:(UIView*)_view;
+ (UIImage*)grayscale:(UIImage*)image;
+ (UIColor*)theLblColor;
+ (UIColor*)theBtnColor;
+ (NSString*)dateConvert:(id)timestamp;
+ (UIViewController*)viewControllerOfView:(UIView*)currView;
+ (NSString*)dateSinceNow:(id)timestamp;
+ (void)saveImage:(UIImage*)image withQuality:(CGFloat)quality saveKey:(NSString*)keyStr;
+ (UIImage*)getImgFromUserDefaultForKey:(NSString*)keyStr;
@end
@interface NSString (NSString_Extended)
- (NSString *)urlencode;
@end
@interface NSString (excute)

- (NSString*)clearNotNumberInString;

@end