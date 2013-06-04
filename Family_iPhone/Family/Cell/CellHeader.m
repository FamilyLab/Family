//
//  CellHeader.m
//  Family
//
//  Created by Aevitx on 13-1-21.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CellHeader.h"
#import "TopView.h"

@implementation CellHeader
@synthesize leftImgView, rightBtn;
@synthesize rightImgView, middleLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.isFromZoneList = NO;
        self.frame = frame;
        self.backgroundColor = bgColor();
        UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
        self.leftImgView = left;
        [self addSubview:left];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(90, 1, 230, 19)];
        self.rightImgView = right;
        [self addSubview:right];
        
        UILabel *middle = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 70, 20)];
        middle.textColor = [UIColor blackColor];
        middle.font = [UIFont boldSystemFontOfSize:16.0f];
        middle.backgroundColor = [UIColor clearColor];
        self.middleLbl = middle;
        [self addSubview:middle];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.isFromZoneList = NO;
        self.backgroundColor = bgColor();
        UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 19)];
        self.leftImgView = left;
        [self addSubview:left];
        
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(90, 1, 230, 19)];
        self.rightImgView = right;
        [self addSubview:right];
        
        UILabel *middle = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 70, 20)];
        middle.textColor = [UIColor blackColor];
        middle.font = [UIFont boldSystemFontOfSize:16.0f];
        middle.backgroundColor = [UIColor clearColor];// bgColor();
        self.middleLbl = middle;
        [self addSubview:middle];
    }
    return self;
}

+ (CGSize)getHeaderHeightWithText:(NSString*)_str {
    CGSize middleLblSize = [_str sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] constrainedToSize:CGSizeMake(190, 40) lineBreakMode:UILineBreakModeWordWrap];
    return middleLblSize;
}

- (void)initHeaderDataWithMiddleLblText:(NSString*)_str {
    self.middleLbl.text = _str;
    self.leftImgView.image = ThemeImage(@"left_bg");//short_title_bg
    self.rightImgView.image = ThemeImage(@"left_bg");
//    if (!_isFromZoneList) {
        [self.leftImgView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [self.rightImgView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//    }
    [self layoutSubviews];
}

//- (id)copyWithZone:(NSZone*)zone {
//    CellHeader *header = [[[self class] allocWithZone:zone] init];
////    header.leftImgView = [leftImgView copy];
////    header.rightBtn = [rightBtn copy];
////    header.rightImgView = [rightImgView copy];
////    header.middleLbl = [middleLbl copy];
//    header.leftImgView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:leftImgView]];
//    header.rightBtn = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:rightBtn]];
//    header.rightImgView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:rightImgView]];
//    header.middleLbl = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:middleLbl]];
//    return header;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self dropShadowWithOffset:CGSizeMake(0, -3) radius:10 color:bgColor() opacity:1 shadowFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 10)];
    
    if (self.middleLbl) {//左右为图片，中间为文字的情况
        self.middleLbl.numberOfLines = 0;
        CGSize middleLblSize = [CellHeader getHeaderHeightWithText:self.middleLbl.text]; //[self.middleLbl.text sizeWithFont:[UIFont boldSystemFontOfSize:15.0f] constrainedToSize:CGSizeMake(190, 40) lineBreakMode:UILineBreakModeWordWrap];
        
        self.middleLbl.frame = (CGRect){.origin.x = 18, .origin.y = 0, .size = middleLblSize};
        
        self.leftImgView.frame = (CGRect){.origin = CGPointZero, .size.width = self.leftImgView.frame.size.width, .size.height = self.frame.size.height};
        
        int rightImgViewX = self.middleLbl.frame.origin.x + self.middleLbl.frame.size.width + 10;
        self.rightImgView.frame = (CGRect){.origin.x = rightImgViewX, .origin.y = 0, .size.width = DEVICE_SIZE.width - rightImgViewX, .size.height = self.frame.size.height};
    }
    UIButton *delBtn = nil;
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            delBtn = (UIButton*)obj;
            break;
        }
    }
    if (delBtn) {
        delBtn.frame = (CGRect){.origin.x = DEVICE_SIZE.width - 80 + 10, .origin.y = 0, .size.width = 100, .size.height = self.frame.size.height};
    }
    if (self.rightBtn) {//空间页面的加号按钮
        self.rightBtn.frame = CGRectMake(140, 10, 170, 40);
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
