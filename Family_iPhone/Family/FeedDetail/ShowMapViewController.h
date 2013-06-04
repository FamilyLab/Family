//
//  ShowMapViewController.h
//  Family
//
//  Created by Aevitx on 13-4-15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "TopView.h"
#import "BottomView.h"

@interface ShowMapViewController : BaseViewController <MKMapViewDelegate, BottomViewDelegate>

@property (nonatomic, assign) IBOutlet MKMapView *mapView;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) MyAnnotation *myAnnotation;

@property (nonatomic, copy) NSString *latStr;
@property (nonatomic, copy) NSString *lngStr;
@end
