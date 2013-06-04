//
//  FamilyListCell.h
//  Family
//
//  Created by Aevitx on 13-1-24.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "CommonCell.h"

@interface FamilyListCell : CommonCell {
}

+ (CGFloat)heightForCellWithText:(NSString *)text andOtherHeight:(CGFloat)_miniHeight;
- (void)initTaskData:(NSDictionary*)aDict;

- (void)initFamilyListForSelect:(NSDictionary*)_aDict;

@end
