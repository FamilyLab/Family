//
//  InviteFamilyCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "CustomCell.h"
#define kBaseInviteCellTag 1000000

@interface InviteFamilyCell : CustomCell
@property (nonatomic,strong)IBOutlet UIButton *inviteButton;
@property (nonatomic,strong)NSDictionary *cellData;
@property (nonatomic,assign)NSUInteger indexRow;

@end
