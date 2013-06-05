//
//  DetailBaseViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableController.h"
#import "DetailHeaderView.h"
#import "PostBaseView.h"
@interface DetailBaseViewController : TableController
{
    IBOutlet DetailHeaderView *header;
    NSMutableArray *selectedArray;

}
@property (nonatomic,strong)IBOutlet DetailHeaderView *header;
@property (nonatomic,assign)PostBaseView *parent;
@property (nonatomic,strong)IBOutlet UIButton *acBtn;
@property (nonatomic,assign)BOOL allowmutilpleSelect;
@property (nonatomic,strong)IBOutlet UIView *accesssoryView;
- (IBAction)backAction:(id)sender;
- (IBAction)addFamilyAction:(id)sender;
@end
