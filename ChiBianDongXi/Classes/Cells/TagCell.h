//
//  TagCell.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-19.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFlowViewCell.h"
#import "AsynImageView.h"
#import "ArticleInfo.h"
#import "TagArticlesInfo.h"

@interface TagCell : WaterFlowViewCell
@property (strong, nonatomic) AsynImageView * authorImageView;
@property (strong, nonatomic) AsynImageView * defaultImageView;
@property (strong, nonatomic) UILabel * authorNameLabel;
@property (strong, nonatomic) UILabel * textLabel;
@property (nonatomic,retain) TagArticlesInfo *tagArticlesInfo;
@property (strong, nonatomic) UILabel * poiNameLabel;
@property (assign, nonatomic) CGFloat cellHeight;

+(CGFloat) cellHeight:(TagArticlesInfo *) tagArticlesInfo;
@end
