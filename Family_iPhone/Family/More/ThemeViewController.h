//
//  ThemeViewController.h
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "CellHeader.h"
#import "TopView.h"
#import "BottomView.h"

@interface ThemeViewController : BaseViewController <TopViewDelegate, BottomViewDelegate>

@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet CellHeader *cellHeader;
@property (nonatomic, strong) IBOutlet UIImageView *symbolImgView;

@end
