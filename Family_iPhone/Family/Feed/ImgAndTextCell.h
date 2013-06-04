//
//  ImgAndTextCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"

@interface ImgAndTextCell : FeedCell

@property (nonatomic, strong) IBOutlet UIImageView *leftImgView;
@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@end
