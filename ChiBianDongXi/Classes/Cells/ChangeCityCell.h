//
//  ChangeCityCell.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityInfo;
@interface ChangeCityCell : UITableViewCell
@property(nonatomic,retain)UILabel *cityNameLabel;
@property(nonatomic,retain)UIImageView *cityIamge;
@property(nonatomic,retain)CityInfo *cityName;
@end
