//
//  MySearchBar.h
//  Family
//
//  Created by Aevitx on 13-1-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySearchBar : UISearchBar {
    BOOL isSearchBtnPressed;
}

- (void)buildMySearchBarWithImgStr:(NSString*)_imgStr;


@end
