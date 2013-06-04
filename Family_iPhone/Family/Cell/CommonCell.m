//
//  CommonCell.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell
@synthesize dataDict, simpleInfoView, delegate;// headImgView, nameLbl, infoLbl, operatorBtn, delegate, ;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.simpleInfoView) {
        [self.simpleInfoView layoutSubviews];
    }
}

- (IBAction)operatorBtnPressed:(UIButton*)sender {
    if (self.simpleInfoView.operatorBtn == (UIButton*)sender) {
        if ([self.delegate respondsToSelector:@selector(userPressedTheOperatorBtn:)]) {
            [self.delegate userPressedTheOperatorBtn:self];
        }
    }
}

- (void)initData:(NSDictionary *)_aDict {
}

@end
