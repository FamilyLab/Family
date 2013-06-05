//
//  ImgAndTextCell.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ImgAndTextCell.h"
#define PIC_SIZE @"!294X390"
@implementation ImgAndTextCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)initData:(NSDictionary *)aDict {
    [_leftImgView setImageWithURL:[self genreateImgURL:[aDict objectForKey:FEED_IMAGE_1] size:PIC_SIZE]  placeholderImage:[UIImage imageNamed:@"pic_default.png"]];
    _titleLbl.text = [aDict objectForKey:TOPIC_SUBJECT];
    if (![[aDict objectForKey:COME]isEqualToString:@""])
        _describeLbl.text = $str(@"%@  来自%@",[aDict objectForKey:MESSAGE],[aDict objectForKey:COME]);
    else
        _describeLbl.text = [aDict objectForKey:MESSAGE];}
@end
