//
//  POIListInfo.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-13.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "POIListInfo.h"
#import "POIInfo.h"
#import "POIShareInfo.h"

@implementation POIListInfo

-(POIListInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.poiListArray = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * poiInfoDic in [dic objectForKey:@"getPoiList"])
        {
            
            POIInfo * poiInfo = [[POIInfo alloc] initWithDictionary:poiInfoDic];
            /****
             //        poiInfo.poiId = [dic objectForKey:@"poiId"];
             //        poiInfo.poiAddress = [dic objectForKey:@"addressDetail"];
             //        poiInfo.poiDistrict = [dic objectForKey:@"address"];
             //        poiInfo.poiCategory = [dic objectForKey:@"category"];
             //        poiInfo.poiImageId = [dic objectForKey:@"imageId"];
             //        poiInfo.poiImageSize = [[dic objectForKey:@"imageSize"] fromArrayToCGSize];
             //        poiInfo.poiLatitude = [[dic objectForKey:@"location"] objectAtIndex:1];
             //        poiInfo.poiLongitude = [[dic objectForKey:@"location"] objectAtIndex:0];
             //        poiInfo.poiBeatPercent = [dic objectForKey:@"percent"];
             //        poiInfo.poiPhone = [dic objectForKey:@"phoneNumber"];
             //        poiInfo.poiDetailUrl = [dic objectForKey:@"poiDetailUrl"];
             //        poiInfo.poiName = [dic objectForKey:@"poiName"];
             //        poiInfo.poiAverageSpend = [dic objectForKey:@"price"];
             //
             //
             //        poiInfo.poiSpecialArray = [NSMutableArray arrayWithCapacity:1];
             //
             //        for (NSString * str in [dic objectForKey:@"qqTagLsit"])
             //        {
             //            NSArray * array =  [str componentsSeparatedByString:@"="];
             //
             //            NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithCapacity:1];
             //            [mDic setObject:[array objectAtIndex:0] forKey:@"imageUrl"];
             //            [mDic setObject:[array objectAtIndex:1] forKey:@"name"];
             //            [poiInfo.poiSpecialArray addObject:mDic];
             //        }
             //
             //        poiInfo.poiRecommentionFood = [dic objectForKey:@"recommentionFood"];
             //        poiInfo.poiScore = [dic objectForKey:@"score"];
             //
             //        POIShareInfo * poiShareInfo = [[POIShareInfo alloc] init];
             //        poiShareInfo.shareContent = [[dic objectForKey:@"share"] objectForKey:@"text"];
             //        poiShareInfo.userImageUrl = [[dic objectForKey:@"share"] objectForKey:@"userAvatar"];
             //        poiShareInfo.screenName = [[dic objectForKey:@"share"] objectForKey:@"userName"];
             //        poiShareInfo.userId = [[dic objectForKey:@"share"] objectForKey:@"userId"];
             //        poiInfo.poiShareInfo = poiShareInfo;
             //        [poiShareInfo release];
             //        
             //        poiInfo.poiShareNum = [[dic objectForKey:@"shareNum"] stringValue];
             
             ***/
            [self.poiListArray addObject:poiInfo];
            [poiInfo release];
        }
    }
    
    return self;
}
@end
