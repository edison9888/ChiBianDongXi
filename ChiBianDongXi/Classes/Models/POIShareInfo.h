//
//  POIShareInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIShareInfo : NSObject

@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * shareId;
@property (strong, nonatomic) NSString * screenName;
@property (strong, nonatomic) NSString * sharePicUrl;
@property (strong, nonatomic) NSString * shareContent;
@property (strong, nonatomic) NSString * userImageUrl;
@property (strong, nonatomic) NSString * weiboTime;


-(POIShareInfo *) initWithDictionary:(NSDictionary *)dic;


@end
