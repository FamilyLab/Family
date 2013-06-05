//
//  TaskViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-3-22.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "TableController.h"
@class DetailHeaderView;
@interface TaskViewController : TableController
@property (nonatomic,strong)IBOutlet DetailHeaderView *header;
- (IBAction)backAction:(UIButton *)sender;
@end
