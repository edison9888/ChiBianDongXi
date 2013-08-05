//
//  RecommendViewController.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-18.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "RecommendViewController.h"
#import "POIInfo.h"
#import "NetConnectionMacro.h"
#import "POIShareInfo.h"
#import "POIShareList.h"
#import "POIShareInfoCell.h"
#import "POIDetailViewController.h"

#define kWeekendImageWidth 155.5
#define kWeekendTextSize 10.0
#define kWeekendTextWidth 60
#define kWaterFlowColumnNum 2
@interface RecommendViewController ()

@end

@implementation RecommendViewController

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
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
//    self.navigationItem.rightBarButtonItem = backButtonItem;
    [backButtonItem release];
    self.leftColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray, nil];
    
	self.pageNo = 0;
    
    CGRect rect = self.view.frame;
    self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.waterFlowView.backgroundColor = [UIColor grayColor];
    
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate = self;
    
    [self.view addSubview:self.waterFlowView];
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [paramsDic setObject:self.poiInfo.poiId forKey:@"poiId"];
    [paramsDic setObject:[NSNumber numberWithInt:20] forKey:@"limit"];
    [paramsDic setObject:self.recommendation forKey:@"recommendation"];
    [paramsDic setObject:[NSNumber numberWithInt:0] forKey:@"start"];
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kPOI methodUrl:KGetRecommendShareList params:paramsDic];
    
}

-(void)back
{
    POIDetailViewController *poiDetailVC = [[POIDetailViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
    [poiDetailVC release];
}

#pragma mark - NetworkConnectionDelegate

-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.POIShareInfoResult = (POIShareList *)result;
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
    
    for (POIShareInfo * aPOIShareInfo in self.POIShareInfoResult.poiShareInfoArray)
    {
        CGFloat height = [self calculateCellHeightWithText:aPOIShareInfo.shareContent userImageUrl:aPOIShareInfo.userImageUrl sharePicUrl:aPOIShareInfo.sharePicUrl];
        
        if (self.leftColumnHeight == 0.0)
        {
            [self.leftColumnArray addObject:aPOIShareInfo];
            self.leftColumnHeight += height;
        }
        else
        {
            if (self.leftColumnHeight <= self.rightColumnHeight)
            {
                [self.leftColumnArray addObject:aPOIShareInfo];
                self.leftColumnHeight += height;
                
                
            }
            else
            {
                [self.rightColumnArray addObject:aPOIShareInfo];
                self.rightColumnHeight += height;
            }
        }
    }
    
}

-(CGFloat) calculateCellHeightWithText:(NSString *)text userImageUrl:(NSString *)userImageUrl sharePicUrl:(NSString *)sharePicUrl
{
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:kWeekendTextSize] constrainedToSize:CGSizeMake(kWeekendTextWidth, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat cellHeight;
    
    if ([userImageUrl isEqualToString:@""])
    {
        if ([sharePicUrl isEqualToString:@""])
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
        if ([sharePicUrl isEqualToString:@""])
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

- (POIShareInfoCell *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(WFIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"POIShareInfoCell";
    
    POIShareInfoCell *cell = (POIShareInfoCell *)[self.waterFlowView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[[POIShareInfoCell alloc] initWithIdentifier:cellIdentifier] autorelease];
    }
    
    
    POIShareInfo * aPOIShareInfo = (POIShareInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    cell.shareInfo = aPOIShareInfo;
    
    return cell;
}

- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(WFIndexPath *)indexPath
{
    POIShareInfo * aPOIShareInfo = (POIShareInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    return [POIShareInfoCell cellHeight:aPOIShareInfo];
    
}

//瀑布流列数
- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return kWaterFlowColumnNum;
}
//代理方法
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    POIShareInfo * aPOIShareInfo = (POIShareInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row];
    
    if (aPOIShareInfo.sharePicUrl == nil) {
        
    }
    else
    {
   
    UIImageView*bigImageView = [[UIImageView alloc] init];
    bigImageView.userInteractionEnabled = YES;
    [self.view addSubview:bigImageView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTo:)];
    [bigImageView addGestureRecognizer:tapGes];
    [UIView animateWithDuration:0.5 animations:^{
        bigImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        //        if (finished) {
        //            _animationView.backgroundColor = [UIColor grayColor];
        //        }
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@",aPOIShareInfo.sharePicUrl];
    NSString *fileName = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path])
    {
        bigImageView.image = [UIImage imageWithContentsOfFile:path];
    }
        [bigImageView release];
    }
    
}

-(void)backTo:(UITapGestureRecognizer *)sender{
    [sender.view removeFromSuperview];
    
}

- (void)dealloc
{
    self.poiInfo = nil;
    self.poiShareInfo = nil;
    self.recommendation = nil;
    self.networkConnection = nil;
    self.waterFlowView = nil;
    self.dataArray = nil;
    self.leftColumnArray = nil;
    self.rightColumnArray = nil;
    self.imageArray = nil;
    self.refreshHeaderView = nil;
    self.refreshFooterView = nil;
    self.POIShareInfoResult = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
