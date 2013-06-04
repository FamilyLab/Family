//
//  BootViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-5-28.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "BootViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BootViewController ()

@end

@implementation BootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width * BOOT_PAGE_COUNT, DEVICE_SIZE.height);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * DEVICE_SIZE.width, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"boot%d.jpg", i+1]];
        [view addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(BOOT_VIEW_BUTTON_ORIGIN.x, BOOT_VIEW_BUTTON_ORIGIN.y, BOOT_VIEW_BUTTON_SIZE.width, BOOT_VIEW_BUTTON_SIZE.height)];
        
        if (i < 2) {
            [button addTarget:self action:@selector(scrollToNextPage) forControlEvents:UIControlEventTouchUpInside];
        } else {
//            view.userInteractionEnabled = YES;
//            
//            UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(enterLoginView)];
//            [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
//
//            [self.view addGestureRecognizer:swipeGesture];
            [button addTarget:self action:@selector(enterLoginView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:button];
        [self.scrollView addSubview:view];
    }
    
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.center = CGPointMake(DEVICE_SIZE.width / 2, DEVICE_SIZE.height - 30);
    self.pageControl.numberOfPages = BOOT_PAGE_COUNT;
    self.pageControl.currentPage = 0;
    [self.pageControl setBounds:CGRectMake(0, 0, 16 * (BOOT_PAGE_COUNT - 1) + 16, 16)];
    [self.pageControl.layer setCornerRadius:8];
    [self.pageControl setBackgroundColor:color(0, 0, 0, 0.8)];
    [self.pageControl addTarget:self action:@selector(pageShouldChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

- (void)pageShouldChange
{
    int currentPage = self.pageControl.currentPage;
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * currentPage, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void)scrollToNextPage
{
    int currentScrollPage = [self currentScrollPage];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width * (currentScrollPage + 1), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
}

- (void)enterLoginView
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (NSInteger)currentScrollPage
{
    return (int)(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self currentScrollPage] == BOOT_PAGE_COUNT - 1) {
        [self enterLoginView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [self currentScrollPage];
}

@end







