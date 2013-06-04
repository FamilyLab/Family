//
//  ThemeManager.m
//  Family
//
//  Created by apple on 12-12-20.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
@synthesize theme = _theme;

//static ThemeManager *instance = nil;

+ (ThemeManager*)sharedThemeManager {
//    @synchronized(self) {
//        if (instace == nil) {
//            instace = [[ThemeManager alloc] init];
//        }
//    }
    static dispatch_once_t once;
    static ThemeManager *instance = nil;
    dispatch_once( &once, ^{ instance = [[ThemeManager alloc] init]; } );
    return instance;
}

//设置主题
- (void)setTheme:(NSString *)theme {
    if (_theme) {
        [_theme release];
    }
    _theme = [theme copy];

    [[NSUserDefaults standardUserDefaults] setObject:theme forKey:SETTING_THEME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ThemeStatus status = ThemeStatusDidChange;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:THEME_CHANGE object:[NSNumber numberWithInt:status]];
}

- (NSString *)theme {
    return [self themeName];
}

//设置相应的主题图片
- (UIImage *)imageWithImageName:(NSString *)imageName {
    NSString *directory = [NSString stringWithFormat:@"Theme/%@", [self themeName]];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName
                                                          ofType:@"png"
                                                     inDirectory:directory];
    return [UIImage imageWithContentsOfFile:imagePath];
}

//返回当前的主题名字
- (NSString*)themeName {
    _theme = [[NSUserDefaults standardUserDefaults] objectForKey:SETTING_THEME];
    if (_theme == nil) {
        return DEFAULT_THEME;
    }
    return _theme;
}

- (void)dealloc {
    [_theme release];
    [super dealloc];
}





@end
