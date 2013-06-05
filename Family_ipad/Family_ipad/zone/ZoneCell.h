//
//  ZoneCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-10.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
@interface ZoneCell : CustomCell
@property (nonatomic,strong)IBOutlet UILabel *photoNumLabel;
@property (nonatomic,strong)IBOutlet UILabel *videoNumLabel;
@property (nonatomic,strong)IBOutlet UILabel *diaryNumLabel;
@property (nonatomic,strong)IBOutlet UILabel *activityNumLabel;
@property (nonatomic,strong)IBOutlet UIView *cotentview;
@property (nonatomic,copy) NSString *tagID;
@end
