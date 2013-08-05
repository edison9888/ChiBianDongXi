//
//  NearByHottestViewController.h
//  ChiBianDongXi
//
//  Created by lanou on 7/8/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NetworkConnection.h"
#import "WaterFlowView.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@class POIListInfo;
@class DistrictView;



@interface NearByHottestViewController : BaseViewController<CLLocationManagerDelegate, NetworkConnectionDelegate, WaterFlowViewDataSource,WaterFlowViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>
{
    //NSUserDefaults *defaults;
}
@property (nonatomic ,retain) CLLocationManager  *locationManager;    //地理定位器
@property (nonatomic, retain) CLLocation         *currentLocation;    //地图定位坐标

@property (strong, nonatomic) WaterFlowView     * waterFlowView;  //瀑布流
@property (strong, nonatomic) NSMutableArray    * dataArray;//二维数组。存放每列的值

@property (strong, nonatomic) UILabel           *addressLabel;   //地址title
@property (strong, nonatomic) UIControl         *backView;  //地图后面半透明的背景图
@property (strong, nonatomic) DistrictView      *midMapView;  //弹出来的地图视图

@property (strong, nonatomic) NSMutableArray    * leftColumnArray;//瀑布流左列数据
@property (strong, nonatomic) NSMutableArray    * rightColumnArray;//瀑布流右列数据


@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;
@property (strong, nonatomic) POIListInfo     *poiListResult;

@property (assign, nonatomic) CGFloat       leftColumnHeight;//左列高度
@property (assign, nonatomic) CGFloat       rightColumnHeight;//右列高度
@property (assign, nonatomic) BOOL          isReloading;  //  判断是否加载数据中
@property (assign, nonatomic) int           start;
@property (assign, nonatomic) int           limit ;



@end
