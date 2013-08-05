//
//  POIInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "POIInfo.h"
#import "NSArray+ArrayToCGSize.h"
#import "POIShareInfo.h"

@implementation POIInfo

@synthesize poiId = _poiId;
@synthesize poiName = _poiName;
@synthesize poiPhone = _poiPhone;
@synthesize poiCategory = _poiCategory;
@synthesize poiBeatPercent = _poiBeatPercent;
@synthesize poiAverageSpend = _poiAverageSpend;
@synthesize poiSpecialArray = _poiSpecialArray;
@synthesize poiAddress = _poiAddress;
@synthesize poiDistrict = _poiDistrict;
@synthesize poiLatitude = _poiLatitude;
@synthesize poiLongitude = _poiLongitude;
@synthesize poiScore = _poiScore;
@synthesize poiRecommentionFood = _poiRecommentionFood;
@synthesize poiImageId = _poiImageId;
@synthesize poiImageUrl = _poiImageUrl;
@synthesize poiImageSize = _poiImageSize;
@synthesize poiFavoriteNum = _poiFavoriteNum;
@synthesize poiDetailUrl = _poiDetailUrl;



-(POIInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.poiId = [dic objectForKey:@"poiId"];
        self.poiAddress = [dic objectForKey:@"addressDetail"];
        self.poiDistrict = [dic objectForKey:@"address"];
        self.poiCategory = [dic objectForKey:@"category"];
        self.poiImageId = [dic objectForKey:@"imageId"];
        self.poiImageSize = [[dic objectForKey:@"imageSize"] fromArrayToCGSize];
        self.poiLatitude = [[dic objectForKey:@"location"] objectAtIndex:1];
        self.poiLongitude = [[dic objectForKey:@"location"] objectAtIndex:0];
        self.poiBeatPercent = [dic objectForKey:@"percent"];
        self.poiPhone = [dic objectForKey:@"phoneNumber"];
        self.poiDetailUrl = [dic objectForKey:@"poiDetailUrl"];
        self.poiName = [dic objectForKey:@"poiName"];
        self.poiAverageSpend = [dic objectForKey:@"price"];
        self.distance = [[dic objectForKey:@"distance"] intValue];
        self.poiSpecialArray = [NSMutableArray arrayWithCapacity:1];
        NSDictionary * tagDic = [dic objectForKey:@"qqTagLsit"];
        
        if ([tagDic count] > 0)
        {
            NSArray * keysArray = [tagDic allKeys];
            for (int i = 0; i < keysArray.count; i++)
            {
                NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithCapacity:1];
                NSString * keyStr = [keysArray objectAtIndex:i];
                [mDic setObject:[tagDic objectForKey:keyStr] forKey:keyStr];
                [self.poiSpecialArray addObject:mDic];
            }
        }

        self.poiRecommentionFood = [dic objectForKey:@"recommentionFood"];
        self.poiScore = [dic objectForKey:@"score"];

        POIShareInfo * poiShareInfo = [[POIShareInfo alloc] init];
        poiShareInfo.shareContent = [[dic objectForKey:@"share"] objectForKey:@"text"];
        poiShareInfo.userImageUrl = [[dic objectForKey:@"share"] objectForKey:@"userAvatar"];
        poiShareInfo.screenName = [[dic objectForKey:@"share"] objectForKey:@"userName"];
        poiShareInfo.userId = [[dic objectForKey:@"share"] objectForKey:@"userId"];
        self.poiShareInfo = poiShareInfo;
        [poiShareInfo release];
        
        self.poiShareNum = [[dic objectForKey:@"shareNum"] stringValue];
    }
    return self;
}

- (void)dealloc
{
    [_poiId release];
    [_poiName release];
    [_poiPhone release];
    [_poiCategory release];
    [_poiBeatPercent release];
    [_poiAverageSpend release];
    [_poiSpecialArray release];
    [_poiAddress release];
    [_poiDistrict release];
    [_poiLatitude release];
    [_poiLongitude release];
    [_poiScore release];
    [_poiRecommentionFood release];
    [_poiImageId release];
    [_poiImageUrl release];
    [_poiDetailUrl release];
    [_poiFavoriteNum release];
    [_poiShareInfo release];
    [super dealloc];
}

@end
