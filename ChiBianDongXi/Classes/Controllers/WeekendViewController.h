//
//  WeekendViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/8/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WaterFlowView.h"
#import "BaseViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "NetworkConnection.h"
@class Weekend;

@interface WeekendViewController : UIViewController <WaterFlowViewDelegate, WaterFlowViewDataSource, NetworkConnectionDelegate,
                                                        EGORefreshTableDelegate, UIScrollViewDelegate>

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
@property (assign, nonatomic) int topicImageViewIndex;
@property (strong, nonatomic) Weekend * weekendResult;
@property (strong, nonatomic) UIScrollView * topicScrollView;
@property (strong, nonatomic) UIPageControl * pageControl;

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) BOOL hasLoaded;

@property (assign, nonatomic) int start;
@property (assign, nonatomic) int limit;
@property (assign, nonatomic) int recommendArticleArrayCount;
@property (assign, nonatomic) int dataNumber;


-(void)show;

-(void)refreshUI;
//-(void)loadListBarItem;

- (void)enableUserInterface;
- (void)unEnableUserInterface;

@end
