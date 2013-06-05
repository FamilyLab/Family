//
//  MessageCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-11.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "MessageCell.h"
#import "UIButton+WebCache.h"
#import "Common.h"
#define kCellGapInMsg     4

@implementation MessageCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.multiTextTypeView.frame = (CGRect){.origin = self.multiTextTypeView.frame.origin, .size.width = self.multiTextTypeView.frame.size.width, .size.height = self.bounds.size.height - kCellGapInMsg * 2};
    [self.multiTextTypeView layoutSubviews];
     _isNewImage.frame = CGRectMake(_isNewImage.frame.origin.x, self.frame.size.height-_isNewImage.frame.size.height, _isNewImage.frame.size.width, _isNewImage.frame.size.height);
    _newsNumLabel.center = _isNewImage.center;
    _newsNumLabel.frame = CGRectMake(_newsNumLabel.frame.origin.x+5, _newsNumLabel.frame.origin.y+5, _newsNumLabel.frame.size.width,_newsNumLabel.frame.size.height);

}
- (void)setTaskData:(NSDictionary *)dict
{
    
    [self.multiTextTypeView.headBtn setBackgroundImageWithURL:[NSURL URLWithString:[dict objectForKey:IMAGE]] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
    if (![[dict objectForKey:NOTE] isEqual:[NSNull null]]) {
          self.multiTextTypeView.contentLbl.text = [NSString stringWithFormat:@"%@", [dict objectForKey:NOTE]];
    }
    self.multiTextTypeView.nameLbl.text = [dict objectForKey:NAME];
}
- (void)setCellData:(NSDictionary *)dict
{
    //头像
  [self.multiTextTypeView.headBtn setImageForMyHeadButtonWithUrlStr:[dict objectForKey:PM_TO_AVATAR] plcaholderImageStr:nil size:MIDDLE];
    self.multiTextTypeView.headBtn.type = HEAD_BTN;
    [self.multiTextTypeView.headBtn setVipStatusWithStr:[dict objectForKey:VIPSTATUS] isSmallHead:NO];

    self.multiTextTypeView.headBtn.identify = [dict objectForKey:PM_TO_UID];
    self.multiTextTypeView.userId = [dict objectForKey:PM_TO_UID];
    
    //时间
    self.multiTextTypeView.timeLbl.text = [Common dateSinceNow:[dict objectForKey:LAST_DATE_LINE]];
    
    //富文本，名字
    //    self.multiTextTypeView.contentLbl.extendBottomToFit = YES;//自适应高度
    NSString *name = emptystr([dict objectForKey:PM_TO_NAME]);
    if (!isEmptyStr([dict objectForKey:NOTE])) {
        name = [NSString stringWithFormat:@"%@(%@)", name, [dict objectForKey:NOTE]];
    }
    self.multiTextTypeView.nameLbl.text = name;
    [self.multiTextTypeView fillLblWithStr:emptystr([dict objectForKey:PM_TO_NAME]) isNickName:YES];
    
    //富文本，内容
    self.multiTextTypeView.contentLbl.numberOfLines = 0;
    NSString *lastTalkStr = [dict objectForKey:LAST_SUMMARY];
    
    if (![[dict objectForKey:ADDRESS] isEqual:[NSNull null]] && ![[dict objectForKey:ADDRESS] isEqualToString:@""]) {
        lastTalkStr = [NSString stringWithFormat:@"%@  %@", lastTalkStr, [dict objectForKey:ADDRESS]];
        self.multiTextTypeView.contentLbl.text = lastTalkStr;
        [self.multiTextTypeView fillLblWithStr:[dict objectForKey:ADDRESS] isNickName:NO];
    } else
        self.multiTextTypeView.contentLbl.text = lastTalkStr;
    self.multiTextTypeView.contentStr = lastTalkStr;

    if ([[dict objectForKey:@"new"]intValue]>0) {
       
        _isNewImage.hidden = NO;
        _newsNumLabel.text = [dict objectForKey:@"new"];
        _newsNumLabel.hidden = NO;
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
+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight {
    CGFloat height = _miniHeight + ceilf([text sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(310.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    return height;
}
@end
