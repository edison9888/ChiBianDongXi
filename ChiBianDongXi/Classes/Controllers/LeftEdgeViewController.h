//
//  LeftEdgeViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/2/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

/*
 * 本类主要是左边折叠类，是应用的各个页面的切换入口
 */
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PaperFoldViewController.h"
#import "SinaWeibo.h"
#import "AsynImageView.h"
#import "NetworkConnection.h"
#import "LoginUserInfo.h"

@interface LeftEdgeViewController : PaperFoldViewController<UITableViewDelegate,UITableViewDataSource,SinaWeiboDelegate,SinaWeiboRequestDelegate,NetworkConnectionDelegate>
{
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
}
@property (nonatomic,retain)  NSDictionary *authData;
@property (nonatomic,retain) NSDictionary * dic;
@property (nonatomic,retain) NetworkConnection * networkConnection;
@property (nonatomic,retain) LoginUserInfo * loginUserInfo;

@property (strong, nonatomic) UITableView * listTableView;
@property (strong, nonatomic) NSMutableArray * listArray;
@property (strong, nonatomic) NSMutableArray * viewControllers;

@property (nonatomic,retain)UIImageView *image;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)AsynImageView *userImage;
@property (nonatomic,retain)UIButton *collectButton1;

-(void)fold;

@end
