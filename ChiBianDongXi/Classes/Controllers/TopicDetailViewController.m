//
//  TopicDetailViewController.m
//  ChiBianDongXi 2.0
//
//  Created by Andy Gu on 7/13/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "NetConnectionMacro.h"
#import "TopicInfo.h"
#import "TopicInfoCell.h"
#import "ArticleDetailViewController.h"

#define kWeekendImageWidth 155.5

#define kWeekendTextSize 10.0
#define kWeekendTextWidth 60

#define kWaterFlowColumnNum 2

@interface TopicDetailViewController ()

@end

@implementation TopicDetailViewController

@synthesize topicInfo = _topicInfo;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    NetworkConnection * networkConnection = [[NetworkConnection alloc] init];
    networkConnection.delegate = self;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:self.topicId, @"topicId", nil];
    [networkConnection initWithBaseUrl:KBaseURL functionUrl:kTopic methodUrl:KGetTopicDetail params:dic];
    [networkConnection release];
    
    
    self.leftColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray, nil];

    CGRect rect = self.view.frame;
    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.waterFlowView.backgroundColor = [UIColor grayColor];
    
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate = self;
    
    [self.view addSubview:self.waterFlowView];
    
}

#pragma mark - NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.topicInfo = (TopicInfo *)result;
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
    
    for (ArticleInfo * article in self.topicInfo.articleInfoArray)
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

- (TopicInfoCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TopicInfoCell";
    
    TopicInfoCell *cell = (TopicInfoCell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[TopicInfoCell alloc] initWithIdentifier:cellIdentifier] autorelease];
    }
    ArticleInfo * articleInfo = (ArticleInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    cell.articleInfo = articleInfo;
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    ArticleInfo * articleInfo = (ArticleInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    return [TopicInfoCell cellHeight:articleInfo];
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
    //    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kArticle methodUrl:KGetArticleDetail params:dic];
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
        [self setFooterView];
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
    TopicInfo * dataAccess = [[TopicInfo alloc]init];
    
    [self testFinishedLoadData];
    
}

//加载调用的方法
-(void)getNextPageView
{
    [self removeFooterView];
    TopicInfo * dataAccess = [[TopicInfo alloc]init];
    
    [self testFinishedLoadData];
    
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

- (void)dealloc
{
    [_topicInfo release];
    [super dealloc];
}

@end
