//
//  LeftEdgeViewController.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "LeftEdgeViewController.h"
#import "AuthorViewController.h"
#import "WeekendViewController.h"
#import "FriendViewController.h"
#import "NearByHottestViewController.h"
#import "ChangeCityViewController.h"
#import "CollectViewController.h"
#import "AppDelegate.h"
#import "NetConnectionMacro.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface LeftEdgeViewController ()

@end

@implementation LeftEdgeViewController

@synthesize listTableView = _listTableView;
@synthesize listArray = _listArray;
@synthesize viewControllers = _viewControllers;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.viewControllers = [[NSMutableArray alloc] init];
        self.listArray = [[NSMutableArray alloc] init];
        
        
        [self.listArray addObject:@"吃货周末"];
        [self.listArray addObject:@"附近最热"];
        [self.listArray addObject:@"好友探店"];
        [self.listArray addObject:@"选择城市"];
        [self.listArray addObject:@"作者信息"];
        [self.listArray addObject:@"收藏信息"];
    
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,250,[self.view bounds].size.height)];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        
        self.collectButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton1 setTitle:@"" forState:UIControlStateNormal];
        [_collectButton1 addTarget:self action:@selector(collectIn) forControlEvents:UIControlEventTouchUpInside];
        
        self.userImage = [[AsynImageView alloc] initWithFrame:CGRectMake(30, 5, 50, 50)];
        _userImage.image = [UIImage imageNamed:@"userhead-frame-list-default.png"];
        [_collectButton1 addSubview:_userImage];
        
        if (iPhone5)
        {
            [_collectButton1 setFrame:CGRectMake(0, 0, 200, 60)];
            
        }
        else
        {
            [_collectButton1 setFrame:CGRectMake(0, 0, 200, 60)];
        }

        UIImageView * backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu-left-background-568h.png"]];
        self.listTableView.backgroundView = backgroundView;
        [backgroundView release];

        self.listTableView.tableHeaderView = _collectButton1;

        [self setLeftFoldContentView:self.listTableView];
        
        [self loadViewControlers];
        
        [self.viewControllers release];
        [self.listArray release];
        [self.listTableView release];
        
    }
    return self;
}

- (SinaWeibo*)sinaWeibo
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaWeibo];
    self.authData = [NSDictionary dictionaryWithObjectsAndKeys:
                     sinaweibo.accessToken, @"AccessTokenKey",
                     sinaweibo.expirationDate, @"ExpirationDateKey",
                     sinaweibo.userID, @"UserIDKey",
                     sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:_authData forKey:@"SinaWeiboAuthData"];
    
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}


-(void)fold
{
    if (self.state == PaperFoldStateLeftUnfolded)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldRightView:) userInfo:nil repeats:YES];
    }
    
    
    if (self.state == PaperFoldStateDefault)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(unfoldLeftView:) userInfo:nil repeats:YES];
    }
}


-(void)loadViewControlers
{
   
    
    WeekendViewController * weekendVC = [[WeekendViewController alloc] init];
    weekendVC.delegate = self;
    weekendVC.title = @"吃货周末";
    UINavigationController * weekendNav = [[UINavigationController alloc] initWithRootViewController:weekendVC];
    
    if (iPhone5)
    {
        weekendNav.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        weekendNav.view.frame = CGRectMake(0, -20, 320, 480);
    }
    [self.contentView addSubview:weekendNav.view];
    [self.viewControllers addObject:weekendNav];
    [weekendNav release];
    [weekendVC release];
    
    
    NearByHottestViewController * nearVC = [[NearByHottestViewController alloc] init];
    nearVC.delegate = self;
    nearVC.title = @"附近最热";
    UINavigationController * nearNav = [[UINavigationController alloc] initWithRootViewController:nearVC];
    nearNav.view.backgroundColor = [UIColor greenColor];
    
    if (iPhone5)
    {
        nearNav.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        nearNav.view.frame = CGRectMake(0, -20, 320, 480);
    }

    [self.viewControllers addObject:nearNav];
    [nearVC release];
    [nearNav release];
   
    FriendViewController * friendVC = [[FriendViewController alloc] init];
    friendVC.delegate = self;
    friendVC.title = @"好友探店";
    UINavigationController * friendNav = [[UINavigationController alloc] initWithRootViewController:friendVC];
    
    if (iPhone5)
    {
        friendNav.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        friendNav.view.frame = CGRectMake(0, -20, 320, 480);
    }
    [self.viewControllers addObject:friendNav];
    [friendVC release];
    [friendNav release];
    
    ChangeCityViewController * changeCity = [[ChangeCityViewController alloc] init];
    changeCity.delegate = self;
    changeCity.title = @"选择城市";
    UINavigationController * changeCityView = [[UINavigationController alloc] initWithRootViewController:changeCity];
    if (iPhone5)
    {
        changeCityView.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        changeCityView.view.frame = CGRectMake(0, -20, 320, 480);
    }
    [self.viewControllers addObject:changeCityView];
    [changeCity release];
    [changeCityView release];
    
    
    AuthorViewController * authorVC = [[AuthorViewController alloc] init];
    authorVC.delegate = self;
    authorVC.title = @"作者信息";
    UINavigationController * authorNav = [[UINavigationController alloc] initWithRootViewController:authorVC];
    
    if (iPhone5)
    {
        authorNav.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        authorNav.view.frame = CGRectMake(0, -20, 320, 480);
    }
    [self.viewControllers addObject:authorNav];
    [authorVC release];
    [authorNav release];
 
    CollectViewController *collectVC = [[CollectViewController alloc] init];
    collectVC.title = @"收藏信息";
    collectVC.delegate = self;
    UINavigationController * collectNav = [[UINavigationController alloc] initWithRootViewController:collectVC];
    
    if (iPhone5)
    {
        collectNav.view.frame = CGRectMake(0, -20, 320, 568);
    }
    else
    {
        collectNav.view.frame = CGRectMake(0, -20, 320, 480);
    }
//    [self.contentView addSubview:collectNav.view];
    [self.viewControllers addObject:collectNav];
    [collectVC release];
    [collectNav release];
    
    [self.contentView bringSubviewToFront:weekendNav.view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITalbeViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
	}
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 40, 40)];
    imageView.image = [UIImage imageNamed:@"left_item_select_city.png"];
    [cell addSubview:imageView];
    NSString *str = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvcer = [self.viewControllers objectAtIndex:indexPath.row];
    [self.contentView addSubview:nvcer.view];
    nvcer.view.alpha = 0.0f;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    nvcer.view.alpha = 1.0f;

    [[nvcer.viewControllers objectAtIndex:0] viewWillAppear:YES];

    [self.contentView bringSubviewToFront:nvcer.view];
    [UIView commitAnimations];
    
    [self fold];
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //    sinaweibo.delegate = self;
    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release], userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release], statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release];
        userInfo = [result retain];
        
        NSMutableArray * locationArray = [NSMutableArray arrayWithCapacity:1];
        [locationArray addObject:[NSNumber numberWithDouble:116.317596]];
        [locationArray addObject:[NSNumber numberWithDouble:40.043064]];
        
        NSMutableDictionary * sinaUserLoginDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:userInfo,@"sinaInfo",locationArray,@"location",[NSString stringWithFormat:@"%f",1.5],@"version",[_authData objectForKey:@"AccessTokenKey"],@"token", nil];
        
        self.networkConnection = [[NetworkConnection alloc] init];
        self.networkConnection.delegate = self;
        
        [self.networkConnection initWithBaseUrl:KBaseURL functionUrl:kUser methodUrl:KSinaUserLogin params:sinaUserLoginDic];
        [self.networkConnection release];
        
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release];
        statuses = [[result objectForKey:@"statuses"] retain];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postStatusText release], postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postImageStatusText release], postImageStatusText = nil;
    }
}

- (void)didFinishRequestSuccessful:(NetworkConnection *)connection result:(id)result
{
    self.loginUserInfo = (LoginUserInfo *)result;
    NSString * userImage = [NSString stringWithFormat:@"%@",_loginUserInfo.userImageUrl];
    NSString * userName = [NSString stringWithFormat:@"%@",_loginUserInfo.userName];
    NSString * uid = [NSString stringWithFormat:@"%@",_loginUserInfo.userWeiboId];
    NSLog(@"uid = %@",userName);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uid forKey:@"userId"];
    [defaults setObject:userImage forKey:@"userImage"];
    [defaults setObject:userName forKey:@"userName"];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 130, 30)];
    if (userName == nil || [userName isEqualToString:@""])
    {
        _nameLabel.text = @"";
    }
    else
    {
        _nameLabel.text = userName;
    }
    
    if (userImage == nil)
    {
        _userImage.image = [UIImage imageNamed:@"userhead-frame-list-default.png"];
    }
    else
    {
        _userImage.urlString = userImage;
    }
    [_collectButton1 addSubview:_userImage];
    [_collectButton1 addSubview:_nameLabel];
}

-(void)collectIn
{
    SinaWeibo *sinaweibo = [self sinaWeibo];
    sinaweibo.delegate = self;
    BOOL authValid = sinaweibo.isAuthValid;
    if (!authValid)
    {
        [sinaweibo logIn];
        
    }
    else
    {
        UIAlertView * logOutAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注销微博！" delegate:self cancelButtonTitle:@"注销" otherButtonTitles:@"取消", nil];
        [logOutAlert show];
        [logOutAlert release];
        [sinaweibo logOut];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"userName"];
        [defaults removeObjectForKey:@"userImage"];
    }
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [_viewControllers release];
    [_listArray release];
    [_listTableView release];
    [super dealloc];
}

@end
