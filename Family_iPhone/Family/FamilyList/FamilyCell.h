//
//  FamilyCell.h
//  Family
//
//  Created by Aevitx on 13-6-14.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeadButton.h"

@interface FamilyCell : UITableViewCell

@property (nonatomic, assign) int indexRow;
//@property (nonatomic, assign) int indexSection;

@property (nonatomic, strong) IBOutlet MyHeadButton *headBtn;
@property (nonatomic, strong) IBOutlet UILabel *nameLbl;
@property (nonatomic, strong) IBOutlet UILabel *noteLbl;
@property (nonatomic, strong) IBOutlet UILabel *contentLbl;
@property (nonatomic, strong) IBOutlet UIButton *callBtn;

@property (nonatomic, strong) NSDictionary *dataDict;

- (void)initData:(NSDictionary *)aDict;

@end
