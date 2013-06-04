//
//  ShowMapViewController.m
//  Family
//
//  Created by Aevitx on 13-4-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ShowMapViewController.h"

@interface ShowMapViewController ()

@end

@implementation ShowMapViewController

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
    self.view.frame = DEVICE_BOUNDS;
    self.mapView.frame = CGRectMake(0, 50, DEVICE_SIZE.width, DEVICE_SIZE.height - 50 - 40);
    [self addTopView];
    [self addBottomView];
    
    _coordinate.latitude = [_latStr doubleValue];
    _coordinate.longitude = [_lngStr doubleValue];
    
    float zoomLevel = 0.018;
    MKCoordinateRegion region = MKCoordinateRegionMake(_coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    //大头针
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:_coordinate];
    annotation.title = @"我在这里";
    //            annotation.subtitle = @"";
    self.myAnnotation = annotation;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:_myAnnotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
- (void)addTopView {
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    topView.topViewType = notLoginOrSignIn;
    [topView leftBg];
    [topView leftText:@"我在"];
    [topView rightLogo];
    [topView rightLine];
    [self.view addSubview:topView];
}

- (void)addBottomView {
    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"menu_back", nil];
    BottomView *aView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
                                                     type:notAboutTheme
                                                buttonNum:[normalImages count]
                                          andNormalImages:normalImages
                                        andSelectedImages:nil
                                       andBackgroundImage:@"login_bg"];
    aView.delegate = self;
//    self.bottomView = aView;
    [self.view addSubview:aView];
}

- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
    switch (_button.tag - kTagBottomButton) {
        case 0://后退
        {
            [self.navigationController popViewControllerAnimated:YES];//
            break;
        }
        default:
            break;
    }
}

#pragma mark - mapview
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [_mapView selectAnnotation:_myAnnotation animated:YES];
}

@end
