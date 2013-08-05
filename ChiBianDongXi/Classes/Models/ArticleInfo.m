//
//  ArticleInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "ArticleInfo.h"
#import "NSArray+ArrayToCGSize.h"

@implementation ArticleInfo

-(ArticleInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        UserInfo * userInfo = [[UserInfo alloc] init];
        userInfo.userName = [dic objectForKey:@"authorName"];
        userInfo.userImageUrl = [dic objectForKey:@"authorImage"];
        self.userInfo = userInfo;
        [userInfo release];
        
        self.articleFavoriteNum = [dic objectForKey:@"favoriteNum"];
        self.articleIntroduction = [dic objectForKey:@"groupBuyTitle"];
        
        POIInfo * poiInfo = [[POIInfo alloc] init];
        poiInfo.poiId = [[dic objectForKey:@"poi"] objectForKey:@"poiId"];
        poiInfo.poiName = [[dic objectForKey:@"poi"] objectForKey:@"poiName"];
        poiInfo.poiAddress = [[dic objectForKey:@"poi"] objectForKey:@"addressDetail"];
        poiInfo.poiDistrict = [[dic objectForKey:@"poi"] objectForKey:@"address"];
        poiInfo.poiCategory = [[dic objectForKey:@"poi"] objectForKey:@"category"];
        poiInfo.poiLatitude = [[[dic objectForKey:@"poi"] objectForKey:@"location"] objectAtIndex:1];
        poiInfo.poiLongitude = [[[dic objectForKey:@"poi"] objectForKey:@"location"] objectAtIndex:0];
        poiInfo.poiBeatPercent = [[dic objectForKey:@"poi"] objectForKey:@"percent"];
        poiInfo.poiPhone = [[dic objectForKey:@"poi"] objectForKey:@"phoneNumber"];
        poiInfo.poiDetailUrl = [[dic objectForKey:@"poi"] objectForKey:@"poiDetailUrl"];
        poiInfo.poiAverageSpend = [[dic objectForKey:@"poi"] objectForKey:@"price"];
        poiInfo.poiRecommentionFood = [[dic objectForKey:@"poi"] objectForKey:@"recommentionFood"];
        poiInfo.poiScore = [[dic objectForKey:@"poi"] objectForKey:@"score"];
        poiInfo.poiShareNum = [[dic objectForKey:@"poi"] objectForKey:@"shareNum"];
        self.poiInfo = poiInfo;
        [poiInfo release];
        
        for (NSString * str in [dic objectForKey:@"tags"])
        {
            self.articleTag = str;

        }
        self.articleTime = [dic objectForKey:@"time"];
        
        if ([[[dic objectForKey:@"textType"] stringValue] isEqualToString:@"2"])
        {
            self.articleContent = [[[dic objectForKey:@"text"] objectAtIndex:0] objectForKey:@"content"];
            self.articleImageSize = [[[[dic objectForKey:@"text"] objectAtIndex:0] objectForKey:@"imageSize"] fromArrayToCGSize];
            self.articleImageUrl = [[[dic objectForKey:@"text"] objectAtIndex:0] objectForKey:@"imageUrl"];
        }
        if ([[[dic objectForKey:@"textType"] stringValue] isEqualToString:@"1"])
        {
            self.textArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary * textDic in [dic objectForKey:@"text"])
            {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic setObject:[textDic objectForKey:@"content"] forKey:@"content"];
                [dic setObject:[textDic objectForKey:@"imageSize"] forKey:@"imageSize"];
                [dic setObject:[textDic objectForKey:@"imageUrl"] forKey:@"imageUrl"];
                [self.textArray addObject:dic];
            }
        }
    }
    return self;
}

@end
