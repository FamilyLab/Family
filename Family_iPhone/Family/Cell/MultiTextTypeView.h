//
//  MultiTextTypeView.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <MapKit/MapKit.h>
#import "MyHeadButton.h"

typedef enum {
    hasImage    = 0,
    noImage     = 1,
} MultiTextType;

@interface MultiTextTypeView : UIView <MKReverseGeocoderDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;
@property (nonatomic, strong) IBOutlet UIImageView *headImgView;
@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *contentLbl;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *timeView;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIImageView *rightImgView;

//@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *nameLbl;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *theNewsNumView;
@property (nonatomic, strong) IBOutlet UILabel *timeLbl;

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *userId;

//- (void)setWhichType:(MultiTextType)_type;
//- (void)fillNameLblWithNickStr:(NSString*)_onlyNickName;
- (void)fillLblWithStr:(NSString*)_text isNickName:(BOOL)_isNickName;

- (void)fillMultiTypeWithStr:(NSString*)aStr withColor:(UIColor*)aColor withSize:(CGFloat)aSize isBold:(BOOL)isBold;

- (void)fillMultiTypeNameColorWithStr:(NSString*)_text,...;
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude;

@end
