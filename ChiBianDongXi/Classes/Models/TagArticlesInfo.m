//
//  TagArticlesInfo.m
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-19.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "TagArticlesInfo.h"
#import "NSArray+ArrayToCGSize.h"
#import "POIShareInfo.h"
@implementation TagArticlesInfo

-(TagArticlesInfo *)initWithDictionary:(NSDictionary *)dic
{

    self.tagArticlesInfoArray = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary * tagArticInfoDic in [dic objectForKey:@"articleArray"]) {
        
        TagArticlesInfo *tagArticlesInfo = [[TagArticlesInfo alloc] init];
        tagArticlesInfo.authorImage  = [tagArticInfoDic objectForKey:@"authorImage"];
        tagArticlesInfo.authorName  = [tagArticInfoDic objectForKey:@"authorName"];
        tagArticlesInfo.defaultImageUrl  = [tagArticInfoDic objectForKey:@"defaultImageUrl"];
        tagArticlesInfo.defaultText  = [tagArticInfoDic objectForKey:@"defaultText"];
        tagArticlesInfo.poiName  = [tagArticInfoDic objectForKey:@"poiName"];
        tagArticlesInfo.articleId = [tagArticInfoDic objectForKey:@"articleId"];
        tagArticlesInfo.defaultImageSize  = [[tagArticInfoDic objectForKey:@"defaultImageSize"] fromArrayToCGSize];
        tagArticlesInfo.favNum  = [[tagArticInfoDic objectForKey:@"poiName"] intValue];

        [_tagArticlesInfoArray addObject:tagArticlesInfo];
    }
    return self;
}

- (void)dealloc
{
    self.articleId = nil;
    self.authorImage = nil;
    self.authorName = nil;
    self.defaultImageUrl = nil;
    self.defaultText = nil;
    self.poiName = nil;
    [super dealloc];
}
@end
