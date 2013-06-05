//
//  PhotoViewController.h
//  Family_ipad
//
//  Created by walt.chan on 13-3-5.
//  Copyright (c) 2013年 walt.chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
{
    UIImageView *imageView;
    CGFloat minScale;
    CGFloat maxScale;

}
@property (nonatomic,strong)IBOutlet UIView *toolBarView;
@end
