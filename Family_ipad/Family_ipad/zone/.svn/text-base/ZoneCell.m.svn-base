//
//  ZoneCell.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-10.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "ZoneCell.h"
#import "NSString+ConciseKit.h"
#import "UIButton+WebCache.h"
#define PIC_SIZE @"!330X330"
@implementation ZoneCell
- (void)setCellData:(NSDictionary *)dict
{
    
    [avatar setImageWithURL:[NSURL URLWithString:$str(@"%@%@",[((NSString *)[dict objectForKey:LATEST_PIC] ) delLastStrForYouPai],PIC_SIZE)] placeholderImage:[UIImage imageNamed:@"space_default.jpg"]];
    self.nameLabel.text = $safe([dict objectForKey:TAG_NAME]);

    _photoNumLabel.text = $safe($str(@"%@张",[dict objectForKey:PHOTO_NUM]));
    _videoNumLabel.text = $safe($str(@"%@个",[dict objectForKey:VIDEO_NUM]));
    _diaryNumLabel.text = $safe($str(@"%@篇",[dict objectForKey:BLOG_NUM]));
    _activityNumLabel.text= $safe($str(@"%@个",[dict objectForKey:EVENT_NUM]));
    _tagID = $safe([dict objectForKey:TAG_ID]);
    avatar.contentMode = UIViewContentModeScaleToFill;

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
