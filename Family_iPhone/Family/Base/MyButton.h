//
//  MyButton.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

//@property(nonatomic, copy) NSString *imageNameStr;
//@property(nonatomic, copy) NSString *labelStr;
//@property(nonatomic, assign) CGFloat labelX;
//- (id)initWithFrame:(CGRect)frame withImageNameStr:(NSString*)_imgstr withLabelStr:(NSString*)_text withLabelX:(CGFloat)_labelX;

@property (nonatomic, strong) UILabel *btnLbl;

//- (void)addALabelWithText:(NSString *)_text andColor:(UIColor*)_color andSize:(CGFloat)_size theX:(CGFloat)_theX;
- (void)changeLblWithText:(NSString *)_text andColor:(UIColor*)_color andSize:(CGFloat)_size theX:(CGFloat)_theX;

- (void)addALittleImageViewWithFrame:(CGRect)_frame imgStr:(NSString*)_imgStr;

//- (void)makeCornerWithRadius:(CGFloat)_radius;

@end