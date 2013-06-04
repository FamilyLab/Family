//
//  MySearchBar.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MySearchBar.h"
#import <QuartzCore/QuartzCore.h>

@interface MySearchBar ()

//@property (nonatomic, strong) UIButton *cancelBtn;
//@property (nonatomic, strong) UIImageView *bgImgView;

@end

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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, self.frame.size.height)];//WithImage:[UIImage imageNamed:_imgStr]];  y值为1是因为就需要1好看点。。。。。
    UIImage *image = [UIImage imageNamed:_imgStr];
    imageView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self insertSubview:imageView atIndex:0];
}

//去掉textfield背景
- (void)layoutSubviews {
    [super layoutSubviews];
    
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
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated {
    [super setShowsCancelButton:showsCancelButton animated:animated];
    
    //“搜索“按钮
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)obj;
            [btn setBackgroundColor:color(168, 48, 54, 1.0000)];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            [btn setBackgroundImage:nil forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            [btn setTitle:@"搜索" forState:UIControlStateNormal];
            [btn setTitle:@"搜 索" forState:UIControlStateHighlighted];
//            [btn setTitle:@"取消" forState:UIControlStateNormal];
//            [btn setTitle:@"取 消" forState:UIControlStateHighlighted];
            [btn.layer setCornerRadius:3.0];
            
            break;
        }
    }
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
