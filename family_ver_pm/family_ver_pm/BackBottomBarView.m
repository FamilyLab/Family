//
//  BottomBarView.m
//  Family_pm
//
//  Created by shawjanfore on 13-3-21.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "BackBottomBarView.h"

@implementation BackBottomBarView
@synthesize buttonNum, normalImg, selectedImg, bgImageView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)_frame
        numOfButton:(NSInteger)_num
     andNormalImage:(NSArray*)_normalImage
   andSelectedImage:(NSArray*)_selectedImage
backgroundImageView:(NSString*)_bgImg
{
    self.buttonNum= _num;
    self.normalImg = _normalImage;
    self.selectedImg = _selectedImage;
    self.bgImageView = _bgImg;
    return [self initWithFrame:_frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [bgImg setImage:[UIImage imageNamed:bgImageView]];
        [self addSubview:bgImg];
        [bgImg release], bgImg = nil;
        
        for (int i=0; i < buttonNum; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = kTheBottomButtonTag + i;
            [button addTarget:self action:@selector(theButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(frame.size.width / buttonNum * i, 0, frame.size.width / buttonNum, frame.size.height)];
            [button setImage:[UIImage imageNamed:[normalImg objectAtIndex:i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[selectedImg objectAtIndex:i]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:[selectedImg objectAtIndex:i]] forState:UIControlStateSelected];
            [self addSubview:button];
        }
    }
    return self;
}

-(void)theButtonPressed:(UIButton*)_button
{
    if ([self.delegate respondsToSelector:@selector(userPressTheBottomButton:andTheButton:)]) {
        [self.delegate userPressTheBottomButton:self andTheButton:_button];
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
-(void)dealloc
{
    [super dealloc];
    [normalImg release];
    [selectedImg release];
    [bgImageView release];
}

@end
