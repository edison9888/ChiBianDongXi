//
//  POICell.h
//  TwoTableView
//
//  Created by lanou on 7/10/13.
//  Copyright (c) 2013 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowViewCell.h"
#import "POIInfo.h"
#import "AsynImageView.h"

@interface POICell : WaterFlowViewCell


@property(nonatomic, retain)  UILabel       *poiNameLabel;
@property (strong, nonatomic) AsynImageView *poiImageView;
@property(nonatomic, retain)  UILabel       *shareNumLabel;
@property(nonatomic, retain)  UILabel       *weiboLabel;
@property(nonatomic, retain)  UILabel       *addressLabel;
@property(nonatomic, retain)  UILabel       *categoryLabel;
@property(nonatomic, retain)  UILabel       *priceLabel;
@property(nonatomic, assign)  CGFloat        cellHeight;


@property(nonatomic, retain)  POIInfo       *poiIndo;


+(CGFloat) cellHeight:(POIInfo *) poiInfo;

@end
