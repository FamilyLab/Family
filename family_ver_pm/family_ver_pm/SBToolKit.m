//
//  SBToolKit.m
//  family_ver_pm
//
//  Created by pandara on 13-4-16.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "SBToolKit.h"
#import "SBKeycahin.h"

@implementation SBToolKit

//将时间戳timestamp转换为几分钟前，几小时前，几天前
+ (NSString *)dateForShow:(id)timestamp
{
    //超过一天显示完整日期
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSString *timeString = @"";
    NSTimeInterval timeInterval = now - [timestamp doubleValue];
    if (timeInterval < 60) {
        timeString = [NSString stringWithFormat:@"%d秒前", (int)(timeInterval)];
    } else if (timeInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%d分钟前", (int)(timeInterval / 60)];
    } else if (timeInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%d小时前", (int)(timeInterval / 3600)];
    } else {
//        timeString = [NSString stringWithFormat:@"%d天前", (int)(timeInterval / 86400)];
        timeString = [SBToolKit dateFromTimesp:timestamp];
    }
    
    return timeString;
}

+ (NSString *)dateSinceNow:(id)timestamp
{
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSString *timeString = @"";
    NSTimeInterval timeInterval = now - [timestamp doubleValue];
    if (timeInterval < 60) {
        timeString = [NSString stringWithFormat:@"%d秒前", (int)(timeInterval)];
    } else if (timeInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%d分钟前", (int)(timeInterval / 60)];
    } else if (timeInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%d小时前", (int)(timeInterval / 3600)];
    } else {
        timeString = [NSString stringWithFormat:@"%d天前", (int)(timeInterval / 86400)];
    }
    
    return timeString;
}

+ (NSString *)dateFromTimesp:(id)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *conformTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *conformTimespStr = [formatter stringFromDate:conformTimesp];
    return conformTimespStr;
}

+ (NSString *)getMAuth
{
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
//    NSMutableString *authName = [NSMutableString stringWithString:userName];
//    [authName appendString:KEY_AUTH];
//    NSString *m_auth = [SBKeycahin getPassWordForName:authName];
//    return m_auth;
    return [[NSUserDefaults standardUserDefaults] objectForKey:M_AUTH];
//    return [SBKeycahin getPassWordForName:M_AUTH];
}

+ (void)saveMAuth:(NSString *)m_auth
{
    [[NSUserDefaults standardUserDefaults] setObject:m_auth forKey:M_AUTH];
//    if ([SBKeycahin searchItemForUserName:M_AUTH]) {
//        [SBKeycahin updatePassWord:m_auth ForUserName:M_AUTH];
//    } else {
//        [SBKeycahin addPassword:m_auth withUerName:M_AUTH];
//    }
//    NSString *sm_auth = [SBKeycahin getPassWordForName:M_AUTH];
}

+ (void)deleteMAuth
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:M_AUTH];
//    [SBKeycahin deletePassWordForUserName:M_AUTH];
}

+ (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
}

+ (void)deleteUserName
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERNAME];
}

+ (NSString *)getUID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UID];
}

+ (void)deleteUID
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UID];
}

+ (NSString *)getPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
}

+ (void)savePassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASSWORD];
}

+ (void)deletePassword
{
//    [SBKeycahin deletePassWordForUserName:[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME]];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:PASSWORD];
}

+ (UIScrollView *)getScrollFromWebview:(UIWebView *)webView
{
    for (id subView in [webView subviews]) {
        if ([[subView class] isSubclassOfClass:[UIScrollView class]]) {
//            NSLog(@"scrollview.contentSize.height%f", ((UIScrollView *)subView).contentSize.height);
            return (UIScrollView *)subView;
        }
    }
    return nil;
}

+ (NSString *)getWeatherApiFromCityCode:(NSString *)cityCode
{
    return [NSString stringWithFormat:@"%@%@.html", WEATHER_API, cityCode];
}

+ (NSString *)convertReidtypeToidtype:(NSString *)idtype
{
    if ([idtype isEqualToString:REPHOTOID])
        return PHOTOID;
    
    if ([idtype isEqualToString:REBLOGID])
        return BLOGID;
    
    if ([idtype isEqualToString:REEVENTID])
        return EVENTID;
    
    if([idtype isEqualToString:REVIDEOID])
        return VIDEOID;
    
    return idtype;
}

@end
