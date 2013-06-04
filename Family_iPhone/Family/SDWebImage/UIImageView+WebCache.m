/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

#define kSDWebImageProgressView 10086

//static const char *exptecedLengthKey = "exptecedLengthKey";
//static const char *currentLengthKey = "currentLengthKey";

@implementation UIImageView (WebCache)
//@dynamic expectedLength, currentLength;

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    placeholder = [UIImage imageNamed:@"pic_default.png"];
    if ((self.frame.size.width >= placeholder.size.width && self.frame.size.height >= placeholder.size.height) || self.frame.size.width == 0 || self.frame.size.height == 0) {
        [self setContentMode:UIViewContentModeCenter];
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

//for progressview By Aevit
- (void)setImageWithProgressViewWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:SDWebImageProgressiveDownload];
}

//for progressview By Aevit
- (void)updateProgressView:(NSNumber *)progress {
	if ([progress floatValue] < 1) {
        MBProgressHUD *hud = nil;
        if ([self viewWithTag:kSDWebImageProgressView] == nil) {
//            hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud = [[MBProgressHUD alloc] initWithView:self];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.delegate = self;
            hud.tag = kSDWebImageProgressView;
            [self addSubview:hud];
        } else {
            hud = (MBProgressHUD*)[self viewWithTag:kSDWebImageProgressView];
        }
        [hud show:YES];
        hud.labelText = [NSString stringWithFormat:@"%.2f%@", [progress floatValue] * 100, @"%"];
        hud.progress = [progress floatValue];
    } else {
        MBProgressHUD *hud = (MBProgressHUD*)[self viewWithTag:kSDWebImageProgressView];
        [hud hide:YES];
    }
    
//		UIProgressView *prg = nil;
//		if ([self viewWithTag:kSDWebImageProgressView] == nil) {
//			CGRect r = CGRectMake(10, (self.frame.size.height / 2) - 10, self.frame.size.width - 20, 30);
//			prg = [[UIProgressView alloc] initWithFrame:r];
//			prg.tag = kSDWebImageProgressView;
//			prg.progressViewStyle = UIProgressViewStyleDefault;
//			
//			[self addSubview:prg];
//#if __has_attribute(objc_arc)
//			[prg release];
//#endif
//		} else {
//			prg = (UIProgressView *)[self viewWithTag:kSDWebImageProgressView];
//		}
//		[prg setHidden:NO];
//		[prg setProgress:[progress floatValue]];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[hud removeFromSuperview];
#if __has_attribute(objc_arc)
	[hud release];
#endif
	hud = nil;
}

//#pragma mark - category 加变量
//- (void)setExpectedLength:(NSNumber*)expectedLength_ {
//     objc_setAssociatedObject(self, exptecedLengthKey, expectedLength_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSNumber*)expectedLength {
//    return (NSNumber *)objc_getAssociatedObject(self, exptecedLengthKey);
//}
//
//- (void)setCurrentLength:(NSNumber *)currentLength_ {
//    objc_setAssociatedObject(self, currentLengthKey, currentLength_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSNumber*)currentLength {
//    return (NSNumber *)objc_getAssociatedObject(self, currentLengthKey);
//}

#pragma mark - By Aevit 这里是可以更改placeholder的地方，上面的那函数写死了placeholder为pic_defaulut.png，因为懒得去改其他地方，所以再增加这两个函数。。。
- (void)setImageForAevitWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageForAevitWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageForAevitWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
//    self.image = image;
//    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    [self setContentMode:UIViewContentModeScaleToFill];
    [self setNeedsLayout];
}

@end
