//
//  TopView.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "TopView.h"
#import "Common.h"
#import "ThemeManager.h"
#import <QuartzCore/QuartzCore.h>


#define leftBgRect  CGRectMake(10, 0, 100, 50)
#define rightLogoRect  CGRectMake(243, 14, 69, 26)
#define rightLineRect   CGRectMake(115, 47, 195, 3)
#define arrowImgViewWidth   13
#define arrowImgViewHeight  9

#define rightLineWidth  195
#define rightLineX      115

@implementation UIView (shadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity
                 shadowFrame:(CGRect)shadowFrame {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, self.bounds);
    CGPathAddRect(path, NULL, shadowFrame);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
//    self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;//与上面的效果相同
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.clipsToBounds = NO;
}

@end

@implementation TopView
@synthesize topViewType, leftBgImgView, rightLogoImgView, rightLineImgView;//, textContent;
@synthesize rightBtnNum, arrowImgView;
@synthesize rightBtnContainerView;
@synthesize leftHeadBtn, leftNameLbl, rightLbl;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self dropShadowWithOffset:CGSizeMake(0, -3) radius:15 color:bgColor() opacity:0.8 shadowFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 10)];
        [self whenTapped:^{
            if ([self.delegate respondsToSelector:@selector(userPressedTheBgOfTopView:)]) {
                [self.delegate userPressedTheBgOfTopView:self];
            } else {
                [Common resignKeyboardInView:[Common viewControllerOfView:self].view];
            }
        }];
        for (id obj in self.gestureRecognizers) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                UITapGestureRecognizer *ges = (UITapGestureRecognizer*)obj;
                ges.delegate = self;
                break;
            }
        }
    }
    return self;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self) {
//        return nil;
//    } else {
//        return hitView;
//    }
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    } else {
        return YES;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self whenTapped:^{
            if ([self.delegate respondsToSelector:@selector(userPressedTheBgOfTopView:)]) {
                [self.delegate userPressedTheBgOfTopView:self];
            } else {
                [Common resignKeyboardInView:[Common viewControllerOfView:self].view];
            }
        }];
        for (id obj in self.gestureRecognizers) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                UITapGestureRecognizer *ges = (UITapGestureRecognizer*)obj;
                ges.delegate = self;
                break;
            }
        }
//        [self dropShadowWithOffset:CGSizeMake(0, -3) radius:15 color:bgColor() opacity:0.8 shadowFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 10)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = bgColor();
    if (self.leftNameLbl) {
        CGSize leftNameSize = [self.leftNameLbl.text sizeWithFont:self.leftNameLbl.font constrainedToSize:CGSizeMake(100, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        self.leftNameLbl.frame = (CGRect){.origin = self.leftNameLbl.frame.origin, .size = leftNameSize};
        
        if (self.leftOtherLbl) {
            CGSize leftOtherSize = [self.leftOtherLbl.text sizeWithFont:self.leftOtherLbl.font constrainedToSize:CGSizeMake(100, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            self.leftOtherLbl.frame = (CGRect){.origin.x = self.leftNameLbl.frame.origin.x + self.leftNameLbl.frame.size.width + 3, .origin.y = self.leftNameLbl.frame.origin.y, .size = leftOtherSize};
        }
    }
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
    aImgView.image = ThemeImage(_imgName);
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
    [self dropShadowWithOffset:CGSizeMake(0, -3) radius:10 color:bgColor() opacity:1 shadowFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 10)];
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
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    tmpLbl.textAlignment = UITextAlignmentCenter;
//#else
//    tmpLbl.textAlignment = NSTextAlignmentCenter;
//#endif
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
    for (int i = rightBtnNum; i > 0; i--) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kTagBtnInTopBarView + ( rightBtnNum - i );
        [btn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];//根据主题
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];//根据主题
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];//默认值
        btn.titleLabel.textAlignment = UITextAlignmentCenter;//默认值
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        btn.titleLabel.textAlignment = UITextAlignmentCenter;
//#else
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//#endif
        [btn setTitle:[_textArray objectAtIndex:( rightBtnNum - i )] forState:UIControlStateNormal];
        
        CGFloat everyBtnWidth = rightLineWidth / 4;//rightLineImgView这一行上面最多只能放下4个按钮
        if (i > 4) {//这里为了给”发布页面“的”我想说“页面用，多了一个按钮，总共5个
            btn.frame = (CGRect){.origin.x = 0, .origin.y = 0, .size.width = 100, .size.height = self.frame.size.height};
            [btn setTitleColor:[Common theBtnColor] forState:UIControlStateNormal];//根据主题
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 17, 8, 15)];
            imgView.image = ThemeImage(@"goto_b");
            [btn addSubview:imgView];
        } else {
            btn.frame = CGRectMake(rightLineX + everyBtnWidth * (4-i), 0, everyBtnWidth, self.frame.size.height);
        }
        [rightBtnContainerView addSubview:btn];
        [self addSubview:rightBtnContainerView];
    }
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
                             [self rightBtnPressed:((UIButton*)[self viewWithTag:kTagBtnInTopBarView + 1])];
                         }
                     }];
}

//左边的 头像btn+名字lbl
- (void)leftHeadAndName {
    //头像btn
    MyHeadButton *btn = [MyHeadButton buttonWithType:UIButtonTypeCustom];// [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"head_220.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 7, 35, 35);
    self.leftHeadBtn = btn;
    [self addSubview:leftHeadBtn];
    
    //名字lbl
    UILabel *tmpLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 100, 30)];
    tmpLbl.textColor = [Common theLblColor];
    tmpLbl.textAlignment = UITextAlignmentLeft;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    tmpLbl.textAlignment = UITextAlignmentLeft;
//#else
//    tmpLbl.textAlignment = NSTextAlignmentLeft;
//#endif
    tmpLbl.backgroundColor = [UIColor clearColor];
    tmpLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    tmpLbl.text = @"";
    self.leftNameLbl = tmpLbl;
    [self addSubview:leftNameLbl];
}

//左边的其他文字（如“发表了照片”）
- (void)leftOtherTextLbl:(NSString*)text {
    UILabel *otherLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftNameLbl.frame.origin.x + leftNameLbl.frame.size.width + 3, 10, 100, 30)];
    otherLbl.textColor = [UIColor darkGrayColor];
    otherLbl.textAlignment = UITextAlignmentLeft;
    otherLbl.backgroundColor = [UIColor clearColor];
    otherLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    otherLbl.text = text;
    self.leftOtherLbl = otherLbl;
    [self addSubview:otherLbl];
}

//右边 图片＋文字 或 纯文字
- (void)rightLblAndImgStr:(NSString*)_imgStr {
    if (_imgStr) {
        UIImage *image = [UIImage imageNamed:_imgStr] ? [UIImage imageNamed:_imgStr] : ThemeImage(_imgStr);
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = (CGRect){.origin.x = 250, .origin.y = 22, .size = image.size};
        [self addSubview:imgView];
    }
    UILabel *tmpLbl = [[UILabel alloc] initWithFrame:CGRectMake(262, 12, 100, 30)];
    tmpLbl.textColor = [UIColor lightGrayColor];
    tmpLbl.textAlignment = UITextAlignmentLeft;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    tmpLbl.textAlignment = UITextAlignmentLeft;
//#else
//    tmpLbl.textAlignment = NSTextAlignmentLeft;
//#endif
    tmpLbl.backgroundColor = [UIColor clearColor];
    tmpLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    tmpLbl.text = @"";
    self.rightLbl = tmpLbl;
    [self addSubview:rightLbl];
}

//更改主题(公共部分)(一级界面才需要)
- (void)changeTheme {
    if (self.leftBgImgView) {
        self.leftBgImgView.image = ThemeImage(@"left_bg");
    }
    if (self.rightLogoImgView) {
        self.rightLogoImgView.image = ThemeImage(@"right_logo");
    }
    if (self.rightLineImgView) {
        self.rightLineImgView.image = ThemeImage(@"boundary");
    }
    if (self.rightBtnContainerView) {
        self.arrowImgView.image = ThemeImage(@"directing");
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
