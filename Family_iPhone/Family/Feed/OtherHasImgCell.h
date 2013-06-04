//
//  OtherHasImgCell.h
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "FeedCell.h"

@interface OtherHasImgCell : FeedCell

@property (nonatomic, strong) IBOutlet MultiTextTypeView *multiTextTypeView;
@property (nonatomic, copy) NSString *userId;


//@property (nonatomic, assign) int indexRow;
//@property (nonatomic, strong) NSDictionary *dataDict;

//- (void)initData:(NSDictionary*)_aDict;

@end
