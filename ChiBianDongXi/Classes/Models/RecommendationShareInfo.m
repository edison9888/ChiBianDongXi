//
//  RecommendationShareInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "RecommendationShareInfo.h"

@implementation RecommendationShareInfo

-(RecommendationShareInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.matchRecommondation = [dic objectForKey:@"matchRecommondation"];
        self.poiShareInfo.shareId = [dic objectForKey:@"shareId"];
        self.poiShareInfo.screenName = [dic objectForKey:@"screenName"];
        self.poiShareInfo.sharePicUrl = [dic objectForKey:@"sharePicUrl"];
        self.poiShareInfo.shareContent = [dic objectForKey:@"text"];
        self.poiShareInfo.userImageUrl = [dic objectForKey:@"userImageUrl"];
        self.poiShareInfo.weiboTime = [dic objectForKey:@"weiboTime"];
    }
    return self;
}

@end
