//
//  SearchInfoCell.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-23.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowViewCell.h"
#import "POIInfo.h"
#import "AsynImageView.h"
@interface SearchInfoCell : WaterFlowViewCell

@property(nonatomic, retain)  UILabel       *distanceLabel;
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
