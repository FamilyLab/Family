//
//  HorizontalTableView.h
//  family_ver_pm
//
//  Created by pandara on 13-3-21.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalTableView : UITableView

- (NSIndexPath *)prevPage:(NSIndexPath *)indexPath;
- (BOOL)nextPage:(NSIndexPath *)indexPath withTotalPage:(NSInteger)pageCount;

@end
