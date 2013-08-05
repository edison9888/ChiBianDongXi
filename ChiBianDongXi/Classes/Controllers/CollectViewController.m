//
//  CollectViewController.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "CollectViewController.h"
#import "DataHandle.h"
#import "CollectInfo.h"
#import "CollectFirstCell.h"
#import "CollectSecondCell.h"
#import "ArticleDetailViewController.h"
#import "POIDetailViewController.h"
#import "WeekendViewController.h"
#import "LeftEdgeViewController.h"

@interface CollectViewController ()

@end

@implementation CollectViewController

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
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
//    self.tableView.allowsSelection = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView release];
    [self getPOIDetailCollectData];
 
    [self.tableView reloadData];
    
}

-(void)pushWeek
{
    WeekendViewController *weekVC = [[WeekendViewController alloc] init];
    [self.navigationController pushViewController:weekVC animated:YES];
    [weekVC release];
}

-(void)getPOIDetailCollectData
{
    self.collectInfoArray =[DataHandle getAllCollectInfo];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _collectInfoArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectInfo *collectInfo = [_collectInfoArray objectAtIndex:indexPath.row];
    //条件判断
    if (collectInfo.articleContent == nil) {
        static NSString *CellIdentifier = @"Cell";
        CollectFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[CollectFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.collectInfo = collectInfo;
        return cell;
    }else
    {
        static NSString *SecondCellIdentifier = @"SecondCell";
        CollectSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:SecondCellIdentifier];
        if (cell == nil) {
            cell = [[[CollectSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondCellIdentifier] autorelease];
        }
        cell.collectInfo = collectInfo;
        //取消cell的选取高亮效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectInfo *collect = [_collectInfoArray objectAtIndex:indexPath.row];
    if (collect.articleContent == nil) {
        POIDetailViewController *restaurantVC = [[POIDetailViewController alloc] init];
        restaurantVC.collected = YES;
        POIInfo *poiInfo = [[POIInfo alloc] init];
        poiInfo.poiId = collect.poiId;
        poiInfo.poiName = collect.poiName;
        poiInfo.poiCategory = collect.poiCategory;
        poiInfo.poiScore = collect.poiScore;
        poiInfo.poiAverageSpend = [NSString stringWithFormat:@"%0.2f",collect.poiPerCapita];
        poiInfo.poiAddress = collect.poiAddress;
        poiInfo.poiPhone = collect.poiPhone;
        restaurantVC.poiInfo = poiInfo;
        [self.navigationController pushViewController:restaurantVC animated:YES];
        
    }
    else
    {
        ArticleDetailViewController *articleVC = [[ArticleDetailViewController alloc] init];
        NSDictionary *collectDic = [[NSDictionary alloc] initWithObjectsAndKeys:collect.articleId,@"articleId", nil];
        articleVC.paramsDic = collectDic;
        articleVC.collected = YES;
        [self.navigationController pushViewController:articleVC animated:YES];
    }   
}
- (void)dealloc
{
    self.collectInfoArray = nil;
    self.collectPoiInfo = nil;
    [super dealloc];
}
@end
