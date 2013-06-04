//
//  TopView.h
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//


//采用Builder模式
#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

typedef enum {
    loginOrSignIn       = 0,
    notLoginOrSignIn    = 1
} TopViewType;

typedef enum {
    leftBgPart       = 0,
    rightLogoPart    = 1,
    rightLinePart    = 2,
    arrowImgPart     = 3,
    leftBtnPart      = 4,
    headViewPart     = 5
} PartType;

//typedef enum {
//    imageBtnType    = 0,
//    textBtnType     = 1
//} RightBtnType;

@protocol TopViewDelegate;

@interface TopView : UIView <UIGestureRecognizerDelegate> {
    
}

@property (nonatomic, assign) TopViewType topViewType;
@property (nonatomic, strong) UIImageView *leftBgImgView;//左边的大色块
@property (nonatomic, strong) UIImageView *rightLogoImgView;//右边的family logo
@property (nonatomic, strong) UIImageView *rightLineImgView;//右边下面的线
//@property (nonatomic, strong) UIView *btnContainerView;

@property (nonatomic, strong) UIView *rightBtnContainerView;//右边的按钮的container
@property (nonatomic, strong) UIImageView *arrowImgView;//右边的按钮下面的箭头
@property (nonatomic, assign) int rightBtnNum;//右边的按钮的数量
//@property (nonatomic, assign) int currBtnTag;

//@property (nonatomic, strong) UIButton *leftButton;//左边的按钮
//@property (nonatomic, strong) UIImageView *leftSecondImgView;//左边的大色块下面的一个图片

@property (nonatomic, strong) MyHeadButton *leftHeadBtn;
@property (nonatomic, strong) UILabel *leftNameLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UILabel *leftOtherLbl;

@property (nonatomic, assign) id<TopViewDelegate>delegate;

- (void)changeTheme;
- (void)leftBg;
- (void)leftText:(NSString*)_text;
- (void)rightLogo;
- (void)rightLine;
- (void)rightBtnTextArray:(NSArray*)_textArray;
//- (void)leftImgWithFrame:(CGRect)_frame andImgNameStr:(NSString*)_imgNameStr;

//- (void)leftBtn;
//- (void)leftBtnWithUpImgStr:(NSString*)_upImgStr andDownImgStr:(NSString*)_downImgStr;

- (void)moveRightBtnContainerViewToLeft:(BOOL)_left;

- (void)leftHeadAndName;
- (void)leftOtherTextLbl:(NSString*)text;

- (void)rightLblAndImgStr:(NSString*)_imgStr;

@end

@protocol TopViewDelegate <NSObject>

@optional
- (void)userPressedTheTopViewBtn:(TopView*)_topView andButton:(UIButton*)_button;

- (void)userPressedTheBgOfTopView:(TopView*)_topView;

@end


@interface UIView (shadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                 shadowFrame:(CGRect)shadowFrame;
@end

