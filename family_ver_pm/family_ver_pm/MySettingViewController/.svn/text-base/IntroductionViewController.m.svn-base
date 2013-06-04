//
//  IntroductionViewController.m
//  Family_pm
//
//  Created by shawjanfore on 13-5-12.
//  Copyright (c) 2013年 shawjanfore. All rights reserved.
//

#import "IntroductionViewController.h"
#import "TopBarView.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController
@synthesize showImg, theScrollView, whichType;
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
    //
    [self setTheTopBarView];
    [self setTheBackBottomBarView];
    // Do any additional setup after loading the view from its nib.
    
    
    
    NSString *showImgStr = whichType == aquirecoin ? @"coin_use.jpg" : whichType == vipintroduction ? @"vip_info.jpg" : @"about_family.jpg";
    UIImage *image = [UIImage imageNamed:showImgStr];
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    height = 300 / width * height;
    self.view.frame = CGRectMake(0, 0, DEVICE_SIZE.width, height+80);
    theScrollView.frame = CGRectMake(0, 65, DEVICE_SIZE.width, height+30);
    theScrollView.contentSize = CGSizeMake(DEVICE_SIZE.width, height+50);
    
    [showImg setFrame:CGRectMake(10, 0, 300, height)];
    [showImg setImage:image];
    //showImg.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheTopBarView
{
    TopBarView *customTopBarView = [[TopBarView alloc] initWithConId:@"3" andTopBarFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 65) TheFrameWidth:@"168"];
    customTopBarView.familyLbl.text = MY_NAME;
    NSString *themeStr = whichType == aquirecoin ? @"获取金币" : whichType == vipintroduction ? @"vip服务" : @"关于我们";
    customTopBarView.themeLbl.text = themeStr;
    [self.view addSubview:customTopBarView];
    [customTopBarView release], customTopBarView = nil;
}

-(void)setTheBackBottomBarView
{
    NSArray *normalImage = [[NSArray alloc] initWithObjects:@"back_a_bottombar.png", nil];
    NSArray *selectedImage = [[NSArray alloc] initWithObjects:@"back_b_bottombar.png", nil];
    customBackBottomBarView = [[BackBottomBarView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height-49, DEVICE_SIZE.width, 49) numOfButton:[normalImage count] andNormalImage:normalImage andSelectedImage:selectedImage backgroundImageView:@"bg_bottombar.png"];
    customBackBottomBarView.delegate = self;
    [self.view addSubview:customBackBottomBarView];
    [normalImage release], normalImage = nil;
    [selectedImage release], selectedImage = nil;
}

-(void)userPressTheBottomButton:(BackBottomBarView *)_view andTheButton:(UIButton *)_button
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
    [super dealloc];
    [showImg release], showImg = nil;
    [theScrollView release], theScrollView = nil;
}

@end
