//
//  POIInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class POIShareInfo;

@interface POIInfo : NSObject

@property (strong, nonatomic) NSString * poiId;
@property (strong, nonatomic) NSString * poiName;
@property (strong, nonatomic) NSString * poiPhone;
@property (strong, nonatomic) NSString * poiCategory;
@property (strong, nonatomic) NSString * poiBeatPercent;
@property (strong, nonatomic) NSString * poiAverageSpend;
@property (strong, nonatomic) NSMutableArray * poiSpecialArray;
@property (strong, nonatomic) NSString * poiAddress;
@property (strong, nonatomic) NSString * poiDistrict;
@property (strong, nonatomic) NSString * poiLatitude;
@property (strong, nonatomic) NSString * poiLongitude;
@property (strong, nonatomic) NSString * poiScore;
@property (strong, nonatomic) NSArray * poiRecommentionFood;
@property (strong, nonatomic) NSString * poiImageId;
@property (strong, nonatomic) NSString * poiImageUrl;
@property (assign, nonatomic) CGSize     poiImageSize;
@property (strong, nonatomic) NSString * poiDetailUrl;
@property (strong, nonatomic) NSString * poiFavoriteNum;
@property (strong, nonatomic) NSString * poiShareNum;
@property (assign, nonatomic) NSInteger distance;
@property (strong, nonatomic) POIShareInfo * poiShareInfo;



-(POIInfo *) initWithDictionary:(NSDictionary *)dic;
@end
