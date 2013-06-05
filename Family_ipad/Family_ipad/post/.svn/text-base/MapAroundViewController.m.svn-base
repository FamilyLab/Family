//
//  MapAroundViewController.m
//  Family
//
//  Created by Aevitx on 13-4-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MapAroundViewController.h"
#import "REVClusterMap.h"
#import "MapArroundAnnoView.h"
#import "SVProgressHUD.h"
#import "MyHttpClient.h"
#import "PostBaseViewController.h"
#import "PostBaseView.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "StackScrollViewController.h"
#define BASE_RADIUS .5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_CLUSTER_LEVEL 100000

@interface MapAroundViewController ()

@end

@implementation MapAroundViewController
- (IBAction)backAction:(id)sender
{
    
  [[AppDelegate instance].rootViewController.stackScrollViewController removeThirdView];
    
}
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
//    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
  //  self.view.frame = DEVICE_BOUNDS;
    _tableView.refreshView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _mapView = [[REVClusterMapView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 200)];
    _mapView.delegate = self;
    
    _tableView.tableHeaderView = _mapView;
//    [self.view addSubview:_mapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_latStr floatValue];
    coordinate.longitude = [_lngStr floatValue];
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method(s)
//- (void)addTopView {
//    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    topView.topViewType = notLoginOrSignIn;
//    [topView leftBg];
//    [topView leftText:@"地点"];
//    [topView rightLogo];
//    [topView rightLine];
//    [self.view addSubview:topView];
//}
//
//- (void)addBottomView {
//    NSArray *normalImages = [[NSArray alloc] initWithObjects:@"login_back", nil];
//    BottomView *bottomView = [[BottomView alloc] initWithFrame:CGRectMake(0, DEVICE_SIZE.height - 40, DEVICE_SIZE.width, 40)
//                                                          type:notAboutTheme
//                                                     buttonNum:[normalImages count]
//                                               andNormalImages:normalImages
//                                             andSelectedImages:nil
//                                            andBackgroundImage:@"login_bg"];
//    bottomView.delegate = self;
//    [self.view addSubview:bottomView];
//}
//
//- (void)userPressedTheBottomButton:(BottomView *)_view andButton:(UIButton *)_button {
//    switch (_button.tag - kTagBottomButton) {
//        case 0:
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)sendRequest:(id)sender {
    NSString *url = $str(@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&page=%d&count=%d&source=100908&apiverd=2", _latStr, _lngStr, currentPage, 15);
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            needRemoveObjects = NO;
        } else if ([[dict objectForKey:@"items"] count] <= 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多数据了T_T"];
            currentPage--;
        }
        
        [dataArray addObjectsFromArray:[dict objectForKey:@"items"]];
        
        NSMutableArray *pins = [NSMutableArray array];
        for(int i = 0; i < [dataArray count]; i++) {
            CGFloat latDelta = rand()*0.125/RAND_MAX - 0.02;
            CGFloat lonDelta = rand()*0.130/RAND_MAX - 0.08;
            
            CGFloat lat = [_latStr floatValue];
            CGFloat lng = [_lngStr floatValue];
            
            CLLocationCoordinate2D newCoord = {lat+latDelta, lng+lonDelta};
            REVClusterPin *pin = [[REVClusterPin alloc] init];
            pin.title = [[dataArray objectAtIndex:i] objectForKey:NAME];
//            pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle",i+1];
            pin.coordinate = newCoord;
            [pins addObject:pin];
        }
        
        [_mapView addAnnotations:pins];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不好T_T"];
        [self stopLoading:sender];
        currentPage--;
    }];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *mapAroundCellId = @"mapAroundCellId";
    cell = [tableView dequeueReusableCellWithIdentifier:mapAroundCellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mapAroundCellId];
    }
    cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
    cell.detailTextLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"addr"];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PostBaseViewController *con = (PostBaseViewController*)preController;
//    ((PostBaseView *)con.view).postion = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
//    con.downPostView.myLocationLbl.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
//    [self.navigationController popViewControllerAnimated:YES];
    _parent.postion = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
    _parent.myLocationLbl.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
    REMOVEDETAIL;
}

#pragma mark -
#pragma mark Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        pin.title = @"___";
        
        annView = (MapArroundAnnoView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        if( !annView )
            annView = (MapArroundAnnoView*)[[MapArroundAnnoView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        annView.image = [UIImage imageNamed:@"cluster.png"];
        
        [(MapArroundAnnoView*)annView setClusterText:[NSString stringWithFormat:@"%i",[pin nodeCount]]];
        annView.canShowCallout = NO;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
        annView.image = [UIImage imageNamed:@"PinDown2.png"];
        //annView.image = [UIImage imageNamed:@"pinpoint.png"];
        annView.canShowCallout = YES;
        
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"REVMapViewController mapView didSelectAnnotationView:");
    
    if (![view isKindOfClass:[MapArroundAnnoView class]])
        return;
    
    CLLocationCoordinate2D centerCoordinate = [(REVClusterPin *)view.annotation coordinate];
    
    MKCoordinateSpan newSpan =
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                         mapView.region.span.longitudeDelta/2.0);
    
    //mapView.region = MKCoordinateRegionMake(centerCoordinate, newSpan);
    
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
              animated:YES];
}


@end
