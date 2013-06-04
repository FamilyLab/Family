//
//  SBToolKit.h
//  family_ver_pm
//
//  Created by pandara on 13-4-16.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBToolKit : NSObject

+ (NSString *)dateSinceNow:(id)timestamp;//返回几天前……等格式的时间标签
+ (NSString *)dateFromTimesp:(id)timestamp;//从时间戳获取相应格式的时间标签

+ (UIScrollView *)getScrollFromWebview:(UIWebView *)webView;//抽取webView中的ScrollView

+ (NSString *)getUserName;//获取当前登陆用户的用户名
+ (void)deleteUserName;//删除当前登陆用户userName

+ (NSString *)getUID;//获取当前登陆用户的UID
+ (void)deleteUID;//删除当前登陆用户UID

+ (NSString *)getPassword;
+ (void)savePassword:(NSString *)password;
+ (void)deletePassword;

+ (NSString *)getMAuth;//获取m_auth
+ (void)saveMAuth:(NSString *)m_auth;//保存m_auth
+ (void)deleteMAuth;

+ (NSString *)convertReidtypeToidtype:(NSString *)idtype;//将reidtye转换成相应的idtype
+ (NSString *)getWeatherApiFromCityCode:(NSString *)cityCode;//根据给定的城市代码返回天气api url
@end
