//
//  ArticleDetailViewController.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/11/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConnection.h"
#import "NetConnectionMacro.h"
#import "SinaWeibo.h"
@class ArticleInfo;
@class AsynImageView;

@interface ArticleDetailViewController : UIViewController <NetworkConnectionDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) NSDictionary * paramsDic;
@property (strong, nonatomic) NetworkConnection * networkConnection;

@property (strong, nonatomic) NSString * poiName;
@property (strong, nonatomic) NSString * poiId;
@property (strong, nonatomic) ArticleInfo * articleInfo;
@property (nonatomic,retain) UIButton *shareBtn;
@property (nonatomic,retain) UIButton *collectButton;
@property (nonatomic,retain) UIImage *tempImage;
@property (strong, nonatomic) AsynImageView * authorImageView;
@property (strong, nonatomic) AsynImageView * articleImageView;
@property (strong, nonatomic) UILabel * authorNameLabel;
@property (strong, nonatomic) UILabel * articleTagLabel;
@property (strong, nonatomic) UILabel * articleContentLabel;
@property (strong, nonatomic) UIScrollView * articleScrollView;
@property (nonatomic,assign)  BOOL collected;

@end
