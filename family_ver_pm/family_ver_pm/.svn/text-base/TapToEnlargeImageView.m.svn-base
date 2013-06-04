//
//  TapToEnlargeImageView.m
//  family_ver_pm
//
//  Created by pandara on 13-4-12.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "TapToEnlargeImageView.h"
#import "EnlargeImageBottomBar.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SVProgressHUD.h"

@implementation TapToEnlargeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImage)];
        [self addGestureRecognizer:tapGesture];
        
        self.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.activityView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.activityView];
        [self.activityView startAnimating];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)enlargeImage
{
    //config enlargeView
    self.enlargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    self.enlargeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.enlargeView.alpha = 0;
    
    //config enlargeImageView
    self.enlargeImageView = [[PinchImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    self.enlargeImageView.imageView.image = self.image;
    self.enlargeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.enlargeImageView.alpha = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeEnlargedImage)];
    self.enlargeImageView.userInteractionEnabled = YES;
    [self.enlargeImageView addGestureRecognizer:tapGesture];
    [self.enlargeView addSubview:self.enlargeImageView];
    
    //config enlargeBottomView
    EnlargeImageBottomBar *enlargeViewBottomBar = [[[NSBundle mainBundle] loadNibNamed:@"EnlargeImageBottomBar" owner:self options:nil] objectAtIndex:0];
    enlargeViewBottomBar.frame = CGRectMake(0, DEVICE_SIZE.height - ENLARGE_VIEW_BOTTOM_VIEW_SIZE.height, ENLARGE_VIEW_BOTTOM_VIEW_SIZE.width, ENLARGE_VIEW_BOTTOM_VIEW_SIZE.height);
    enlargeViewBottomBar.delegate = self;
    [self.enlargeView addSubview:enlargeViewBottomBar];
    
    [self.delegate addEnlargeImageView:self.enlargeView];
}

- (void)closeEnlargedImage
{
    [UIView animateWithDuration:0.3f animations:^{self.enlargeImageView.alpha = 0;self.enlargeView.alpha = 0;} completion:^(BOOL finished) {
        if (finished) {
            [self.enlargeView removeFromSuperview];
        }
    }];
}

- (void)stopActivityView
{
    [self.activityView stopAnimating];
}

- (void)downloadEnlargedImage
{
    ALAssetsLibrary *assetslibary = [[ALAssetsLibrary alloc] init];
    [assetslibary writeImageToSavedPhotosAlbum:[self.enlargeImageView.imageView.image CGImage] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error == nil) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error]];
            NSLog(@"保存图片错误：%@", error);
        }
    }];
}

- (void)rePostEnlargedImage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_REPOST_IAMGE object:nil];
}

@end
