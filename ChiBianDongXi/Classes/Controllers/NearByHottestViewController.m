//
//  NearByHottestViewController.m
//  ChiBianDongXi
//
//  Created by lanou on 7/8/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "NearByHottestViewController.h"
#import "NetConnectionMacro.h"
#import "POIInfo.h"
#import "POICell.h"
#import "POIListInfo.h"
#import "POIDetailViewController.h"
#import "DistrictView.h"

#define kWaterFlowColumnNum 2
#define kPoiImageWidth  145
#define kPOINamTextSize 16.0
#define kPOINamTextWidth 135
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface NearByHottestViewController ()

@end

@implementation NearByHottestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.start = 0;
        self.limit = 12;
        self.dataArray = [[[NSMutableArray alloc] init] autorelease];
        self.currentLocation = [[[CLLocation alloc] init] autorelease];
        
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    //接收 update 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetWorkData) name:@"updateNear" object:nil];
  
    //创建title按钮
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, 200, 30)];
    _addressLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    _addressLabel.layer.cornerRadius = 5;
    _addressLabel.userInteractionEnabled = YES;
    _addressLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    _addressLabel.textAlignment = 1;
    _addressLabel.font = [UIFont systemFontOfSize:14.0];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addedMapView)];
    [_addressLabel addGestureRecognizer:tapRecognizer];
    
    self.navigationItem.title = nil;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.titleView = _addressLabel;
    
    //打开系统定位系统
    [self startLocationManager];
    
 
    //*********创建瀑布流 ***********************************/
    
    self.leftColumnArray =  [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray,nil];

    
    //初始化一个瀑布流
    CGRect rect = self.view.frame;
  
    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) headerViewHeight:2.0f];
    //给瀑布流一个背景色
    self.waterFlowView.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    //设置代理
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate   = self;
    
    [self.view addSubview: self.waterFlowView];
   
    [self createHeaderView]; //创建下拉刷新
    [self setFooterView];    //创建上拉加载更多
      
}


#pragma mark - CLLocationManagerDelegate

-(void)startLocationManager
{
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    
    //精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;  //精确度
    self.locationManager.distanceFilter = 1000;    //距离筛选器   1000米时才通知用户
    self.locationManager.delegate = self;

    //是否打开定位服务
    if ([CLLocationManager locationServicesEnabled])    //locationManger已经打开
    {
        [self.locationManager startUpdatingLocation];
       
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否打开定位服务" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        
    }

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations.count > 0)
    {
        [manager stopUpdatingLocation];  //如果有数据，停止定位
    }
   
    //现在的位置
    CLLocation * currentLocution = [locations lastObject];
    self.currentLocation = currentLocution;
    
    //将现在的位置转换为数组， 存在单例里
    NSArray *locationArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:currentLocution.coordinate.longitude],[NSNumber numberWithDouble:currentLocution.coordinate.latitude], nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: locationArray forKey:@"currentLocution"];
    
    
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    //
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        for (CLPlacemark *mark in placemarks)
         {
             NSString *str = [[[placemarks objectAtIndex:0] name] substringToIndex:2];
  
             NSString *addressTitle = [[[NSString alloc] init] autorelease];

             if ([str isEqualToString:@"中国"])
             {
                 //地址标签 在addressButton上显示
                 addressTitle = [[[placemarks objectAtIndex:0] name] substringFromIndex:5];
             }
             else
             {
                 addressTitle = [[placemarks objectAtIndex:0] name];
             }
             //将地址存为单例
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject: addressTitle forKey:@"addressName"];

             self.addressLabel.text = addressTitle;
         }
   
    }];
    
    [self getNetWorkData];   //定位成功后进行网络请求
    
}


#pragma mark - getNetWorkData
//网络请求方法
-(void) getNetWorkData
{
   
    [self.leftColumnArray removeAllObjects];
    [self.rightColumnArray removeAllObjects];

    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

     NSDictionary *getPoiListDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"network",
                                   [NSNumber numberWithInt:3], @"distance",
                                   @"", @"uid",
                                   [defaults objectForKey:@"currentLocution"],@"location",
                                   [NSNumber numberWithInt:self.limit], @"limit",
                                   [NSNumber numberWithInt:0], @"start",
                                   nil];
    
    
    NetworkConnection *networkConnection2 = [[NetworkConnection alloc] init];
    networkConnection2.delegate = self;  // 实现NetworkConnection代理
    
    [networkConnection2 initWithBaseUrl:KBaseURL functionUrl:kPOI methodUrl:KGetPoiList params:getPoiListDic];
    [networkConnection2 release];

    self.addressLabel.text = [defaults objectForKey:@"addressName"];

}



#pragma  mark - addedMapView

-(void) addedMapView  //添加地图视图
{

        //在试图控制器上添加一个半透明的试图
        self.backView = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.window.bounds.size.height)] autorelease];
//        [self.backView addTarget:self action:@selector(hiddenMapView) forControlEvents:UIControlEventTouchUpInside];
 
        
        self.midMapView = [[[DistrictView alloc] init] autorelease];
        self.midMapView.backgroundColor = [UIColor whiteColor];
        self.midMapView.userInteractionEnabled = YES;
    
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.backgroundColor = [UIColor clearColor];
        [aButton addTarget:self action:@selector(hiddenMapView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bButton.backgroundColor = [UIColor clearColor];
        [bButton addTarget:self action:@selector(hiddenMapView) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (iPhone5)
        {
            self.midMapView.frame = CGRectMake(15, 70, 290, 430);
            aButton.frame = CGRectMake(0, 0, 320, 70);
            bButton.frame = CGRectMake(0, 500, 320, 68);
        }
        else
        {
            self.midMapView.frame = CGRectMake(15, 60, 290, 370);
            aButton.frame = CGRectMake(0, 0, 320, 60);
            bButton.frame = CGRectMake(0, 430, 320, 50);
        }
        
        [self.backView addSubview:aButton];
        [self.backView addSubview:bButton];
    
    
        self.midMapView.currentLocation = self.currentLocation;
        
        [self.midMapView getMapData];
        
        [ self.midMapView.selectedButton addTarget:self action:@selector(selectedAddressButton) forControlEvents:UIControlEventTouchUpInside];
 
        
        [self.backView addSubview: self.midMapView];
        
        self.backView.backgroundColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:0.8];
        [self.view.window addSubview: self.backView];

}



-(void) hiddenMapView
{
    self.backView.hidden = YES;

}


-(void) selectedAddressButton
{
   //地图中心点的坐标
    CLLocation    *selectedLocation = [[CLLocation alloc] initWithLatitude:(self.midMapView.locationMapView.centerCoordinate.latitude) longitude:(self.midMapView.locationMapView.centerCoordinate.longitude)];
    
    //逆向地理编码
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:selectedLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *mark in placemarks)
         {
             
             NSString *str = [[[placemarks objectAtIndex:0] name] substringToIndex:2];
             
             NSString *addressTitle = [[[NSString alloc] init] autorelease];
             NSString *cityName = [[[NSString alloc] init] autorelease];
              cityName     = [[[placemarks objectAtIndex:0] name] substringWithRange:NSMakeRange(2, 2)];
             if ([str isEqualToString:@"中国"])
             {
                 addressTitle = [[[placemarks objectAtIndex:0] name] substringFromIndex:5]; //从第五位开始取， 取出地址
            }
             else
             {
                 addressTitle = [[placemarks objectAtIndex:0] name];
             }
             //将地址存为单例
             self.addressLabel.text = addressTitle;
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
             [defaults setObject: addressTitle forKey:@"addressName"];
//             NSLog(@"selectedaddressTitle = %@", addressTitle);

             [defaults setObject:cityName forKey:@"cityName"];
         }
         
     }];

   //将坐标转换为数组作为参数
    NSArray *locationArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:selectedLocation.coordinate.longitude],[NSNumber numberWithFloat:selectedLocation.coordinate.latitude], nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: locationArray forKey:@"currentLocution"];
    
 
    //选定地址后重新请求数据 加载瀑布流
    [self getNetWorkData];
    
    [self.backView removeFromSuperview]; //一定要最后才remove掉
    
}


#pragma mark ---NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result;
{
    
    self.poiListResult = (POIListInfo *) result;
        
    [self separateToColumn];
    
    [self.waterFlowView reloadData];
 
    [self setFooterView];
    
}

-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error
{
    NSLog(@"error = %@", error);
}



#pragma mark - Init Data

//按照行高将瀑布流分行， 每次都添加到矮的那一行
-(void) separateToColumn
{
    self.leftColumnHeight = 0;
    self.rightColumnHeight = 0;
    for (POIInfo *poiInfo in self.poiListResult.poiListArray)
    {
        CGFloat height = [self calculateCellHeightWithPOIName:poiInfo.poiName imageHeight:poiInfo.poiImageSize];
        
        if (self.leftColumnHeight == 0)
        {
            [self.leftColumnArray addObject:poiInfo];
            self.leftColumnHeight += height;
        }
        else
        {
            if (self.leftColumnHeight > self.rightColumnHeight)
            {
                [self.rightColumnArray addObject: poiInfo];
                self.rightColumnHeight += height;
            }
            else
            {
                [self.leftColumnArray addObject:poiInfo];
                self.leftColumnHeight += height;
            }
        }
    }
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray,nil];
    
}

//这个方法判断每列的高度，cell添加到低的那一列
-(CGFloat) calculateCellHeightWithPOIName:(NSString *)poiName imageHeight:(CGSize)poiImageSize
{
    CGSize textSize = [poiName sizeWithFont:[UIFont systemFontOfSize:kPOINamTextSize] constrainedToSize:CGSizeMake(kPOINamTextWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat cellHeight;   //初始化一个float数据作为行高
    
    cellHeight = textSize.height + poiImageSize.height * (kPoiImageWidth /poiImageSize.width);
    
    return cellHeight;
    
}



#pragma mark --WaterFlowDataSource

//每列的行数
- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)column
{
    
    return  [[self.dataArray objectAtIndex: column] count];
    
}

//给cell数据
- (POICell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"poiCell";
    
    POICell *cell = (POICell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[POICell alloc] initWithIdentifier:cellIdentifier];
    }
    
    POIInfo *poiInfo = [[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    cell.poiIndo = poiInfo;
    
    return cell;
    
    
}

//行高
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    
    POIInfo *poiInfo = [[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    return (CGFloat)[POICell cellHeight: poiInfo];
    
    
}

//瀑布流分为多收列
- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{  
    return kWaterFlowColumnNum;
}

//选中每行后所做的操作
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    
    POIDetailViewController * poiDetailVC = [[POIDetailViewController alloc] init];
    poiDetailVC.poiInfo = [[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:poiDetailVC animated:YES];
    [poiDetailVC release];
    
}

///**************************
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark - creating and removing the header view methods

-(void)createHeaderView
{
    
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f,
                                     0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width,
                                     self.view.bounds.size.height)];
    
    _refreshHeaderView.delegate = self;
    
	[self.waterFlowView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}


-(void)setFooterView
{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.waterFlowView.contentSize.height, self.waterFlowView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.waterFlowView.frame.size.width,
                                              self.view.bounds.size.height);
    }
    else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         height,
                                                                                         self.waterFlowView.frame.size.width,
                                                                                         self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        
        [self.waterFlowView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}


#pragma mark - force to show the refresh headerView

-(void)showRefreshHeader:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.waterFlowView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // 
        [self.waterFlowView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.waterFlowView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.waterFlowView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}


//刷新delegate  重新请求数据
#pragma mark - data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
	//  should be calling your tableviews data source model to reload
	self.isReloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
    }
    else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
    }
    
	// overide, the actual loading data operation is done in the subclass
}



#pragma mark - method that should be called when the refreshing is finished

- (void)finishReloadingData
{
	//  model should call this when its done loading
	self.isReloading = NO;
    
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.waterFlowView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.waterFlowView];
        [self setFooterView];
    }
 
}

#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self.waterFlowView];
    }
	
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:self.waterFlowView];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.waterFlowView];
    }
	
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:self.waterFlowView];
    }
}



#pragma mark *******EGORefreshTableDelegate*******

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];

}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return self.isReloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date]; // should return date data source was last changed
}


-(void)refreshView
{

    [self testFinishedLoadData];
 
}


//上拉加载时调用的方法
-(void)getNextPageView
{
    
    [self removeFooterView];
    
    
    static int i = 1;
        
    self.start = (i++)* self.limit;//加载更多每次都从上次请求的数据基础上加载更多
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *locationArray = [defaults objectForKey:@"currentLocution"];

    
    //拼接请求字典
    NSDictionary *getPoiListDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"network",
                                   [NSNumber numberWithInt:2], @"distance",
                                   @"", @"uid",
                                   locationArray,@"location",
                                   [NSNumber numberWithInt:self.limit], @"limit",
                                   [NSNumber numberWithInt:self.start], @"start",
                                   nil];
    
    //建立网络连接，请求数据
    NetworkConnection *networkConnection = [[NetworkConnection alloc] init];
    networkConnection.delegate = self; // 实现NetworkConnection代理
    
    [networkConnection initWithBaseUrl:KBaseURL functionUrl:kPOI methodUrl:KGetPoiList params:getPoiListDic];
    
    [networkConnection release];
    
    
    [self testFinishedLoadData];
    

}


-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}



- (void)dealloc
{
    [self.currentLocation release];
    [self.locationManager release];
    [self.leftColumnArray release];
    [self.rightColumnArray release];
    [self.backView release];
    [self.waterFlowView release];
    [self.dataArray release];
    [self.poiListResult release];
    [self.refreshHeaderView release];
    [self.refreshFooterView release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
