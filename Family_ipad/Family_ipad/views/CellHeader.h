//
//  CellHeader.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHeader : UIView

@property (nonatomic, strong) IBOutlet UIImageView *leftImgView;
@property (nonatomic, strong) IBOutlet UIButton *rightBtn;

@property (nonatomic, strong) IBOutlet UIImageView *rightImgView;

@property (nonatomic, strong) IBOutlet UILabel *middleLbl;

+ (CGSize)getHeaderHeightWithText:(NSString*)_str;
- (void)initHeaderDataWithMiddleLblText:(NSString*)_str;

@end
