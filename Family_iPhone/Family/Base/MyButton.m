//
//  MyButton.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyButton.h"
#import "ThemeManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MLNavigationController.h"

@implementation MyButton
@synthesize btnLbl;

//- (id)initWithFrame:(CGRect)frame withImageNameStr:(NSString*)_imgstr withLabelStr:(NSString*)_text withLabelX:(CGFloat)_lableX {
//    self.imageNameStr = _imgstr;
//    self.labelStr = _text;
//    self.labelX = _lableX;
//    return [self initWithFrame:frame];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.layer.cornerRadius = 2.0f;
        
//        self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
//        self.layer.shadowOffset = CGSizeMake(0, -3);
//        self.layer.shadowRadius = 1.0f;
//        self.layer.shadowOpacity = 1.0f;
        
//        self.clipsToBounds = NO;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, self.frame.size.height)];//默认值
        lbl.backgroundColor = [UIColor clearColor];//默认值
        lbl.textAlignment = UITextAlignmentLeft;//默认值
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        lbl.textAlignment = UITextAlignmentLeft;
//#else
//        lbl.textAlignment = NSTextAlignmentLeft;
//#endif
        lbl.textColor = [UIColor whiteColor];//默认值
        lbl.font = [UIFont boldSystemFontOfSize:12.0f];//默认值
        lbl.text = @"";
        self.btnLbl = lbl;
        [self addSubview:btnLbl];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.layer.shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        self.layer.cornerRadius = 3.0f;
        
//        self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
//        self.layer.shadowOffset = CGSizeMake(0, -3);
//        self.layer.shadowRadius = 1.0f;
//        self.layer.shadowOpacity = 1.0f;
//        
//        self.clipsToBounds = NO;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, self.frame.size.height)];//默认值
        lbl.backgroundColor = [UIColor clearColor];//默认值
        lbl.textAlignment = UITextAlignmentLeft;//默认值
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        lbl.textAlignment = UITextAlignmentLeft;
//#else
//        lbl.textAlignment = NSTextAlignmentLeft;
//#endif
        lbl.textColor = [UIColor whiteColor];//默认值
        lbl.font = [UIFont boldSystemFontOfSize:12.0f];//默认值
        lbl.text = @"";
        self.btnLbl = lbl;
        [self addSubview:btnLbl];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, self.frame.size.height)];//默认值
        lbl.backgroundColor = [UIColor clearColor];//默认值
        lbl.textAlignment = UITextAlignmentLeft;//默认值
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        lbl.textAlignment = UITextAlignmentLeft;
//#else
//        lbl.textAlignment = NSTextAlignmentLeft;
//#endif
        lbl.textColor = [UIColor whiteColor];//默认值
        lbl.font = [UIFont boldSystemFontOfSize:12.0f];//默认值
        lbl.text = @"";
        self.btnLbl = lbl;
        [self addSubview:self.btnLbl];
    }
    return self;
}

//- (void)addALabelWithText:(NSString *)_text andColor:(UIColor*)_color andSize:(CGFloat)_size theX:(CGFloat)_theX {
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(_theX, 0, self.frame.size.width, self.frame.size.height)];
//    lbl.backgroundColor = [UIColor clearColor];
//    lbl.textColor = _color;
//    lbl.textAlignment = UITextAlignmentLeft;
//    lbl.text = _text;
//    lbl.font = [UIFont boldSystemFontOfSize:_size];
//    self.btnLbl = lbl;
//    [self addSubview:btnLbl];
//}

- (void)changeLblWithText:(NSString *)_text andColor:(UIColor*)_color andSize:(CGFloat)_size theX:(CGFloat)_theX {
    self.btnLbl.text = _text;
    self.btnLbl.textColor = _color ? _color : [UIColor whiteColor];
    self.btnLbl.font = _size > 0 ? [UIFont boldSystemFontOfSize:_size] : [UIFont boldSystemFontOfSize:_size];
    CGRect theFrame = self.btnLbl.frame;
    theFrame.origin.x = _theX;
    self.btnLbl.frame = theFrame;
}

- (void)addALittleImageViewWithFrame:(CGRect)_frame imgStr:(NSString*)_imgStr {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:_frame];
    imgView.image = ThemeImage(_imgStr);
    [self addSubview:imgView];
}

////设置圆角
//- (void)makeCornerWithRadius:(CGFloat)_radius {
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = _radius;
//}

//#pragma mark - UIResponse Subclassing -
//- (MLNavigationController *)firstAvailableNavigationController
//{
//    if ([[Common viewControllerOfView:self].navigationController isKindOfClass:[MLNavigationController class]])
//    {
//        return (MLNavigationController *)[Common viewControllerOfView:self].navigationController;
//    }
//    
//    return nil;
//}
//
////- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
////    UIView *hitView = [super hitTest:point withEvent:event];
////    if ([hitView isKindOfClass:[UIControl class]]) {
////        return hitView;
////    }
////    return nil;
////}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    [self.firstAvailableNavigationController touchesBegan:touches withEvent:event];
//    self.enabled = NO;
//}
//
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//    [self.firstAvailableNavigationController touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    
//    UITouch *touch = [touches anyObject];
//    if (touch.tapCount > 1) {
//        [self.firstAvailableNavigationController touchesEnded:touches withEvent:event];
//        self.enabled = YES;
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesCancelled:touches withEvent:event];
//    
//    UITouch *touch = [touches anyObject];
//    if (touch.tapCount > 1) {
//        [self.firstAvailableNavigationController touchesCancelled:touches withEvent:event];
//        self.enabled = YES;
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
