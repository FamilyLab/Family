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
#import "PostViewController.h"

#define BASE_RADIUS .5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_CLUSTER_LEVEL 100000

@interface MapAroundViewController ()

@end

@implementation MapAroundViewController

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
    self.view.frame = DEVICE_BOUNDS;
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
    
    [self addTopView];
    [self addBottomView];
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
    [topView leftText:@"地点"];
    [topView rightLogo];
    [topView rightLine];
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
    switch (_button.tag - kTagBottomButton) {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)sendRequest:(id)sender {
    NSString *url = $str(@"http://api.jiepang.com/v1/locations/search?lat=%@&lon=%@&page=%d&count=%d&source=100908&apiverd=2", _latStr, _lngStr, currentPage, 15);
//    NSString *url = $str(@"http://api.map.baidu.com/geocoder/v2/?ak=5140245b0608e3ae325a63ca47a86479&callback=renderReverse&location=%@,%@&output=xml&pois=1", _latStr, _lngStr, currentPage, 15);
    
//    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:15 ];
//    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    if  (theConnection) {
//        //得到文件数据
//        NSMutableData *tmp = [[NSMutableData alloc] init];
//        self.receivedData = tmp;
//    }
//    else
//    {
//        NSLog(@"error" );
//    }
    
    
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
//    parser.delegate = self;
//    [parser parse];
    
//    return;
    [[MyHttpClient sharedInstance] commandWithPath:url onCompletion:^(NSDictionary *dict) {
        [self stopLoading:sender];
        if (needRemoveObjects == YES) {
            [dataArray removeAllObjects];
            needRemoveObjects = NO;
        } else if ([[[dict objectForKey:@"result"] objectForKey:@"pois"] count] <= 0) {
//        } else if ([[dict objectForKey:@"items"] count] <= 0) {
            [SVProgressHUD showSuccessWithStatus:@"没有更多内容了T_T"];
            currentPage--;
        }
        
        [dataArray addObjectsFromArray:[dict objectForKey:@"items"]];
//        [dataArray addObjectsFromArray:[[dict objectForKey:@"result"] objectForKey:@"pois"]];
        
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
        NSLog(@"error:%@", [error description]);
        [self stopLoading:sender];
        currentPage--;
    }];
}

//#pragma mark -
//#pragma mark RSS processing
//- (void )connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {       [_receivedData setLength:0 ];
//}
//
//- (void )connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
//    [_receivedData appendData:data];
//}
//
//- (void )connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error  {
//    NSLog(@"Error:%@", [error description]);
//}
//
//- (void )connectionDidFinishLoading:(NSURLConnection *)connection  {
//    NSString *content = [[NSString alloc] initWithData: _receivedData encoding: NSUTF8StringEncoding];   NSLog(@"content: %@" ,content);
//    //开始解析获取的receivedData
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_receivedData];
//    [parser setDelegate:self];//设置NSXMLParser对象的解析方法代理
//    [parser parse];//调用代理解析NSXMLParser对象，看解析是否成   //NSString *content = [[NSString alloc] initWithData: receivedData encoding: NSJapaneseEUCStringEncoding];
//}
//
//
//
//
//
//
//- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
//{
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
//    [parser setDelegate:self];
//    [parser setShouldProcessNamespaces:NO];
//    [parser setShouldReportNamespacePrefixes:NO];
//    [parser setShouldResolveExternalEntities:NO];
//    [parser parse];
//    NSError *parseError = [parser parserError];
//    if (parseError && error) {
//        *error = parseError;
//    }
//}
//
//
//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//    if ([elementName isEqualToString:@"poi"]) {
//        NSLog(@"ele:%@", elementName);
//        NSLog(@"namespaceURI:%@", namespaceURI);
//        NSLog(@"qName:%@", qName);
//        NSLog(@"attributeDict:%@", attributeDict);
////        [dataArray addObjectsFromArray:[attributeDict objectForKey:@"pois"]];
////        NSMutableArray *pins = [NSMutableArray array];
////        for(int i = 0; i < [dataArray count]; i++) {
////            CGFloat latDelta = rand()*0.125/RAND_MAX - 0.02;
////            CGFloat lonDelta = rand()*0.130/RAND_MAX - 0.08;
////            
////            CGFloat lat = [_latStr floatValue];
////            CGFloat lng = [_lngStr floatValue];
////            
////            CLLocationCoordinate2D newCoord = {lat+latDelta, lng+lonDelta};
////            REVClusterPin *pin = [[REVClusterPin alloc] init];
////            pin.title = [[dataArray objectAtIndex:i] objectForKey:NAME];
////            //            pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle",i+1];
////            pin.coordinate = newCoord;
////            [pins addObject:pin];
////        }
////        
////        [_mapView addAnnotations:pins];
////        
////        [_tableView reloadData];
//    }
//}
//
//// 这里才是真正完成整个解析并保存数据的最终结果的地方
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    if([elementName isEqualToString:@"Books"])
//        return;
//    //There is nothing to do if we encounter the Books element here.
//    //If we encounter the Book element howevere, we want to add the book object to the array 遇到Book元素的结束标签，则添加book对象到设置好的数组中。
//    // and release the object.
//    if([elementName isEqualToString:@"poi"]) {
//        NSLog(@"elementName:%@", elementName);
//        NSLog(@"namespaceURI:%@", namespaceURI);
//        NSLog(@"qName:%@", qName);
////        [aBook release];
////        aBook = nil;
//    }
//    else {
//        
//    }
//        // 不是Book元素时也不是根元素，则用 setValue:forKey为当前book对象的属性赋值
////        [aBook setValue:currentElementValue forKey:elementName];
//    
////    [currentElementValue release];
////    currentElementValue = nil;
//}
//
//-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    // Save foundCharacters for later
//    NSLog(@"str:%@", string);
//}
//
//-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
//    NSLog(@"%@ with error %@",NSStringFromSelector(_cmd),parseError.localizedDescription);
//}

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
    PostViewController *con = (PostViewController*)preController;
    con.addressStr = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
    con.downPostView.myLocationLbl.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:NAME];
    [self.navigationController popViewControllerAnimated:YES];
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
//        annView.image = [UIImage imageNamed:@"pinpoint.png"];
        annView.canShowCallout = YES;
        
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    NSLog(@"REVMapViewController mapView didSelectAnnotationView:");
    
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
