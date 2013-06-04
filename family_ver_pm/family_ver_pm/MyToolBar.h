//
//  MyToolBar.h
//  family_ver_pm
//
//  Created by pandara on 13-5-30.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyToolBarDelegate.h"

@interface MyToolBar : UIToolbar

@property (strong, nonatomic) IBOutlet UIBarItem *finishBtn;
@property (strong, nonatomic) id<MyToolBarDelegate> delegateInMyToolBar;

@end
