//
//  TopBarView.h
//  Family_pm
//
//  Created by shawjanfore on 13-3-27.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBarView : UIView

@property(nonatomic, retain) NSString *VConId;
@property(nonatomic, retain) NSString *rightGreenBgWidth;
@property(nonatomic, retain) UILabel *themeLbl;
@property(nonatomic, retain) UILabel *familyLbl;
@property(nonatomic, retain) UILabel *countPerLbl;

-(id) initWithConId:(NSString *) _VConId andTopBarFrame:(CGRect) _frame;
-(id) initWithConId:(NSString *)_VConId andTopBarFrame:(CGRect)_frame TheFrameWidth:(NSString *)_width;
@end
