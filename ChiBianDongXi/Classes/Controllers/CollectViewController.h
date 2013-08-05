//
//  CollectViewController.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIInfo.h"
#import "BaseViewController.h"

@interface CollectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
//@interface CollectViewController : UITableViewController
@property (nonatomic,retain) NSMutableArray *collectInfoArray;
@property (nonatomic,retain) POIInfo *collectPoiInfo;
@property (nonatomic,retain) UITableView *tableView;
-(void)getPOIDetailCollectData;
@end
