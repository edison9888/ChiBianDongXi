//
//  POIShareInfoCell.h
//  ChiBianDongXi
//
//  Created by  lanou on 13-7-10.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "WaterFlowViewCell.h"
#import "WaterFlowViewCell.h"
#import "AsynImageView.h"
#import "POIShareInfo.h"



@interface POIShareInfoCell : WaterFlowViewCell
@property (strong, nonatomic) AsynImageView * shareImageView;
@property (strong, nonatomic) AsynImageView * userImageView;
@property (strong, nonatomic) UILabel * screenNameLabel;
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) POIShareInfo * shareInfo;
@property (assign, nonatomic) CGFloat cellHeight;

+(CGFloat) cellHeight:(POIShareInfo *) articleInfo;
@end
