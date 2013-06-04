//
//  OperateView.m
//  Family
//
//  Created by Aevitx on 13-1-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "OperateView.h"
#import "Common.h"
#import "MyButton.h"
#import "ThemeManager.h"

#define theArrowWidth   13
#define theArrowHeight  9

@implementation OperateView

@synthesize btnPressedBlock;
@synthesize arrowImgView;
@synthesize btnNum;
@synthesize albumBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)btnPressed:(UIButton*)sender {
    if (sender.tag != kTagBtnInFeedDetail + btnNum) {//不是按到相册按钮
        if (currIndex == sender.tag - kTagBtnInFeedDetail) {
            return;
        }
        currIndex = sender.tag - kTagBtnInFeedDetail;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             CGRect theFrame = self.arrowImgView.frame;
                             theFrame.origin.x = [self moveArrowToX:sender];
                             self.arrowImgView.frame = theFrame;
                         }];
        for (int i=0; i<btnNum; i++) {
            UIButton *btn = (UIButton*)[self viewWithTag:kTagBtnInFeedDetail + i];
            btn.selected = NO;
        }
        sender.selected = YES;
    } else//按到相册按钮
        currIndex = sender.tag - kTagBtnInFeedDetail;
    if (self.btnPressedBlock) {
        self.btnPressedBlock(sender.tag);
    }
}

- (CGFloat)moveArrowToX:(UIButton*)sender {
    CGFloat theX = sender.frame.origin.x + sender.frame.size.width / 2 - theArrowWidth / 2;
    return theX;
}

- (void)initWithBtnNum:(int)_num everyBtnSize:(CGSize)_size btnTexts:(NSArray*)_textArray withAction:(BtnPressedBlock)_block {
    currIndex = 0;
    self.backgroundColor = [UIColor clearColor];
    self.btnNum = _num;
    
    for (int i=0; i<_num; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + _size.width * i, 0, _size.width, _size.height);
        btn.tag = kTagBtnInFeedDetail + i;
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateHighlighted];//根据主题
        [btn setTitleColor:[Common theBtnColor] forState:UIControlStateSelected];//根据主题
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];//默认值
        btn.titleLabel.textAlignment = UITextAlignmentCenter;//默认值
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//        btn.titleLabel.textAlignment = UITextAlignmentCenter;
//#else
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//#endif
        [btn setTitle:[_textArray objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    self.btnPressedBlock = _block;
    UIButton *firstBtn = (UIButton*)[self viewWithTag:kTagBtnInFeedDetail];
    firstBtn.selected = YES;
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 32, 290, 3)];
    lineImgView.image = ThemeImage(@"boundary");
    [self addSubview:lineImgView];
    
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake([self moveArrowToX:firstBtn], 26, theArrowWidth, theArrowHeight)];
    aImgView.image = ThemeImage(@"directing");
    self.arrowImgView = aImgView;
    [self addSubview:arrowImgView];
    
    MyButton *tmpBtn = [MyButton buttonWithType:UIButtonTypeCustom];
    tmpBtn.frame = CGRectMake(205, 0, 100, 35);
    [tmpBtn setImage:ThemeImage(@"album_bg_a") forState:UIControlStateNormal];
    tmpBtn.tag = kTagBtnInFeedDetail + _num;
    [tmpBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.albumBtn = tmpBtn;
    self.albumBtn.btnLbl.frame = (CGRect){.origin = self.albumBtn.btnLbl.frame.origin, .size = CGSizeMake(100, 35)};
    [self.albumBtn changeLblWithText:[_textArray objectAtIndex:btnNum - 1] andColor:[UIColor whiteColor] andSize:11.0f theX:25];
    [self addSubview:albumBtn];
    
    UIImageView *albumImgView = [[UIImageView alloc] initWithFrame:CGRectMake(205, 7, 22, 20)];
    albumImgView.image = ThemeImage(@"album");
    [self addSubview:albumImgView];
}

- (void)fillDataWithBtnNum:(int)_num everyBtnSize:(CGSize)_size btnTexts:(NSArray*)_textArray withAction:(BtnPressedBlock)_block {
    
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
