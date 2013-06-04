//
//  EnlargeImageBottomBarDelegate.h
//  family_ver_pm
//
//  Created by pandara on 13-4-14.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EnlargeImageBottomBarDelegate <NSObject>

@required
- (void)closeEnlargedImage;
- (void)rePostEnlargedImage;
- (void)downloadEnlargedImage;

@end
