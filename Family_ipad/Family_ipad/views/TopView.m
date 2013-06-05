//
//  TopView.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "TopView.h"
#import "Common.h"


#define leftBgRect  CGRectMake(10, 0, 100, 50)
#define rightLogoRect  CGRectMake(243, 14, 69, 26)
#define rightLineRect   CGRectMake(115, 47, 195, 3)
#define arrowImgViewWidth   13
#define arrowImgViewHeight  9

#define rightLineWidth  195
#define rightLineX      115
#define kTagBtnInTopBarView  80  //topBarView上的按钮
@implementation TopView
@synthesize topViewType, leftBgImgView, rightLogoImgView, rightLineImgView;//, textContent;
@synthesize rightBtnNum, arrowImgView;
@synthesize rightBtnContainerView;
@synthesize headView, leftHeadBtn, leftNameLbl, rightImgView, rightLbl;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)buildImgViewFrame:(CGRect)_frame withImgName:(NSString*)_imgName {
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:_frame];
    aImgView.image = [UIImage imageNamed:_imgName];
    [self addSubview:aImgView];
}

//- (void)setTopViewType:(TopViewType)theTopViewType {
//    switch (theTopViewType) {
//        case loginOrSignIn:
//        {
//            [self buildImgViewFrame:leftBgRect withImgName:@"left_bg_gray.png"];
//            [self buildImgViewFrame:rightLogoRect withImgName:@"right_logo.png"];
//            [self buildImgViewFrame:rightLineRect withImgName:@"boundary_gray.png"];
//            break;
//        }
//        case onlyTextAndImage:
//        {
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (TopViewType)topViewType {
//    return topViewType;
//}

- (void)addAPartWithFrame:(CGRect)_frame withImgName:(NSString*)_imgName withType:(PartType)_type {
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:_frame];
    aImgView.image = [UIImage imageNamed:_imgName];
    if (_type == leftBgPart) {
        self.leftBgImgView = aImgView;
    } else if (_type == rightLogoPart ) {
        self.rightLogoImgView = aImgView;
    } else if (_type == rightLinePart) {
        self.rightLineImgView = aImgView;
    } else if (_type == arrowImgPart) {
        self.arrowImgView = aImgView;
    }
    if (_type == arrowImgPart) {
        [rightBtnContainerView addSubview:aImgView];
    } else {
        [self addSubview:aImgView];
    }
}

//左边那一块的颜色  ImageView
- (void)leftBg {
    if (self.topViewType == loginOrSignIn) {
        [self buildImgViewFrame:leftBgRect withImgName:@"left_bg_gray.png"];
    } else if (self.topViewType == notLoginOrSignIn) {
        [self addAPartWithFrame:leftBgRect withImgName:@"left_bg" withType:leftBgPart];
    }
}

////左边的button (组成：上面的大色块+下面一张图片)
//- (void)leftBtn {
//    [self leftBtnWithUpImgStr:@"left_bg" andDownImgStr:@"to_down_a"];
//}
//
//- (void)leftBtnWithUpImgStr:(NSString*)_upImgStr andDownImgStr:(NSString*)_downImgStr {
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(10, 0, 100, self.frame.size.height);
//    UIImage *normalImg = [self combinFirstImgWithStr:_upImgStr andSecondImgWithStr:_downImgStr];
////    UIImage *highlightedImg = [self combinFirstImgWithStr:@"left_bg" andSecondImgWithStr:@"to_down_a"];
//    btn.backgroundColor = [UIColor colorWithPatternImage:normalImg];
//    self.leftButton = btn;
//    [self addSubview:leftButton];
//}
//
//- (UIImage*)combinFirstImgWithStr:(NSString*)_firstImgStr andSecondImgWithStr:(NSString*)_secondImgStr {
//    UIImageView *firstImgView = [[UIImageView alloc] initWithImage:ThemeImage(_firstImgStr)];
//    firstImgView.frame = leftBgRect;
//    self.leftBgImgView = firstImgView;
//    UIImageView *secondImgView = [[UIImageView alloc] initWithImage:ThemeImage(_secondImgStr)];
//    secondImgView.frame = (CGRect){.origin.x = 0, .origin.y = self.leftBgImgView.frame.size.height, .size = secondImgView.image.size};
//    self.leftSecondImgView = secondImgView;
//    [self.leftBgImgView addSubview:self.leftSecondImgView];
//    return firstImgView.image;
//}

//左边那一块上面的文字  Label
- (void)leftText:(NSString*)_text {
    UILabel *tmpLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 100, 30)];
    tmpLbl.textColor = [UIColor whiteColor];
    tmpLbl.textAlignment = UITextAlignmentCenter;
    tmpLbl.backgroundColor = [UIColor clearColor];
    tmpLbl.font = [UIFont boldSystemFontOfSize:23];
    tmpLbl.text = _text;
    [self addSubview:tmpLbl];
}

//右边Family Logo ImageView
- (void)rightLogo {
    if (self.topViewType == loginOrSignIn) {
        [self buildImgViewFrame:rightLogoRect withImgName:@"right_logo.png"];
    } else if (self.topViewType == notLoginOrSignIn) {
        [self addAPartWithFrame:rightLogoRect withImgName:@"right_logo" withType:rightLogoPart];
    }
}

//右边的那一条线 ImageView
- (void)rightLine {
    if (self.topViewType == loginOrSignIn) {
        [self buildImgViewFrame:rightLineRect withImgName:@"boundary_gray.png"];
    } else if (self.topViewType == notLoginOrSignIn) {
        [self addAPartWithFrame:rightLineRect withImgName:@"boundary" withType:rightLinePart];
    }
}

//右边的图片+文字   ImageView+Label

//右边的按钮       Button

//cell的header
////左边的图片
//- (void)leftImgWithFrame:(CGRect)_frame andImgNameStr:(NSString*)_imgNameStr {
//    [self addAPartWithFrame:_frame withImgName:_imgNameStr withType:myLeftImgPart];
//}

//右边的按钮区域，需要先调用[self rightLine];
- (void)rightBtnTextArray:(NSArray*)_textArray {
    UIView *aView = [[UIView alloc] initWithFrame:self.frame];
    aView.backgroundColor = [UIColor clearColor];
    self.rightBtnContainerView = aView;
    self.rightBtnNum = [_textArray count];
    for (int i=rightBtnNum; i>0; i--) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kTagBtnInTopBarView + ( rightBtnNum - i );
        [btn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];//根据主题
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];//根据主题
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];//默认值
        btn.titleLabel.textAlignment = UITextAlignmentCenter;//默认值
        [btn setTitle:[_textArray objectAtIndex:( rightBtnNum - i )] forState:UIControlStateNormal];
        
        CGFloat everyBtnWidth = rightLineWidth / 4;//rightLineImgView这一行上面最多只能放下4个按钮
        if (i > 4) {//这里为了给”发布页面“的”我想说“页面用，多了一个按钮，总共5个
            btn.frame = (CGRect){.origin.x = 0, .origin.y = 0, .size.width = 100, .size.height = self.frame.size.height};
            [btn setTitleColor:[Common theBtnColor] forState:UIControlStateNormal];//根据主题
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 17, 8, 15)];
            imgView.image = [UIImage imageNamed:@"goto_b"];
            [btn addSubview:imgView];
        } else {
            btn.frame = CGRectMake(rightLineX + everyBtnWidth * (4-i), 0, everyBtnWidth, self.frame.size.height);
        }
        [rightBtnContainerView addSubview:btn];
        [self addSubview:rightBtnContainerView];
    }
//    for (int i=rightBtnNum; i>0; i--) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat everyBtnWidth = rightLineWidth / 4;//这里最多只能放下4个按钮
//        btn.frame = CGRectMake(rightLineX + everyBtnWidth * (4-i), 0, everyBtnWidth, self.frame.size.height);
//        btn.tag = kTagBtnInTopBarView + ( rightBtnNum - i );
//        [btn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];//根据主题
//        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];//根据主题
//        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];//默认值
//        btn.titleLabel.textAlignment = UITextAlignmentCenter;//默认值
//        [btn setTitle:[_textArray objectAtIndex:( rightBtnNum - i )] forState:UIControlStateNormal];
//        [self addSubview:btn];
//    }
    UIButton *firstBtn = rightBtnNum > 4 ? (UIButton*)[self viewWithTag:kTagBtnInTopBarView + 1] : (UIButton*)[self viewWithTag:kTagBtnInTopBarView];//这里为了给”发布页面“的”我想说“页面用，多了一个按钮，总共5个
    firstBtn.selected = YES;
    [self addAPartWithFrame:CGRectMake([self moveArrowToX:firstBtn], 41, arrowImgViewWidth, arrowImgViewHeight) withImgName:@"directing" withType:arrowImgPart];
    
//    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake([self moveArrowToX:firstBtn], 41, arrowImgViewWidth, arrowImgViewHeight)];
//    aImgView.image = ThemeImage(@"directing");
//    self.arrowImgView = aImgView;
//    [rightBtnContainerView addSubview:arrowImgView];
}

- (void)rightBtnPressed:(UIButton*)sender {
    if (rightBtnNum > 4 && sender.tag == kTagBtnInTopBarView) {//这里为了给”发布页面“的”我想说“页面用，多了一个按钮，总共5个
        [self moveRightBtnContainerViewToLeft:YES];
    } else {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             CGRect theFrame = self.arrowImgView.frame;
                             theFrame.origin.x = [self moveArrowToX:sender];
                             self.arrowImgView.frame = theFrame;
                         }];
        for (int i=0; i<rightBtnNum; i++) {
            UIButton *btn = (UIButton*)[self viewWithTag:kTagBtnInTopBarView + i];
            btn.selected = NO;
        }
        sender.selected = YES;
    }
    if ([self.delegate respondsToSelector:@selector(userPressedTheTopViewBtn:andButton:)]) {
        [self.delegate userPressedTheTopViewBtn:self andButton:sender];
    }
}

- (CGFloat)moveArrowToX:(UIButton*)sender {
    CGFloat theX = sender.frame.origin.x + sender.frame.size.width / 2 - arrowImgViewWidth / 2;
    return theX;
}

//这里为了给”发布页面“的”我想说“页面用，多了一个按钮，总共5个
- (void)moveRightBtnContainerViewToLeft:(BOOL)_left {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect theFrame = self.rightBtnContainerView.frame;
                         theFrame.origin.x = _left ? 0 : 210;
                         self.rightBtnContainerView.frame = theFrame;
                     } completion:^(BOOL finished) {
                         if (!_left) {
                           //  [self rightBtnPressed:((UIButton*)[self viewWithTag:kTagBtnInTopBarView + 1])];
                         }
                     }];
}

//左边的 头像btn+名字lbl
- (void)leftHeadAndName {
    //头像btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 7, 35, 35);
    self.leftHeadBtn = btn;
    [self addSubview:leftHeadBtn];
    
    //名字lbl
    UILabel *tmpLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 100, 30)];
    tmpLbl.textColor = [Common theLblColor];
    tmpLbl.textAlignment = UITextAlignmentCenter;
    tmpLbl.backgroundColor = [UIColor clearColor];
    tmpLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    tmpLbl.text = @"";
    self.leftNameLbl = tmpLbl;
    [self addSubview:leftNameLbl];
}

//右边 图片＋文字 或 纯文字
- (void)rightLblAndImgStr:(NSString*)_imgStr {
    if (_imgStr) {
        UIImage *image = [UIImage imageNamed:_imgStr];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = (CGRect){.origin.x = 250, .origin.y = 22, .size = image.size};
        [self addSubview:imgView];
    }
    UILabel *tmpLbl = [[UILabel alloc] initWithFrame:CGRectMake(262, 12, 100, 30)];
    tmpLbl.textColor = [UIColor lightGrayColor];
    tmpLbl.textAlignment = UITextAlignmentLeft;
    tmpLbl.backgroundColor = [UIColor clearColor];
    tmpLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    tmpLbl.text = @"";
    self.rightLbl = tmpLbl;
    [self addSubview:rightLbl];
}

//更改主题(公共部分)(一级界面才需要)
- (void)changeTheme {
    if (self.leftBgImgView) {
        self.leftBgImgView.image = [UIImage imageNamed:@"left_bg"];
    }
    if (self.rightLogoImgView) {
        self.rightLogoImgView.image =[UIImage imageNamed:@"right_logo"];
    }
    if (self.rightLineImgView) {
        self.rightLineImgView.image = [UIImage imageNamed:@"boundary" ];
    }
    if (self.rightBtnContainerView) {
        self.arrowImgView.image = [UIImage imageNamed:@"directing"];
        for (id obj in self.rightBtnContainerView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton*)obj;
                [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];
                [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];
            }
        }
    }
//    if (self.arrowImgView) {
//        self.arrowImgView.image = ThemeImage(@"directing");
//        for (int i=0; i<rightBtnNum; i++) {
//            UIButton *btn = (UIButton*)[self viewWithTag:kTagBtnInTopBarView + i];
//            [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];
//            [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];
//        }
//    }
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
