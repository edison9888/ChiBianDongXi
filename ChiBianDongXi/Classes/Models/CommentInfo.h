//
//  CommentInfo.h
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-14.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIInfo.h"
#import "POIShareInfo.h"

@interface CommentInfo : NSObject

@property (strong, nonatomic) NSMutableArray * userInfoArray;
@property (strong, nonatomic) NSString * favoriteUsers;
@property (strong, nonatomic) POIInfo * poiInfo;
@property (strong, nonatomic) POIShareInfo * poiShareInfo;


-(CommentInfo * ) initWithDictionary:(NSDictionary *)dic;
@end
