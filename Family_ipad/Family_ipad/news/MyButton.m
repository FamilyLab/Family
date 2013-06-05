//
//  MyButton.m
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MyButton.h"
#import "AppDelegate.h"
#import "StackScrollViewController.h"
#import "RootViewController.h"
#import "KGModal.h"
#import "FamilyCardViewController.h"
#import "ZoneWaterFallView.h"
#import "UIButton+JMImageCache.h"
@implementation MyButton
//@synthesize imageNameStr, labelStr, labelX;
@synthesize v_logo;
- (NSURL *)headImgURLWith:(HEAD_SIZE)size
                   url:(NSString *)url
{
    NSRange range = [url rangeOfString:@"_small.jpg"];
    if (range.location==NSNotFound) {
        return [NSURL URLWithString:url];
    }
    if (size == MIDDLE)
        return [NSURL URLWithString:[url stringByReplacingCharactersInRange:range withString:@"_middle.jpg"]];
    else if (size == BIG){
        NSString *bigHeadURL = [url stringByReplacingCharactersInRange:range withString:@"_big.jpg"];
        return [NSURL URLWithString:bigHeadURL];
    }
    return [NSURL URLWithString:url];
        
}
- (void)doSomeThing:(UIButton *)sender
{
    if ([_identify isEqual:@" "]||_identify == nil) {
        return;
    }
    if (_type == HEAD_BTN) {
        REMOVEDETAIL;
        FamilyCardViewController *detailViewController = [[FamilyCardViewController alloc] initWithNibName:@"FamilyCardViewController" bundle:nil];
        detailViewController.userId = _identify;
        [[AppDelegate instance].rootViewController.stackScrollViewController addViewInSlider:detailViewController invokeByController:[AppDelegate instance].rootViewController isStackStartView:FALSE];
        [detailViewController sendRequestWith:_identify];
    }
    else if (_type == ZONE_BTN)
    {
        ZoneWaterFallView *view = [[ZoneWaterFallView alloc]initWithFrame:CGRectMake(0, 0, 1024-100, 768)];
        view.tagID = _identify;
        view.userid = _extraInfo;
        view.contentType = ZONE_TYPE;
        [view refreshTable:$int(ZONE_TYPE)];
        [[KGModal sharedInstance] showWithContentView:view andAnimated:YES];

    }
    else
        return;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(doSomeThing:) forControlEvents:UIControlEventTouchUpInside];
        //[self setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    return self;
}


- (void)setVipStatusWithStr:(NSString*)vipStatus isSmallHead:(BOOL)isSmallHead {
    //CGFloat vipWidth = isSmallHead ? 10 : 15;
    if (!v_logo) {
        v_logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_v_m.png"]];
        if (isSmallHead) 
            v_logo.frame = CGRectMake(self.frame.size.width-v_logo.frame.size.width/2, self.frame.size.height-v_logo.frame.size.height/2, v_logo.frame.size.width/2, v_logo.frame.size.height/2);
        else
            v_logo.frame = CGRectMake(self.frame.size.width-v_logo.frame.size.width, self.frame.size.height-v_logo.frame.size.height, v_logo.frame.size.width, v_logo.frame.size.height);
        [self addSubview:v_logo];
        v_logo.hidden = YES;
    }
    if ([vipStatus isEqualToString:@"personal"]) {
       // v_logo.image = [UIImage imageNamed:@"personal_v_red.png"];
        v_logo.hidden = NO;
    } else if ([vipStatus isEqualToString:@"family"]) {
        v_logo.image = [UIImage imageNamed:@"blue_v_m.png"];
        v_logo.hidden = NO;
    } else {
        v_logo.hidden = YES;
    }
}
- (void)setImageForMyHeadButtonWithUrlStr:(NSString*)urlStr
                       plcaholderImageStr:(NSString*)placeholderImageStr
                                     size:(HEAD_SIZE)size{
    CALayer *layer = self.layer;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.borderWidth = 1.0f;
    placeholderImageStr = placeholderImageStr ? placeholderImageStr : @"head_220.png";
    NSURL *url = [self headImgURLWith:size url:urlStr];
    [self setImageWithURL:url  placeholder:[UIImage imageNamed:placeholderImageStr]];

   
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
