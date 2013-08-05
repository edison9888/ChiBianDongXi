//
//  RecommendViewController.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-18.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WaterFlowView.h"
#import "BaseViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "NetworkConnection.h"
@class POIInfo;
@class POIShareInfo;
@class POIShareList;
@interface RecommendViewController : BaseViewController <WaterFlowViewDelegate, WaterFlowViewDataSource, NetworkConnectionDelegate,
EGORefreshTableDelegate, UIScrollViewDelegate>

@property (nonatomic,retain) POIInfo *poiInfo;
@property (nonatomic,retain) POIShareInfo *poiShareInfo;
@property (nonatomic,retain) NSString *recommendation;
@property (strong, nonatomic) NetworkConnection * networkConnection;
@property (strong, nonatomic) WaterFlowView * waterFlowView;
@property (strong, nonatomic) NSMutableArray * dataArray;//二维数组。存放每列的值
@property (strong, nonatomic) NSMutableArray * leftColumnArray;//瀑布流左列数据
@property (strong, nonatomic) NSMutableArray * rightColumnArray;//瀑布流右列数据
@property (assign, nonatomic) CGFloat  leftColumnHeight;//左列高度
@property (assign, nonatomic) CGFloat  rightColumnHeight;//右列高度
@property (strong, nonatomic) NSMutableArray * imageArray;//图片数组
@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;
@property (assign, nonatomic) BOOL isReloading;//是否加载数据中
@property (assign, nonatomic) int pageNo;
@property (strong, nonatomic) POIShareList * POIShareInfoResult;
@end
