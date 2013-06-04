//
//  MainViewController.h
//  family_ver_pm
//
//  Created by pandara on 13-3-18.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView * mainTableView;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) WeatherView *weatherView;
@property (strong, nonatomic) NSMutableDictionary *feedCountDict;
@property (strong, nonatomic) NSArray *viewControllName;

- (void)reflesh;
- (void)requestFeedCount;

@end
