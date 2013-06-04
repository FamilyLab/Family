//
//  ShowMapViewController.m
//  family_ver_pm
//
//  Created by pandara on 13-5-31.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "ShowMapViewController.h"
#import "SBAnnotation.h"

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
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    [self setMapToRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBackButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_POP_FROM_SHOWMAPVIEW object:nil];
}

- (void)setRegionWithLat:(CGFloat)slat lng:(CGFloat)slng
{
    lat = slat;
    lng = slng;
}

- (void)setMapToRegion
{
    if (lat == 0 && lng == 0) {
        return;
    }
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lng);
    CGFloat zoomLevel = 0.02;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    [self createAnnotationWithCoords:coords];
}

//使用大头针
- (void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords
{
    SBAnnotation *annotation = [[SBAnnotation alloc] initWithCoordinate:coords];
    annotation.title = @"我在这里";
//    annotation.subtitle = @"子标题";
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    }
    annotationView.canShowCallout = YES;
    annotationView.pinColor = MKPinAnnotationColorRed;
    annotationView.animatesDrop = YES;
    annotationView.highlighted = YES;
    annotationView.draggable = YES;
    return annotationView;
}


- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
