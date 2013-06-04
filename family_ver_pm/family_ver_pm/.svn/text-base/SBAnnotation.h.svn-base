//
//  SBAnnotation.h
//  map_test
//
//  Created by pandara on 13-5-31.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SBAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords;

@end
