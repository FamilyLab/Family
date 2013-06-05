//
//  SomeImgsCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"

@interface SomeImgsCell : FeedCell

@property (nonatomic, strong) IBOutlet UIImageView *firstImgView;
@property (nonatomic, strong) IBOutlet UIImageView *secondImgView;
@property (nonatomic, strong) IBOutlet UIImageView *thirdImgView;
@property (nonatomic, strong) IBOutlet UILabel *imgsNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@end
