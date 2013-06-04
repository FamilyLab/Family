//
//  MoreCell.h
//  Family
//
//  Created by Aevitx on 13-1-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

typedef enum {
    familySection     = 0,//家人
    childSection      = 1,//孩子资料
//    creditSection     = 2,//积分
    watchSection      = 2,//查看
    settingSection    = 3,//设置
    aboutSection      = 4//关于
} MoreCellSection;

@interface MoreCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDict;
//@property (nonatomic, assign) int indexSection;
@property (nonatomic, assign) MoreCellSection seciontType;
@property (nonatomic, assign) int indexRow;

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UIButton *firstBtn;
@property (nonatomic, strong) IBOutlet UIButton *secondBtn;
@property (nonatomic, strong) IBOutlet UIButton *thirdBtn;
//@property (nonatomic, strong) IBOutlet UILabel *leftLbl;
//@property (nonatomic, strong) IBOutlet UIImageView *rightImgView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;

@property (nonatomic, strong) IBOutlet UILabel *firstLbl;
@property (nonatomic, strong) IBOutlet UILabel *secondLbl;
@property (nonatomic, strong) IBOutlet UILabel *thirdLbl;


@property (nonatomic, strong) IBOutlet UILabel *tipsLbl;
@property (nonatomic, strong) IBOutlet UILabel *numLbl;
@property (nonatomic, strong) IBOutlet UIImageView *rightImgView;


- (void)initData:(NSDictionary *)_aDict;

@end
