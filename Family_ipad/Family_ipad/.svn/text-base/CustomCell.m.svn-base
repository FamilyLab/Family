//
//  MenuCell.m
//  Family
//
//  Created by on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"
#import "UIButton+WebCache.h"
//static const NSArray *headerArray;
//static const NSArray *myselfArray;
//static const NSArray *settingArray;

@implementation CustomCell
@synthesize indexSection,cellType,nameLabel;

- (void)setCellData:(NSDictionary *)dict
{
   
    [avatar setImageForMyHeadButtonWithUrlStr:[dict objectForKey:AVATER] plcaholderImageStr:@"head_220.png" size:MIDDLE];
    
    
    [avatar setVipStatusWithStr:[dict objectForKey:VIPSTATUS] isSmallHead:NO];
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
