//
//  MapViewController.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 7/19/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapViewController : UIViewController<BMKMapViewDelegate, BMKSearchDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BMKSearch* _search;
    UIView *_aView;
    
}

@property(nonatomic,retain)UIAlertView          *alertView;
@property(nonatomic,retain)BMKMapView           *mapView;
@property(nonatomic,retain)CLLocation           *mylocation;
@property(nonatomic, retain) CLLocation         *destinationLocation;
@property(nonatomic,retain)NSMutableArray       *routeArray;
@property(nonatomic,retain)UITableView          *tableView;
@property(nonatomic,retain)UISegmentedControl   *segment;


@end