//
//  PreContentView.h
//  Family
//
//  Created by Aevitx on 13-5-26.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreContentView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *leftImgView;
@property (nonatomic, strong) IBOutlet UILabel *rightLbl;

+ (CGSize)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight andLblMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font;

@end
