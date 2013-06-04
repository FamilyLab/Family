//
//  MyToolBar.m
//  family_ver_pm
//
//  Created by pandara on 13-5-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "MyToolBar.h"

@implementation MyToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyToolBar" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyToolBar" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (IBAction)finishInput:(id)sender {
    [self.delegateInMyToolBar tapFinishButtonInMyToolBar];
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
