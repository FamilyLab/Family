//
//  SimpleInfoView.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "MyButton.h"
@interface SimpleInfoView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *headImgView;
@property (nonatomic, strong) IBOutlet MyButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *noteNameLbl;//备注名
@property (nonatomic, strong) IBOutlet UILabel *infoLbl;
@property (nonatomic, strong) IBOutlet UIButton *operatorBtn;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *rightImgView;

@property (nonatomic, assign) BOOL isFamilyList;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isFromTask;

- (void)initInfoWithHeadUrlStr:(NSString*)_headUrlStr
                       nameStr:(NSString*)_nameStr
                       infoStr:(NSString*)_infoStr
             rightlBtnNormaImg:(NSString*)_rightBtnNormalImg
         rightlBtnHighlightImg:(NSString*)_rightBtnHighlightImg
          rightlBtnSelectedImg:(NSString*)_rightBtnSelectedImg;

- (void)initInfoWithHeadUrlStr:(NSString*)_headUrlStr
                       nameStr:(NSString*)_nameStr
                   noteNameStr:(NSString*)_noteNameStr
                       infoStr:(NSString*)_infoStr
              andRightImgPoint:(CGPoint)_point
                      rightImg:(NSString*)_rightImg
                      rightStr:(NSString*)_rightStr;


@end
