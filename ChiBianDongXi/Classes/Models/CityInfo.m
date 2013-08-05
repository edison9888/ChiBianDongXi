//
//  CityInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo

@synthesize cityName = _cityName;
@synthesize cityLatitude = _cityLatitude;
@synthesize cityLongitude = _cityLongitude;
@synthesize cityImageUrl = _cityImageUrl;

-(CityInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        for (NSDictionary * mDic in [dic objectForKey:@"cityList"])
        {
            self.cityName = [mDic objectForKey:@"cityName"];
            self.cityLatitude = [[mDic objectForKey:@"cityLocation"] objectAtIndex:1];
            self.cityLongitude = [[mDic objectForKey:@"cityLocation"] objectAtIndex:0];
            self.locationArray  = [mDic objectForKey:@"cityLocation"];
            
            for (NSDictionary * dictrictDic in [mDic objectForKey:@"districtList"])
            {
                DistrictInfo * districtInfo = [[DistrictInfo alloc] init];
                
                districtInfo.districtLatitude = [[dictrictDic objectForKey:@"districtLocation"] objectAtIndex:1];
                districtInfo.districtLongitude = [[dictrictDic objectForKey:@"districtLocation"] objectAtIndex:0];
                districtInfo.districtName = [dictrictDic objectForKey:@"districtName"];
                
                [self.districtArray addObject:districtInfo];
                [districtInfo release];
            }

        }
    }
    return self;
}

- (void)dealloc
{
    [_cityName release];
    [_cityLatitude release];
    [_cityLongitude release];
    [_cityImageUrl release];
    [self.locationArray release];
    [super dealloc];
}
@end
