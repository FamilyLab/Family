//
//  MultiTextTypeView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MultiTextTypeView.h"
#import "Common.h"
#import "CKMacros.h"
#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@implementation MultiTextTypeView
@synthesize bgImgView, headImgView, headBtn, contentLbl, timeView, imgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        self.contentLbl.textColor = color(111, 111, 111, 1);
        self.contentLbl.extendBottomToFit = YES;//自适应高度
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
//名字根据主题变色，msgStr为红色，otherStr为默认灰色
- (NSMutableAttributedString*)fillMultiTypeWithStr:(NSMutableArray*)nameArray inText:(NSString*)aText withColor:(UIColor*)aColor withSize:(CGFloat)aSize isBold:(BOOL)isBold msgStr:(NSString*)msgStr otherStr:(NSMutableArray*)otherStrArray {
    /**(1)** Build the NSAttributedString *******/
    NSMutableAttributedString* attrStr = [self.contentLbl.attributedText mutableCopy];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    CGFloat theSize = aSize ? aSize : 15.0f;
    BOOL theBold = isBold ? isBold : YES;
    
   // NSString *tmpStr = self.contentLbl.text;//若前后的名字有相同的，防止只匹配到前面，而后面的就不匹配到了。解决方法是每一个名字变色后，都把该名字从aText里去掉（用tmpStr保存）,记得range需要变化
    for (int i = 0; i < [nameArray count]; i++) {
        NSRange theRange = [self.contentLbl.text rangeOfString:[nameArray objectAtIndex:i]];
        UIColor *theColor = aColor ? aColor : [Common theLblColor];
        [attrStr setTextColor:theColor range:theRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:theRange];
        //tmpStr = [tmpStr stringByReplacingCharactersInRange:currRange withString:@""];//currRange
    }
    
    //不需要变色的文字
    for (int i = 0; i < [otherStrArray count]; i++) {
        NSRange otherRange = [self.contentLbl.text rangeOfString:[otherStrArray objectAtIndex:i]];
        [attrStr setTextColor:[UIColor lightGrayColor] range:otherRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:otherRange];
    }
    //    NSString *otherStr = [aText stringByReplacingOccurrencesOfString:aStr withString:@""];
    //    NSMutableAttributedString *otherAttrStr = [NSMutableAttributedString attributedStringWithString:otherStr];
    //    NSRange otherRange = [aText rangeOfString:otherStr];
    //    [attrStr setTextColor:[UIColor darkGrayColor] range:otherRange];
    //    [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:otherRange];
    
    //红色
    if (!isEmptyStr(msgStr)) {
        NSRange theRange = [self.contentLbl.text rangeOfString:msgStr];
        UIColor *theColor = color(229, 113, 116, 1);
        [attrStr setTextColor:theColor range:theRange];
        [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:theRange];
    }
    
    /**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
        self.contentLbl.attributedText = attrStr;
        self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    self.contentLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
    [attrStr release];
#endif
    return attrStr;
}


- (void)fillColorWithStr:(NSString*)aStr withColor:(UIColor*)aColor {
    /**(1)** Build the NSAttributedString *******/
    NSMutableAttributedString* attrStr = [self.contentLbl.attributedText mutableCopy];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    NSRange theRange = [self.contentLbl.text rangeOfString:aStr];
    
    [attrStr setTextColor:aColor range:theRange];
    
    /**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
    self.contentLbl.attributedText = attrStr;
    self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    self.nameLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
    [attrStr release];
#endif
}
- (void)fillMultiTypeWithStr:(NSString*)aStr withColor:(UIColor*)aColor withSize:(CGFloat)aSize isBold:(BOOL)isBold {
    /**(1)** Build the NSAttributedString *******/
    NSMutableAttributedString* attrStr = [self.contentLbl.attributedText mutableCopy];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    NSRange theRange = [self.contentLbl.text rangeOfString:aStr];
    UIColor *theColor = aColor ? aColor : [Common theLblColor];
    CGFloat theSize = aSize ? aSize : 14.0f;
    BOOL theBold = isBold ? isBold : YES;
    [attrStr setTextColor:theColor range:theRange];
    [attrStr setFontFamily:@"helvetica" size:theSize bold:theBold italic:NO range:theRange];
    
    /**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
    self.contentLbl.attributedText = attrStr;
    self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    self.nameLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
    [attrStr release];
#endif
}

- (void)fillMultiTypeNameColorWithStr:(NSString*)_text,... {
    va_list list;
    id arg;
    while (_text) {
        va_start(list, _text);
        while ((arg = va_arg(list, id))) {
            /**(1)** Build the NSAttributedString *******/
            NSMutableAttributedString* attrStr = [self.contentLbl.attributedText mutableCopy];
            
            // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
            [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
                paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
                paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
                paragraphStyle.paragraphSpacing = 8.f;
                paragraphStyle.lineSpacing = 3.f;
            }];
            //昵称部分根据主题变色
            NSRange theRange = [self.contentLbl.text rangeOfString:_text];
            [attrStr setTextColor:[Common theLblColor] range:theRange];
            [attrStr setFontFamily:@"helvetica" size:15 bold:YES italic:NO range:theRange];
            
            /**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
            self.contentLbl.attributedText = attrStr;
            self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
            //    self.nameLbl.centerVertically = YES;
            
#if ! __has_feature(objc_arc)
            [attrStr release];
#endif
        }
        va_end(list);
    }
}

//给“对话”列表用的
- (void)fillLblWithStr:(NSString*)_text isNickName:(BOOL)_isNickName {
	/**(1)** Build the NSAttributedString *******/
    OHAttributedLabel *pointLbl = _isNickName ? self.nameLbl : self.contentLbl;
	NSMutableAttributedString* attrStr = [pointLbl.attributedText mutableCopy];
    
    // Change the paragraph attributes, like textAlignment, lineBreakMode and paragraph spacing
    [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
        paragraphStyle.textAlignment = kCTLeftTextAlignment;// kCTCenterTextAlignment;
        paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
        paragraphStyle.paragraphSpacing = 8.f;
        paragraphStyle.lineSpacing = 3.f;
    }];
    //昵称部分根据主题变色
    NSRange theRange = [pointLbl.text rangeOfString:_text];
    UIColor *theColor = _isNickName ? [Common theLblColor] : [UIColor lightGrayColor];
	[attrStr setTextColor:theColor range:theRange];
    CGFloat theSize = _isNickName ? 17 : 15;
    [attrStr setFontFamily:@"helvetica" size:theSize bold:YES italic:NO range:theRange];
	
	/**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
	pointLbl.attributedText = attrStr;
	pointLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    pointLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
	[attrStr release];
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //拉伸背景图片
    self.bgImgView.image = [self.bgImgView.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    //contentLbl的高度
    self.contentLbl.numberOfLines = 0;
    CGSize contentSize = [self.contentLbl.text sizeWithFont:self.contentLbl.font constrainedToSize:CGSizeMake(305.0f, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    self.contentLbl.frame = (CGRect){.origin = self.contentLbl.frame.origin, .size.width = contentSize.width, .size.height = contentSize.height + 10};
    //未读的标志图片
    if (self.theNewsNumView) {//对话列表
        self.theNewsNumView.frame = (CGRect){.origin.x = self.theNewsNumView.frame.origin.x, .origin.y = self.frame.origin.y + self.frame.size.height - self.theNewsNumView.leftImgView.frame.size.height - 6, .size = self.theNewsNumView.frame.size};
    }
    if (self.imgView) {//通知列表
        self.imgView.frame = (CGRect){.origin.x = self.imgView.frame.origin.x, .origin.y = self.frame.origin.y + self.frame.size.height - self.imgView.frame.size.height - 13, .size = self.imgView.frame.size};
       // self.timeLbl.frame = (CGRect){.origin.x = self.timeLbl.frame.origin.x, .origin.y = contentLbl.frame.origin.y + contentLbl.frame.size.height - 5, .size = self.timeLbl.frame.size};
    }
}

//根据经纬度得到地区
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude {
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    geoCoder.delegate = self;
    if (!geoCoder.querying) {
        [geoCoder start];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSString *subthroung = placemark.subThoroughfare;
    NSString *local = placemark.locality;
    NSLog(@"来自城市:%@-%@", local, subthroung);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"map error:%@", [error description]);
}
@end
