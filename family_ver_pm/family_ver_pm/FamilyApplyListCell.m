//
//  FamilyApplyListCell.m
//  Family_pm
//
//  Created by shawjanfore on 13-4-4.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FamilyApplyListCell.h"

@implementation FamilyApplyListCell
@synthesize headBtn, nameLbl, rightBtn, leftBtn, whichTypeVC, delegate, index;

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

-(void)initData:(NSDictionary *)_dict
{
    [headBtn setImageForMyHeadButtonWithUrlStr:[_dict objectForKey:AVATAR] placeholderImageStr:@"head_110.png"];
    nameLbl.text = [_dict objectForKey:NAME];
    nameLbl.adjustsFontSizeToFitWidth = YES;
    if (whichTypeVC == 0) {
        leftBtn.hidden = NO;
        leftBtn.tag = kTheListViewCellButtonTag + 1;
        [leftBtn setImage:[UIImage imageNamed:@"cancel_a.png"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"cancel_b.png"] forState:UIControlStateHighlighted];
        [leftBtn setImage:[UIImage imageNamed:@"cancel_b.png"] forState:UIControlStateSelected];
        [leftBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag = kTheListViewCellButtonTag;
        [rightBtn setImage:[UIImage imageNamed:@"agree_a.png"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"agree_b.png"] forState:UIControlStateHighlighted];
        [rightBtn setImage:[UIImage imageNamed:@"agree_b.png"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else if(whichTypeVC == 1){
        leftBtn.hidden = YES;
        if ([[_dict objectForKey:IS_MY_FAMILY] intValue] == 1) {
            rightBtn.hidden = YES;
            return;
        }
        CGRect nextFrame = nameLbl.frame;
        nextFrame.size.width += 60;
        nameLbl.frame = nextFrame;
        rightBtn.tag = kTheListViewCellButtonTag;
        [rightBtn setImage:[UIImage imageNamed:@"add_a.png"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"add_b.png"] forState:UIControlStateHighlighted];
        [rightBtn setImage:[UIImage imageNamed:@"add_b.png"] forState:UIControlStateSelected];
        [rightBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)buttonPressed:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(userDidPressedTheCellButtonOfView:andButton:)]) {
        [self.delegate userDidPressedTheCellButtonOfView:self andButton:sender];
    }
}

-(void)dealloc
{
    [super dealloc];
    [headBtn release], headBtn = nil;
    [nameLbl release], nameLbl = nil;
    [rightBtn release], rightBtn = nil;
    [leftBtn release], leftBtn = nil;
}

@end
