//
//  CommentCell.m
//  Family
//
//  Created by Walter.Chan on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)setCellData:(NSDictionary *)dict
{
    //[avatar setImageWithURL:[NSURL URLWithString:[dict objectForKey:NOTICE_AUTHOR_AVATAR]] placeholderImage:[UIImage imageNamed:@"commentary_head_default"]];
    noteLabel.text = $safe([dict objectForKey:NOTE]);
    timeLabel.text = $safe([dict objectForKey:DATELINE]);
    nameLabel.text = $safe([dict objectForKey:NOTICE_AUTHOR_NAME]);
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
