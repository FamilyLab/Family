//
//  WetherButton.h
//  family_ver_pm
//
//  Created by pandara on 13-5-12.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherView: UIButton<CLLocationManagerDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) IBOutlet UILabel *temLabel;
@property (strong, nonatomic) UIActivityIndicatorView *juhuaView;
@property (strong, nonatomic) NSDictionary *weatherIconFileDict;
@property (strong, nonatomic) NSString *suggestion;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSMutableArray *cityCodes;
@property (strong, nonatomic) UIViewController *delegate;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

#ifdef TARGET_IPHONE_SIMULATOR
//@interface CLLocationManager (Simulator)
//@end
//
//@implementation CLLocationManager (Simulator)
//
//-(void)startUpdatingLocation
//{
//    float latitude = 23.139218;
//    float longitude = 113.346682;
//    CLLocation *setLocation= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    [self.delegate locationManager:self didUpdateLocations:[NSArray arrayWithObject:setLocation]];
//}
//@end
#endif // TARGET_IPHONE_SIMULATOR