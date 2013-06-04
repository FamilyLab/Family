//
//  ExpandView.m
//  Family
//
//  Created by Aevitx on 13-1-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ExpandView.h"

@implementation ExpandView
@synthesize postType, selectTypeBtn, currTypeLbl, typeContainerView, bgImgView, directBtn;
@synthesize delegate;


#define EXPAND_BUTTON_NUM           5//需要加 发视频 的话，只需要这里改为6，再用ExpandView.xib里的第一个view就行了（记得button的tag要按顺序从130－135排列，135为最下面一小栏的按钮）。ExpandView.xib里第二个view为5个按钮的（button的tag从130－136，136为最下面一小栏的按钮）。
#define FIRST_BUTTON_HEIGHT         50
#define EVERY_BUTTON_HEIGHT         55

//A的为未展开的，B的为已展开的

#define TYPE_CONTAINER_FRAME_A      CGRectMake(0, FIRST_BUTTON_HEIGHT, 100, 0)
//#define TYPE_CONTAINER_FRAME_B      CGRectMake(0, 49, 100, 275)
#define TYPE_CONTAINER_FRAME_B      CGRectMake(0, FIRST_BUTTON_HEIGHT, 100, (EXPAND_BUTTON_NUM - 1) *EVERY_BUTTON_HEIGHT)

#define DIRECT_BTN_FRAME_A          CGRectMake(0, FIRST_BUTTON_HEIGHT, 100, 16)
//#define DIRECT_BTN_FRAME_B          CGRectMake(0, 323, 100, 16)
#define DIRECT_BTN_FRAME_B          CGRectMake(0, FIRST_BUTTON_HEIGHT + (EXPAND_BUTTON_NUM - 1) * EVERY_BUTTON_HEIGHT - 1, 100, 16)

#define SELF_FRAME_A                CGRectMake(10, 0, 100, 66)
//#define SELF_FRAME_B                CGRectMake(10, 0, 100, 340)
#define SELF_FRAME_B                CGRectMake(10, 0, 100, FIRST_BUTTON_HEIGHT + (EXPAND_BUTTON_NUM - 1) * EVERY_BUTTON_HEIGHT + 16 - 2)

#define POST_PHOTO          @"发照片"
#define POST_DIARY          @"发日记"
#define POST_PRIVATE_MSG    @"发私信"
#define POST_ACTIVITY       @"发活动"
#define POST_VIDEO          @"发视频"
#define POST_WANT_TO_SAY    @"我想说"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

//- (void)willMoveToSuperview:(UIView *)newSuperview {
//    [super willMoveToSuperview:newSuperview];
//    if (EXPAND_BUTTON_NUM == 5) {
//        //此处为了处理少了 发视频 的情况，需要重新设置一下tag
//        int indexTag = 0;
//        for (id obj in self.subviews) {
//            if ([obj isKindOfClass:[UIButton class]]) {
//                UIButton *btn = (UIButton*)obj;
//                btn.tag = kTagBtnInExpandView + indexTag;
//                indexTag++;
//            } else if ([obj isKindOfClass:[UIView class]]) {
//                UIView *aView = (UIView*)obj;
//                for (id obj2 in aView.subviews) {
//                    if ([obj2 isKindOfClass:[UIButton class]]) {
//                        UIButton *btn2 = (UIButton*)obj2;
//                        btn2.tag = kTagBtnInExpandView +indexTag;
//                        indexTag++;
//                    }
//                }
//            }
//        }
//    }
//}

- (void)expand {
    self.selectTypeBtn.selected = !self.selectTypeBtn.selected;
    [self changeDirectBtnImg];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         typeContainerView.frame = self.selectTypeBtn.selected ? TYPE_CONTAINER_FRAME_B : TYPE_CONTAINER_FRAME_A;
                         directBtn.frame = self.selectTypeBtn.selected ? DIRECT_BTN_FRAME_B : DIRECT_BTN_FRAME_A;
                     } completion:^(BOOL finished) {
                         self.frame = self.selectTypeBtn.selected ? SELF_FRAME_B : SELF_FRAME_A;
                     }];
}

- (PostType)getPostTypeWithBtnTitle:(NSString*)_title {
    if ([_title isEqualToString:POST_PHOTO]) {
        return postPhoto;
    } else if ([_title isEqualToString:POST_DIARY]) {
        return postDiary;
    } else if ([_title isEqualToString:POST_PRIVATE_MSG]) {
        return postPrivateMsg;
    } else if ([_title isEqualToString:POST_ACTIVITY]) {
        return postActivity;
    } else if ([_title isEqualToString:POST_VIDEO]) {
        return postVideo;
    } else if ([_title isEqualToString:POST_WANT_TO_SAY]) {
        return postWantToSay;
    } else return postHitError;
}

- (void)selecteWantToSayThroughOtherView:(UIButton *)sender {
    for (id obj in self.typeContainerView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)obj;
            if ([btn.titleLabel.text isEqualToString:POST_WANT_TO_SAY]) {
                [self changeTypeAndTextWithButton:btn];
                return;
            }
        }
    }
}

- (IBAction)btnPressed:(UIButton*)sender {
//    NSString *btnText = sender.titleLabel.text;
//    int btnTag = sender.tag - kTagBtnInExpandView;
//    if (btnTag != 0 && btnTag != EXPAND_BUTTON_NUM) {//除了最上面和最下面的
//        self.postType = [self getPostTypeWithBtnTitle:btnText];//设置新的postType
//        [sender setTitle:self.currTypeLbl.text forState:UIControlStateNormal];//改变当前点击的按钮的文本为当前currTypeLbl的值
//        self.currTypeLbl.text = btnText;//设置currTypeLbl新的值
//        if ([self.delegate respondsToSelector:@selector(userPressedTheSelectBtn:)]) {
//            [self.delegate userPressedTheSelectBtn:self];
//        }
//    }
    [Common resignKeyboardInView:[Common viewControllerOfView:self].view];
    [self changeTypeAndTextWithButton:sender];
    //上面和下面的选择按钮
    [self expand];
}

- (void)changeTypeAndTextWithButton:(UIButton*)sender {
    NSString *btnText = sender.titleLabel.text;
    int btnTag = sender.tag - kTagBtnInExpandView;
    if (btnTag != 0 && btnTag != EXPAND_BUTTON_NUM) {//除了最上面和最下面的
        self.postType = [self getPostTypeWithBtnTitle:btnText];//设置新的postType
        [sender setTitle:self.currTypeLbl.text forState:UIControlStateNormal];//改变当前点击的按钮的文本为当前currTypeLbl的值
        self.currTypeLbl.text = btnText;//设置currTypeLbl新的值
        if ([self.delegate respondsToSelector:@selector(userPressedTheSelectBtn:)]) {
            [self.delegate userPressedTheSelectBtn:self];
        }
    }
}

- (void)fillTheme {
    [self.selectTypeBtn setImage:ThemeImage(@"left_bg") forState:UIControlStateNormal];
    self.bgImgView.image = ThemeImage(@"write_five_bg");
    [self changeDirectBtnImg];
}

- (void)changeDirectBtnImg {
    NSString *directImgStr = self.selectTypeBtn.selected ? @"to_top_a" : @"to_down_a";
    [self.directBtn setImage:ThemeImage(directImgStr) forState:UIControlStateNormal];
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
