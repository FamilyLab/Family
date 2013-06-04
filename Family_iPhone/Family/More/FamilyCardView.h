//
//  FamilyCardView.h
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"
#import "MyButton.h"
#import "MLScrollView.h"

@interface FamilyCardView : MLScrollView

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *phoneNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *birthdayLbl;

@property (nonatomic, strong) IBOutlet UILabel *tipsLbl;

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UILabel *familyNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *zoneNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *lastLoginDateLbl;

@property (nonatomic, strong) IBOutlet UIButton *callBtn;

@property (nonatomic, strong) IBOutlet UIButton *postPMBtn;

@property (nonatomic, strong) IBOutlet UIButton *changeNoteBtn;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *noteNameStr;

- (void)initCardDataWithIsMyFamily:(BOOL)_isMyFamily
                        headUrlStr:(NSString*)_headStr
                           nameStr:(NSString*)_namStr
                       phoneNumStr:(NSString*)_phoneNumStr
                       birthdayStr:(NSString*)_birthdayStr
                            tipStr:(NSString*)_tipStr
                         familyNum:(int)_familyNum
                        zoneNumStr:(NSString*)_zoneNumStr
                  lastLoginDateStr:(NSString*)_lastLoginDateStr;


@end
