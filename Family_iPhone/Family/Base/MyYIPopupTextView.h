//
//  MyYIPopupTextView.h
//  Family
//
//  Created by Aevitx on 13-6-19.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "YIPopupTextView.h"

@interface MyYIPopupTextView : YIPopupTextView <YIPopupTextViewDelegate>

- (id)initWithMaxCount:(NSUInteger)maxCount;
- (id)initWithMaxCount:(NSUInteger)maxCount placeHolger:(NSString*)placeHolderStr;
- (id)initWithMaxCount:(NSUInteger)maxCount placeHolger:(NSString*)placeHolderStr textViewSize:(CGSize)textViewSize textViewInsets:(UIEdgeInsets)textViewInsets;

@end
