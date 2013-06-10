//
//  CommentView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CommentView.h"
#import "Common.h"
#define CONTAINTER_FRAME_HAS_HEAD       CGRectMake(52, 10, 265, 35)
#define CONTAINTER_FRAME_NO_HEAD        CGRectMake(10, 0, 304, 35)
#define CONTAINTER_FRAME_ONLY_A_LABEL   CGRectMake(0, 0, DEVICE_SIZE.width, kNoCommentHeight)

#define CONTENT_LABEL_FRAME CGRectMake(43, 0, 221, 21)  

@implementation CommentView
@synthesize headImgView, headBtn, containerView, nameLbl, contentLbl, timeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentLbl.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_commentType == leftIsText) {
        CGSize nameSize = [_frontBtn.titleLabel.text sizeWithFont:_frontBtn.titleLabel.font constrainedToSize:CGSizeMake(DEVICE_SIZE.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//        nameSize.height = nameSize.height < COMMENT_MIN_HEIGHT ? COMMENT_MIN_HEIGHT : nameSize.height;
        _frontBtn.frame = (CGRect){.origin.x = _frontBtn.frame.origin.x, .origin.y = 10, .size = nameSize};
    } else if (_commentType == leftIsImage) {
        _frontBtn.frame = (CGRect){.origin.x = 20, .origin.y = 10, .size = _frontBtn.imageView.image.size};
    }
    
//FUCK_NUM_0、FUCK_NUM_1、FUCK_NUM_2（FUCK_NUM_1和FUCK_NUM_2的值一样）都改为0，再将评论的背景图片_commentBgImgView改为：@"feed_comment_bg_v12.png"(@"feed_comment_bg_short_v12.png"的为短的)，就可以让评论的那背景框宽度为300。
//#define FUCK_NUM_1  33
    
    CGFloat maxWidth = _commentType == leftIsImage ? LOVE_MAX_WIDTH - FUCK_NUM_1 : COMMENT_MAX_WIDTH - FUCK_NUM_1;
//    CGFloat minHeight = _commentType == leftIsImage ? LOVE_MIN_HEIGHT : COMMENT_MIN_HEIGHT;
    CGSize contentSize = [contentLbl.text sizeWithFont:contentLbl.font constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//    contentSize.height = contentSize.height < minHeight ? minHeight : contentSize.height;
    CGFloat contentX = _commentType == leftIsImage ? 10 : 0;
    CGFloat contentY = _commentType == leftIsImage ? -2 : 0;
    contentLbl.frame = (CGRect){.origin.x = _frontBtn.frame.origin.x + _frontBtn.frame.size.width + 2 + contentX, .origin.y = _frontBtn.frame.origin.y + contentY, .size = contentSize};

    _lineImgView.frame = (CGRect){.origin.x = 11, .origin.y = self.frame.size.height - 2, .size.width = self.frame.size.width - 10 * 2 - 2, .size.height = _lineImgView.frame.size.height};
}

//- (void)setWhichType:(CommentType)_type {
//    self.commentType = _type;
//    switch (_type) {
//        case hasHeadType:
//        {
//            self.headImgView.hidden = NO;
//            self.headBtn.hidden = NO;
//            self.nameLbl.hidden = NO;
//            self.timeView.hidden = NO;
//            self.containerView.frame = CONTAINTER_FRAME_HAS_HEAD;
//            self.contentLbl.frame = CONTENT_LABEL_FRAME;
//            self.contentLbl.textAlignment = UITextAlignmentLeft;
////#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
////            self.contentLbl.textAlignment = UITextAlignmentLeft;
////#else
////            self.contentLbl.textAlignment = NSTextAlignmentLeft;
////#endif
//            self.contentLbl.font = [UIFont boldSystemFontOfSize:14.0f];
//            self.contentLbl.textColor = [UIColor darkGrayColor];
//            break;
//        }
//        case noHeadType:
//        {
//            self.headImgView.hidden = YES;
//            self.headBtn.hidden = YES;
//            self.nameLbl.hidden = NO;
//            self.timeView.hidden = NO;
//            self.containerView.frame = CONTAINTER_FRAME_NO_HEAD;
//            self.contentLbl.frame = CONTENT_LABEL_FRAME;
//            self.contentLbl.textAlignment = UITextAlignmentLeft;
////#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
////            self.contentLbl.textAlignment = UITextAlignmentLeft;
////#else
////            self.contentLbl.textAlignment = NSTextAlignmentLeft;
////#endif
//            self.contentLbl.font = [UIFont boldSystemFontOfSize:14.0f];
//            self.contentLbl.textColor = [UIColor darkGrayColor];
////            [self changeContainerViewFrame];
//            break;
//        }
//        case onlyALabelType:
//        {
//            self.headImgView.hidden = YES;
//            self.headBtn.hidden = YES;
//            self.nameLbl.hidden = YES;
//            self.timeView.hidden = YES;
//            
////            CGRect theFrame = self.frame;
////            theFrame.size.height = 30;
////            self.frame = theFrame;
//            
////            self.containerView.frame = CGRectMake(0, 5, self.frame.size.width, self.frame.size.height);
////            self.contentLbl.frame = self.containerView.frame;
//            
//            self.containerView.frame = CONTAINTER_FRAME_ONLY_A_LABEL;
//            self.contentLbl.frame = self.containerView.frame;
//            self.contentLbl.textAlignment = UITextAlignmentCenter;
////#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
////            self.contentLbl.textAlignment = UITextAlignmentCenter;
////#else
////            self.contentLbl.textAlignment = NSTextAlignmentCenter;
////#endif
//            self.contentLbl.font = [UIFont boldSystemFontOfSize:15.0f];
//            self.contentLbl.textColor = [UIColor lightGrayColor];
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)fillCommentData:(NSDictionary*)aDict {
//    [self setWhichType:noHeadType];
    
//    self.nameLbl.numberOfLines = 0;
//    self.nameLbl.textColor = [Common theLblColor];
    
//    self.nameLbl.text = [aDict objectForKey:COMMENT_AUTHOR_NAME];
    
    self.commentType = leftIsText;
    NSString *nameStr = $str(@"%@: ", [aDict objectForKey:COMMENT_AUTHOR_NAME]);
    [_frontBtn setTitle:nameStr forState:UIControlStateNormal];
    [_frontBtn setTitleColor:_frontBtn.titleLabel.textColor forState:UIControlStateHighlighted];
    self.contentLbl.text = [NSString stringWithFormat:@"%@", [aDict objectForKey:MESSAGE]];
    
//    [self.timeView fillWithPointInImgAndLblView:CGPointMake(0, 23) withLeftImgStr:@"time.png" withRightText:[Common dateSinceNow:[aDict objectForKey:DATELINE]] withFont:[UIFont boldSystemFontOfSize:12.0f] withTextColor:[UIColor lightGrayColor]];
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
