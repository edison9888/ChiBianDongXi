//
//  ArticlesByTagViewController.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-19.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "ArticlesByTagViewController.h"

#import "POIInfo.h"
#import "NetConnectionMacro.h"
#import "POIDetailViewController.h"
#import "TagInfo.h"
#import "TagArticlesInfo.h"
#import "TagCell.h"
#import "ArticleDetailViewController.h"
#import "WeekendViewController.h"


#define kWeekendImageWidth 155.5
#define kWeekendTextSize 10.0
#define kWeekendTextWidth 60
#define kWaterFlowColumnNum 2
@interface ArticlesByTagViewController ()

@end

@implementation ArticlesByTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.start = 0;
        self.limit = 12;
        self.dataArray = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *pushWeekItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(pushWeek)];
    [self.navigationItem setLeftBarButtonItem:pushWeekItem];

    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",self.tagInfo.tagName]];
	self.leftColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray, nil];
    
	self.pageNo = 0;
    
    CGRect rect = self.view.frame;
    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) headerViewHeight:0.0f];
    self.waterFlowView.backgroundColor = [UIColor grayColor];
    
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate = self;
    [self createHeaderView];
    [self setFooterView];
    [self.view addSubview:self.waterFlowView];
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityName = [userDefaults objectForKey:@"cityName"];
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [paramsDic setObject:self.tagInfo.tagName forKey:@"tag"];
    [paramsDic setObject:[NSNumber numberWithInt:20] forKey:@"limit"];
    
    if ([cityName isEqualToString:@""] || cityName == nil)
    {
        [paramsDic setObject:@"北京" forKey:@"city"];
    }
    else
    {
        [paramsDic setObject:cityName forKey:@"city"];
    }

    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kArticle methodUrl:KSearchByTag params:paramsDic];
    
    
    [self createHeaderView]; //创建下拉刷新
    [self setFooterView];    //创建上拉加载更多
    
}


-(void)pushWeek
{
    WeekendViewController *weekVC = [[WeekendViewController alloc] init];
    [self.navigationController pushViewController:weekVC animated:YES];
}


#pragma mark - NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.tagArticlesInfoResult = (TagArticlesInfo *)result;
    [self separateToColumn];
    [self.waterFlowView reloadData];
}

-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error
{
    NSLog(@"error %@", error);
}

#pragma mark - Init Data

-(void) separateToColumn
{
    self.leftColumnHeight = 0;
    self.rightColumnHeight = 0;
    
    for ( TagArticlesInfo* aTagArticlesInfo in self.tagArticlesInfoResult.tagArticlesInfoArray)
    {
        CGFloat height = [self calculateCellHeightWithText:aTagArticlesInfo.defaultText authorImage:aTagArticlesInfo.defaultImageUrl defaultImageUrl:aTagArticlesInfo.defaultImageUrl];
        
        if (self.leftColumnHeight == 0.0)
        {
            [self.leftColumnArray addObject:aTagArticlesInfo];
            self.leftColumnHeight += height;
        }
        else
        {
            if (self.leftColumnHeight <= self.rightColumnHeight)
            {
                [self.leftColumnArray addObject:aTagArticlesInfo];
                self.leftColumnHeight += height;
                
                
            }
            else
            {
                [self.rightColumnArray addObject:aTagArticlesInfo];
                self.rightColumnHeight += height;
            }
        }
    }
    
}

-(CGFloat) calculateCellHeightWithText:(NSString *)text authorImage:(NSString *)authorImage defaultImageUrl:(NSString *)defaultImageUrl
{
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:kWeekendTextSize] constrainedToSize:CGSizeMake(kWeekendTextWidth, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat cellHeight;
    
    if ([authorImage isEqualToString:@""])
    {
        if ([defaultImageUrl isEqualToString:@""])
        {
            cellHeight = textSize.height;
        }
        else
        {
            cellHeight = textSize.height + 153;
        }
        
    }
    else
    {
        if ([defaultImageUrl isEqualToString:@""])
        {
            cellHeight = textSize.height + 35;
        }
        else
        {
            cellHeight = textSize.height + 35 + 153;
        }
        
    }
    return cellHeight;
}

#pragma mark - WaterFlowViewDataSource

//每列的行数
- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)column
{
    
    return [[self.dataArray objectAtIndex:column] count];
}

- (TagCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"TagCell";
    
    TagCell *cell = (TagCell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[TagCell alloc] initWithIdentifier:cellIdentifier] autorelease];
    }
    
    TagArticlesInfo *tagAriclesInfo = (TagArticlesInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    cell.tagArticlesInfo = tagAriclesInfo;
    
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    TagArticlesInfo *tagAriclesInfo = (TagArticlesInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    return [TagCell cellHeight:tagAriclesInfo];
}

//瀑布流列数
- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return kWaterFlowColumnNum;
}
//代理方法
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
     TagArticlesInfo *tagArticlesInfo = (TagArticlesInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    ArticleDetailViewController *articleDetailVC =[[ArticleDetailViewController alloc] init];
    NSDictionary *tagArticleDic = [[NSDictionary alloc] initWithObjectsAndKeys:tagArticlesInfo.articleId,@"articleId", nil];
    articleDetailVC.paramsDic = tagArticleDic;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
    [articleDetailVC release];
    
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
  
    //拼接请求字典
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [paramsDic setObject:self.tagInfo.tagName forKey:@"tag"];
    [paramsDic setObject:[NSNumber numberWithInt:20] forKey:@"limit"];
    [paramsDic setObject:@"北京" forKey:@"city"];
    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kArticle methodUrl:KSearchByTag params:paramsDic];
 
    [self testFinishedLoadData];
    
    
}

- (void)dealloc
{
    self.tagArticlesInfoResult = nil;
    self.recommendation = nil;
    self.networkConnection = nil;
    self.waterFlowView = nil;
    self.dataArray = nil;
    self.leftColumnArray = nil;
    self.rightColumnArray = nil;
    self.imageArray = nil;
    self.refreshHeaderView = nil;
    self.refreshFooterView = nil;
    self.tagInfo = nil;
    [super dealloc];
}


-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
