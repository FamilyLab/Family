//
//  FamilyCardViewController.h
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "BottomView.h"
#import "FamilyCardView.h"

//typedef enum {
//    isMyFamilyMember    = 0,
//    isNotMyFamilyMember = 1,
//    isMyChild           = 2
//} FamilyType;

@interface FamilyCardViewController : BaseViewController <BottomViewDelegate> {
    BOOL isFirstShow;
}

@property (nonatomic, assign) BOOL isMyFamily;
@property (nonatomic, assign) BOOL isMyChild;
//@property (nonatomic, assign) FamilyType familyType;
@property (nonatomic, strong) IBOutlet FamilyCardView *familyCardView;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) BottomView *bottomView;

@end
