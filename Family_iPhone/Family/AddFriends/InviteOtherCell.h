//
//  InviteOtherCell.h
//  Family
//
//  Created by Aevitx on 13-6-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

@interface InviteOtherCell : UITableViewCell
@property (nonatomic, assign) int indexRow;
//@property (nonatomic, assign) int indexSection;

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *phoneLbl;
@property (nonatomic, strong) IBOutlet UIButton *operateBtn;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UILabel *smsLbl;

@property (nonatomic, strong) NSDictionary *dataDict;

- (void)initData:(NSDictionary *)aDict;


@end
