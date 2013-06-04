//
//  FamilyListCell.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-28.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "FamilyListCell.h"
#import "UIImageView+WebCache.h"

@implementation FamilyListCell

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

-(void)initData:(NSDictionary*)dict
{
    [headImg setImageWithURL:[NSURL URLWithString:[dict objectForKey:AVATAR]] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
    NSString *nicknameStr = [[dict objectForKey:NOTE] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"(%@)", [dict objectForKey:NOTE]];
    NSString *noteStr = [NSString stringWithFormat:@"%@%@", [[dict objectForKey:NAME] isEqual:[NSNull null]] ? @"" : [dict objectForKey:NAME], nicknameStr];
    nameLbl.text = noteStr;
    nameLbl.adjustsFontSizeToFitWidth = YES;
    //noteLbl.text = [dict objectForKey:NOTE];
    birthLbl.text = [dict objectForKey:BIRTHDAY];
    
}

@end
