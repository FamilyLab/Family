//
//  FamilyViewController.h
//  Family
//
//  Created by Aevitx on 13-6-14.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "TableController.h"
#import "TopView.h"

@interface FamilyViewController : TableController

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *applyBtn;
@property (nonatomic, strong) IBOutlet UIButton *inviteBtn;
@property (nonatomic, strong) IBOutlet UILabel *familyNumLbl;
@property (nonatomic, strong) IBOutlet UILabel *applyNumLbl;

@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, assign) int familyNum;

@end
