//
//  SearchListInfo.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-22.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "SearchListInfo.h"
#import "POIInfo.h"
@implementation SearchListInfo

-(SearchListInfo *) initWithDictionary:(NSDictionary *)dic
{
    self.searchInfoArray = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *searchInfoDic in [[dic objectForKey:@"searchKeyword"] objectForKey:@"results"]) {
        POIInfo *poiInfo = [[POIInfo alloc] initWithDictionary:searchInfoDic];
        [self.searchInfoArray addObject:poiInfo];
        [poiInfo release];
    }
    
    return self;
}
@end
