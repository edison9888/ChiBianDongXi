//
//  TagViewController.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-14.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkConnection.h"
#import "TagInfo.h"
#import "TagList.h"
@class NetworkConnection;
@interface TagViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,NetworkConnectionDelegate>
@property (nonatomic,retain) NSMutableData *receiveData;
@property (nonatomic,retain) UITextField *tagTextField;
@property (nonatomic,retain) UISearchBar *tagSearchBar;
@property (nonatomic,retain) UITableView *tagTableView;

@property (nonatomic,retain) TagInfo *tagInfo;
@property (strong, nonatomic) NetworkConnection * networkConnection;
@property (strong, nonatomic) TagList * tagInfoResult;
@end
