//
//  ThemeManager.h
//  Family
//
//  Created by apple on 12-12-20.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ThemeImage(imageName) [[ThemeManager sharedThemeManager] imageWithImageName:(imageName)]
#define currentTheme [ThemeManager sharedThemeManager].theme
#define SETTING_THEME   @"setting.theme"


typedef enum {
    ThemeStatusWillChange = 0, // todo
    ThemeStatusDidChange,
} ThemeStatus;

@interface ThemeManager : NSObject

@property (nonatomic, copy) NSString *theme;

+ (ThemeManager*)sharedThemeManager;
- (UIImage *)imageWithImageName:(NSString *)imageName;

@end
