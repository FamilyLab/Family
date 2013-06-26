//
//  Common.m
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "Common.h"
#import "web_config.h"
#import <QuartzCore/QuartzCore.h>

@implementation Common
//存图片
//直接传入一张图片
+ (void)saveImage:(UIImage*)image withQuality:(CGFloat)quality saveKey:(NSString*)keyStr {
    NSData *imgData = UIImageJPEGRepresentation(image, quality);
    NSData *encodeImgData = [NSKeyedArchiver archivedDataWithRootObject:imgData];
    [[NSUserDefaults standardUserDefaults] setObject:encodeImgData forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//取图片
+ (UIImage*)getImgFromUserDefaultForKey:(NSString*)keyStr {
    NSData *encodeImgData = [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];
    NSData *decodeImgData = [NSKeyedUnarchiver unarchiveObjectWithData:encodeImgData];
    UIImage *image = [UIImage imageWithData:decodeImgData];
    return image;
}
#pragma mark - resign keyboard
+ (void)resignKeyboardInView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyboardInView:v];
        }
        if ([v isFirstResponder] && ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]])) {
            [v resignFirstResponder];
        }
    }
}
#pragma mark - 找到当前view所在的controller
+ (UIViewController*)viewControllerOfView:(UIView*)currView {
    for (UIView *next = [currView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
+ (UIColor*)theLblColor
{
    return color(157, 212, 74, 1.0);
}
//修改图片颜色
+ (UIImage*)convertImageColor:(UIImage *)i red:(int)R green:(int)G blue:(int)B {
//    int kRed = R / 255;
//    int kGreen = G / 255;
//    int kBlue = B / 255;
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen;
    int m_width = i.size.width;
    int m_height = i.size.height;
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    return resultUIImage;
}

//压缩图片到指定大小
+ (UIImage*)compressImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//等比缩放
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height *scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//+ (void)cutImage:(UIImage*)image withRect:(CGRect)frame {
//    CGImageRef tileImage = CGImageCreateWithImageInRect((__bridge CGImageRef)(image),
//                                                        frame);
//}

#pragma mark capture the image 截图
+ (UIImage*)captureAImage:(UIView*)_view {
    UIView *view = _view;
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage*)grayscale:(UIImage*)image {
    /* const UInt8 luminance = (red * 0.2126) + (green * 0.7152) + (blue * 0.0722); // Good luminance value */
    /// Create a gray bitmap context
    const size_t width = image.size.width;
    const size_t height = image.size.height;
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, width * 3, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (!bmContext)
        return nil;
    
    /// Image quality
    CGContextSetShouldAntialias(bmContext, false);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    /// Draw the image in the bitmap context
    CGContextDrawImage(bmContext, imageRect, image.CGImage);
    
    /// Create an image object from the context
    CGImageRef grayscaledImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *grayscaled = [UIImage imageWithCGImage:grayscaledImageRef
                                              scale:image.scale
                                        orientation:image.imageOrientation];
    
    /// Cleanup
    CGImageRelease(grayscaledImageRef);
    CGContextRelease(bmContext);
    
    return grayscaled;
}

//时间戳转化为几分钟、小前、天前(传参为一个时间戳)
+ (NSString*)dateSinceNow:(id)timestamp {
    //    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    //    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *d = [date dateFromString:theDate];
    //    NSTimeInterval late = [d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    //    NSLog(@"now:%ll, late:%ll", now, late);
    NSTimeInterval cha = now - [timestamp doubleValue];
    if (cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if (cha / 3600 > 1 && cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha / 86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    //    [date release];
    return timeString;
}
//时间戳转化为几年几月几日几时几分
+ (NSString*)dateConvert:(id)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]]]];
    //    [dateFormatter release];
    return textDate;
}
//判断是否为整型
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
@end
@implementation NSString (excute)

//遍历字符串，清除非数字的
- (NSString*)clearNotNumberInString {
    //    NSString *stringCopy = [self copy];
    NSString *finalStr = [self copy];
    for (size_t i = 0; i < self.length; i++) {
        unichar ch = [self characterAtIndex:i];
        NSString *chStr = [NSString stringWithFormat:@"%c", ch];
        if (![Common isPureInt:chStr]) {
            finalStr = [finalStr stringByReplacingOccurrencesOfString:chStr withString:@""];
        }
    }
    return finalStr;
}

@end
@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSString * s=@"!*'();:@&=+$,/?%#[]";
	NSString * encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (__bridge_retained CFStringRef)self,
                                                                                                     NULL,
                                                                                                     (__bridge_retained CFStringRef)s,
                                                                                                     kCFStringEncodingUTF8 );
	return encodedString;
}
@end