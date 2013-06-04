//
//  SimpleInfoView.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "SimpleInfoView.h"
#import "Common.h"
//#import "UIButton+WebCache.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"

@implementation SimpleInfoView
@synthesize headImgView, headBtn, nameLbl, noteNameLbl, infoLbl, operatorBtn, rightImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isFromTask = NO;
        [self.noteNameLbl sizeToFit];
        self.noteNameLbl.autoresizesSubviews = UIViewAutoresizingFlexibleRightMargin;
        _isFamilyList = NO;
        _isFromZone = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _isFromTask = NO;
        [self.noteNameLbl sizeToFit];
        self.noteNameLbl.autoresizesSubviews = UIViewAutoresizingFlexibleRightMargin;
        _isFamilyList = NO;
        _isFromZone = NO;
    }
    return self;
}

//SimpleInfoView.xib里的第一种view
- (void)initInfoWithHeadUrlStr:(NSString*)_headUrlStr
                       nameStr:(NSString*)_nameStr
                       infoStr:(NSString*)_infoStr
             rightlBtnNormaImg:(NSString*)_rightBtnNormalImg
         rightlBtnHighlightImg:(NSString*)_rightBtnHighlightImg
          rightlBtnSelectedImg:(NSString*)_rightBtnSelectedImg {
//    [headBtn setImageWithURL:[NSURL URLWithString:_headUrlStr] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [headBtn setImageForMyHeadButtonWithUrlStr:_headUrlStr plcaholderImageStr:nil];
    [headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.nameLbl.text = _nameStr;
    self.infoLbl.text = _infoStr;
    if (_rightBtnNormalImg) {
        [self.operatorBtn setImage:[UIImage imageNamed:_rightBtnNormalImg] forState:UIControlStateNormal];
    }
    if (_rightBtnHighlightImg) {
        [self.operatorBtn setImage:[UIImage imageNamed:_rightBtnHighlightImg] forState:UIControlStateHighlighted];
    }
    if (_rightBtnSelectedImg) {
        [self.operatorBtn setImage:[UIImage imageNamed:_rightBtnSelectedImg] forState:UIControlStateSelected];
    }
}

//SimpleInfoView.xib里的第二种view
- (void)initInfoWithHeadUrlStr:(NSString*)_headUrlStr
                       nameStr:(NSString*)_nameStr
                    noteNameStr:(NSString*)_noteNameStr
                       infoStr:(NSString*)_infoStr
              andRightImgPoint:(CGPoint)_point
                      rightImg:(NSString*)_rightImg
                      rightStr:(NSString*)_rightStr {
//    [headBtn setImageWithURL:[NSURL URLWithString:_headUrlStr] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
    [headBtn setImageForMyHeadButtonWithUrlStr:_headUrlStr plcaholderImageStr:nil];
    [headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [headBtn whenTapped:^{
        [self headBtnPressed:headBtn];
    }];
    if (![_nameStr isEqual:[NSNull null]]) {
        self.nameLbl.text = _nameStr;
    }
    self.noteNameLbl.text = _noteNameStr;
    self.infoLbl.numberOfLines = 0;
    self.infoLbl.text = _infoStr;
    if ([_rightStr isEqualToString:@""]) {
        self.rightImgView.hidden = YES;
    } else {
        self.rightImgView.hidden = NO;
        [self.rightImgView fillWithPointInImgAndLblView:_point
                                         withLeftImgStr:_rightImg
                                          withRightText:_rightStr
                                               withFont:[UIFont boldSystemFontOfSize:13.0f]
                                          withTextColor:[UIColor lightGrayColor]];
    }
}

- (void)headBtnPressed:(id)sender {
    if (_userId) {
        FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
        con.isMyFamily = YES;
        con.userId = _userId;
//        [[Common viewControllerOfView:self].navigationController pushViewController:con animated:YES];
        //        pushACon(con);
        pushAConInView(self, con);
    }
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
}

+ (UIViewController*)viewControllerForView:(UIView*)currView {
    for (UIView *next = [currView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;  
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.nameLbl) {
        self.nameLbl.textColor = [Common theLblColor];
        self.nameLbl.numberOfLines = 0;
        CGSize nameSize = [self.nameLbl.text sizeWithFont:self.nameLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        self.nameLbl.frame = (CGRect){.origin = self.nameLbl.frame.origin, .size = nameSize};
    }
    if (self.noteNameLbl) {
        self.noteNameLbl.numberOfLines = 0;
        CGSize noteNameSize = [self.noteNameLbl.text sizeWithFont:self.noteNameLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        self.noteNameLbl.frame = (CGRect){.origin.x = self.nameLbl.frame.origin.x + self.nameLbl.frame.size.width, .origin.y = self.noteNameLbl.frame.origin.y, .size = noteNameSize};
    }
    if (!self.operatorBtn) {//右边没有一个操作按钮的
        CGFloat maxWidth = _isFromTask ? (320 - 15 - nameLbl.frame.origin.x) : (320 - 15 - nameLbl.frame.origin.x - nameLbl.frame.size.width - 5);
        CGSize infoSize = [infoLbl.text sizeWithFont:infoLbl.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (_isFamilyList) {//家人列表
            infoLbl.frame = (CGRect){.origin.x = nameLbl.frame.origin.x, .origin.y = nameLbl.frame.origin.y + nameLbl.frame.size.height + 3, .size = infoSize};//家人列表
            rightImgView.frame = (CGRect){.origin.x = rightImgView.frame.origin.x, .origin.y = infoLbl.frame.origin.y, .size = rightImgView.frame.size};
        } else if (_isFromTask) {//任务列表
            
//            UIImageView *bgImgView = (UIImageView*)[[self subviews] objectAtIndex:0];
//            bgImgView.image = [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//            bgImgView.frame = (CGRect){.origin = bgImgView.frame.origin, .size.width = bgImgView.frame.size.width, .size.height = self.frame.size.height};
            
            infoLbl.frame = (CGRect){.origin.x = nameLbl.frame.origin.x, .origin.y = nameLbl.frame.origin.y + nameLbl.frame.size.height + 3, .size = infoSize};//家人列表
            self.frame = (CGRect){.origin = self.frame.origin, .size.width = self.frame.size.width, .size.height = infoLbl.frame.origin.y + infoLbl.frame.size.height + 8};
        } else if (_isFromZone) {
            infoLbl.frame = (CGRect){.origin.x = nameLbl.frame.origin.x, .origin.y = nameLbl.frame.origin.y + nameLbl.frame.size.height + 3, .size = infoSize};//空间列表的
            rightImgView.frame = (CGRect){.origin.x = 320 - 10 - rightImgView.frame.size.width - 10, .origin.y = nameLbl.frame.origin.y, .size = rightImgView.frame.size};
        }else {
            infoLbl.frame = (CGRect){.origin.x = nameLbl.frame.origin.x + nameLbl.frame.size.width + 5, .origin.y = nameLbl.frame.origin.y, .size = infoSize};//非 家人列表 的
            rightImgView.frame = (CGRect){.origin.x = rightImgView.frame.origin.x, .origin.y = infoLbl.frame.origin.y + infoLbl.frame.size.height + 5, .size = rightImgView.frame.size};
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
