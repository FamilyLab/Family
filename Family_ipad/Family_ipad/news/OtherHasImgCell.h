//
//  OtherHasImgCell.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"

typedef enum {
    eventid          = 0,
    reeventid        = 1,
    eventcomment      = 2,
    blogid        = 3,
    reblogid        = 4,
    blogcomment    = 5,
    photoid     = 6,
    photocomment,
    rephotoid,
    videoid,
    revideoid,
    videocomment,
    profield,
    avatar
} IDTYPE;
@interface OtherHasImgCell : FeedCell

@property (nonatomic, strong) IBOutlet MultiTextTypeView *multiTextTypeView;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong)IBOutlet UIImageView *rightImg;

//@property (nonatomic, assign) int indexRow;
//@property (nonatomic, strong) NSDictionary *dataDict;

//- (void)initData:(NSDictionary*)_aDict;

@end
