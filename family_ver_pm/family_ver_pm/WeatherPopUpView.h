//
//  WeatherPopUpView.h
//  family_ver_pm
//
//  Created by pandara on 13-5-13.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherPopUpView : UIView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *button;

- (void)setSuggestionContent:(NSString *)content;

@end
