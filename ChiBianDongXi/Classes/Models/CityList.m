//
//  CityList.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-13.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "CityList.h"

#import "CityInfo.h"

@implementation CityList
@synthesize cityInfoArray = _cityInfoArray;

-(CityList *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.cityInfoArray = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * mDic in [dic objectForKey:@"cityList"])
        {
            CityInfo * cityInfo = [[CityInfo alloc] initWithDictionary:mDic];
           
     
            cityInfo.cityName = [mDic objectForKey:@"cityName"];
            cityInfo.cityLatitude = [[mDic objectForKey:@"cityLocation"] objectAtIndex:1];
            cityInfo.cityLongitude = [[mDic objectForKey:@"cityLocation"] objectAtIndex:0];
            
            for (NSDictionary * dictrictDic in [mDic objectForKey:@"districtList"])
            {
                DistrictInfo * districtInfo = [[DistrictInfo alloc] init];
                
                districtInfo.districtLatitude = [[dictrictDic objectForKey:@"districtLocation"] objectAtIndex:1];
                districtInfo.districtLongitude = [[dictrictDic objectForKey:@"districtLocation"] objectAtIndex:0];
                districtInfo.districtName = [dictrictDic objectForKey:@"districtName"];
                
                [cityInfo.districtArray addObject:districtInfo];
                [districtInfo release];
            }
        
             
            [self.cityInfoArray addObject:cityInfo];
            [cityInfo release];
        }
        
    }
    return self;
}



- (void)dealloc
{
    [_cityInfoArray release];
    [super dealloc];
}
@end
