//
//  ZoneViewController.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "BottomView.h"
#import "JBKenBurnsView.h"

@interface ZoneViewController : TableController <BottomViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KenBurnsViewDelegate> {
    CGFloat offsetY;
    BOOL isShowingThemeImage;
    NSTimer *timer;
    BOOL isCurrShowViewCon;//防止TableControl发送过来要求刷新数据的通知，以致不是停留在当前controller，仍会执行sendRequest里的startCountTimeWhenDoNothingInTimes，从而出现屏保页面)
}

@property (nonatomic, assign) BOOL isMyself;

@property (nonatomic, strong) NSMutableDictionary *infoDict;
@property (nonatomic, strong) NSMutableArray *memberArray;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL isOnlyShowMyZone;

//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int lastRandomNum;

@property (nonatomic, retain) KenBurnsView *kenView;
@end
