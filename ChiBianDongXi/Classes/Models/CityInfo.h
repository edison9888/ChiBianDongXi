//
//  CityInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistrictInfo.h"



@interface CityInfo : NSObject

@property (strong, nonatomic) NSString * cityName;
@property (strong, nonatomic) NSString * cityLatitude;
@property (strong, nonatomic) NSString * cityLongitude;
@property (strong, nonatomic) NSMutableArray * districtArray;
@property (strong, nonatomic) DistrictInfo * districtInfo;

@property (strong, nonatomic) NSString * cityImageUrl;
@property (strong, nonatomic) NSArray  *locationArray;


-(CityInfo *) initWithDictionary:(NSDictionary *)dic;
@end
