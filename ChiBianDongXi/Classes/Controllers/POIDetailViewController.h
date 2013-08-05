//
//  POIDetailViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/11/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "WaterFlowView.h"
#import "BaseViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "NetworkConnection.h"
#import "SinaWeibo.h"
@class POIShareList;
@class ArticleInfo;
@interface POIDetailViewController : BaseViewController <WaterFlowViewDelegate, WaterFlowViewDataSource, NetworkConnectionDelegate,
EGORefreshTableDelegate, UIScrollViewDelegate,UIActionSheetDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) POIInfo * poiInfo;
@property (nonatomic,retain) ArticleInfo *articleInfo;
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
@property (assign, nonatomic) int recommendArticleArrayCount;
@property (assign, nonatomic) BOOL isReloading;//是否加载数据中
@property (assign, nonatomic) int pageNo;
@property (nonatomic,retain) UIView *headView;
@property(nonatomic,retain)UIView *vegetableView;
@property (strong, nonatomic) POIShareList * POIShareInfoResult;
@property (nonatomic,assign)  BOOL collected;
@property (nonatomic,retain) UIButton *shareBtn;
@property (nonatomic,retain) UIButton *collectButton;
@property (nonatomic,retain) UIImage *tempImage;
@property (nonatomic,retain) UIWebView *phoneCallWebView;
@property (nonatomic,retain) UIImageView *bigImageView;
@property (assign, nonatomic) int start;
@property (assign, nonatomic) int limit ;
@property (nonatomic,assign) float vegetableViewHeight;
@end
