//
//  FamilyCardViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyNewsCell;
@interface FamilyCardViewController : UIViewController
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *birthdayLabel;
@property (nonatomic,strong) IBOutlet UILabel *lastLoginDateLabel;
@property (nonatomic,strong) IBOutlet UILabel *fmembersLabel;
@property (nonatomic,strong) IBOutlet UILabel *zonesLabel;
@property (nonatomic,strong) IBOutlet UIImageView *avatarImage;
@property (nonatomic,strong) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong) IBOutlet UIView *familyInfoView;
@property (nonatomic,assign) BOOL isMyFamily;
@property (nonatomic,strong) IBOutlet UILabel *tipsLabel;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic,strong) IBOutlet UIButton *sendPMbtn;

- (IBAction)backAction:(id)sender;
- (void)sendRequest:(FamilyNewsCell *)sender;
- (void)sendRequestWith:(NSString *)userid;
- (void)setBabyDataWith:(NSDictionary *)dict;
- (IBAction)enterZoneAction:(id)sender;
- (IBAction)sendPM:(id)sender;
@end
