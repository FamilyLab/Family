//
//  MySearchBar.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//自定义背景
- (void)buildMySearchBarWithImgStr:(NSString*)_imgStr {
    self.backgroundColor = [UIColor clearColor];
    [[self.subviews objectAtIndex:0] removeFromSuperview];
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imgStr]];
    [self insertSubview:imageView atIndex:0];
}

//去掉textfield背景
- (void)layoutSubviews {
    UITextField *searchField;
    NSUInteger numViews = [self.subviews count];
    for (int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    if (!(searchField == nil)) {
        searchField.textColor = [UIColor blackColor];
        [searchField.leftView setHidden:NO];
        [searchField setBackground:nil];
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    
    [super layoutSubviews];
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
