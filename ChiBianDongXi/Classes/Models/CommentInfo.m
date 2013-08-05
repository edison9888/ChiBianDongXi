//
//  CommentInfo.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-14.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "CommentInfo.h"
#import "UserInfo.h"
#import "POIInfo.h"
#import "POIShareInfo.h"
#import "NSArray+ArrayToCGSize.h"

@implementation CommentInfo

@synthesize userInfoArray = _userInfoArray;
@synthesize poiInfo = _poiInfo;
@synthesize poiShareInfo = _poiShareInfo;
@synthesize favoriteUsers = _favoriteUsers;

-(CommentInfo * ) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.userInfoArray = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * userInfoDic in [dic objectForKey:@"commentList"])
        {
            UserInfo * userInfo = [[UserInfo alloc] init];
            userInfo.userName = [userInfoDic objectForKey:@"owner"];
            userInfo.userImageUrl = [userInfoDic objectForKey:@"ownerAvatar"];
            userInfo.userComment = [userInfoDic objectForKey:@"text"];
            [self.userInfoArray addObject:userInfo];
            [userInfo release];
        }
        
        self.favoriteUsers = [dic objectForKey:@"favoriteUsers"];

        POIInfo * poiInfo = [[POIInfo alloc] initWithDictionary:[dic objectForKey:@"poiInfo"]];
/****
//        NSDictionary * poiInfoDic = [dic objectForKey:@"poiInfo"];
//        poiInfo.poiId = [poiInfoDic objectForKey:@"poiId"];
//        poiInfo.poiAddress = [poiInfoDic objectForKey:@"addressDetail"];
//        poiInfo.poiDistrict = [poiInfoDic objectForKey:@"address"];
//        poiInfo.poiCategory = [poiInfoDic objectForKey:@"category"];
//        poiInfo.poiImageId = [poiInfoDic objectForKey:@"imageId"];
//        poiInfo.poiImageSize = [[poiInfoDic objectForKey:@"imageSize"] fromArrayToCGSize];
//        poiInfo.poiLatitude = [[poiInfoDic objectForKey:@"location"] objectAtIndex:1];
//        poiInfo.poiLongitude = [[poiInfoDic objectForKey:@"location"] objectAtIndex:0];
//        poiInfo.poiBeatPercent = [poiInfoDic objectForKey:@"percent"];
//        poiInfo.poiPhone = [poiInfoDic objectForKey:@"phoneNumber"];
//        poiInfo.poiDetailUrl = [poiInfoDic objectForKey:@"poiDetailUrl"];
//        poiInfo.poiName = [poiInfoDic objectForKey:@"poiName"];
//        poiInfo.poiAverageSpend = [poiInfoDic objectForKey:@"price"];
//        
//        poiInfo.poiSpecialArray = [NSMutableArray arrayWithCapacity:1];
//        
//        NSDictionary * tagDic = [poiInfoDic objectForKey:@"qqTagLsit"];
//        
//        if ([tagDic count] > 0)
//        {
//            NSArray * keysArray = [tagDic allKeys];
//            for (int i = 0; i < keysArray.count; i++)
//            {
//                NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithCapacity:1];
//                NSString * keyStr = [keysArray objectAtIndex:i];
//                [mDic setObject:[tagDic objectForKey:keyStr] forKey:keyStr];
//                [poiInfo.poiSpecialArray addObject:mDic];
//            }
//        }
//        
//        poiInfo.poiRecommentionFood = [poiInfoDic objectForKey:@"recommentionFood"];
//        poiInfo.poiScore = [poiInfoDic objectForKey:@"score"];
 ***/

//         NSDictionary * poiInfoDic = [dic objectForKey:@"poiInfo"];
//        POIInfo * poiInfo = [[POIInfo alloc] initWithDictionary:poiInfoDic];
        /***
       
        poiInfo.poiId = [poiInfoDic objectForKey:@"poiId"];
        poiInfo.poiAddress = [poiInfoDic objectForKey:@"addressDetail"];
        poiInfo.poiDistrict = [poiInfoDic objectForKey:@"address"];
        poiInfo.poiCategory = [poiInfoDic objectForKey:@"category"];
        poiInfo.poiImageId = [poiInfoDic objectForKey:@"imageId"];
        poiInfo.poiImageSize = [[poiInfoDic objectForKey:@"imageSize"] fromArrayToCGSize];
        poiInfo.poiLatitude = [[poiInfoDic objectForKey:@"location"] objectAtIndex:1];
        poiInfo.poiLongitude = [[poiInfoDic objectForKey:@"location"] objectAtIndex:0];
        poiInfo.poiBeatPercent = [poiInfoDic objectForKey:@"percent"];
        poiInfo.poiPhone = [poiInfoDic objectForKey:@"phoneNumber"];
        poiInfo.poiDetailUrl = [poiInfoDic objectForKey:@"poiDetailUrl"];
        poiInfo.poiName = [poiInfoDic objectForKey:@"poiName"];
        poiInfo.poiAverageSpend = [poiInfoDic objectForKey:@"price"];
        
        poiInfo.poiSpecialArray = [NSMutableArray arrayWithCapacity:1];
        
        NSDictionary * tagDic = [poiInfoDic objectForKey:@"qqTagLsit"];
        
        if ([tagDic count] > 0)
        {
            NSArray * keysArray = [tagDic allKeys];
            for (int i = 0; i < keysArray.count; i++)
            {
                NSMutableDictionary * mDic = [NSMutableDictionary dictionaryWithCapacity:1];
                NSString * keyStr = [keysArray objectAtIndex:i];
                [mDic setObject:[tagDic objectForKey:keyStr] forKey:keyStr];
                [poiInfo.poiSpecialArray addObject:mDic];
            }
        }
        
        poiInfo.poiRecommentionFood = [poiInfoDic objectForKey:@"recommentionFood"];
        poiInfo.poiScore = [poiInfoDic objectForKey:@"score"];

         **/
        self.poiInfo = poiInfo;
        [poiInfo release];
    
        
        POIShareInfo * poiShareInfo = [[POIShareInfo alloc] init];
        poiShareInfo.shareId = [dic objectForKey:@"shareId"];
        poiShareInfo.screenName = [dic objectForKey:@"screenName"];
        poiShareInfo.sharePicUrl = [dic objectForKey:@"sharePicUrl"];
        poiShareInfo.shareContent = [dic objectForKey:@"text"];
        poiShareInfo.userImageUrl = [dic objectForKey:@"userImageUrl"];
        poiShareInfo.weiboTime = [dic objectForKey:@"weiboTime"];
        
        self.poiShareInfo = poiShareInfo;
        [poiShareInfo release];
        }
        return self;
   }

- (void)dealloc
{
    [_userInfoArray release];
    [_poiInfo release];
    [_poiShareInfo release];
    [_favoriteUsers release];
    [super dealloc];
}

@end
