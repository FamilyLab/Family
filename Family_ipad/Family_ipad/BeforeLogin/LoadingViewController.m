//
//  LoadingViewController.m
//  Family
//
//  Created by apple on 12-12-22.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "LoadingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WaterFallViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
@interface LoadingViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *loadingImgView;



@end

@implementation LoadingViewController

@synthesize loadingImgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(loadingAnimation) withObject:nil afterDelay:1.5f];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [self sendRequestToGetAd];
   
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)loadingAnimation {
   
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI];
    rotationAnimation.duration = 0.5f;
//    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.repeatCount = 3;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [rotationAnimation setValue:@"rotationAnimation"forKey:@"MyAnimationType"];
    [loadingImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self performSelector:@selector(autoLogin) withObject:nil afterDelay:1.5f];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskLandscape;
}

//动画结束后，将view设定到正确位置
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if (flag) {
//        NSString *value = [anim valueForKey:@"MyAnimationType"];
//
//        if ([value isEqualToString:@"rotationAnimation"]) {
//            uiView.transform = CGAffineTransformMakeRotation(0.5*M_PI);
//        }
//    }
//}

- (void)removeTheLoadingView {

//    [UIView beginAnimations:@"Curl"context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//
//    [UIView setAnimationDuration:1.0f];
//    LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:con animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
//   
//    [UIView commitAnimations];
}

- (void)tmp {
    [self removeTheLoadingView];
}

- (void)sendRequestToGetAd {
    [self performSelector:@selector(tmp) withObject:nil afterDelay:1.5f];
    //下面是网络加载广告图片的代码
//    NSString *url = [NSString stringWithFormat:@"%@info.php?ac=ad", BASE_URL];
//    NSLog(@"get ad url:%@", url);
//    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
//    [[AFJSONRequestOperation JSONRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"json:%@", JSON);
//        if ([[JSON objectForKey:WEB_ERROR] intValue] != 0) {
//            NSLog(@"load error:%@", [JSON objectForKey:WEB_MSG]);
//            return ;
//        }
//        [adImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[JSON objectForKey:WEB_DATA] objectForKey:AD_IMAGESRC]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//            [self removeTheLoadingView];
//        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//            NSLog(@"load img error:%@", [error description]);
//        }];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"error:%@", [error description]);
//    }] start];
}

#pragma mark IBAction(s)
//- (IBAction)joinBtnPressed:(id)sender {
//    //未登录时
//    LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:con animated:YES];
//}

- (IBAction)skipBtnPressed:(id)sender {
//    //未登录
//    LoginViewController *con = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:con animated:YES];
    //已登录
    [self.navigationController dismissModalViewControllerAnimated:YES];
}





- (void)autoLogin{
    if (MY_HAS_LOGIN) {
        
        self.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController dismissModalViewControllerAnimated:YES];
        [[AppDelegate instance]setUpRootView];

    }else{
       
        [UIView beginAnimations:@"Curl"context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
        
        WaterFallViewController *con = [[WaterFallViewController alloc] initWithNibName:@"WaterFallViewController" bundle:nil];
        [self.navigationController pushViewController:con animated:NO];
        [UIView commitAnimations];

        
    }
}



@end
