//
//  IntroductionViewController.h
//  Family_pm
//
//  Created by shawjanfore on 13-5-12.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackBottomBarView.h"

typedef enum{
    aquirecoin        =0,
    vipintroduction   =1,
    aboutfamily       =2,
}WhichType;

@interface IntroductionViewController : UIViewController<BackBottomBarViewDelegate, UIScrollViewDelegate>
{
    BackBottomBarView *customBackBottomBarView;
}

@property(nonatomic, assign) WhichType whichType;
@property(nonatomic, retain) IBOutlet UIImageView *showImg;
@property(nonatomic, retain) IBOutlet UIScrollView *theScrollView;

@end
