//
//  FriendViewController.m
//  ChiBianDongXi
//
//  Created by lanou on 13-7-8.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "FriendViewController.h"
#import "NetConnectionMacro.h"
#import "CommentInfo.h"
#import "POIDetailViewController.h"
#import "FriendCell.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)dealloc
{
    [_friendTableView release];
    [_totalfArray release];
    [_commentList release];
    [_networkConnection release];
    [super dealloc];
}

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
//    self.limit = 10;
    
    self.totalfArray = [NSMutableArray arrayWithCapacity:1];
     self.poiInfoArray = [NSMutableArray arrayWithCapacity:1];
    
    self.friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;
    _friendTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_friendTableView];
    [_friendTableView release];
    
//    self.pageNo = 0;
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"userId"];
    
//    NSString * uid = @"504952ee0cf2ab3b6de82ee5";
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"start",userId,@"uid",[NSNumber numberWithInt:20],@"limit", nil];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kFeed methodUrl:KGetFriendFeed params:dic];
    [self.networkConnection release];
    
    [self createHeaderView];
}

#pragma mark - NetworkConnection delegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.commentList = (CommentList *)result;

//    NSLog(@"dffgsgsg %@",self.commentList.poiShareInfo.shareContent);

    for (CommentInfo * commentInfo in self.commentList.commentInfoArray)
    {
        POIShareInfo * poiShareInfo = [[POIShareInfo alloc] init];
        poiShareInfo = commentInfo.poiShareInfo;
        
        [_totalfArray addObject:poiShareInfo];
        [poiShareInfo release];
        
        POIInfo * poiInfo = [[POIInfo alloc] init];
        poiInfo = commentInfo.poiInfo;
        
        [_poiInfoArray addObject:poiInfo];
        [poiInfo release];

    }

    [_friendTableView reloadData];
}

- (void)getNewDidSuccessful:(FriendCell *)friend
{
    [_friendTableView reloadData];
}

-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error
{
    NSLog(@"error = %@" , error);
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_totalfArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * friendCellIndefier = @"friendCellIndefier";
    FriendCell * cell = [tableView dequeueReusableCellWithIdentifier:friendCellIndefier];
    if (cell == nil)
    {
        cell = [[[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendCellIndefier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CommentInfo * commentInfo = [[CommentInfo alloc] init];
    commentInfo = [self.commentList.commentInfoArray objectAtIndex:indexPath.row];
//    POIShareInfo * poiShareInfo = [_totalfArray objectAtIndex:indexPath.row];
//    POIInfo * poiInfo = [_poiInfoArray objectAtIndex:indexPath.row];
    cell.commentInfo = commentInfo;
//    cell.poiInfo = poiInfo;
//    cell.poiShareInfo = poiShareInfo;
//    [poiInfo release];
//    [poiShareInfo release];
    [commentInfo release];
    return cell;
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentInfo *commentInfo = [self.commentList.commentInfoArray objectAtIndex:indexPath.row];
    return [FriendCell cellHeight:commentInfo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    POIDetailViewController * poiDetailView = [[POIDetailViewController alloc] init];
    poiDetailView.poiInfo = [_poiInfoArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:poiDetailView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
	[self.view addSubview:_refreshHeaderView];
    
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
    UIEdgeInsets test = self.friendTableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.friendTableView.contentSize.height, self.friendTableView.frame.size.height);
    
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.friendTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }
    else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         height,
                                                                                         self.friendTableView.frame.size.width,
                                                                                         self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        
        [self.friendTableView addSubview:_refreshFooterView];
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
		self.friendTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.friendTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        self.friendTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.friendTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.friendTableView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.friendTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark - UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self.friendTableView];
    }
	
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidScroll:self.friendTableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.friendTableView];
    }
	
	if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:self.friendTableView];
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
//    CommentList * dataAccess = [[CommentList alloc] init];
    
//    self.networkConnection = [[NetworkConnection alloc] init];
//    self.networkConnection.delegate = self;
//    
//    NSUserDefaults * cbdxDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * userId = [cbdxDefaults objectForKey:@"userId"];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.pageNo],@"start",userId,@"uid",[NSNumber numberWithInt:10],@"limit", nil];
//    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kFeed methodUrl:KGetFriendFeed params:dic];
//    [self.networkConnection release];
//    
//    [self testFinishedLoadData];
//    [self setFooterView];
}

//加载调用的方法
-(void)getNextPageView
{
    [self removeFooterView];
    CommentList * dataAccess = [[CommentList alloc]init];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSUserDefaults * cbdxDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [cbdxDefaults objectForKey:@"userId"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"start",userId,@"uid",[NSNumber numberWithInt:10],@"limit", nil];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kFeed methodUrl:KGetFriendFeed params:dic];
    [self.networkConnection release];
    
    [self testFinishedLoadData];
    
}


-(void)testFinishedLoadData
{
    [self finishReloadingData];
    [self setFooterView];
}



@end
