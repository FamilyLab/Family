//
//  FlowLayoutLabel.m
//  family_ver_pm
//
//  Created by pandara on 13-4-16.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "FlowLayoutLabel.h"

@implementation FlowLayoutLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setMaxWidth:(int)smaxWidth maxLine:(int)smaxLine font:(UIFont *)sfont
{
    maxWidth = smaxWidth;
    self.font = sfont;
    self.numberOfLines = smaxLine;
}

- (CGSize)setTextContent:(NSString *)text
{
//    CGSize size;
//    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
//    
//    if ([osVersion characterAtIndex:0] == '6') {
//        size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByClipping];
//        
//        self.lineBreakMode = NSLineBreakByClipping | NSLineBreakByWordWrapping;
//    } else {
//        size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap | UILineBreakModeClip];
//        
//        self.lineBreakMode = UILineBreakModeClip | UILineBreakModeWordWrap;
//    }
//
//    CGRect originFrame = self.frame;
//    self.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, size.width, size.height);
//    [super setText:text];
//    [self sizeToFit];
    //ios6
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    self.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByClipping;
    self.text = text;
    
    if ([osVersion characterAtIndex:0] == '6') {
        CGRect originFrame = self.frame;
        self.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, maxWidth, 200);
        [self sizeToFit];
    } else {
        if (self.numberOfLines != 0) {
            CGSize flowSize = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByClipping ];
            CGSize sampleSize;
            
            //取自适应label的高度
            NSString *sampleString = @"";
            for (int i = 0; i < self.numberOfLines; i++) {
                sampleString = [NSString stringWithFormat:@"%@a", sampleString];
            }

            sampleSize = [sampleString sizeWithFont:self.font constrainedToSize:CGSizeMake(TITLE_FONT_SIZE, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping | NSLineBreakByClipping];
            
            self.numberOfLines = 0;
            //高度取实际高度与最大高度的较小者
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, flowSize.width, sampleSize.height < flowSize.height? sampleSize.height:flowSize.height);
        } else {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxWidth, 10);
            [self sizeToFit];
        }
    }
    
    return self.frame.size;
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
