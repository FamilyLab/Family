//
//  Common.m
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "Common.h"
#import "ThemeManager.h"
#import <QuartzCore/QuartzCore.h>


@implementation Common
//与所选日期date相隔day天的日期
+ (NSDate *)getNextDateFromDate:(NSDate *)date withDay:(int)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
//    [comps release];
//    [calender release];
    return mDate;
}

//时间戳转化为几年几月几日几时几分
+ (NSString*)dateConvert:(id)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]]]];
//    [dateFormatter release];
    return textDate;
}

//时间戳转化为几年几月几日
+ (NSString*)convertToDate:(id)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]]]];
    //    [dateFormatter release];
    return textDate;
}

//时间戳转化为几时几分几秒
+ (NSString*)dateConvertToHour:(id)timestamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]]]];
//    [dateFormatter release];
    return textDate;
}

//时间戳转化为几天后(传参为一个时间戳)（注释部分可转化为几分钟、几小时后）
+ (NSString*)severalDays:(id)timestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
    //    NSLog(@"now:%ll, late:%ll", now, late);
    NSTimeInterval cha = [timestamp doubleValue] - now;
//    if (cha / 3600 < 1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/60];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString = [NSString stringWithFormat:@"%@分钟后", timeString];
//    }
//    if (cha / 3600 > 1 && cha / 86400 < 1) {
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString = [NSString stringWithFormat:@"%@小时后", timeString];
//    }
    if (cha / 86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天后", timeString];
    }
    //    [date release];
    return timeString;
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
    //下面注释掉的这段不太好，原因可查看http://stackoverflow.com/questions/1282830/uiimagepickercontroller-uiimage-memory-and-more
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    // Tell the old image to draw in this new context, with the desired
//    // new size // 绘制改变大小的图片
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    // Get the new image from the context// 从当前context中创建一个改变大小后的图片 
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    // End the context// 使当前的context出堆栈  
//    UIGraphicsEndImageContext();
//    // Return the new image.// 返回新的改变大小后的图片 
//    return newImage;
    
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    
    CGImageRef imageRef = [image CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (image.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (image.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (image.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

//跟AspectFill一样的
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
        
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
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

//传入两个经纬度，计算经纬度之间的距离
+(double)LantitudeLongitudeDist:(double)lon1 lat1:(double)lat1 lon2:(double)lon2 lat2:(double)lat2 {
    double er = 6378137; // 6378700.0f;
    
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}

#pragma mark - 主题相关
+ (UIColor*)theLblColor {
    if ([currentTheme isEqualToString:DEFAULT_THEME]) {
        return color(157, 212, 74, 1.0);
    } else if ([currentTheme isEqualToString:SPRING_THEME]) {
        return color(179, 221, 92, 1.0);
    } else if ([currentTheme isEqualToString:SUMMER_THEME]) {
        return color(2, 171, 204, 1.0);
    } else if ([currentTheme isEqualToString:AUTUMN_THEME]) {
        return color(214, 171, 0, 1.0);
    } else if ([currentTheme isEqualToString:WINTER_THEME]) {
        return color(119, 124, 172, 1.0);
    } else return color(157, 212, 74, 1.0);
}

+ (UIColor*)theBtnColor {
    if ([currentTheme isEqualToString:DEFAULT_THEME]) {
        return color(20, 93, 49, 1.0);
    } else if ([currentTheme isEqualToString:SPRING_THEME]) {
        return color(86, 148, 56, 1.0);
    } else if ([currentTheme isEqualToString:SUMMER_THEME]) {
        return color(15, 108, 166, 1.0);
    } else if ([currentTheme isEqualToString:AUTUMN_THEME]) {
        return color(135, 48, 33, 1.0);
    } else if ([currentTheme isEqualToString:WINTER_THEME]) {
        return color(75, 81, 127, 1.0);
    } else return color(20, 93, 49, 1.0);
}

+ (NSString*)theThemeName {
    if ([currentTheme isEqualToString:DEFAULT_THEME]) {
        return @"默认主题";
    } else if ([currentTheme isEqualToString:SPRING_THEME]) {
        return @"春天里";
    } else if ([currentTheme isEqualToString:SUMMER_THEME]) {
        return @"夏日情";
    } else if ([currentTheme isEqualToString:AUTUMN_THEME]) {
        return @"秋意浓";
    } else if ([currentTheme isEqualToString:WINTER_THEME]) {
        return @"雪白的冬天";
    } else return @"默认主题";;
}


#pragma mark  - html 相关
//判断是否包括html标签
+ (BOOL)hasHyperLinkInString:(NSString*)content {
    //    BOOL hasContainLink = ([content rangeOfString:@"<a href"].length != 0) && ([content rangeOfString:@">"].length != 0) ? YES : NO;
    BOOL hasContainLink = ([content rangeOfString:@"<"].length != 0) && ([content rangeOfString:@">"].length != 0) ? YES : NO;
    return hasContainLink;
}

//+ (NSString*)separateWithString:(NSString*)separationStr inStr:(NSString*)content {
//    NSString *afterSeparate = content;
//    
//    if ([afterSeparate hasPrefix:@"<"]) {
//        afterSeparate = [afterSeparate substringFromIndex:1];
//    }
//    if ([afterSeparate hasSuffix:@"</a>  "]) {
//        afterSeparate = [afterSeparate substringToIndex:[afterSeparate rangeOfString:@"</a>  "].location];
//    }
//    
//    NSRange left = [afterSeparate rangeOfString:@"</a>"];
//    while (left.length != 0) {
//        NSRange right = [afterSeparate rangeOfString:@"<a"];
//        if (right.length != 0) {
//            NSString *theStr = [afterSeparate substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)];
//            afterSeparate = [afterSeparate stringByReplacingOccurrencesOfString:theStr withString:separationStr];
//        }
//        left = [afterSeparate rangeOfString:@"</a>"];
//    }
//    
//    afterSeparate = [afterSeparate stringByReplacingOccurrencesOfString:@"</a>" withString:separationStr];
//    
////    NSString *afterSeparate = content;
//    left = [afterSeparate rangeOfString:@"a href"];
//    while (left.length != 0) {
//        NSRange right = [afterSeparate rangeOfString:@">"];
//        NSString *theHtmlStr = [afterSeparate substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)];
//        NSString *urlStr = [self getTheUrlInString:theHtmlStr];
//        urlStr = [urlStr stringByAppendingString:separationStr];
//        
//        afterSeparate = [afterSeparate stringByReplacingOccurrencesOfString:theHtmlStr withString:urlStr];
//        left = [afterSeparate rangeOfString:@"a href"];
//    }
//    return afterSeparate;
//}

/////////////////////////////////////提取通知列表里的数据///////////////////////////////////////////////////
//先把"</a>"和"<a"的替换为"_____"，再根据"_____"分离出一个数组，再在这个数组里检测如果没有含href，即不用有网络操作的（如“发布了图片”）去掉。接着对这个数组里的每个元素（此时每个元素都是前面一串html后面相应的文字，如［“<a href=\"space.php?uid=217\" target=\"_blank\">YaLing”］）进行拆分，将html和后面的文字拆出来。最后再检测html里若含"do="，则将相应文本改为“进入详情”，不然太长了。
+ (NSMutableArray*)separateAndGetTheArrayWithStr:(NSString*)content {
    NSString *separateStr = [content stringByReplacingOccurrencesOfString:@"</a>" withString:@"_____"];
    separateStr = [separateStr stringByReplacingOccurrencesOfString:@"<a " withString:@"_____"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[separateStr componentsSeparatedByString:@"_____"]];
    for (int i = 0; i < [arr count]; i++) {
        NSString *str = [arr objectAtIndex:i];
        BOOL hasContainLink = ([str rangeOfString:@"href"].length != 0) ? YES : NO;
        if (!hasContainLink) {
            [arr removeObject:str];
        }
    }
    NSMutableArray *finalArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr count]; i++) {
        NSString *str = [arr objectAtIndex:i];
        NSRange left = [str rangeOfString:@"href"];
        while (left.length != 0) {
            NSRange right = [str rangeOfString:@">"];
            NSString *theHtmlStr = [str substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)];
            NSString *urlStr = [self getTheUrlInString:theHtmlStr];
            urlStr = [urlStr stringByAppendingString:@"_____"];
            
            str = [str stringByReplacingOccurrencesOfString:theHtmlStr withString:urlStr];
            
            left = [str rangeOfString:@"href"];
            
            NSArray *tmpArray = [str componentsSeparatedByString:@"_____"];
            [finalArr addObject:[tmpArray objectAtIndex:0]];
            if ([[tmpArray objectAtIndex:0] rangeOfString:@"&do="].length != 0) {
                [finalArr addObject:@"进入详情"];
            } else
                [finalArr addObject:[tmpArray objectAtIndex:1]];
        }
    }
    
    return finalArr;
}
/////////////////////////////////////提取通知列表里的数据///////////////////////////////////////////////////


//<a href="space.php?uid=476&do=quiz&id=358" target="_blank">  和  <a href='space.php?uid=4'>  从此类字符串里提取出所需url
+ (NSString*)getTheUrlInString:(NSString*)content {
    NSRange leftRange = [content rangeOfString:@"=\""];//以  (=")开头
    NSRange rightRange = [content rangeOfString:@"\" "];//以 (" )结尾（这里的"后面还有一个空格）
    if (leftRange.length == 0) {
        leftRange = [content rangeOfString:@"='"];//以(=')开头
    }
    if (rightRange.length == 0) {
        rightRange = [content rangeOfString:@"'>"];//以('>)结尾
    }
    if (leftRange.length == 0 && rightRange.length == 0) {
        return @"如果这个出现就见鬼了";
    } else {
        NSString *theUrl = [content substringWithRange:NSMakeRange(leftRange.location + leftRange.length, rightRange.location - leftRange.location - 2)];
        theUrl = [NSString stringWithFormat:@"%@%@&m_auth=%@", BASE_URL, theUrl, MY_M_AUTH];
        return theUrl;
    }
}

//<a href="space.php?uid=476&do=wall&cid=411" target="_blank"> 或 http://www.betit.cn/capi/space.php?uid=476&do=quiz&id=358&m_auth= 从此类字符串里提取出 do= 的类型
+ (NSString*)getTheTypeInUrlString:(NSString*)urlStr {
    NSArray *urlComponent = [urlStr componentsSeparatedByString:@"&"];
    NSString *type = @"";
    for (NSString *str in urlComponent) {
        if ([str hasPrefix:@"do="]) {
            type = [str substringFromIndex:3];
        }
    }
    return type;
}

//清除字符串里的所有html标签（包含"<"和”>"的）
+ (NSString*)clearTheHtmlInString:(NSString*)content {
    return [self clearTheHtmlInString:content withLeftStr:@"<" andRightStr:@">" withReplaceStr:@""];
}
    
+ (NSString*)clearTheHtmlInString:(NSString*)content withLeftStr:(NSString*)leftStr andRightStr:(NSString*)rightStr withReplaceStr:(NSString*)replaceStr {
    NSString *afterClear = content;
    NSRange left = [afterClear rangeOfString:leftStr];
    while (left.length != 0) {
        NSRange right = [afterClear rangeOfString:rightStr];
        NSString *theHtmlStr = [afterClear substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)];
        afterClear = [afterClear stringByReplacingOccurrencesOfString:theHtmlStr withString:replaceStr];
        left = [afterClear rangeOfString:leftStr];
    }
    return afterClear;
}

//指定左右两过的字符，获取左右两字符间的子串
+ (NSString*)getAsubstringFromString:(NSString*)content withLeft:(NSString*)leftStr andRight:(NSString*)rightStr {
    NSRange left = [content rangeOfString:leftStr];
    NSRange right = [content rangeOfString:rightStr];
    NSString *targetStr = [content substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)];
    return targetStr;
}


//



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

//判断是否为整型
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点型
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//存图片
//查找本地图片
+ (void)saveImgToUserDefaultWithImgNameStr:(NSString*)imgName andImgType:(NSString*)imgType saveKey:(NSString*)keyStr compressQuality:(CGFloat)quality {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:imgType]];
    NSData *imgData = UIImageJPEGRepresentation(image, quality);
    NSData *encodeImgData = [NSKeyedArchiver archivedDataWithRootObject:imgData];
    [[NSUserDefaults standardUserDefaults] setObject:encodeImgData forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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

+ (NSMutableDictionary*)copyAllDataFromDict:(NSDictionary*)aDictionary {//plist用到 By Aevit
    NSMutableDictionary *answer = [NSMutableDictionary dictionary];
    
    for (NSString *key in [aDictionary allKeys]) {
        id value = [aDictionary valueForKey:key];
        if (value && value != [NSNull null]) {
                [answer setObject:value forKey:key];
        }
    }
    return [NSMutableDictionary dictionaryWithDictionary:answer];
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




