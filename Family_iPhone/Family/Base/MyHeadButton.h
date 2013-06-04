//
//  MyHeadButton.h
//  Family
//
//  Created by Aevitx on 13-3-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadButton : UIButton

//@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) UIImageView *vipImgView;

- (void)addBorderColor:(UIColor*)borderColor;

- (void)setImageForMyHeadButtonWithUrlStr:(NSString*)urlStr plcaholderImageStr:(NSString*)placeholderImageStr;

- (void)setVipStatusWithStr:(NSString*)vipStatus isSmallHead:(BOOL)isSmallHead;

@end
