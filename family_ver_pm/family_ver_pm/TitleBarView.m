//
//  TitleBarView.m
//  family_ver_pm
//
//  Created by pandara on 13-3-25.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "TitleBarView.h"
#import "FlowLayoutLabel.h"

@implementation TitleBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"TitleBarView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        //config titlelabel
        self.titleLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(TITLELABLE_ORIGIN.x, TITLELABLE_ORIGIN.y, TITLELABLE_DEFAULT_SIZE.width + TITLE_LABEL_PADDING * 2, 37)];
        self.titleLabelContainer.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(0, 0, TITLELABLE_DEFAULT_SIZE.width, TITLELABLE_DEFAULT_SIZE.height)];
        self.titleLabel.center = CGPointMake(self.titleLabelContainer.frame.size.width / 2, self.titleLabelContainer.frame.size.height / 2);
//        [self.titleLabel setMaxWidth:TITLE_TEXT_MAX_WIDTH maxLine:2 font:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
        [self.titleLabelContainer addSubview:self.titleLabel];
        [self addSubview:self.titleLabelContainer];
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
- (void)setTitleLabelMaxWidth:(int)smaxWidth maxLine:(int)smaxLine font:(UIFont *)sfont
{
    [self.titleLabel setMaxWidth:smaxWidth maxLine:smaxLine font:sfont];
}

- (void)setTitle:(NSString *)titleText
{
    titleText = [titleText isEqualToString:@""]? @"无标题":titleText;
    CGSize labelSize = [self.titleLabel setTextContent:titleText];
    CGRect rect = self.titleLabelContainer.frame;
    self.titleLabelContainer.frame = CGRectMake(rect.origin.x, rect.origin.y, labelSize.width + 2 * TITLE_LABEL_PADDING, labelSize.height);
    
    rect = self.titleBackground.frame;
    self.titleBackground.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, labelSize.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.titleBackground.frame.origin.y + self.titleBackground.frame.size.height);
}

- (void)setAuthor:(NSString *)authorName
{
    self.authorLable.text = authorName;
}

- (void)setDate:(NSString *)dateString
{
    self.dateLable.text = dateString;
}

@end








