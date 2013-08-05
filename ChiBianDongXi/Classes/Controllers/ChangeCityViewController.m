//
//  ChangeCityViewController.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "ChangeCityViewController.h"
#import "NetworkConnection.h"
#import "NetConnectionMacro.h"
#import "CityInfo.h"
#import "ChangeCityCell.h"
#import "LocalImage.h"
#import "CityList.h"
#import "WeekendViewController.h"
#import "NearByHottestViewController.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"

@interface ChangeCityViewController ()

@end

@implementation ChangeCityViewController
- (void)dealloc
{
    [_totalArray release];
    [_imageArray release];
    [_changeCityTableView release];
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
    
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, 50,30)];
    label.text = @"选择城市";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor redColor];
    self.navigationItem.titleView = label;
    [label release];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"_2.jpg"]];
    
    self.totalArray = [NSMutableArray arrayWithCapacity:0];
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
    self.changeCityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _changeCityTableView.dataSource = self;
    _changeCityTableView.delegate = self;
    [self.view addSubview:_changeCityTableView];
    [_changeCityTableView release];
    
    //将获取的图片保存在图片数组里
    for (int i = 1; i < 11; i++) {
        LocalImage *local = [[LocalImage alloc] initWithMyImage:[NSString stringWithFormat:@"%d_.jpg",i]];
        [_imageArray addObject:local];
        //        NSLog(@"loc =%d",_imageArray.count);
    }
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSMutableDictionary *headDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"all",@"city", nil];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kDistrict methodUrl:KGetDistrict params:headDic];
    [self.networkConnection release];
}

#pragma mark - NetworkConnection delegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    CityList * cityList  = (CityList *)result;
    for (CityInfo * cityInfo in cityList.cityInfoArray)
    {
        [_totalArray addObject:cityInfo];
    }
    [_changeCityTableView reloadData];
}

-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error
{
    NSLog(@"error = %@", error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_totalArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ChangeCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChangeCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.cityName = [_totalArray objectAtIndex:indexPath.row];

    cell.cityIamge.image = [UIImage imageNamed:[[_imageArray objectAtIndex:indexPath.row] myImage]];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC addPanGestureRecognizer];
    
    UINavigationController * weekendNav = [leftEdgeVC.viewControllers objectAtIndex:0];
    
    [leftEdgeVC.contentView bringSubviewToFront:weekendNav.view];
        
    //取出对应城市
    NSString *cityName = ((CityInfo *)[_totalArray objectAtIndex:indexPath.row]).cityName;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //取出城市对应的经纬度
    CGFloat longitude = [((CityInfo *)[_totalArray objectAtIndex:indexPath.row]).cityLongitude floatValue];
    CGFloat latitude  = [((CityInfo *)[_totalArray objectAtIndex:indexPath.row]).cityLatitude floatValue];

    //将经纬度存为数组 存在NSUserDefaults。
    NSArray * locationArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:longitude],[NSNumber numberWithFloat:latitude], nil];

    //给他存为默认值
    [defaults setObject: locationArray forKey:@"currentLocution"];
    [defaults setObject: cityName forKey:@"addressName"];
    [defaults setObject: cityName forKey:@"cityName"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNear" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCity" object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
