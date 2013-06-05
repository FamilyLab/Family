//
//  DetailHeaderView.m
//  Family_ipad
//
//  Created by walt.chan on 13-1-15.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "DetailHeaderView.h"
#import "MyHttpClient.h"
#import "UIButton+WebCache.h"    
@implementation DetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setViewDataWithLocal
{
    [_avatarButton setBackgroundImageWithURL:[NSURL URLWithString:[ConciseKit userDefaultsObjectForKey:AVATAR_URL]] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
    _nameLabel.text = [ConciseKit userDefaultsObjectForKey:NAME];
    
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
