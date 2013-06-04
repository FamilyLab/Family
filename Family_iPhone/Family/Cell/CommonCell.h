//
//  CommonCell.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleInfoView.h"

@protocol CommonCellDelegate;

@interface CommonCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDict;
//@property (nonatomic, assign) int indexRow;
@property (nonatomic, strong) IBOutlet SimpleInfoView *simpleInfoView;
@property (nonatomic, assign) int indexRow;
@property (nonatomic, assign) id<CommonCellDelegate>delegate;

- (void)initData:(NSDictionary*)_aDict;

@end

@protocol CommonCellDelegate <NSObject>

@optional
- (void)userPressedTheOperatorBtn:(CommonCell*)_cell;

@end
