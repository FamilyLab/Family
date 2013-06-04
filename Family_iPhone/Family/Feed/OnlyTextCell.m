//
//  OnlyTextCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OnlyTextCell.h"
#import "UILabel+VerticalAlign.h"

@implementation OnlyTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [_describeLbl alignTop];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [_describeLbl alignTop];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.preContentView.hidden) {
        [self.preContentView layoutSubviews];
    }
    CGSize preContentSize = [PreContentView heightForCellWithText:self.preContentView.rightLbl.text andOtherHeight:0 andLblMaxWidth:265 andFont:self.preContentView.rightLbl.font];
    preContentSize.width = preContentSize.width < 280 ? 280 : preContentSize.width;
    self.preContentView.frame = (CGRect){.origin = self.preContentView.frame.origin, .size = preContentSize};
    
    CGFloat preContentH = self.preContentView.hidden ? 0 : self.preContentView.frame.size.height;
    CGSize describeSize = [_describeLbl.text sizeWithFont:_describeLbl.font constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    _describeLbl.frame = (CGRect){.origin.x = _describeLbl.frame.origin.x, .origin.y = 0, .size = describeSize};//35为FeedCellHeadView的高度
    self.comeLbl.frame = (CGRect){.origin.x = self.comeLbl.frame.origin.x, .origin.y = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + preContentH, .size = self.comeLbl.frame.size};
    if (!self.preContentView.hidden) {
        self.preContentView.frame = (CGRect){.origin.x = self.preContentView.frame.origin.x, .origin.y = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + 3, .size = self.preContentView.frame.size};
    }
    self.typeView.frame = (CGRect){.origin = self.typeView.frame.origin, .size.width = self.typeView.frame.size.width, .size.height = _describeLbl.frame.origin.y + _describeLbl.frame.size.height + preContentH + self.comeLbl.frame.size.height};
}

- (void)initData:(NSDictionary *)aDict {
    _describeLbl.text = [aDict objectForKey:MESSAGE];
    
    if ([emptystr([aDict objectForKey:OLD_MESSAGE]) isEqualToString:@""]) {//非转载
        _describeLbl.font = [UIFont systemFontOfSize:14.0f];
        self.preContentView.hidden = YES;
    } else {//转载
        _describeLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        self.preContentView.hidden = NO;
        self.preContentView.rightLbl.text = [aDict objectForKey:OLD_MESSAGE];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
