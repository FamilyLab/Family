//
//  EnlargeImageBottomBar.m
//  family_ver_pm
//
//  Created by pandara on 13-3-24.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "EnlargeImageBottomBar.h"

@implementation EnlargeImageBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init with frame");
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

- (IBAction)closeEnlargedImage:(id)sender
{
    [self.delegate closeEnlargedImage];
    //NSLog(@"closeEnlargedImage in enlargeImageBottomBar");
}

- (IBAction)reblogEnlargedImage:(id)sender
{
    [self.delegate rePostEnlargedImage];
    //NSLog(@"reblogEnalrgedImage in enlargeImageBottomBar");
}

- (IBAction)downloadEnlargedImage:(id)sender
{
    [self.delegate downloadEnlargedImage];
    //NSLog(@"downloadEnlargedImage in enlargeImageBottomBar");
}

@end
