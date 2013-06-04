//
//  WetherButton.m
//  family_ver_pm
//
//  Created by pandara on 13-5-12.
//  Copyright (c) 2013年 pandara. All rights reserved.
//

#import "WeatherView.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "UIButton+Block.h"
#import "SBToolKit.h"
#import "WeatherPopUpView.h"
#import "FlowLayoutLabel.h"

@implementation WeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        self.weatherIcon.image = nil;
        self.temLabel.text = nil;
        self.suggestion = @"数据正在努力的加载中。。。";
        self.cityCodes = [[NSMutableArray alloc] init];
        
        self.juhuaView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.juhuaView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self.juhuaView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.juhuaView];
        [self.juhuaView startAnimating];
        
        self.weatherIconFileDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"w_daxue", DAXUE,
                                    @"w_dayu", DAYU,
                                    @"w_duoyun", DUOYUN,
                                    @"w_leizhenyu", LEIZHENYU,
                                    @"w_qing", QING,
                                    @"w_xiaoxue", XIAOXUE,
                                    @"w_xiaoyu", XIAOYU,
                                    @"w_yin", YIN,
                                    @"w_yujiaxue", YUJIAXUE,
                                    @"w_dayu", @"暴雨",
                                    nil];

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWeatherSuggestion)];
//        [self addGestureRecognizer:tap];
        [self addTarget:self action:@selector(showWeatherSuggestion) forControlEvents:UIControlEventTouchUpInside];
        
//        [self requestWeatherInfo];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000.0f;
        //启用位置更新
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager startUpdatingLocation];
        } else {
            NSLog(@"请打开你的定位服务");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位失败！" message:@"不知道你身处的城市，不能给你最好的天气预报！打开你装置上的定位服务好吗~~" delegate:self cancelButtonTitle:@"我待会就去~" otherButtonTitles:@"我这就去!", nil];
            [alertView show];
        }
    }
    return self;
}

//ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = (CLLocation *)[locations objectAtIndex:0];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    [self requestCityNameFromLatitude:latitude andLongitude:longitude];
    NSLog(@"latitude:%f and longitude:%f", latitude, longitude);
}

//低于ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    [self requestCityNameFromLatitude:latitude andLongitude:longitude];
    NSLog(@"latitude:%f and longitude:%f", latitude, longitude);
}

- (void)requestCityNameFromLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    NSString *locationPara = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:GEOCODER_API parameters:[NSDictionary dictionaryWithObjectsAndKeys:locationPara, LOCATION, BAIDU_KEY, KEY, OUTPUT_JSON, OUTPUT, COORD_TYPE_GPS, COORD_TYPE, nil]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [responseObject objectFromJSONData];
        
        if ([[resultDict objectForKey:STATUS] isEqualToString:OK] && [[[resultDict objectForKey:RESULT] objectForKey:CITYCODE] intValue] != 0) {
            NSString *cityName = [[[resultDict objectForKey:RESULT] objectForKey:ADDRESSCOMPONENT] objectForKey:CITY];
            self.cityName = cityName;
            [self getCityCode];
            NSLog(@"获得城市名称%@", cityName);
        } else {
            NSLog(@"获取城市名称失败%@", resultDict);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取城市名称错误%@", error);
    }];
    
    [operation start];
}

//从xml文件中获取城市代码
- (void)getCityCode
{
    NSError *error;
    NSString *textOfXmlFile = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citycodes" ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
    if (textOfXmlFile == nil) {
        NSLog(@"读取城市代码xml文件错误：%@", error);
        return;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[textOfXmlFile dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    if ([parser parse]) {
        NSLog(@"解释成功");
        if ([self.cityCodes count] == 0) {
            NSLog(@"没有获取到任何城市代码！");
        } else {
            [self requestWeatherInfo];
        }
    } else {
        NSLog(@"解释失败");
    }
}

//准备解析节点
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([attributeDict objectForKey:@"name"] == nil) {
        return;
    }
    
    if ([self.cityName hasPrefix:[attributeDict objectForKey:@"name"]]) {
        [self.cityCodes addObject:[attributeDict objectForKey:@"code"]];
    }
}

//显示天气建议
- (void)showWeatherSuggestion
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"天气无忧" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
    [alertView show];
    
    for (id subView in [alertView subviews]) {
        if ([[subView class] isSubclassOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)subView;
            
            //添加label
            FlowLayoutLabel *label = [[FlowLayoutLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            [label setMaxWidth:ALERTVIEW_SCROLLVIEW_SIZE_WIDTH maxLine:0 font:[UIFont systemFontOfSize:20]];
            [label setTextContent:[NSString stringWithFormat:@"%@", self.suggestion]];
            scrollView.contentSize = label.frame.size;
            [scrollView addSubview:label];
            
            break;
        }
    }
}

- (void)stopJuHuaAnimate
{
    [self.juhuaView stopAnimating];
}

- (void)requestWeatherInfo
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[SBToolKit getWeatherApiFromCityCode:[self.cityCodes objectAtIndex:0]] parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    NSLog(@"获取天气信息request:%@", request);
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *weatherInfo = [[responseObject objectFromJSONData] objectForKey:WEATHERINFO];
//        NSLog(@"获取天气信息成功%@", weatherInfo);
        NSString *tempStr = [weatherInfo objectForKey:TEMP];
        
        //取天气图片名
        NSString *imageTitleA = [weatherInfo objectForKey:IMG_TITLE_A];
        NSString *weatherIconName = [self.weatherIconFileDict objectForKey:imageTitleA];
        if (weatherIconName == nil) {
            weatherIconName = [self.weatherIconFileDict objectForKey:[weatherInfo objectForKey:IMG_TITLE_B]];
        }
        if (weatherIconName == nil) {
            NSRange range = [imageTitleA rangeOfString:@"雨"];
            if (range.location != NSNotFound) {
                weatherIconName = @"w_xiaoyu";
            } else {
                NSRange range = [imageTitleA rangeOfString:@"雪"];
                if (range.location != NSNotFound) {
                    weatherIconName = @"w_xiaoxue";
                }
            }
        }
        if (weatherIconName == nil) {
            weatherIconName = @"w_duoyun";
        }
        
        NSArray *weatherIconKeys = [NSArray arrayWithObjects:DAXUE, DAYU, DUOYUN, LEIZHENYU, QING, XIAOXUE, XIAOYU, YIN, YUJIAXUE, nil];
        NSString *weatherIconKey;
        for (NSString *key in weatherIconKeys) {
            NSRange range = [weatherIconName rangeOfString:key];
            if (range.location != NSNotFound) {
                weatherIconKey = key;
                break;
            }
        }

        UIImage *weatherIconImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@", weatherIconName, PNG]];
        self.temLabel.text = tempStr;
        self.weatherIcon.image = weatherIconImg;
        self.suggestion = [NSString stringWithFormat:@"%@【%@】。\n\n气温：%@\n\n天气状况：%@\n\n小提示：%@", [weatherInfo objectForKey:DATE], self.cityName, tempStr, [weatherInfo objectForKey:WEATHER], [weatherInfo objectForKey:SUGGESTION]];
        [self stopJuHuaAnimate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取天气信息失败%@", error);
    }];
    [operation start];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
