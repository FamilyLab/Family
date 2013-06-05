//
//  MessageCell.h
//  ;
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "MultiTextTypeView.h"

@interface MessageCell : CustomCell
@property (nonatomic, strong) IBOutlet MultiTextTypeView *multiTextTypeView;
@property (nonatomic) IBOutlet UIImageView *isNewImage;
@property (nonatomic, strong) IBOutlet UILabel *newsNumLabel;
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight;
- (void)setTaskData:(NSDictionary *)dict;
@end
