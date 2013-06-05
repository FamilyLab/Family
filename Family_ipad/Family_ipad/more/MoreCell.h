//
//  MoreCell.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-24.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) int indexSection;
@property (nonatomic, assign) int indexRow;

@property (nonatomic, strong) IBOutlet UIButton *headBtn;
@property (nonatomic, strong) IBOutlet UIButton *firstBtn;
@property (nonatomic, strong) IBOutlet UIButton *secondBtn;
@property (nonatomic, strong) IBOutlet UIButton *thirdBtn;
//@property (nonatomic, strong) IBOutlet UILabel *leftLbl;
@property (nonatomic, strong) IBOutlet UIImageView *rightImgView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImgView;

@property (nonatomic, strong) IBOutlet UILabel *firstLbl;
@property (nonatomic, strong) IBOutlet UILabel *secondLbl;
@property (nonatomic, strong) IBOutlet UILabel *thirdLbl;
@property (nonatomic, strong) IBOutlet UISwitch *switchTopic;
- (void)initData:(NSDictionary *)_aDict;
- (IBAction)switchTopicOption:(id)sender;
@end
