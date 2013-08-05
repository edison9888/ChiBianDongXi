//
//  WeekendViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/8/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "WeekendViewController.h"
#import "Weekend.h"
#import "NetworkConnection.h"
#import "NetConnectionMacro.h"
#import "ArticleInfo.h"
#import "TagInfo.h"
#import "TopicInfo.h"
#import "CellHeightMacro.h"
#import "WeekendCell.h"
#import "ArticleDetailViewController.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"
#import "TopicDetailViewController.h"
#import "TagViewController.h"
#import "CollectViewController.h"
#define kWeekendImageWidth 155.5

#define kWeekendTextSize 10.0
#define kWeekendTextWidth 60

#define kWaterFlowColumnNum 2

@interface WeekendViewController ()

@end

@implementation WeekendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString * cityName =  [defaults objectForKey:@"cityName"];

    self.limit = 20;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style: UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchButton;

    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showList:)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.leftColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray, nil];
    
	self.pageNo = 0;
    
    CGRect rect = self.view.frame;

    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) headerViewHeight:190.0f];
    self.waterFlowView.backgroundColor = [UIColor grayColor];
    
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate = self;
    
    [self.view addSubview:self.waterFlowView];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSMutableDictionary * paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    
    if ([[defaults objectForKey:@"cityName"] isEqualToString:@""] || [defaults objectForKey:@"cityName"] == nil)
    {
        [paramsDic setObject:@"北京" forKey:@"city"];
    }
    else
    {
        [paramsDic setObject:[defaults objectForKey:@"cityName"] forKey:@"city"];
    }
    [paramsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kTopic methodUrl:KGetHomePage params:paramsDic];
    [paramsDic release];
    
    [self createHeaderView];
    [self setFooterView];
}

-(void)search
{
    TagViewController *tagVC = [[TagViewController alloc]init];

    [self.navigationController pushViewController:tagVC animated:YES];
    [tagVC release];
    
}

-(void)show:(BOOL)animated
{
    [UIView beginAnimations:nil context:nil];
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity) name:@"chooseCity" object:nil];
    
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC addPanGestureRecognizer];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC removePanGestureRecognizer];
}

- (void)changeCity
{
    NSLog(@"sssssd");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSMutableDictionary * paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    
    if ([[defaults objectForKey:@"cityName"] isEqualToString:@""] || [defaults objectForKey:@"cityName"] == nil)
    {
        [paramsDic setObject:@"北京" forKey:@"city"];
    }
    else
    {
        [paramsDic setObject:[defaults objectForKey:@"cityName"] forKey:@"city"];
    }
    [paramsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    
    [[self.dataArray objectAtIndex:0] removeAllObjects];
    [[self.dataArray objectAtIndex:1] removeAllObjects];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kTopic methodUrl:KGetHomePage params:paramsDic];
    [paramsDic release];

    [self.waterFlowView reloadData];
}

- (void)enableUserInterface
{
    self.view.userInteractionEnabled = YES;
}
- (void)unEnableUserInterface
{
    self.view.userInteractionEnabled = NO;
}

//-(void)loadListBarItem
//{
//    NSLog(@"-->%@",self.navigationItem);
//}

-(void)showList:(id)sender
{
    [self.delegate fold];
}

#pragma mark - Tap Cell To Next Page
-(void) tapImageView:(UIGestureRecognizer *) tap
{
    TopicDetailViewController * topicDetailVC = [[TopicDetailViewController alloc] init];
    TopicInfo * topicInfo = [self.weekendResult.topicArray objectAtIndex:(tap.view.tag - 1000)];
    topicDetailVC.topicId = topicInfo.topicId;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    [topicDetailVC release];
}

-(void) changeOffset:(UIPageControl*) pageControl
{
    [self.topicScrollView setContentOffset:CGPointMake(310 * pageControl.currentPage, 0) animated:YES];
}

#pragma mark - NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.weekendResult = (Weekend *)result;

    [self separateToColumn];
    

    self.topicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, 310, 180)];
    self.topicScrollView.contentSize = CGSizeMake(310 * self.weekendResult.topicArray.count, 180);
    
    for (int i = 0; i < self.weekendResult.topicArray.count; i++)
    {
        TopicInfo * topicInfo = [self.weekendResult.topicArray objectAtIndex:i];
        AsynImageView * topicImageView = [[AsynImageView alloc] init];
        //        一定要算好每个图片的起始位置  重点
        topicImageView.frame = CGRectMake(310 * i, 0, 310, 180);
        topicImageView.tag = 1000 + i;
        topicImageView.urlString = [NSString stringWithFormat:@"%@/%d/%d/%@", kImageURL, (int)topicInfo.topicImageSize.width, (int)topicInfo.topicImageSize.height, topicInfo.topicImageUrl];
        topicImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [topicImageView addGestureRecognizer:tap];
        [tap release];
        [self.topicScrollView addSubview:topicImageView];
        [topicImageView release];

    }
    
    self.topicScrollView.scrollEnabled = YES;
    self.topicScrollView.pagingEnabled = YES;
    self.topicScrollView.showsHorizontalScrollIndicator = YES;
    self.topicScrollView.backgroundColor = [UIColor cyanColor];
    self.topicScrollView.delegate = self;
    
    [self.waterFlowView addSubview:self.topicScrollView];
    [self.topicScrollView release];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, 160, 40, 20)];
    self.pageControl.numberOfPages = self.weekendResult.topicArray.count;
    [self.pageControl addTarget:self action:@selector(changeOffset:) forControlEvents:UIControlEventValueChanged];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.waterFlowView addSubview:self.pageControl];
    [self.pageControl release];

    
    [self.waterFlowView reloadData];
    
    [self setFooterView];
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

    for (ArticleInfo * article in self.weekendResult.articleArray)
    {
        CGFloat height = [self calculateCellHeightWithText:article.articleIntroduction userInfo:article.userInfo imageHeight:article.articleImageSize];
        if (self.leftColumnHeight == 0.0)
        {
            [self.leftColumnArray addObject:article];
            self.leftColumnHeight += height;
        }
        else
        {
            if (self.leftColumnHeight > self.rightColumnHeight)
            {
                [self.rightColumnArray addObject:article];
                self.rightColumnHeight += height;
            }
            else
            {
                [self.leftColumnArray addObject:article];
                self.leftColumnHeight += height;
            }
        }
    }
//    for (TagInfo * tagInfo in self.weekendResult.tagArray)
//    {
//        CGFloat height = tagInfo.tagImageSize.height;
//        
//        if (self.leftColumnHeight == 0.0)
//        {
//            [self.leftColumnArray addObject:tagInfo];
//            self.leftColumnHeight += height;
//        }
//        else
//        {
//            if (self.leftColumnHeight > self.rightColumnHeight)
//            {
//                [self.rightColumnArray addObject:tagInfo];
//                self.rightColumnHeight += height;
//            }
//            else
//            {
//                [self.leftColumnArray addObject:tagInfo];
//                self.leftColumnHeight += height;
//            }
//        }
//    }
}

-(CGFloat) calculateCellHeightWithText:(NSString *)text userInfo:(UserInfo *)userInfo imageHeight:(CGSize)imageSize
{
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:kWeekendTextSize]
                       constrainedToSize:CGSizeMake(kWeekendTextWidth, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat cellHeight;
    
    if (userInfo)
    {
        if (imageSize.height == 0)
        {
            cellHeight = textSize.height + 35;
        }
        else
        {
            cellHeight = textSize.height + 35 + imageSize.height * (kWeekendImageWidth / imageSize.width);
        }
    }
    else
    {
        if (imageSize.height == 0)
        {
            cellHeight = textSize.height;
        }
        else
        {
            cellHeight = textSize.height + imageSize.height * (kWeekendImageWidth / imageSize.width);
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

- (WeekendCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WeekendCell";
    
    WeekendCell *cell = (WeekendCell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[WeekendCell alloc] initWithIdentifier:cellIdentifier] autorelease];
    }
    ArticleInfo * articleInfo = (ArticleInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    cell.articleInfo = articleInfo;
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    ArticleInfo * articleInfo = (ArticleInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    return [WeekendCell cellHeight:articleInfo];
}

//瀑布流列数
- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return kWaterFlowColumnNum;
}

#pragma mark - WaterFlowViewDelegate

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    ArticleDetailViewController * articleDetailVC = [[ArticleDetailViewController alloc] init];
    ArticleInfo * articleInfo = (ArticleInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:articleInfo.articleId, @"articleId", nil];
    articleDetailVC.paramsDic = dic;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
    [articleDetailVC release];
}


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
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
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
        // scroll the table view to the top region
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
//        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
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
    
    CGFloat midPageWidth = scrollView.frame.size.width / 2;
    
    int page = (scrollView.contentOffset.x - midPageWidth) / 320 + 1;
    
    self.pageControl.currentPage = page;
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


#pragma mark - EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	return self.isReloading; // should return if data source model is reloading
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

//刷新调用的方法
-(void)refreshView
{
//    Weekend * weekendData = [[Weekend alloc] init];
//    NSLog(@"Refresh New!!");
//    NetworkConnection * networkConnection = [[NetworkConnection alloc] init];
//    networkConnection.delegate = self;
//    
//    NSMutableDictionary * paramsDic = [[NSMutableDictionary alloc] init];
//    [paramsDic setObject:[NSNumber numberWithInt:self.pageNo] forKey:@"start"];
//    [paramsDic setObject:@"北京" forKey:@"city"];
//    [paramsDic setObject:[NSNumber numberWithInt:10] forKey:@"limit"];
//    
//    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kTopic methodUrl:KGetHomePage params:paramsDic];
//    [paramsDic release];
    [self testFinishedLoadData];
    
}

//加载调用的方法
-(void)getNextPageView
{
    [self removeFooterView];
    if (self.recommendArticleArrayCount == 0)
    {
        for (int i = 0; i < self.weekendResult.articleArray.count; i++)
        {
            ArticleInfo * articleInfo = (ArticleInfo *)[self.weekendResult.articleArray objectAtIndex:i];
            if ([articleInfo.type isEqualToString:@"RecommendArticleInfo"])
            {
                self.recommendArticleArrayCount++;
                NSLog(@"reCount %d", self.recommendArticleArrayCount);
            }
        }
    
    }

    self.start = (self.leftColumnArray.count + self.rightColumnArray.count) - self.recommendArticleArrayCount;
   
    NetworkConnection * networkConnection = [[NetworkConnection alloc] init];
    networkConnection.delegate = self;
    
    NSMutableDictionary * paramsDic = [[NSMutableDictionary alloc] init];
    [paramsDic setObject:[NSNumber numberWithInt:self.start] forKey:@"start"];
    [paramsDic setObject:@"北京" forKey:@"city"];
    [paramsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kTopic methodUrl:KGetHomePage params:paramsDic];
    [paramsDic release];
    
    
    [self testFinishedLoadData];
    
}


-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Dealloc

- (void)dealloc
{
    self.weekendResult = nil;
    self.leftColumnArray = nil;
    self.rightColumnArray = nil;
    self.pageControl = nil;
    self.topicScrollView = nil;
    [super dealloc];
}

@end
