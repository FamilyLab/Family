//
//  BigImgCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"
#import "MWPhotoBrowser.h"

@interface BigImgCell : FeedCell <MWPhotoBrowserDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *bigImgView;
@property (nonatomic, strong) IBOutlet UILabel *bigImgLbl;

@end
