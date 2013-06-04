//
//  WeatherPopUpView.m
//  family_ver_pm
//
//  Created by pandara on 13-5-13.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "WeatherPopUpView.h"
#import "FlowLayoutLabel.h"

@implementation WeatherPopUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeatherPopUpView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
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

- (void)setSuggestionContent:(NSString *)content
{
    FlowLayoutLabel *suggestionContent = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    suggestionContent.textColor = [UIColor whiteColor];
    [suggestionContent setMaxWidth:self.frame.size.width maxLine:0 font:[UIFont systemFontOfSize:24]];
    [suggestionContent setTextContent:content];
    [self.scrollView addSubview:suggestionContent];
    [self.scrollView setContentSize:CGSizeMake(suggestionContent.frame.size.width, suggestionContent.frame.size.height)];
}

@end
