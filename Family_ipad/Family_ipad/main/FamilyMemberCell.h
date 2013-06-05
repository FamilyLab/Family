//
//  FamilyMemberCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-2-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyMemberCell : UITableViewCell
@property (nonatomic, assign) int indexRow;
@property (nonatomic, copy)NSString *userid;
- (IBAction)memberBtnAction:(id)sender;
- (void)setCellData:(NSMutableArray *)dict;

@end
