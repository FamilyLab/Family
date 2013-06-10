//
//  LocationCell.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"
#import "SDWebImageManagerDelegate.h"
#import "MWPhotoBrowser.h"

@interface LocationCell : FeedCell <SDWebImageManagerDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *leftImgView;
@property (nonatomic, strong) IBOutlet UILabel *subjectLbl;
@property (nonatomic, strong) IBOutlet UILabel *dateLbl;
@property (nonatomic, strong) IBOutlet UILabel *locationLbl;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@end
