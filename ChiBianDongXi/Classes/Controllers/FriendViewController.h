//
//  FriendViewController.h
//  ChiBianDongXi
//
//  Created by lanou on 13-7-8.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "NetworkConnection.h"
#import "CommentList.h"
#import "FriendCell.h"

@interface FriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NetworkConnectionDelegate>

@property(nonatomic,retain)UITableView * friendTableView;//建立一个tableview

@property(nonatomic,retain)NSMutableArray * totalfArray;//建立一个数组,里面放每列的值

@property(nonatomic,retain)CommentList *commentList;

@property(nonatomic,retain)NetworkConnection *networkConnection;

@property (strong, nonatomic) EGORefreshTableHeaderView * refreshHeaderView;

@property (strong, nonatomic) EGORefreshTableFooterView * refreshFooterView;

@property (assign, nonatomic) BOOL isReloading;//是否加载数据中

@property (assign, nonatomic) int pageNo;

@property (assign, nonatomic) int start;

@property (assign, nonatomic) int limit;

@property(nonatomic,retain)NSMutableArray * poiInfoArray;//建立一个数组,里面放每列的值
@end

