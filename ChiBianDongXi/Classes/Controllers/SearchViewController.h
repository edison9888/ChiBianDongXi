//
//  SearchViewController.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-22.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NetworkConnection.h"
#import "WaterFlowView.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
@class NetworkConnection;
@class POIInfo;
@class WaterFlowView;
@class SearchListInfo;
@interface SearchViewController : BaseViewController<NetworkConnectionDelegate, WaterFlowViewDataSource,WaterFlowViewDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) NetworkConnection * networkConnection;
@property (nonatomic,retain) NSString *searchStr;
@property (nonatomic,retain) POIInfo *poiInfoResult;
@property (strong, nonatomic) WaterFlowView* waterFlowView;
@property (strong, nonatomic) NSMutableArray    * leftColumnArray;//瀑布流左列数据
@property (strong, nonatomic) NSMutableArray    * rightColumnArray;//瀑布流右列数据
@property (strong, nonatomic) NSMutableArray    * imageArray;//图片数组
@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;
@property (assign, nonatomic) CGFloat           leftColumnHeight;//左列高度
@property (assign, nonatomic) CGFloat           rightColumnHeight;//右列高度
@property (assign, nonatomic) BOOL isReloading;  //  判断是否加载数据中
@property (strong, nonatomic) SearchListInfo     *searchListResult;
@property (strong, nonatomic) NSMutableArray    * dataArray;//二维数组。存放每列的值
@property (nonatomic, retain)  NSArray           *locationArray;  //坐标值  此处作为定位参数去请求数据
@property (nonatomic,retain) UISegmentedControl  *segControl;
@property (strong, nonatomic) NSMutableArray * viewControllers;
@property (assign, nonatomic) int           start;
@property (assign, nonatomic) int           limit ;
@property (assign, nonatomic) int           sortType ;
@end
