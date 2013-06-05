//
//  PostBaseViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-1-8.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
@class PostBaseView;
@interface PostBaseViewController : UIViewController<CLLocationManagerDelegate>
{
}
@property (nonatomic,strong)IBOutlet PostBaseView *postView;
@end
