//
//  BottomBarView.m
//  family_ver_pm
//
//  Created by pandara on 13-3-22.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "BottomBarView.h"

@implementation BottomBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BottomBarView" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        self.frame = frame;
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

- (IBAction)backToRoot:(id)sender
{
    [self.delegate backToRoot];
}

- (IBAction)pressCommentBtn:(id)sender
{
    [self.delegate pressCommentBtn];
}

- (IBAction)reblog:(id)sender
{
    [self.delegate pressRepostBtn];
}

- (IBAction)like:(id)sender
{
    [self.delegate pressLikeBtn];
}
@end
