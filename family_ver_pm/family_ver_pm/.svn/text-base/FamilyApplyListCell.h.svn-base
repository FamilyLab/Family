//
//  FamilyApplyListCell.h
//  Family_pm
//
//  Created by shawjanfore on 13-4-4.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

@protocol FamilyApplyListCellDelegate;
@interface FamilyApplyListCell : UITableViewCell

@property(nonatomic, assign) int index;
@property(nonatomic, assign) int whichTypeVC;
@property(nonatomic, retain) IBOutlet MyHeadButton *headBtn;
@property(nonatomic, retain) IBOutlet UILabel *nameLbl;
@property(nonatomic, retain) IBOutlet UIButton *rightBtn;
@property(nonatomic, retain) IBOutlet UIButton *leftBtn;
@property(nonatomic, assign) id <FamilyApplyListCellDelegate> delegate;

-(void)initData:(NSDictionary *)_dict;

@end

@protocol FamilyApplyListCellDelegate <NSObject>

-(void)userDidPressedTheCellButtonOfView:(FamilyApplyListCell*)cell andButton:(UIButton*)button;

@end