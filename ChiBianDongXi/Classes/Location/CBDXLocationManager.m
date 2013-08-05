//
//  LocationManager.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/18/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "CBDXLocationManager.h"

@interface CBDXLocationManager ()

@end

@implementation CBDXLocationManager

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        //精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  //精确度
        self.locationManager.distanceFilter = 1000;    //距离筛选器   1000米时才通知用户
        self.locationManager.delegate = self;
        self.isOpened = NO;
        self.isLocationed = NO;
    }
    return self;
}



-(void) updateLocation
{
    //是否打开定位服务
    if ([CLLocationManager locationServicesEnabled])    //locationManger已经打开
    {
        [self.locationManager startUpdatingLocation];
        self.isOpened = YES;
        [self openLocationSuccessed:self.isOpened];
    }
    else
    {
        self.isOpened = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否打开定位服务" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        
        
    }

}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations.count > 0)
    {
        [manager stopUpdatingLocation];  //如果有数据，停止定位
        self.isLocationed = YES;
    }
    
    CLLocation * currentLocution = [locations lastObject];
 
    NSLog(@"AAAAAAdefeqwrwerwerault = ");
    
    //将坐标值转换为数组 存在NSUserdefaults中
    NSArray * locationArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:currentLocution.coordinate.longitude],[NSNumber numberWithDouble:currentLocution.coordinate.latitude], nil];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: locationArray forKey:@"currentLocution"];
    
    NSLog(@"AAAAAAdefault = %@", [defaults objectForKey:@"defaultLocution"]);
    
    [self setLocationSuccessed:self.isLocationed];
}



-(void) setLocationSuccessed:(BOOL)isResult
{
    if([self.delegate respondsToSelector:@selector(isSetLocationSuccessed:)])
    {
        [self.delegate isSetLocationSuccessed:isResult];
    }
}

-(void) openLocationSuccessed:(BOOL)isResult
{
    if ([self.delegate respondsToSelector:@selector(isOpenedLocation:)])
    {
        [self.delegate isOpenedLocation:isResult];
    }


}


//#pragma mark--MapViewDelegate--
//
//-(void)mapViewWillStartLoadingMap:(MKMapView *)mapView
//{
//    NSLog(@"mapViewWillStartLoadingMap");
//}


//-(void) mapViewDidFinishLoadingMap:(MKMapView *)mapView
//{
//    MapLocation *currentAnnotation = [[MapLocation alloc] initWithCoordinate:_currentLocation.coordinate];
//    currentAnnotation.title = @"蓝鸥科技";
//    currentAnnotation.subtitle = @"专注iOS";
//    
//    [mapView addAnnotation:currentAnnotation];   //Annotation大头针
//    
//}

//-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    //如果是蓝色，就不处理
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//    {
//        return nil;
//    }
//    
//    static NSString *annotationIndentifier = @"annatation";
//    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIndentifier];
//    
//    NSLog(@"class = %@", NSStringFromClass([annotationIndentifier class]));
//    if (!pinView)
//    {
//        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                   reuseIdentifier:annotationIndentifier] autorelease];
//        
//        pinView.image = [UIImage imageNamed:@"a.png"];
//        
//        pinView.canShowCallout = YES;
//    }
//    pinView.annotation = annotation;
//    
//    
//    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    bButton.frame = CGRectMake(190, 20, 80, 38);
//    [bButton setTitle:@"导航" forState:UIControlStateNormal];
//    [bButton addTarget:self action:@selector(navigation) forControlEvents:UIControlEventTouchUpInside];
//    
//    pinView.rightCalloutAccessoryView = bButton;
//    
//    
//    return pinView;
//    
//    
//}


//-(void) navigation
//{
//    //6.0以上版本导航方法
//    float systemValue = [[UIDevice currentDevice].systemName floatValue]; //系统版本
//    if (systemValue > 5.9)
//    {
//        MKPlacemark *currentPlaceMark = [[[MKPlacemark alloc] initWithCoordinate:_currentLocation.coordinate addressDictionary:nil] autorelease];
//        
//        MKMapItem *currentItem = [[[MKMapItem alloc] initWithPlacemark:currentPlaceMark] autorelease];
//        currentItem.name = @"当前位置";
//        currentItem.phoneNumber = @"156855825852";
//        currentItem.url = [NSURL URLWithString: @"www.lanou3g.com"];
//        
//        CLLocationCoordinate2D destinationPlaceMark = CLLocationCoordinate2DMake(39.935399, 116.454834);  //目的地坐标 先维度 再经度；
//        
//        MKPlacemark *destinaPlaceMark = [[MKPlacemark alloc] initWithCoordinate:destinationPlaceMark addressDictionary:nil];    //目的地
//        MKMapItem *destinaPlaceItem = [[MKMapItem alloc] initWithPlacemark:destinaPlaceMark];
//        NSArray *itemArray = [NSArray arrayWithObjects:currentItem,destinaPlaceItem, nil];
//        
//        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey, [NSNumber numberWithInt:0], MKLaunchOptionsMapTypeKey, nil];
//        //到达方式， 地图类型
//        
//        [MKMapItem openMapsWithItems:itemArray launchOptions:options]; //自动打开地图  launchOptions：发起方式
//        
//    }
//    
//}

//#pragma mark-- LocationManager--
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *newLocation = [locations lastObject];
//    //NSLog(@"new latitude = %f, longitude = %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//    self.currentLocation = [locations lastObject];
//    [self.mapView setRegion:MKCoordinateRegionMake(_currentLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
//    
//    //地理编码
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    //逆向地理编码
//    //    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
//    //     {
//    //         for (CLPlacemark * mark in placemarks) {
//    //             NSLog(@"mark = %@", [mark.addressDictionary objectForKey:@"Name"]);
//    //         }
//    //    }];
//    
//    //正向地理编码
//    [geocoder geocodeAddressString:@"光华创业园" completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         for (CLPlacemark * placeMark in placemarks)
//         {
//             NSLog(@"latitude = %f, longitude = %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
//         }
//     }];
//    
//}
//





- (void)dealloc
{
    [self.locationManager release];
    //    [self.currentLocation release];
    [super dealloc];
}

@end
