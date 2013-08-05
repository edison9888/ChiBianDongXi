//
//  ChangeCityViewController.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "NetworkConnection.h"

@class NetworkConnection;
@interface ChangeCityViewController : BaseViewController<NetworkConnectionDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSMutableArray *totalArray;//用于保存获取到的城市数据的数组

@property(nonatomic,retain)NSMutableArray *imageArray;//用于储存本地图片信息的数组

@property(nonatomic,retain)UITableView *changeCityTableView;

@property(nonatomic,retain)NetworkConnection *networkConnection;
@end
