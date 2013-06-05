//
//  UILabel+VerticalAlign.m
//  Family
//
//  Created by Aevitx on 13-3-14.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int theNewLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<theNewLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int theNewLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<theNewLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

@end
