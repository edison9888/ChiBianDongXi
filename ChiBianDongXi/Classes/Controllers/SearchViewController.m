//
//  SearchViewController.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-21.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "SearchViewController.h"
#import "NetConnectionMacro.h"
#import "NetworkConnection.h"
#import "WaterFlowView.h"
#import "POIInfo.h"
#import "POIListInfo.h"
#import "SearchInfoCell.h"
#import "POIDetailViewController.h"
#import "SearchListInfo.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"
#import "WeekendViewController.h"


#define kWaterFlowColumnNum 2
#define kPoiImageWidth  145
#define kPOINamTextSize 16.0
#define kPOINamTextWidth 135
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.start = 0;
        self.limit = 12;
        self.sortType = 1;
        self.dataArray = [[[NSMutableArray alloc] init] autorelease];
        self.locationArray = [[[NSArray alloc] init] autorelease];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *pushWeekItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(pushWeek)];
    [self.navigationItem setLeftBarButtonItem:pushWeekItem];
    
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"按距离",@"按热度", nil];
    self.segControl = [[UISegmentedControl alloc] initWithItems:segArray];
    [_segControl addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    _segControl.selectedSegmentIndex = 0;
    _segControl.frame = CGRectMake(5, 5, 30, 30);
    self.navigationItem.titleView = _segControl;
 
    self.view.backgroundColor = [UIColor grayColor];
	
    
    
    
    //*********创建瀑布流 ***********************************/
    
    self.leftColumnArray =  [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray,nil];
    
    //初始化一个瀑布流
    CGRect rect = self.view.frame;
    
    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 10, rect.size.width, rect.size.height) headerViewHeight:0.0f];
    //给瀑布流一个背景色
    self.waterFlowView.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    //设置代理
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate   = self;
    
    [self.view addSubview: self.waterFlowView];
    [self createHeaderView];
    [self setFooterView];
    
    [self netConnection];
    
    
}

-(void)pushWeek
{
    WeekendViewController *weekVC = [[WeekendViewController alloc] init];
    [self.navigationController pushViewController:weekVC animated:YES];
}

-(void)netConnection
{

    //搜索连接参数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"cityName"];
    self.locationArray = [userDefaults objectForKey:@"currentLocution"];

    NSMutableDictionary *searParamsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSUserDefaults * cbdxDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [cbdxDefaults objectForKey:@"userId"];
    if (userId != nil) {
        [searParamsDic setObject:userId forKey:@"uid"];
    }else
    {
        [searParamsDic setObject:@"" forKey:@"uid"];
    }
    
    if ([cityName isEqualToString:@""] || cityName == nil)
    {
        [searParamsDic setObject:@"北京" forKey:@"city"];
    }
    else
    {
        [searParamsDic setObject:cityName forKey:@"city"];
    }
    [searParamsDic setObject:@"0" forKey:@"network"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    [searParamsDic setObject:self.searchStr forKey:@"query"];
    [searParamsDic setObject:self.locationArray forKey:@"location"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.sortType] forKey:@"sortType"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.start] forKey:@"start"];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kSearch methodUrl:KSearchByKeyWord params:searParamsDic];
    [_networkConnection release];
    [_locationArray release];
}

-(void)changeType:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        _sortType = 1;
    }
    else
    {
        _sortType = 2;
    }
    [self netConnection];
    [self.leftColumnArray removeAllObjects];
    [self.rightColumnArray removeAllObjects];

}

#pragma mark ---NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result;
{
    self.searchListResult = (SearchListInfo *) result;
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
    for (POIInfo *poiInfo in self.searchListResult.searchInfoArray)
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
- (SearchInfoCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"searchInfoCell";
    
    SearchInfoCell *cell = (SearchInfoCell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[SearchInfoCell alloc] initWithIdentifier:cellIdentifier];
    }
    
    POIInfo *poiInfo = [[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    cell.poiIndo = poiInfo;
    
    return cell;
    
    
}

//行高
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    
    POIInfo *poiInfo = [[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    return (CGFloat)[SearchInfoCell cellHeight: poiInfo];
    
    
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


//加载调用的方法
-(void)getNextPageView
{
    [self removeFooterView];
 
    static int i = 1;
    
    self.start = (i++)* self.limit;//加载更多每次都从上次请求的数据基础上加载更多
    //拼接请求字典
    double longitude = 116.31759643554688;
    double latitude = 40.04306411743164;
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.locationArray = [defaults objectForKey:@"<#string#>"]
    
    self.locationArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:longitude],[NSNumber numberWithDouble:latitude], nil];
    NSMutableDictionary *searParamsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [searParamsDic setObject:@"504952ee0cf2ab3b6de82ee5" forKey:@"uid"];
    [searParamsDic setObject:@"北京" forKey:@"city"];
    [searParamsDic setObject:@"0" forKey:@"network"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    [searParamsDic setObject:self.searchStr forKey:@"query"];
    [searParamsDic setObject:self.locationArray forKey:@"location"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.sortType] forKey:@"sortType"];
    [searParamsDic setObject:[NSNumber numberWithInt:self.start] forKey:@"start"];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kSearch methodUrl:KSearchByKeyWord params:searParamsDic];

    [self testFinishedLoadData];
    [_networkConnection release];
    [_locationArray release];
}


-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}

- (void)dealloc
{
    self.networkConnection = nil;
    self.searchStr = nil;
    self.poiInfoResult = nil;
    self.waterFlowView = nil;
    self.leftColumnArray = nil;
    self.rightColumnArray = nil;
    self.imageArray = nil;
    self.refreshHeaderView = nil;
    self.refreshFooterView = nil;
    self.searchListResult = nil;
    self.dataArray = nil;
    self.locationArray = nil;
    self.segControl = nil;
    self.viewControllers = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
