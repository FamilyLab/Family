//
//  TopicCell.h
//  Family
//
//  Created by Aevitx on 13-3-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UITableViewCell

@property (nonatomic, assign) int indexRow;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *describeLbl;

@property (nonatomic, assign) CGFloat firstPicWidth;
@property (nonatomic, assign) CGFloat firstPicHeight;

@property (nonatomic, assign) BOOL isFromMoreCon;

@property (nonatomic, strong) IBOutlet UIImageView *checkImgView;

@property (nonatomic, copy) NSString *topicId;

- (void)initData:(NSDictionary*)aDict;

@end
