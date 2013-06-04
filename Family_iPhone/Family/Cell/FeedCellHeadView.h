//
//  FeedCellHeadView.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "MyHeadButton.h"

@interface FeedCellHeadView : UIView

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) IBOutlet UIImageView *headImgView;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *repostLbl;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *repostView;
@property (nonatomic, strong) IBOutlet ImageAndLabelView *timeView;
@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;

//- (void)initHeadViewData:(NSDictionary*)_aDict;

@end
