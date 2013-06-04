//
//  MapAroundViewController.h
//  Family
//
//  Created by Aevitx on 13-4-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REVClusterMapView.h"
#import "TopView.h"
#import "BottomView.h"
#import "TableController.h"

@interface MapAroundViewController : TableController <MKMapViewDelegate, BottomViewDelegate, NSXMLParserDelegate> {
    REVClusterMapView *_mapView;
}

@property (nonatomic, copy) NSString *latStr;
@property (nonatomic, copy) NSString *lngStr;

@property (nonatomic, strong) NSMutableData *receivedData;

@end
