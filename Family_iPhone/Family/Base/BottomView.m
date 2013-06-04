//
//  BottomView.m
//  Family
//
//  Created by apple on 12-12-19.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView
@synthesize bottomViewType;
@synthesize buttonNum;
@synthesize normalImagesArray, selectedImagesArray;
@synthesize bgImgView, bgImageStr;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (bottomViewType == notAboutTheme) tmpImgView.image = [UIImage imageNamed:bgImageStr];
        else tmpImgView.image = ThemeImage(bgImageStr);
        self.bgImgView = tmpImgView;
        [self addSubview:bgImgView];
        
        for (int i=0; i<buttonNum; i++) {
            UIImage *normalImage;
            if (bottomViewType == notAboutTheme)
                normalImage = [UIImage imageNamed:[normalImagesArray objectAtIndex:i]];
            else
                normalImage = ThemeImage([normalImagesArray objectAtIndex:i]);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = kTagBottomButton + i;
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setImage:normalImage forState:UIControlStateNormal];
            if (bottomViewType != notAboutTheme) {
                [button setImage:ThemeImage([selectedImagesArray objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
            if (bottomViewType == notAboutTheme && selectedImagesArray) {
                [button setImage:[UIImage imageNamed:[selectedImagesArray objectAtIndex:i]] forState:UIControlStateHighlighted];
            }
            
            if (bottomViewType == tabBarType && i == 2) {
                //中间突起的按钮
                button.frame = CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height);
                CGFloat heightDifference = normalImage.size.height - self.frame.size.height;
                if (heightDifference < 0)
                    button.center = self.center;
                else {
                    CGPoint center = self.center;
                    center.y = center.y - self.frame.origin.y - heightDifference/2.0;
                    button.center = center;
                }
            } else {
                button.frame = CGRectMake(self.bounds.size.width / buttonNum * i, 0, self.bounds.size.width / buttonNum, frame.size.height);
            }
            
            if (bottomViewType == tabBarType) {
                [button setImage:ThemeImage([selectedImagesArray objectAtIndex:i]) forState:UIControlStateSelected];
                button.selected = i==0 ? YES : NO;
            }
            [self addSubview:button];
        } 
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
               type:(BottomViewType)_type
          buttonNum:(NSInteger)_num
    andNormalImages:(NSArray*)_normalImages
  andSelectedImages:(NSArray*)_selectedImages
 andBackgroundImage:(NSString*)_bgImageStr {
    
    self.bottomViewType = _type;
    self.buttonNum = _num;
    self.normalImagesArray = _normalImages;
    self.selectedImagesArray = _selectedImages;
    self.bgImageStr = _bgImageStr;
    return [self initWithFrame:frame];
}

- (void)buttonPressed:(UIButton*)_button {
    if ([self.delegate respondsToSelector:@selector(userPressedTheBottomButton:andButton:)]) {
        if (bottomViewType == tabBarType && _button.tag != kTagBottomButton + 2) {
            for (id obj in [self subviews]) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton *btn = obj;
                    if (btn.tag == _button.tag) btn.selected = YES;
                    else btn.selected = NO;
                }
            }
        }
        [self.delegate userPressedTheBottomButton:self andButton:_button];
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
