//
//  MapViewController.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/19/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "MapViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]



@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface UIImage (InternalMethod)

-(UIImage *) imageRotatedByDegrees:(CGFloat) degrees;

@end

@implementation UIImage (InternalMethod)

-(UIImage *) imageRotatedByDegrees:(CGFloat) degrees;
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return newImage;
    
}

@end




@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _search.delegate = nil;
}

//获取具体路线
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle *libBundle = MYBUNDLE;
    if (libBundle && filename)
    {
        NSString *s = [[libBundle resourcePath] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请重新请求" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    
    self.routeArray = [NSMutableArray arrayWithCapacity:1];
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
     
    //初始化百度地图以及搜索路线功能
    _mapView.showsUserLocation = YES;
    _mapView.userInteractionEnabled = YES;
    _mapView.delegate = self;
    _mapView.mapType = BMKMapTypeTrafficOn;
    
    [self.view addSubview: self.mapView];
    [_mapView release];
    
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dismissButton.tintColor = [UIColor lightGrayColor];
    dismissButton.frame = CGRectMake(15, 13, 35, 27);
    dismissButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [dismissButton setTitle:@"返回" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissThisViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
  
    
    _search = [[BMKSearch alloc] init];
    
    //添加一个segmentControl
    self.segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"公交",@"驾车",@"步行", nil]];
    _segment.segmentedControlStyle = UISegmentedControlStyleBar;
    //_segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor colorWithRed:12/255.0 green:160/255.0 blue:242/255.0 alpha:0.5];
    _segment.frame = CGRectMake(190, 10, 120, 32);
    [_segment addTarget:self action:@selector(changePath) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
    [_segment release];
    
    //底部添加一个view
    _aView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height - 250)];
    [self.view addSubview:_aView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"Map_Route.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"Map_Route.png"] forState:UIControlStateHighlighted];

    button.frame = CGRectMake(-20, 0, 360, 30);
    [_aView addSubview:button];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30, 320, _aView.frame.size.height-button.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 30;
    [_aView addSubview:_tableView];
    [_tableView release];
    
    
    
}

-(void) dismissThisViewController
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)back
{
    NSLog(@"back VC");
}

-(void)hidden
{
    [UIView beginAnimations:@"MyAnimation" context:@"table"];
    _aView.frame = CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height - 300);
    [UIView commitAnimations];
}

-(void)changePath
{
    if (_segment.selectedSegmentIndex == 0) {
        [self onClickBusSearch];
    }
    else if(_segment.selectedSegmentIndex == 1)
    {
        [self onClickDriveSearch];
    }
    else if(_segment.selectedSegmentIndex == 2)
    {
        [self onClickWalkSearch];
    }
}


- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_waypoint.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
		default:
			break;
	}
	
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

//获取公交路线
- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    if (error == BMKErrorOk) {
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item]; // 添加起点标注
		[item release];
        
		item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.endPt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item]; // 终点标注
		[item release];
		
        // 计算路线方案中的点数
		int size = [plan.lines count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			planPointCounts += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					planPointCounts += len;
				}
				break;
			}
		}
		
        // 构造方案中点的数组，用户构建BMKPolyline
		BMKMapPoint* points = new BMKMapPoint[planPointCounts];
		planPointCounts = 0;
		
        // 查询队列中的元素，构建points数组，并添加公交标注
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
				planPointCounts += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + planPointCounts, line.points, line.pointsCount * sizeof(BMKMapPoint));
			planPointCounts += line.pointsCount;
			
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
            
            [self.routeArray addObject:item.title];
            
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item]; // 上车标注
			[item release];
			route = [plan.routes objectAtIndex:i+1];
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOffStopPoiInfo.pt;
			item.title = route.tip;
            
            [self.routeArray addObject:item.title];
            
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			[_mapView addAnnotation:item]; // 下车标注
			[item release];
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + planPointCounts, pointArray, len * sizeof(BMKMapPoint));
					planPointCounts += len;
				}
				break;
			}
		}
        
        
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
		delete []points;
        
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
	}
    [_routeArray addObject:@"到达目的地"];
    _tableView.contentOffset = CGPointMake(0, 0);
    
    [_tableView reloadData];
    
    
    [self animations];
}
//获取驾车路线
- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    if (result != nil) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        
        // error 值的意义请参考BMKErrorCode
        if (error == BMKErrorOk) {
            BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
            
            // 添加起点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = result.startNode.pt;
            item.title = @"起点";
            item.type = 0;
            [_mapView addAnnotation:item];
            [item release];
            
            
            // 下面开始计算路线，并添加驾车提示点
            int index = 0;
            int size = [plan.routes count];
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    int len = [route getPointsNum:j];
                    index += len;
                }
            }
            
            BMKMapPoint* points = new BMKMapPoint[index];
            
            index = 0;
            for (int i = 0; i < 1; i++) {
                BMKRoute* route = [plan.routes objectAtIndex:i];
                for (int j = 0; j < route.pointsCount; j++) {
                    
                    int len = [route getPointsNum:j];
                    BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                    memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                    index += len;
                }
                size = route.steps.count;
                for (int j = 0; j < size; j++) {
                    // 添加驾车关键点
                    BMKStep* step = [route.steps objectAtIndex:j];
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = step.pt;
                    item.title = step.content;
                    [self.routeArray addObject:item.title];
                    
                    item.degree = step.degree * 30;
                    item.type = 4;
                    [_mapView addAnnotation:item];
                    [item release];
                }
                
            }
            
            
            // 添加终点
            item = [[RouteAnnotation alloc]init];
            item.coordinate = result.endNode.pt;
            item.type = 1;
            item.title = @"终点";
            [_mapView addAnnotation:item];
            [item release];
            
            // 添加途经点
            if (result.wayNodes) {
                for (BMKPlanNode* tempNode in result.wayNodes) {
                    item = [[RouteAnnotation alloc]init];
                    item.coordinate = tempNode.pt;
                    item.type = 5;
                    item.title = tempNode.name;
                    [_mapView addAnnotation:item];
                    [item release];
                }
            }
            
            // 根究计算的点，构造并添加路线覆盖物
            BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
            [_mapView addOverlay:polyLine];
            delete []points;
            
            [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
        }
    }
    [_routeArray addObject:@"到达目的地"];
    _tableView.contentOffset = CGPointMake(0, 0);
    [_tableView reloadData];
    
    [self animations];
}
//获取步行路线
- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
        
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
		[item release];
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
                
                [self.routeArray addObject:item.title];
                
                
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
				[item release];
			}
            
		}
		[_routeArray addObject:@"到达目的地"];
        _tableView.contentOffset = CGPointMake(0, 0);
        [_tableView reloadData];
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
        
		[_mapView addAnnotation:item];
		[item release];
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
        
        [_mapView setCenterCoordinate:result.startNode.pt animated:YES];
	}
    
    [self animations];
    
}
//选择公交路线
-(void)onClickBusSearch
{
    [_routeArray removeAllObjects];
    CLLocationCoordinate2D startPt = CLLocationCoordinate2DMake(_mylocation.coordinate.latitude, _mylocation.coordinate.longitude);
    
	CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake(_destinationLocation.coordinate.latitude, _mylocation.coordinate.longitude);
    
	BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
	start.pt = startPt;
	start.name = @"哈哈";
	BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = endPt;
	//end.name = _endAddrText.text;
    BOOL flag = [_search transitSearch:@"北京" startNode:start endNode:end];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        [_alertView show];
        NSLog(@"search failed!");
    }
}

//选择驾驶路线
-(void)onClickDriveSearch
{
    [_routeArray removeAllObjects];
    CLLocationCoordinate2D startPt = _mylocation.coordinate;
	CLLocationCoordinate2D endPt = self.destinationLocation.coordinate;
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
	start.pt = startPt;
	BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = endPt;
        
    NSMutableArray * array = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    BMKPlanNode* wayPointItem1 = [[[BMKPlanNode alloc]init] autorelease];
	wayPointItem1.cityName = @"北京";
	wayPointItem1.name = @"清华大学";
    [array addObject:wayPointItem1];
    
	BOOL flag = [_search drivingSearch:@"北京" startNode:start endCity:@"北京" endNode:end throughWayPoints:array];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        [_alertView show];
        NSLog(@"search failed!");
    }
}
//选择步行路线
-(void)onClickWalkSearch
{
    
    [_routeArray removeAllObjects];
    
    
    CLLocationCoordinate2D startPt = CLLocationCoordinate2DMake(_mylocation.coordinate.latitude, _mylocation.coordinate.longitude);
	CLLocationCoordinate2D endPt = CLLocationCoordinate2DMake(_destinationLocation.coordinate.latitude, _mylocation.coordinate.longitude);;
    
	BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
	start.pt = startPt;
	//start.name = _startAddrText.text;
	BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    end.pt = endPt;
	//end.name = _endAddrText.text;
    
	BOOL flag = [_search walkingSearch:@"北京" startNode:start endCity:@"北京" endNode:end];
	if (flag) {
		NSLog(@"search success.");
	}
    else{
        [_alertView show];
        NSLog(@"search failed!");
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    self.Mylocation = userLocation.location;
    _mapView.showsUserLocation = NO;
    [_mapView setRegion:BMKCoordinateRegionMake(_mylocation.coordinate, BMKCoordinateSpanMake(0.07, 0.07))];
 
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _routeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableViewCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    if (_routeArray.count != 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d   %@",indexPath.row+1,[_routeArray objectAtIndex:indexPath.row]];
    }
    
    
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)animations
{
    [UIView beginAnimations:@"MyAnimation" context:@"table"];
    _aView.frame = CGRectMake(0, 250, 320, self.view.frame.size.height-300);
    [UIView commitAnimations];
}
- (void)dealloc
{
    [_mapView release];
    [_mylocation release];
    [_routeArray release];
    [_tableView release];
    [_segment release];
    [super dealloc];
}
@end
