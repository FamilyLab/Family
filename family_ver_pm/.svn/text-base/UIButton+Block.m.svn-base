//
//  UIButton+Block.m
//  blockskit_test
//
//  Created by pandara on 13-4-29.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "UIButton+Block.h"

@implementation UIButton (Block)

static char overViewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)block
{
    objc_setAssociatedObject(self, &overViewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callActionBlock:(id)sender
{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overViewKey);
    if (block) {
        block();
    }
}

@end
