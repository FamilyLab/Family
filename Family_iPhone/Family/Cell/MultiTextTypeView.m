//
//  MultiTextTypeView.m
//  Family
//
//  Created by Aevitx on 13-1-20.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MultiTextTypeView.h"
#import "Common.h"
#import "MultiText.h"
//#import "UIButton+WebCache.h"
#import "FamilyCardViewController.h"
#import "AppDelegate.h"

@implementation MultiTextTypeView
@synthesize bgImgView, headImgView, headBtn, contentLbl, timeView, imgView;
@synthesize nameLbl, theNewsNumView, timeLbl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        self.contentLbl.textColor = color(111, 111, 111, 1);
        self.contentLbl.extendBottomToFit = YES;//自适应高度
//        [headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        self.contentLbl.textColor = color(111, 111, 111, 1);
        self.contentLbl.extendBottomToFit = YES;//自适应高度
//        [headBtn addTarget:self action:@selector(headBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (IBAction)headBtnPressed:(id)sender {
    FamilyCardViewController *con = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
    con.isMyFamily = YES;
    con.userId = _userId;
    //    pushACon(con);
    pushAConInView(self, con);
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate pushAController:con];
}

//- (void)initData:(MultiText*)model {
//    [self.headBtn setImageWithURL:[NSURL URLWithString:model.head] placeholderImage:[UIImage imageNamed:@"head_70.png"]];
//}

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
//    self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
    //    self.contentLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
    [attrStr release];
#endif
}

- (void)fillMultiTypeNameColorWithStr:(NSString*)_text,... {
    if (_text) {
        va_list list;
        id arg;
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
//            self.contentLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
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
    CGFloat theSize = _isNickName ? 15 : 13;
    [attrStr setFontFamily:@"helvetica" size:theSize bold:YES italic:NO range:theRange];
	
	/**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
	pointLbl.attributedText = attrStr;
//	pointLbl.automaticallyAddLinksForType = NSTextCheckingTypeDate|NSTextCheckingTypeAddress|NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
//    pointLbl.centerVertically = YES;
    
#if ! __has_feature(objc_arc)
	[attrStr release];
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //拉伸背景图片
    self.bgImgView.image = [self.bgImgView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    //contentLbl的高度
    self.contentLbl.numberOfLines = 0;
    
    _contentStr = _contentStr ? _contentStr : self.contentLbl.text;
//    UIFont *theFont = _contentStr ? [UIFont boldSystemFontOfSize:15.0f] : self.contentLbl.font;
    CGFloat contentWidth = self.rightImgView ? 192 : 235;//有rightImgView的是右边有图片的行为动态类型
    CGFloat otherHeight = self.timeView ? 0 : 10;//行为动态的类型
    CGSize contentSize = [_contentStr sizeWithFont:self.contentLbl.font constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    self.contentLbl.frame = (CGRect){.origin = self.contentLbl.frame.origin, .size.width = contentSize.width, .size.height = contentSize.height + otherHeight};
    
//    CGSize contentSize = [self.contentLbl.text sizeWithFont:self.contentLbl.font constrainedToSize:CGSizeMake(240.0f, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//    self.contentLbl.frame = (CGRect){.origin = self.contentLbl.frame.origin, .size.width = contentSize.width, .size.height = contentSize.height + 10};
    //未读的标志图片
    if (self.theNewsNumView) {//对话列表
        self.theNewsNumView.frame = (CGRect){.origin.x = self.theNewsNumView.frame.origin.x, .origin.y = self.frame.origin.y + self.frame.size.height - self.theNewsNumView.leftImgView.frame.size.height - 5, .size = self.theNewsNumView.frame.size};

        self.timeLbl.textAlignment = UITextAlignmentRight;
        CGSize timeSize = [self.timeLbl.text sizeWithFont:self.timeLbl.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        self.timeLbl.frame = (CGRect){.origin.x = self.frame.size.width - 10 * 2 - timeSize.width, .origin.y = self.timeLbl.frame.origin.y, .size = timeSize};
    }
    if (self.imgView) {//通知列表
        self.imgView.frame = (CGRect){.origin.x = self.imgView.frame.origin.x, .origin.y = self.frame.origin.y + self.frame.size.height - self.imgView.frame.size.height - 6, .size = self.imgView.frame.size};
        self.timeLbl.frame = (CGRect){.origin.x = timeLbl.frame.origin.x, .origin.y = contentLbl.frame.origin.y + contentLbl.frame.size.height - 5, .size = timeLbl.frame.size};
    }
    if (self.rightImgView) {//动态列表里行为类型，右边有图片的行为类型
        self.rightImgView.frame = (CGRect){.origin.x = self.rightImgView.frame.origin.x, .origin.y =(self.frame.size.height - self.rightImgView.frame.size.height ) / 2, .size = self.rightImgView.frame.size};
    }
//    if (self.timeView) {//在行为动态里的layoutsubview设置frame了
//        self.timeView.frame = (CGRect){.origin.x = timeView.frame.origin.x, .origin.y = contentLbl.frame.origin.y + contentLbl.frame.size.height - 3, .size = timeView.frame.size};
//    }
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
//    NSString *subthroung = placemark.subThoroughfare;
//    NSString *local = placemark.locality;
//    NSLog(@"来自城市:%@-%@", local, subthroung);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    NSLog(@"map error:%@", [error description]);
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
