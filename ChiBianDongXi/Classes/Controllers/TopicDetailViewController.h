//
//  TopicDetailViewController.h
//  ChiBianDongXi 2.0
//
//  Created by Andy Gu on 7/13/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WaterFlowView.h"
#import "BaseViewController.h"
#import "NetworkConnection.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@class TopicInfo;
@interface TopicDetailViewController : UIViewController<WaterFlowViewDelegate, WaterFlowViewDataSource,
                                                    NetworkConnectionDelegate,EGORefreshTableDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NSString * topicId;
@property (strong, nonatomic) TopicInfo * topicInfo;
@property (strong, nonatomic) WaterFlowView * waterFlowView;
@property (strong, nonatomic) NSMutableArray * dataArray;//二维数组。存放每列的值
@property (strong, nonatomic) NSMutableArray * leftColumnArray;//瀑布流左列数据
@property (strong, nonatomic) NSMutableArray * rightColumnArray;//瀑布流右列数据
@property (assign, nonatomic) CGFloat  leftColumnHeight;//左列高度
@property (assign, nonatomic) CGFloat  rightColumnHeight;//右列高度
@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;
@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;
@property (assign, nonatomic) BOOL isReloading;//是否加载数据中

@end
