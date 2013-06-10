//
//  GuideViewController.m
//  Family
//
//  Created by Aevitx on 13-4-4.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "GuideViewController.h"
#import "TopicViewController.h"
#import "TopicView.h"

#define kTagScrollViewInTips 10000

@interface GuideViewController ()

@end

@implementation GuideViewController

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
    self.view.backgroundColor = bgColor();
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
//    scrollView.delegate = self;
    scrollView.tag = kTagScrollViewInTips;
    scrollView.contentSize = CGSizeMake(DEVICE_SIZE.width * 4 + 1, DEVICE_SIZE.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_SIZE.width * i, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
        
        UIImage* image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide_%d", i + 1] ofType:@"jpg"]];
        //image的size是(640, 1136)
        CGFloat imageCutHeight = iPhone5 ? 0 : 88;
        CGRect rect = CGRectMake(0, imageCutHeight, image.size.width, DEVICE_SIZE.height * 2);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect) scale:1.0f orientation:UIImageOrientationUp];
        
        imageView.image = image;
        [scrollView addSubview:imageView];
        if (i == 3) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(DEVICE_SIZE.width * 3, 0, DEVICE_SIZE.width, DEVICE_SIZE.height);
            [btn addTarget:self action:@selector(removeTips) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btn];
        }
    }
    [self.view addSubview:scrollView];
//    if (MY_IS_FIRST_SHOW) {//不是第一次展示了
//        [self addBottomView];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)dismiss {
}

- (void)removeTips {
    if (MY_NOT_FIRST_SHOW) {//不是第一次展示了
        [self.navigationController popViewControllerAnimated:YES];
    } else if (MY_WANT_SHOW_TODAY_TOPIC) {//第一次展示
        
        TopicView *aView = [[[NSBundle mainBundle] loadNibNamed:@"TopicView" owner:self options:nil] objectAtIndex:0];
        aView.isFromMoreCon = NO;
        
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        UIViewController *con = nil;
        if (sysVer < 5.0) {
            UINavigationController *nav = (UINavigationController*)self.navigationController.parentViewController;
            con = [nav.viewControllers objectAtIndex:0];
        } else {
            UINavigationController *nav = (UINavigationController*)self.navigationController.presentingViewController;
            con = [nav.viewControllers objectAtIndex:0];
        }
        [con.view addSubview:aView];
        [aView sendRequest:nil];
        
        [ConciseKit setUserDefaultsWithObject:@"notFirstShow" forKey:NOT_FIRST_SHOW];
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
//        TopicViewController *con = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
//        con.isFromMoreCon = NO;
//        [self.navigationController pushViewController:con animated:YES];
    }
    //由于 今日话题 改版，不能在这里设置为NO了
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_FIRST_SHOW];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)addBottomView {
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", nil];
//    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
//                                                     type:notAboutTheme
//                                                buttonNum:[normalImages count]
//                                          andNormalImages:normalImages
//                                        andSelectedImages:nil
//                                       andBackgroundImage:@"login_bg"];
//    aView.delegate = self;
////    self.bottomView = aView;
//    [self.view addSubview:aView];
//}
//
//- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
//    switch (_button.tag - kTagBottomButton) {
//        case 0://后退
//        {
//            [self.navigationController popViewControllerAnimated:YES];//
//            break;
//        }
//        default:
//            break;
//    }
//}

@end
