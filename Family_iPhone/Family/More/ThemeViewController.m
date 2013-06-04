//
//  ThemeViewController.m
//  Family
//
//  Created by Aevitx on 13-1-25.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ThemeViewController.h"
#import "Common.h"
#import "MLScrollView.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController
@synthesize topView, containerView, cellHeader, symbolImgView;

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
    self.symbolImgView.image = ThemeImage(@"symbol_right");
    
    int count = 0;
    if ([currentTheme isEqualToString:DEFAULT_THEME]) {
        count = 0;
    } else if ([currentTheme isEqualToString:SPRING_THEME]) {
        count = 1;
    } else if ([currentTheme isEqualToString:SUMMER_THEME]) {
        count = 2;
    } else if ([currentTheme isEqualToString:AUTUMN_THEME]) {
        count = 3;
    } else if ([currentTheme isEqualToString:WINTER_THEME]) {
        count = 4;
    } else count = 0;
    symbolImgView.frame = (CGRect){.origin.x = symbolImgView.frame.origin.x, .origin.y = 33 + 60 * count, .size = symbolImgView.frame.size};
    
    [self addTopView];
    [self addBottomView];
//    UIScrollView *scrollView = (UIScrollView*)self.containerView;
//    scrollView.contentSize = (CGSize){.width = scrollView.frame.size.width, .height = scrollView.frame.size.height + 1};
//    [self.view sendSubviewToBack:scrollView];
    MLScrollView *scrollView = (MLScrollView*)self.containerView;
    scrollView.contentSize = (CGSize){.width = scrollView.frame.size.width, .height = scrollView.frame.size.height + 1};
    [self.view sendSubviewToBack:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *aView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    aView.topViewType = notLoginOrSignIn;
    
    [aView leftHeadAndName];
    
//    self.containerView.frame = (CGRect){.origin.x = 0, .origin.y = 70, .size = self.containerView.frame.size};
    cellHeader.frame = (CGRect){.origin = CGPointMake(0, 50), .size.width = DEVICE_SIZE.width, .size.height = [CellHeader getHeaderHeightWithText:@"主题设置"].height};
    [cellHeader initHeaderDataWithMiddleLblText:@"主题设置"];
    
//    [aView.leftHeadBtn setImage:[UIImage imageNamed:@"head_70.png"] forState:UIControlStateNormal];//假数据
    [aView.leftHeadBtn setImageForMyHeadButtonWithUrlStr:MY_HEAD_AVATAR_URL plcaholderImageStr:nil];
    [aView.leftHeadBtn setVipStatusWithStr:emptystr(MY_VIP_STATUS) isSmallHead:YES];
    aView.leftNameLbl.text = MY_NAME;
    aView.backgroundColor = bgColor();
    [topView setNeedsLayout];
    
    self.topView = aView;
    [self.view addSubview:topView];
}

- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                          type:notAboutTheme
                                                     buttonNum:[normalImages count]
                                               andNormalImages:normalImages
                                             andSelectedImages:nil
                                            andBackgroundImage:@"login_bg"];
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    [self.navigationController popViewControllerAnimated:YES];
//    switch (_button.tag - kTagBottomButton) {
//        case 0:
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        }  
//        default:
//            break;
//    }
}

- (IBAction)btnPressed:(UIButton*)sender {
    int btnTag = sender.tag - kTagBtnInThemeView;
    self.symbolImgView.frame = (CGRect){.origin.x = self.symbolImgView.frame.origin.x, .origin.y = btnTag * 60 + 33, .size = self.symbolImgView.frame.size};
    
    NSString *themeStr = btnTag == 0 ? DEFAULT_THEME :  (btnTag == 1 ? SPRING_THEME : (btnTag == 2 ? SUMMER_THEME : (btnTag == 3 ? AUTUMN_THEME : (btnTag == 4 ? WINTER_THEME : DEFAULT_THEME))));
    [[ThemeManager sharedThemeManager] setTheme:themeStr];
    
    self.topView.leftNameLbl.textColor = [Common theLblColor];
    self.cellHeader.leftImgView.image = ThemeImage(@"left_bg");
    self.cellHeader.rightImgView.image = ThemeImage(@"left_bg");
    self.symbolImgView.image = ThemeImage(@"symbol_right");
}

@end
