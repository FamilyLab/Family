//
//  addFamilyCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "FamilyNewsCell.h"

@interface addFamilyCell : FamilyNewsCell
@property (nonatomic,strong)IBOutlet UIButton *addButton;
@property (nonatomic,strong)IBOutlet UILabel *feedLabel;
@property (nonatomic,copy) NSString *friendID;
- (IBAction)addFriend:(id)sender;
@end
