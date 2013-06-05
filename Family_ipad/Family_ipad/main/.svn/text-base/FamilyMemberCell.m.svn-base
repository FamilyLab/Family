//
//  FamilyMemberCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-2-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "FamilyMemberCell.h"
#import "TileItemButton.h"
#import "web_config.h"
#import "FamilyMemberZoneViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "InviteFamilyViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#import "FamilyCardViewController.h"
#import "CKMacros.h"
#define NUM_PER_ROW 5
#define kTagMembersBtnTag 1000
@implementation FamilyMemberCell
- (void)addFamilyMember:(id)sender
{
    InviteFamilyViewController *con = [[InviteFamilyViewController alloc] initWithNibName:@"InviteFamilyViewController" bundle:nil];
    [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:con invokeByController:[AppDelegate instance].rootViewController isStackStartView:FALSE];
}
- (void)familyInfoAction:(id)sender
{
    FamilyCardViewController *card = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    card.userId = _userid;
    [card sendRequestWith:_userid];
    [self.superview.superview addSubview:card.view];

}
- (IBAction)memberBtnAction:(UIButton *)sender
{

    FamilyMemberZoneViewController *memberZone = [[FamilyMemberZoneViewController alloc] initWithNibName:@"FamilyMemberZoneViewController" bundle:nil];
    memberZone.userId = $str(@"%d",sender.tag);
    [[AppDelegate instance].rootViewController.navigationController pushViewController:memberZone animated:YES];
}
- (void)setCellData:(NSMutableArray *)dict
{
    int index = _indexRow *NUM_PER_ROW;
    for (int i = 0; i < NUM_PER_ROW; i++) {
        TileItemButton *btn = (TileItemButton*)[self viewWithTag:kTagMembersBtnTag + i];
        if (index+ i <=[dict count]) {
            if (index+i == [dict count]&&!_userid) {
                [btn.tileImage setImage:[UIImage imageNamed:@"addbtn2.png"] forState:UIControlStateNormal];
                [btn.tileImage removeTarget:self action:@selector(memberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn.tileImage addTarget:self action:@selector(addFamilyMember:) forControlEvents:UIControlEventTouchUpInside];
                btn.hidden = NO;
            }
            else{
                if (index+i < [dict count]) {
                    if (_userid) {
                        [btn.tileImage  removeTarget:self action:@selector(memberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    [btn setUpSubViews:[[dict objectAtIndex:index+i] objectForKey:AVATER] _str:[[dict objectAtIndex:index+i] objectForKey:NAME]];
                    btn.tileImage.tag = [[[dict objectAtIndex:index+i] objectForKey:UID] intValue];
                    btn.hidden = NO;
                    if (!isEmptyStr([[dict objectAtIndex:index+i] objectForKey:VIPSTATUS])){
                        UIImageView  *v_logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_v_m.png"]];
                        v_logo.frame = CGRectMake(btn.tileImage.frame.size.width-v_logo.frame.size.width/2, btn.tileImage.frame.size.height-v_logo.frame.size.height/2, v_logo.frame.size.width/2, v_logo.frame.size.height/2);
                        [btn.tileImage addSubview:v_logo];
                    }
                    CALayer *layer = btn.tileImage.layer;
                    layer.borderColor = [[UIColor lightGrayColor] CGColor];
                    layer.borderWidth = 1.0f;
                    
                }
                else
                    btn.hidden = YES;
                
            }
        }
        else {
            btn.hidden = YES;
        }
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
