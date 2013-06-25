//
//  MyYIPopupTextView.m
//  Family
//
//  Created by Aevitx on 13-6-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyYIPopupTextView.h"

@implementation MyYIPopupTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMaxCount:(NSUInteger)maxCount {
    return [self initWithMaxCount:maxCount placeHolger:@"随便说点啥吧..."];
}

- (id)initWithMaxCount:(NSUInteger)maxCount placeHolger:(NSString*)placeHolderStr {
    return [self initWithMaxCount:maxCount placeHolger:placeHolderStr textViewSize:CGSizeZero textViewInsets:UIEdgeInsetsZero];
}

- (id)initWithMaxCount:(NSUInteger)maxCount placeHolger:(NSString*)placeHolderStr textViewSize:(CGSize)textViewSize textViewInsets:(UIEdgeInsets)textViewInsets {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
//        CGSize textViewSize = CGSizeMake(DEVICE_SIZE.width - 10 * 2, 200);
//        UIEdgeInsets textViewInsets = UIEdgeInsetsMake(50, 10, 50, -10);
        YIPopupTextView *popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:placeHolderStr textViewSize:textViewSize textViewInsets:textViewInsets maxCount:maxCount buttonStyle:YIPopupTextViewButtonStyleLeftCancelRightDone tintsDoneButton:NO];
        //        YIPopupTextView *popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"随便说点啥吧..." maxCount:0 buttonStyle:YIPopupTextViewButtonStyleLeftCancelRightDone tintsDoneButton:NO];
        //        popupTextView.delegate = self;
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        //        popupTextView.editable = NO;                  // set editable=NO to show without keyboard _popupView
        UIImageView *lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pop_line.png"]];
        if (CGSizeEqualToSize(textViewSize, CGSizeZero)) {
            [popupTextView setAcceptBtnFrame:CGRectMake(10, 180, 150, 40) andNormalImageWithStr:@"pop_left.png" andHighlightImageWithStr:nil];
            [popupTextView setCloseBtnFrame:CGRectMake(160, 180, 150, 40) andNormalImageWithStr:@"pop_right.png" andHighlightImageWithStr:nil];
            lineImgView.frame = CGRectMake(160, 180, 1, 40);
        } else {
            [popupTextView setAcceptBtnFrame:CGRectMake(textViewInsets.left, textViewSize.height - 50 - 1, 150, 40) andNormalImageWithStr:@"pop_left.png" andHighlightImageWithStr:nil];
            [popupTextView setCloseBtnFrame:CGRectMake(textViewInsets.left + 150, popupTextView.acceptButton.frame.origin.y, 150, 40) andNormalImageWithStr:@"pop_right.png" andHighlightImageWithStr:nil];
            lineImgView.frame = CGRectMake(textViewInsets.left + 150, popupTextView.acceptButton.frame.origin.y, 1, 40);
        }
        [popupTextView.superview addSubview:lineImgView];
        //        [popupTextView showInView:self.view];
        UIImageView *alphaBgImgVIew = [[UIImageView alloc] initWithFrame:DEVICE_BOUNDS];
        alphaBgImgVIew.backgroundColor = [UIColor blackColor];
        alphaBgImgVIew.alpha = 0.6f;
        [popupTextView.superview.superview insertSubview:alphaBgImgVIew atIndex:0];
        
        self = (MyYIPopupTextView*)popupTextView;
        //        return (MyYIPopupTextView*)popupTextView;
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

@end
