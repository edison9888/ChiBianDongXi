//
//  Tag.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "TagInfo.h"

@implementation TagInfo

-(TagInfo *) initWithDictionary:(NSDictionary *)dic
{
  
    self = [super init];
    if (self)
    {
        self.tagName = [dic objectForKey:@"tagName"];
    }
    return self;
}

@end
