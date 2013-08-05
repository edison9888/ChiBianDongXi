//
//  CollectSecondCell.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectInfo.h"
@interface CollectSecondCell : UITableViewCell
@property (nonatomic,retain) UIImageView *collectImageView;
@property (nonatomic,retain) UILabel *poiLabel;
@property (nonatomic,retain) UILabel *articleLabel;
@property (nonatomic,retain) CollectInfo *collectInfo;
@property (nonatomic,retain) NSString *path;
@end
