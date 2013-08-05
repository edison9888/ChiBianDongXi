//
//  ArticleDetailViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/11/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleInfo.h"
#import "POIDetailViewController.h"
#import "AsynImageView.h"
#import "CollectInfo.h"
#import "DataHandle.h"
#import "LPPopup.h"
#import "AppDelegate.h"
#import "SendWeiBoViewController.h"
#import "LeftEdgeViewController.h"
#import "AppDelegate.h"
#import "CollectViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController

@synthesize articleScrollView = _articleScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

    self.view.backgroundColor = [UIColor whiteColor];
    self.networkConnection = [[NetworkConnection alloc] init];
    self.networkConnection.delegate = self;
    [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kArticle methodUrl:KGetArticleDetail params:self.paramsDic];
    
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
    _collectButton.frame = CGRectMake(260, 10, 30, 30);
    
    [_collectButton setBackgroundImage:_tempImage forState:UIControlStateNormal];
    UIBarButtonItem *collectButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
//    [self.navigationItem setRightBarButtonItem:collectButtonItem];
    
    NSArray *otherArray = [NSArray arrayWithObjects:shareButtonItem,collectButtonItem, nil];
    
    [self.navigationItem setRightBarButtonItems:otherArray];
   
}

#pragma mark - NetworkConnectionDelegate

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
        
        NSString *articleId = [self.paramsDic objectForKey:@"articleId"];
            NSString *urlStr = @"http:__img.91mahua.com_huohua_v2_imageinterfacev2_api_interface_image_disk_get";
          CollectInfo *collectInfo = [[CollectInfo alloc]initWithPoiName:self.poiName articleId:articleId articleContent:self.articleInfo.articleContent articleImageurl:[NSString stringWithFormat:@"%@_%d_%d_%@",urlStr,(int)self.articleInfo.articleImageSize.width, (int)self.articleInfo.articleImageSize.height, self.articleInfo.articleImageUrl]];
  
        LPPopup *popup = [LPPopup popupWithText:@"您已收藏!"];
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:kLPPopupDefaultWaitDuration
               completion:nil];
        
        
        BOOL result = [DataHandle insertCollectInfoToDataBase:collectInfo];
        if (result)
        {
            NSLog(@"result----%d",result);
        }
        _collected = YES;
        
        _tempImage = (_collected)?[UIImage imageNamed:@"favoriteArticleAlready.png"]:[UIImage imageNamed:@"favoriteArticle.png"];
        [_collectButton setBackgroundImage:_tempImage forState:UIControlStateNormal];
        
    }
    else
    {

        NSString *articleId = [self.paramsDic objectForKey:@"articleId"];
        BOOL result = [DataHandle deleteCollectInfoWithArticleId:articleId];
        
        LPPopup *popup = [LPPopup popupWithText:@"您已取消收藏!"];
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:kLPPopupDefaultWaitDuration
               completion:nil];
        if (result)
        {
            NSLog(@"result----%d",result);
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




-(void) didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.articleInfo = (ArticleInfo *)result;
    self.poiName = self.articleInfo.poiInfo.poiName;
    self.poiId = self.articleInfo.poiInfo.poiId;
    
    self.authorImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    self.authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 200, 35)];
    
    self.articleTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 320, 35)];
    CGFloat imageHeight = 300 * self.articleInfo.articleImageSize.height / self.articleInfo.articleImageSize.width;
    self.articleImageView = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 80, 300, imageHeight)];

    self.articleImageView.urlString = [NSString stringWithFormat:@"%@/%d/%d/%@", kImageURL,
                                       (int)self.articleInfo.articleImageSize.width,
                                       (int)self.articleInfo.articleImageSize.height,
                                       self.articleInfo.articleImageUrl];
    self.authorImageView.urlString = self.articleInfo.userInfo.userImageUrl;

    
    CGSize textSize = [self.articleInfo.articleContent sizeWithFont:[UIFont systemFontOfSize:12.0]
                                    constrainedToSize:CGSizeMake(300,2000) lineBreakMode:NSLineBreakByCharWrapping];
    self.articleContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90 + imageHeight, 300, textSize.height)];
    
        
    
    self.authorNameLabel.text = self.articleInfo.userInfo.userName;
    self.articleTagLabel.text = [NSString stringWithFormat:@"#%@#  ", self.articleInfo.articleTag];
    self.articleTagLabel.textAlignment = NSTextAlignmentRight;
    self.articleContentLabel.text = self.articleInfo.articleContent;
    self.articleContentLabel.numberOfLines = 0;
    self.articleContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    if (iPhone5)
    {
        self.articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    }
    else
    {
        self.articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 414)];
    }
    
    self.articleScrollView.contentSize = CGSizeMake(320, 35 + 35 + imageHeight + textSize.height + 40 + 40);
    
    self.articleScrollView.scrollEnabled = YES;
    
    [self.articleScrollView addSubview:self.authorImageView];
    [self.authorImageView release];
    
    [self.articleScrollView addSubview:self.authorNameLabel];
    [self.authorNameLabel release];
    
    [self.articleScrollView addSubview:self.articleTagLabel];
    [self.articleTagLabel release];
    
    [self.articleScrollView addSubview:self.articleImageView];
    [self.articleImageView release];
    
    [self.articleScrollView addSubview:self.articleContentLabel];
    [self.articleContentLabel release];
    
    UIButton * showPOIDetailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [showPOIDetailButton setTitle:self.articleInfo.poiInfo.poiName forState:UIControlStateNormal];
    [showPOIDetailButton addTarget:self action:@selector(showPOIInfoDetail) forControlEvents:UIControlEventTouchDown];
    [showPOIDetailButton setFrame:CGRectMake(10, 100 + imageHeight + textSize.height, 300, 40)];
    
    [self.articleScrollView addSubview:showPOIDetailButton];
    
    [self.view addSubview:self.articleScrollView];
    [self.articleScrollView release];
    
}

-(void)showPOIInfoDetail
{
    POIDetailViewController * poiDetailVC = [[POIDetailViewController alloc] init];
    POIInfo *poiInfo = [[POIInfo alloc] init];
    poiInfo = self.articleInfo.poiInfo;
    poiInfo.poiImageSize = self.articleInfo.articleImageSize;
    poiInfo.poiImageId = self.articleInfo.articleImageUrl;
    poiDetailVC.poiInfo = poiInfo;
    poiDetailVC.articleInfo = self.articleInfo;
    [self.navigationController pushViewController:poiDetailVC animated:YES];
    [poiDetailVC release];
    
}

-(void) didFinishRequestUnsuccessful:(NetworkConnection *)connection error:(NSError *)error
{
    NSLog(@"error %@", error);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_paramsDic release];
    [super dealloc];
}

@end
