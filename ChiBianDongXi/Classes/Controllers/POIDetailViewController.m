//
//  POIDetailViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/11/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "POIDetailViewController.h"
#import "POIShareInfo.h"
#import "POIShareInfoCell.h"
#import "NetConnectionMacro.h"
#import "CellHeightMacro.h"
#import "POIInfo.h"
#import "DataHandle.h"
#import "CollectInfo.h"
#import "CollectViewController.h"
#import "POIShareList.h"
#import "RecommendViewController.h"
#import "LPPopup.h"
#import "ArticleInfo.h"
#import "MapViewController.h"
#import "SendWeiBoViewController.h"
#import "AppDelegate.h"
#import "LeftEdgeViewController.h"


#define kWeekendImageWidth 155.5
#define kWeekendTextSize 10.0
#define kWeekendTextWidth 60
#define kWaterFlowColumnNum 2

//#pragma mark_informationCell
#define kHeadViewHeight 80
#define kHeadImageHeight 40//头像的高度
#define kMarkLblHeight 20 //标签高度
#define kDesImageHeight 150 //详情图片
#define kArticleLblHeight 100 //详情lable高度
#define kPoiBtnHeight 50 //button高度
#define kMarginVertical    10 //距x轴的距离
#define kWidth 300
//#pragma mark_restaurantDetail
#define kHeadViewHigh 300
#define kMarginHorizontal 10
#define kNameLblHeight
#define kCOUNT  5 //topicScroll的图片个数

#define  kResNameLblHeight 30
#define kResWidth 80
#define kKindLableHeigth 30
#define kPriceLblHeight 50
#define kVegetablesBtnHeight 100
@interface POIDetailViewController ()

@end

@implementation POIDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.start = 0;
        self.limit = 20;
        // Custom initialization      
    }
    return self;
}

- (SinaWeibo*)sinaWeibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate = self;
    return delegate.sinaweibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //LPPopup Demo
    [[LPPopup appearance] setPopupColor:[UIColor whiteColor]];
    _vegetableViewHeight = ([self.poiInfo.poiRecommentionFood count]/2 + [self.poiInfo.poiRecommentionFood count]%2)*25;
    self.leftColumnArray = [NSMutableArray arrayWithCapacity:1];
    self.rightColumnArray = [NSMutableArray arrayWithCapacity:1];
    
    self.dataArray = [NSMutableArray arrayWithObjects:self.leftColumnArray, self.rightColumnArray, nil];
    
	self.pageNo = 0;
    
    CGRect rect = self.view.frame;
 
    if (self.poiInfo.poiRecommentionFood == nil) {
        self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) headerViewHeight:185.0f];
    }else
    {
//        [_headView addSubview:_vegetableView];
        self.waterFlowView = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) headerViewHeight:185.0f + _vegetableViewHeight];
    }
    self.waterFlowView.backgroundColor = [UIColor grayColor];    
    self.waterFlowView.waterFlowDataSource = self;
    self.waterFlowView.waterFlowDelegate = self;
    [self setFooterView];
    [self.view addSubview:self.waterFlowView];
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramsDic setObject:self.poiInfo.poiId forKey:@"poiId"];
    [paramsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    
    NSUserDefaults * cbdxDefaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [cbdxDefaults objectForKey:@"userId"];
    if (userId != nil) {
        [paramsDic setObject:userId forKey:@"uid"];
    }else
    {
        [paramsDic setObject:@"" forKey:@"uid"];
    }
    [paramsDic setObject:[NSNumber numberWithInt:self.start] forKey:@"start"];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kPOI methodUrl:KGetPoiShareList params:paramsDic];
    self.headView = [[UIView alloc]init];

//    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
//    backButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.title = @"餐馆详情";
 
//分享按钮    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setFrame:CGRectMake(280, 10, 30, 30)];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"transmitArticle.png"] forState:UIControlStateNormal];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];
    
//收藏按钮 取消收藏按钮
    self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectButton addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    self.tempImage = (_collected)?[UIImage imageNamed:@"favoriteArticleAlready.png"]:[UIImage imageNamed:@"favoriteArticle.png"];
    _collectButton.frame = CGRectMake(250, 10, 30, 30);
    
    [_collectButton setBackgroundImage:_tempImage forState:UIControlStateNormal];
    UIBarButtonItem *collectButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    
    NSArray *otherArray = [NSArray arrayWithObjects:shareButtonItem,collectButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:otherArray];
    
    
//poiName
    UILabel *poiNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical, kMarginHorizontal, 200,kResNameLblHeight)];
    poiNameLabel.text = self.poiInfo.poiName;
    poiNameLabel.backgroundColor = [UIColor clearColor];
    poiNameLabel.font = [UIFont systemFontOfSize:19.0];
    [_headView addSubview:poiNameLabel];
    [poiNameLabel release];
//scoreLabel
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 20, 35, 35)];
    scoreLabel.text = self.poiInfo.poiScore;
    scoreLabel.backgroundColor = [UIColor clearColor];
    [scoreLabel setTextAlignment:NSTextAlignmentCenter];
    scoreLabel.font = [UIFont systemFontOfSize:19.0];
    [_headView addSubview:scoreLabel];
    
//    类别
    UILabel * showCategory = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical, kMarginVertical + kResNameLblHeight, kResWidth, kKindLableHeigth)];
    showCategory.text = @"类别";
    showCategory.backgroundColor = [UIColor clearColor];
    showCategory.font = [UIFont systemFontOfSize:15.0];
    [_headView addSubview:showCategory];
    [showCategory release];
    
    UILabel * categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(kResWidth + kMarginVertical, showCategory.frame.origin.y, 150,kKindLableHeigth) ];
    categoryLabel.text = self.poiInfo.poiCategory;
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.font = [UIFont systemFontOfSize:15.0];
    [_headView addSubview:categoryLabel];
    [categoryLabel release];
    
    //人均 poiAverageSpend
    UILabel *showAverageSpend = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical, poiNameLabel.frame.size.height + showCategory.frame.size.height + kMarginHorizontal, kResWidth, kKindLableHeigth)];
    
    showAverageSpend.backgroundColor = [UIColor clearColor];
    [_headView addSubview:showAverageSpend];
    showAverageSpend.text = @"人均";
    showAverageSpend.font = [UIFont systemFontOfSize:15.0];
    [showAverageSpend release];

    UILabel *averageSpendLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical + kResWidth,showAverageSpend.frame.origin.y, 200, kKindLableHeigth)];
    [averageSpendLabel setText:[NSString stringWithFormat:@"%@元",self.poiInfo.poiAverageSpend]];
//    averageSpendLabel.textColor = [UIColor redColor];
    averageSpendLabel.font = [UIFont systemFontOfSize:15.0];
     averageSpendLabel.backgroundColor = [UIColor clearColor];
    [_headView addSubview:averageSpendLabel];
    [averageSpendLabel release];
    //分割线
    UIImageView *cLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot-line-horizontal.png"]];
    cLine.frame = CGRectMake(10, averageSpendLabel.frame.origin.y, 300, 1);
    [self.headView addSubview:cLine];
    [cLine release];
//    //地址
    UILabel *showAddress = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical, showAverageSpend.frame.origin.y + showAverageSpend.frame.size.height, kResWidth, kPriceLblHeight)];
    showAddress.userInteractionEnabled = YES;
    showAddress.text = @"地址";
    showAddress.backgroundColor = [UIColor clearColor];
    showAddress.font = [UIFont systemFontOfSize:15.0];
    [self.headView addSubview:showAddress];
    [showAddress release];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginHorizontal + showAddress.frame.size.width, showAddress.frame.origin.y, 230, kPriceLblHeight)];
    addressLabel.font = [UIFont systemFontOfSize:15.0];
    [addressLabel setNumberOfLines:0];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.text = self.poiInfo.poiAddress;
    addressLabel.textColor = [UIColor blueColor];
    addressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMap)];
    [addressLabel addGestureRecognizer:tapGesture];
    [_headView addSubview:addressLabel];
    [addressLabel release];
    [tapGesture release];
//分割线
    UIImageView *bLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot-line-horizontal.png"]];
    bLine.frame = CGRectMake(10, addressLabel.frame.origin.y, 300, 1);
    [self.headView addSubview:bLine];
    [bLine release];
//    //电话
    UILabel *showPhoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical, addressLabel.frame.origin.y + addressLabel.frame.size.height, kResWidth, kKindLableHeigth)];
    showPhoneNumber.text = @"电话";
    showPhoneNumber.backgroundColor = [UIColor clearColor];
    showPhoneNumber.font = [UIFont systemFontOfSize:15.0];
    [_headView addSubview:showPhoneNumber];
    [showPhoneNumber release];
//    
    UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginVertical + showPhoneNumber.frame.size.width, showPhoneNumber.frame.origin.y, 230, kKindLableHeigth)];
    phoneNumberLabel.text = self.poiInfo.poiPhone;
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] init];
    [phoneTap addTarget:self action:@selector(cellPhone)];
    [phoneNumberLabel addGestureRecognizer:phoneTap];
    phoneNumberLabel.backgroundColor = [UIColor clearColor];
    phoneNumberLabel.font = [UIFont systemFontOfSize:15.0];
    phoneNumberLabel.textAlignment = NSTextAlignmentLeft;
    [phoneNumberLabel setTextColor:[UIColor blueColor]];
    phoneNumberLabel.userInteractionEnabled = YES;
    [phoneTap release];
    [_headView addSubview:phoneNumberLabel];
    [phoneNumberLabel release];
    /*分割线-----------------------*/
    UIImageView *aLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot-line-horizontal.png"]];
    aLine.frame = CGRectMake(10, phoneNumberLabel.frame.origin.y, 300, 1);
    [self.headView addSubview:aLine];
    [aLine release];

//    推荐菜
    self.vegetableView = [[UIView alloc]initWithFrame:CGRectMake(0 , phoneNumberLabel.frame.origin.y + phoneNumberLabel.frame.size.height,320 , _vegetableViewHeight)];
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginVertical,0, kResWidth-8, kKindLableHeigth)];
    recommendLabel.text = @"推荐菜";
     recommendLabel.backgroundColor = [UIColor clearColor];
    recommendLabel.font = [UIFont systemFontOfSize:15.0];
    [_vegetableView addSubview:recommendLabel];
    [recommendLabel release];

    for (int i=0; i<[self.poiInfo.poiRecommentionFood count]; i++)
    {
        UIButton *buttons = [UIButton buttonWithType:UIButtonTypeCustom];
        buttons.frame =CGRectMake(105*(i%2)+80, 25*(i/2),120, 25);
        //tag值
        buttons.tag = 1000 + i;
   
        NSString *foodStr =[self.poiInfo.poiRecommentionFood objectAtIndex:i];
        NSRange index = [foodStr rangeOfString:@"(0"];
        if (NSNotFound == index.location) {
            [buttons setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [buttons addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        { 
            [buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
        [buttons setTitle:[self.poiInfo.poiRecommentionFood objectAtIndex:i] forState:UIControlStateNormal];
        buttons.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_vegetableView addSubview:buttons];

    }
    
   
    if (self.poiInfo.poiRecommentionFood == nil) {
        self.headView .frame = CGRectMake(0, 0, 320, 200);
      
    }else
    {
        [_headView addSubview:_vegetableView];
        _headView.frame = CGRectMake(0, 0, 320,200 + _vegetableViewHeight);
    } 
    _vegetableView.backgroundColor = [UIColor brownColor];
    [_vegetableView release];   
    [self.waterFlowView addSubview:_headView];
    [_headView release];
    /*分割线-----------------------*/
    UIImageView *dLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot-line-horizontal.png"]];
    dLine.frame = CGRectMake(10, phoneNumberLabel.frame.origin.y + phoneNumberLabel.frame.size.height, 300, 1);
    [self.headView addSubview:dLine];
    [dLine release];
}

//分享按钮响应方法
- (void)shareBtnClicked{
    SinaWeibo *sinaweibo = [self sinaWeibo];
    BOOL authValid = sinaweibo.isAuthValid;
    if (!authValid) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未登录，请登录微博！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        SendWeiBoViewController *swbvc = [[[SendWeiBoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        SinaWeibo *sinaweibo = [self sinaWeibo];
        [swbvc addWeiBo:sinaweibo];
        [self.navigationController pushViewController:swbvc animated:NO];
    }
}

//收藏 取消收藏按钮
-(void)collect
{
    if (_collected == NO)
    {
        NSString *urlStr = @"http:__img.91mahua.com_huohua_v2_imageinterfacev2_api_interface_image_disk_get";
        CollectInfo *collectInfo = [[CollectInfo alloc]initWithPoiName:_poiInfo.poiName poiCategory:_poiInfo.poiCategory poiScore:_poiInfo.poiScore  poiPerCapita:[_poiInfo.poiAverageSpend floatValue] poiAddress:_poiInfo.poiAddress poiPhone:_poiInfo.poiPhone poiImageurl:[NSString stringWithFormat:@"%@_%d_%d_%@",urlStr,(int)_poiInfo.poiImageSize.width, (int)_poiInfo.poiImageSize.height, _poiInfo.poiImageId] poiId:_poiInfo.poiId];
        
        
        LPPopup *popup = [LPPopup popupWithText:@"您已收藏!"];
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:kLPPopupDefaultWaitDuration
               completion:nil];
        
        
        BOOL result = [DataHandle insertCollectInfoToDataBase:collectInfo];
        if (result)
        {
           
        }
        _collected = YES;
        
        _tempImage = (_collected)?[UIImage imageNamed:@"favoriteArticleAlready.png"]:[UIImage imageNamed:@"favoriteArticle.png"];
        [_collectButton setBackgroundImage:_tempImage forState:UIControlStateNormal];
        
    }
    else
    { 
        NSString *poiId = self.poiInfo.poiId;
        BOOL result = [DataHandle deleteCollectInfoWithPoiId:poiId];
        
        LPPopup *popup = [LPPopup popupWithText:@"您已取消收藏!"];
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:kLPPopupDefaultWaitDuration
               completion:nil];
        if (result)
        {
           
        }
        else
        {
            
        }
        _collected = NO;        
        _tempImage = (_collected)?[UIImage imageNamed:@"favoriteArticleAlready.png"]:[UIImage imageNamed:@"favoriteArticle.png"];
        [_collectButton setBackgroundImage:_tempImage forState:UIControlStateNormal];
 
        
    }
    
    LeftEdgeViewController  * leftEdgeVC = (LeftEdgeViewController *)[AppDelegate shareAppDelegate].window.rootViewController;
    [leftEdgeVC addPanGestureRecognizer];
    
    UINavigationController * collectionNav = [leftEdgeVC.viewControllers objectAtIndex:6];
    
    CollectViewController * collectionVC = (CollectViewController *)[collectionNav.viewControllers objectAtIndex:0];
    [collectionVC getPOIDetailCollectData];
    [collectionVC.tableView reloadData];
    
}

//跳转到地图页面
-(void)goToMap
{
    MapViewController *locationMapView = [[[MapViewController alloc] init] autorelease];
    
    locationMapView.destinationLocation = [[[CLLocation alloc] initWithLatitude:[self.poiInfo.poiLatitude floatValue] longitude:[self.poiInfo.poiLongitude floatValue]] autorelease];

    [self presentViewController:locationMapView animated:YES completion:^{}];

}
//拨电话方法
-(void)cellPhone
{  
    UIActionSheet *actionButton = [[UIActionSheet alloc]initWithTitle:@"联系方式" delegate:self cancelButtonTitle:@"取消拨号" destructiveButtonTitle:@"确认拨号" otherButtonTitles: nil];
    [actionButton setActionSheetStyle:UIActionSheetStyleAutomatic];
    [actionButton showInView:self.view];

}
//UIActionSheet 代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {

        NSString *phoneNumber = self.poiInfo.poiPhone;
        NSURL *phoneURl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURl];

    }
    else
    {
        
    }
}

//推荐菜跳转到相关页面
-(void)pushNext:(UIButton *)aButton
{
    RecommendViewController *recomendVC = [[RecommendViewController alloc] init];
    recomendVC.poiInfo = self.poiInfo;
    NSArray *array = [[NSArray alloc] init];
    array =  [aButton.titleLabel.text componentsSeparatedByString:@"("];
    recomendVC.recommendation = [array objectAtIndex:0];
    [self.navigationController pushViewController:recomendVC animated:YES];
}

//返回上一个页面
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - WaterFlowViewDelegate

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(WFIndexPath *)indexPath
{
    POIShareInfo * aPOIShareInfo = (POIShareInfo *)[[self.dataArray objectAtIndex:indexPath.column] objectAtIndex:indexPath.row]; 
    self.bigImageView = [[UIImageView alloc] init];
    _bigImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bigImageView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTo:)];
    [_bigImageView addGestureRecognizer:tapGes];   
    //设置图片出现时的动画
    _bigImageView.frame = CGRectMake(160,210, 0,0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _bigImageView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    //读取保存在本地的图片
    NSString *urlStr = [NSString stringWithFormat:@"%@",aPOIShareInfo.sharePicUrl];
    NSString *fileName = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cacheDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path])
    {
        _bigImageView.image = [UIImage imageWithContentsOfFile:path];
    }
    [_bigImageView release];
}

-(void)backTo:(UITapGestureRecognizer *)sender{

    [sender.view removeFromSuperview];
   
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
    
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [paramsDic setObject:self.poiInfo.poiId forKey:@"poiId"];
    [paramsDic setObject:[NSNumber numberWithInt:self.limit] forKey:@"limit"];
    [paramsDic setObject:@"" forKey:@"uid"];
    [paramsDic setObject:[NSNumber numberWithInt:self.start] forKey:@"start"];
    
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kPOI methodUrl:KGetPoiShareList params:paramsDic];
    
    
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
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    self.poiInfo = nil;
    self.networkConnection = nil;
    self.waterFlowView = nil;
    self.dataArray = nil;
    self.leftColumnArray = nil;
    self.rightColumnArray= nil;
    self.imageArray= nil;
    self.refreshHeaderView= nil;
    self.refreshFooterView= nil;
    self.POIShareInfoResult= nil;
    self.articleInfo= nil;
    self.dataArray= nil;
    self.leftColumnArray= nil;
    self.rightColumnArray= nil;
    self.imageArray= nil;
    self.refreshHeaderView= nil;
    self.refreshFooterView= nil;
    self.headView= nil;
    self.vegetableView= nil;
    self.POIShareInfoResult= nil;
    self.collectButton= nil;
    self.tempImage= nil;
    self.phoneCallWebView= nil;
    self.bigImageView= nil;  
    [super dealloc];
}
@end
