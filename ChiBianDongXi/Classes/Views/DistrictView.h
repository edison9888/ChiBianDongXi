//
//  DistrictView.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/16/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class NetworkConnection;

//此类是点击附近最热页面的地址按钮后弹出来的地图视图，可以选择地点和商业圈


@interface DistrictView : UIView<MKMapViewDelegate, UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) CLLocation         *currentLocation;
@property(nonatomic, retain) MKMapView          *locationMapView;
@property(nonatomic, retain) UITableView        *tableView;
@property(nonatomic, retain) UISegmentedControl *segmentControl;
@property(nonatomic, retain) UIButton           *selectedButton;

@property(nonatomic, retain) NetworkConnection *networkConnection;
@property(nonatomic, retain) NSMutableArray    *districtNameArray;
@property(nonatomic, retain) NSMutableDictionary *districtNameDic;


@property(nonatomic, assign) BOOL               flag;


- (void)getMapData;


@end
