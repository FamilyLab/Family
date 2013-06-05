//
//  WaterFallCommentView.h
//  Family_ipad
//
//  Created by walt.chan on 13-2-26.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define COMMENT_HEIGHT 90
@interface WaterFallCommentView : UIView
@property (nonatomic,strong)IBOutlet UILabel *authorLabel;
@property (nonatomic,strong)IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)IBOutlet UILabel *commentLabel;
- (void)clearText;
@end
