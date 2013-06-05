//
//  UIButton+JMImageCache.h
//  Family
//
//  Created by Aevitx on 13-3-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JMImageCache)

- (void) setImageWithURLByJM:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void) setImageWithURL:(NSURL *)url;
- (void) setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholderImage;
- (void) setImageWithURL:(NSURL *)url key:(NSString*)key placeholder:(UIImage *)placeholderImage;

- (void)setImageWithNoCacheWithURLByJM:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
