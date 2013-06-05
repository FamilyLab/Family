//
//  DetailHeaderView.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAndLabelView.h"
#import "MyButton.h"
@interface DetailHeaderView : UIView
@property (nonatomic,strong)IBOutlet MyButton *avatarButton;
@property (nonatomic,strong)IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)IBOutlet ImageAndLabelView *timeLabel;
@property (nonatomic,strong)IBOutlet UILabel *timeLabelview;
@property (nonatomic,strong)IBOutlet UILabel *actionLabel;
@property (nonatomic,strong)IBOutlet MyButton *zoneBtn;
- (void)setViewDataWithLocal;

@end
