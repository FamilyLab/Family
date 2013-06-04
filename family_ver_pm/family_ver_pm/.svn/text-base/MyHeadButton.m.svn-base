//
//  MyHeadButton.m
//  Family_pm
//
//  Created by shawjanfore on 13-4-25.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "MyHeadButton.h"
#import "UIButton+JMImageCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyHeadButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 1.0f;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CALayer *layer = self.layer;
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 1.0f;
    }
    return self;
}

-(void)setImageForMyHeadButtonWithUrlStr:(NSString *)urlStr placeholderImageStr:(NSString *)placeholderImageStr
{
    NSString *placeholderImage = placeholderImageStr.length != 0 ? placeholderImageStr : @"head_220.png";
    //NSString *placeholderImage = @"head_220.png";
    NSString *tempStr1 = [urlStr copy];
    tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"small" withString:@""];
    tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"middle" withString:@""];
    tempStr1 = [tempStr1 stringByReplacingOccurrencesOfString:@"big" withString:@""];
    
    NSString *tempStr2 = [MY_HEAD_AVATAR_URL copy];
    tempStr2 = [tempStr2 stringByReplacingOccurrencesOfString:@"small" withString:@""];
    tempStr2 = [tempStr2 stringByReplacingOccurrencesOfString:@"middle" withString:@""];
    tempStr2 = [tempStr2 stringByReplacingOccurrencesOfString:@"big" withString:@""];
    
    if ([tempStr1 isEqualToString:tempStr2]) {
        [self setImageWithNoCacheWithURLByJM:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImage]];
    }else{
        [self setImageWithURLByJM:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeholderImage]];
    }
    //[tempStr1 release],[tempStr2 release];
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
