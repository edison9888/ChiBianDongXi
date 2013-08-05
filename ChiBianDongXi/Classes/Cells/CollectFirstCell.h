//
//  CollectFirstCell.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AsyImageView;
@class CollectInfo;
@interface CollectFirstCell : UITableViewCell
@property (nonatomic,retain) UIImageView *collectImageView;
@property (nonatomic,retain) UILabel *poiLabel;
@property (nonatomic,retain) UILabel *perCapitaLabel;
@property (nonatomic,retain) UILabel *addressLabel;
@property (nonatomic,retain) UILabel *phoneLabel;
@property (nonatomic,retain) CollectInfo *collectInfo;
@property (nonatomic,retain)AsyImageView  * videoImage;
@property (nonatomic,retain) NSString *path;
@end
