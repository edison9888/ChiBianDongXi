//
//  POIShareList.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-13.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "POIShareList.h"
#import "POIShareInfo.h"

@implementation POIShareList

@synthesize poiShareInfoArray = _poiShareInfoArray;

-(POIShareList *) initWithDictionary:(NSDictionary *)dic
{
    self.poiShareInfoArray = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary * shareInfoDic in [dic objectForKey:@"shareList"])
    {
        POIShareInfo *poiShareInfo = [[POIShareInfo alloc] init];
        poiShareInfo.shareId = [shareInfoDic objectForKey:@"shareId"];
        poiShareInfo.screenName = [shareInfoDic objectForKey:@"screenName"];
        poiShareInfo.sharePicUrl = [shareInfoDic objectForKey:@"sharePicUrl"];
        poiShareInfo.shareContent = [shareInfoDic objectForKey:@"text"];
        poiShareInfo.userImageUrl = [shareInfoDic objectForKey:@"userImageUrl"];
        poiShareInfo.weiboTime = [shareInfoDic objectForKey:@"weiboTime"];
        
        [self.poiShareInfoArray addObject:poiShareInfo];
        
    }
    return self;
    
}


- (void)dealloc
{
    [_poiShareInfoArray release];
    [super dealloc];
}

@end
