//
//  UIViewController+Swipe.m
//  Family_ipad
//
//  Created by walt.chan on 13-3-9.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import "UIViewController+Swipe.h"

@implementation UIViewController (Swipe)
- (void)backAction:(id)sender
{
    
}
- (void)swipeToDismiss:(id)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.height, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self backAction:nil];
        
    }];
}
@end
