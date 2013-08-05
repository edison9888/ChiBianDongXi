//
//  POIShareInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "POIShareInfo.h"

@implementation POIShareInfo

-(POIShareInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {

        for (NSDictionary * shareInfoDic in [dic objectForKey:@"shareList"])
        {
            self.shareId = [shareInfoDic objectForKey:@"shareId"];
            self.screenName = [shareInfoDic objectForKey:@"screenName"];
            self.sharePicUrl = [shareInfoDic objectForKey:@"sharePicUrl"];
            self.shareContent = [shareInfoDic objectForKey:@"text"];
            self.userImageUrl = [shareInfoDic objectForKey:@"userImageUrl"];
            self.weiboTime = [shareInfoDic objectForKey:@"weiboTime"];
        }
    }
    return self;
}






@end
