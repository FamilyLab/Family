//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationController : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic,assign) BOOL canDragBack;

@end
