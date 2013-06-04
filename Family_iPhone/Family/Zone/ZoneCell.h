//
//  ZoneCell.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleInfoView.h"

@interface ZoneCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSMutableArray *memberArray;
@property (nonatomic, assign) int indexSection;
@property (nonatomic, assign) int indexRow;

@property (nonatomic, strong) IBOutlet UIImageView *photoImgView;
@property (nonatomic, strong) IBOutlet SimpleInfoView *simpleInfoView;

//@property (nonatomic, strong) IBOutlet UIButton *headBtn0;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn1;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn2;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn3;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn4;
//@property (nonatomic, strong) IBOutlet UIButton *headBtn5;

@property (nonatomic, strong) IBOutlet UIImageView *latestPicImgView;
@property (nonatomic, strong) IBOutlet UILabel *albumNameLbl;
@property (nonatomic, strong) IBOutlet UILabel *photoNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *diaryNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *activityNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *videoNumLbl;

- (void)initFamilyMemberHeadBtn;
- (void)initData:(NSDictionary *)_aDict;

@end
