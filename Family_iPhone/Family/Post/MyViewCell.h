//
//  MyViewCell.h
//  Family
//
//  Created by Aevitx on 13-3-5.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedButton.h"

@interface MyViewCell : UIView

@property (nonatomic, strong) UIButton *button;
//@property (nonatomic, strong) UIButton *delBtn;   

@property (nonatomic, strong) SelectedButton *selcetBtn;
@end
