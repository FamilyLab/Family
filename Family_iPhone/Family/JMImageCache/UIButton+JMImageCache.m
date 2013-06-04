//
//  UIButton+JMImageCache.m
//  Family
//
//  Created by Aevitx on 13-3-16.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "UIButton+JMImageCache.h"
#import "JMImageCache.h"
#import <objc/runtime.h>

static char kJMImageURLObjectKey;

@interface UIButton (_JMImageCache)

@property (readwrite, nonatomic, retain, setter = jm_setImageURL:) NSURL *jm_imageURL;

@end

@implementation UIButton (_JMImageCache)

@dynamic jm_imageURL;

@end

@implementation UIButton (JMImageCache)

#pragma mark - Private Setters

- (NSURL *) jm_imageURL {
    return (NSURL *)objc_getAssociatedObject(self, &kJMImageURLObjectKey);
}
- (void) jm_setImageURL:(NSURL *)imageURL {
    objc_setAssociatedObject(self, &kJMImageURLObjectKey, imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public Methods

- (void) setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholder:nil];
}

- (void) setImageWithURL:(NSURL *)url placeholder:(UIImage *)placeholderImage {
    [self setImageWithURL:url key:nil placeholder:placeholderImage];
}

- (void) setImageWithURLByJM:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self setImageWithURL:url key:nil placeholder:placeholder];
}

- (void) setImageWithURL:(NSURL *)url key:(NSString*)key placeholder:(UIImage *)placeholderImage {
    self.jm_imageURL = url;
    
	UIImage *i;
    
    if (key) {
        i = [[JMImageCache sharedCache] cachedImageForKey:key];
    } else {
        i = [[JMImageCache sharedCache] cachedImageForURL:url];
    }
    
	if(i) {
        [self setImage:i forState:UIControlStateNormal];
        self.jm_imageURL = nil;
	} else {
        [self setImage:placeholderImage forState:UIControlStateNormal];
        
        __block UIButton *safeSelf = self;
        
        [[JMImageCache sharedCache] imageForURL:url key:key completionBlock:^(UIImage *image) {
            if ([url isEqual:safeSelf.jm_imageURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(image) {
                        [self setImage:image forState:UIControlStateNormal];
                    } else {
                        [self setImage:placeholderImage forState:UIControlStateNormal];
                    }
                    safeSelf.jm_imageURL = nil;
                });
            }
        }];
    }
}

///////////////////////////////////// 我自己的头像不缓存 By Aevit  /////////////////////////////////////////
- (void)setImageWithNoCacheWithURLByJM:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    if (placeholder) {
        [self setImage:placeholder forState:UIControlStateNormal];
    }
    if (MY_HEAD_AVATAR) {
        NSData *encodeHeadImgData = MY_HEAD_AVATAR;
        NSData *decodeHeadImgData = [NSKeyedUnarchiver unarchiveObjectWithData:encodeHeadImgData];
        UIImage *headImg = [UIImage imageWithData:decodeHeadImgData];
        [self setImage:headImg forState:UIControlStateNormal];
    }
//    } else {
        [NSThread detachNewThreadSelector:@selector(loadHeadImage:) toTarget:self withObject:url];
//    }
}

- (void)loadHeadImage:(NSURL*)_headUrl {
#if !__has_feature(objc_arc)
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
    NSData *headImgData = [NSData dataWithContentsOfURL:_headUrl];
    UIImage *headImg = [UIImage imageWithData:headImgData];
    if (headImg) {
        [self performSelectorOnMainThread:@selector(fillTheImage:) withObject:headImg waitUntilDone:NO];
    }
#if !__has_feature(objc_arc)
    [pool release];
#endif
}

- (void)fillTheImage:(UIImage*)_image {
    if (_image) {
        [self setImage:_image forState:UIControlStateNormal];
        NSData *myHeadImgData = UIImageJPEGRepresentation(_image, 0.8);
        NSData *encodeHeadImgData = [NSKeyedArchiver archivedDataWithRootObject:myHeadImgData];
        [[NSUserDefaults standardUserDefaults] setObject:encodeHeadImgData forKey:AVATAR];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

///////////////////////////////////// 我自己的头像不缓存 By Aevit  /////////////////////////////////////////

@end
