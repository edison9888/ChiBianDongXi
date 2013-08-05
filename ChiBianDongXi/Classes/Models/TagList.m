//
//  TagList.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-15.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "TagList.h"
#import "TagInfo.h"


@implementation TagList

@synthesize tagInfoArray = _tagInfoArray;

-(TagList *) initWithDictionary:(NSDictionary *)dic
{
    self.tagInfoArray = [[NSMutableArray alloc] init];
    for (NSDictionary * tagInfoDic in [dic objectForKey:@"tags"])
    {
        TagInfo * tagInfo = [[TagInfo alloc] initWithDictionary:tagInfoDic];
        
        [self.tagInfoArray addObject:tagInfo];
  
    }
    
    return self;
}

@end
