//
//  ImageAndLabelView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ImageAndLabelView.h"

@interface ImageAndLabelView ()

//@property (nonatomic, strong) UIImage *leftImage;
//@property (nonatomic, copy) NSString *lblText;
//@property (nonatomic, strong) UIColor *lblTextColor;
//@property (nonatomic, assign) CGFloat lblTextSize;

@end

@implementation ImageAndLabelView
//@synthesize leftImage, lblText, lblTextColor, lblTextSize;
@synthesize leftImgView, rightlbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UILabel *lbl = [[UILabel alloc] init];
//        lbl.backgroundColor = [UIColor clearColor];
//        lbl.textColor = self.lblTextColor;
//        lbl.textAlignment = UITextAlignmentLeft;
//        lbl.text = self.lblText;
//        lbl.font = [UIFont boldSystemFontOfSize:self.lblTextSize];
//        
//        CGSize lblSize = [self.lblText sizeWithFont:[UIFont boldSystemFontOfSize:self.lblTextSize] constrainedToSize:CGSizeMake(320, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//        lbl.frame = CGRectMake(self.leftImage.size.width + 2, 0, lblSize.width, lblSize.height);
//        [self addSubview:lbl];
//        
//        frame.size.width = self.leftImage.size.width + 4 + lblSize.width;
//        frame.size.height = self.leftImage.size.width > lblSize.height ? self.leftImage.size.width : lblSize.height;
//        self.frame = frame;
//        
//        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.leftImage];
//        CGFloat theY = frame.size.height > self.leftImage.size.height ? frame.size.height - self.leftImage.size.height : self.leftImage.size.height - frame.size.height;
//        imgView.frame = CGRectMake(0, theY / 2, self.leftImage.size.width, self.leftImage.size.height);
//        [self addSubview:imgView];
    }
    return self;
}

- (void)fillWithPointInImgAndLblView:(CGPoint)_point
                      withLeftImgStr:(NSString*)_imgStr
                       withRightText:(NSString*)_text
                            withFont:(UIFont*)_font
                       withTextColor:(UIColor*)_color {
    self.frame = (CGRect){.origin.x = _point.x, .origin.y = _point.y, .size = CGSizeZero};
    self.leftImgView.image = [UIImage imageNamed:_imgStr] ? [UIImage imageNamed:_imgStr] : ThemeImage(_imgStr);
    if ([_text isEqualToString:@"0"]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        self.rightlbl.text = _text;
    }
    if (_font) {
        self.rightlbl.font = _font;
    } else
        self.rightlbl.font = [UIFont boldSystemFontOfSize:11.0f];
    if (_color) {
        self.rightlbl.textColor = _color;
    } else
        self.rightlbl.textColor = [UIColor lightGrayColor];
    [self adjustFrame];
}

//图片在左，lbl在右的情况
- (void)adjustFrame {
    //适应rightlbl的frame
    CGSize lblSize = [self.rightlbl.text sizeWithFont:self.rightlbl.font constrainedToSize:CGSizeMake(DEVICE_SIZE.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    self.rightlbl.frame = CGRectMake(self.leftImgView.image.size.width + 2, 0, lblSize.width, lblSize.height);
    
    //适应self的frame
    CGRect theFrame = self.frame;
    theFrame.size.width = self.leftImgView.image.size.width + 4 + lblSize.width;
    theFrame.size.height = self.leftImgView.image.size.width > lblSize.height ? self.leftImgView.image.size.width : lblSize.height;
    self.frame = theFrame;

    //适应leftImgView的frame
    CGFloat theY = theFrame.size.height > self.leftImgView.image.size.height ? theFrame.size.height - self.leftImgView.image.size.height : self.leftImgView.image.size.height - theFrame.size.height;
    leftImgView.frame = CGRectMake(0, theY / 2, self.leftImgView.image.size.width, self.leftImgView.image.size.height);
}

/**
 * 根据传入的图片和文本自动生成一个长度为 图片长+文本长，高度为 图片高度+文本高度 的UIView
 * @param frame 需要X、Y值，width、height的值在这个类里会自动适应
 * @param _image 左边的图片
 * @param _text 文本
 * @param _color 文本颜色
 * @param _size 文本字体大小
 **/
//- (id)initWithFrame:(CGRect)frame
//        andTheImage:(UIImage*)_image
//       andLabelText:(NSString*)_text
//           andColor:(UIColor*)_color
//            andSize:(CGFloat)_size {
//    self.leftImage = _image;
//    self.lblText = _text;
//    self.lblTextColor = _color;
//    self.lblTextSize = _size;
//    return [self initWithFrame:frame];
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
