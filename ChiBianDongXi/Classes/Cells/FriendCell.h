//
//  FriendCell.h
//  ChiBianDongXi
//
//  Created by lanou on 13-7-11.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"
#import "POIShareInfo.h"

@class POIInfo;
@class POIShareInfo;
@class CommentList;
@class AsynImageView;

@interface FriendCell : UITableViewCell

@property(nonatomic,retain)AsynImageView * userImage;
@property(nonatomic,retain)AsynImageView * shareImage;
@property(nonatomic,retain)CommentInfo * commentInfo;
@property(nonatomic,retain)UILabel * screenNameLabel;
@property(nonatomic,retain)UILabel * shareContentLabel;
@property(nonatomic,retain)UILabel * weiboTimeLabel;
@property(nonatomic,retain)UILabel * poiNameLabel;
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,strong) POIInfo * poiInfo;
@property(nonatomic,strong) POIShareInfo * poiShareInfo;
@property(nonatomic,retain)UIView *oneView;
@property(nonatomic,retain)UITextField *fieldComment;
@property(nonatomic,retain)UITextField *fieldCommentInfo;

+ (CGFloat)cellHeight:(POIShareInfo *)poiShareInfo;
@end
