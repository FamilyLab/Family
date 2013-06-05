//
//  AboutViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-4-3.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    vip_image,
    money_image,
    about_image
} ImageType;
@interface AboutViewController : UIViewController
@property (nonatomic,strong)IBOutlet UIScrollView *scrollerView;
@property (nonatomic,strong)IBOutlet UIImageView *imageView;
@property (nonatomic,assign)ImageType type;
@end
