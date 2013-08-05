//
//  TopicInfoCell.h
//  ChiBianDongXi 2.0
//
//  Created by Andy Gu on 7/15/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "WaterFlowViewCell.h"
#import "AsynImageView.h"
#import "ArticleInfo.h"

@interface TopicInfoCell : WaterFlowViewCell

@property (strong, nonatomic) AsynImageView * authorImageView;
@property (strong, nonatomic) AsynImageView * articleImageView;
@property (strong, nonatomic) UILabel * authorNameLabel;
@property (strong, nonatomic) UILabel * textLabel;
@property (strong, nonatomic) ArticleInfo * articleInfo;
@property (strong, nonatomic) UILabel * poiNameLabel;
@property (assign, nonatomic) CGFloat cellHeight;

+(CGFloat) cellHeight:(ArticleInfo *) articleInfo;

@end
