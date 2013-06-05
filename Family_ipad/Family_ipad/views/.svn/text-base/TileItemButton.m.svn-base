//
//  TileItemButton.m
//  atFaXian
//
//  Created by Walter.Chan on 12-11-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TileItemButton.h"
#import "ConciseKit.h"
#import "UIButton+WebCache.h"
@implementation TileItemButton
@synthesize tileImage,tagLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
- (void)setUpSubViews:(NSString *)_img
                 _str:(NSString *)_str
{
    self.tagLabel.text = $safe(_str);
    [self.tileImage setBackgroundImageWithURL:[NSURL URLWithString:_img] placeholderImage:[UIImage imageNamed:@"head_110.png"]];
}

@end
