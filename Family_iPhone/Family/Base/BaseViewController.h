//
//  BaseViewController.h
//  Family
//
//  Created by Aevitx on 13-1-17.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
#import "SinaWeibo.h"
#import "TouchTableView.h"

typedef enum {
    commonLoginType     = 0,//普通登录接口
    sinaLoginType       = 1//第三方登录接口
} LoginType;

@interface BaseViewController : UIViewController <SinaWeiboDelegate, MBProgressHUDDelegate, TouchTableViewDelegate>

//@property (nonatomic, strong) MBProgressHUD *mbHud;

- (void)initViews;
- (void)configureViews;
- (void)uploadRequestToBindSinaWeibo;
//- (void)uploadRequestToSinaWeibo:(SinaWeibo *)sinaweibo;
- (void)storeAuthData;
- (void)uploadRequestToLoginWithPara:(NSMutableDictionary*)para loginType:(LoginType)loginType;

@end


