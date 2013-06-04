//
//  FeedCellAlbumView.h
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"

@interface FeedCellAlbumView : UIView

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UILabel *comeLbl;
@property (nonatomic, strong) IBOutlet MyButton *albumBtn;
@property (nonatomic, strong) IBOutlet UIImageView *albumLeft;
@property (nonatomic, strong) IBOutlet MyButton *repostBtn;
@property (nonatomic, strong) IBOutlet MyButton *likeitBtn;
@property (nonatomic, strong) IBOutlet MyButton *commentBtn;

@property (nonatomic, strong) IBOutlet UIImageView *arrowImgView;

@property (nonatomic, strong) IBOutlet UIButton *showMoreBtn;
@property (nonatomic, assign) BOOL isShowing;

//- (void)initAlbumViewData:(NSDictionary *)_aDict;

@end
