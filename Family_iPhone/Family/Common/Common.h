//
//  Common.h
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (NSDate *)getNextDateFromDate:(NSDate *)date withDay:(int)day;
+ (NSString*)dateConvert:(id)timestamp;
+ (NSString*)convertToDate:(id)timestamp;
+ (NSString*)dateConvertToHour:(id)timestamp;
+ (NSString*)dateSinceNow:(NSString*)theDate;
+ (NSString*)severalDays:(id)timestamp;

+ (UIImage*)convertImageColor:(UIImage *)i red:(int)R green:(int)G blue:(int)B;
+ (UIImage*)compressImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage*)captureAImage:(UIView*)_view;
+ (UIImage*)grayscale:(UIImage*)image;
+(double)LantitudeLongitudeDist:(double)lon1 lat1:(double)lat1 lon2:(double)lon2 lat2:(double)lat2;

+ (UIColor*)theLblColor;
+ (UIColor*)theBtnColor;
+ (NSString*)theThemeName;

+ (BOOL)hasHyperLinkInString:(NSString*)content;
//+ (NSString*)separateWithString:(NSString*)separationStr inStr:(NSString*)content;
+ (NSMutableArray*)separateAndGetTheArrayWithStr:(NSString*)content;
+ (NSString*)getTheUrlInString:(NSString*)content;
+ (NSString*)getTheTypeInUrlString:(NSString*)urlStr;
+ (NSString*)clearTheHtmlInString:(NSString*)content;
+ (NSString*)getAsubstringFromString:(NSString*)content withLeft:(NSString*)leftStr andRight:(NSString*)rightStr;


+ (void)resignKeyboardInView:(UIView *)view;

+ (UIViewController*)viewControllerOfView:(UIView*)currView;

+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

+ (void)saveImgToUserDefaultWithImgNameStr:(NSString*)imgName andImgType:(NSString*)imgType saveKey:(NSString*)keyStr compressQuality:(CGFloat)quality;
+ (void)saveImage:(UIImage*)image withQuality:(CGFloat)quality saveKey:(NSString*)keyStr;
+ (UIImage*)getImgFromUserDefaultForKey:(NSString*)keyStr;

+ (NSMutableDictionary*)copyAllDataFromDict:(NSDictionary*)aDictionary;
@end

@interface NSString (excute)

- (NSString*)clearNotNumberInString;

@end

    
