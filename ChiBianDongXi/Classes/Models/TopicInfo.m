//
//  TopicInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "TopicInfo.h"
#import "NSArray+ArrayToCGSize.h"

@implementation TopicInfo

@synthesize topicId = _topicId;
@synthesize topicName = _topicName;
@synthesize topicImageSize = _topicImageSize;
@synthesize topicImageUrl = _topicImageUrl;
@synthesize topicIntroduction = _topicIntroduction;
@synthesize topicLikeNumber = _topicLikeNumber;
@synthesize articleInfoArray = _articleInfoArray;
@synthesize start = _start;
@synthesize limit = _limit;

-(TopicInfo *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.articleInfoArray = [NSMutableArray arrayWithCapacity:1];
        
        if ([dic objectForKey:@"articles"] != nil)
        {
            for (NSDictionary * articleDic in [dic objectForKey:@"articles"])
            {
                ArticleInfo * articleInfo = [[ArticleInfo alloc] init];
                articleInfo.articleId = [articleDic objectForKey:@"articleId"];
                
                UserInfo * userInfo = [[UserInfo alloc] init];
                userInfo.userName = [articleDic objectForKey:@"authorName"];
                userInfo.userImageUrl = [articleDic objectForKey:@"authorImage"];
                articleInfo.userInfo = userInfo;
                [userInfo release];
                
                articleInfo.articleImageSize = [[articleDic objectForKey:@"defaultImageSize"] fromArrayToCGSize];
                articleInfo.articleImageUrl = [articleDic objectForKey:@"defaultImageUrl"];
                articleInfo.articleIntroduction = [articleDic objectForKey:@"defaultText"];
                articleInfo.articleFavoriteNum = [articleDic objectForKey:@"favNum"];
                
                POIInfo * poiInfo = [[POIInfo alloc] init];
                poiInfo.poiName = [articleDic objectForKey:@"poiName"];
                articleInfo.poiInfo = poiInfo;
                [poiInfo release];
                                
                [self.articleInfoArray addObject:articleInfo];
                [articleInfo release];
            }
        }
            
        self.topicImageUrl = [dic objectForKey:@"defaultTopicImageUrl"];
        self.topicImageSize = [[dic objectForKey:@"defaultTopicImageSize"] fromArrayToCGSize];
        self.topicName = [dic objectForKey:@"title"];
        self.topicIntroduction = [dic objectForKey:@"intro"];
        self.topicLikeNumber = [dic objectForKey:@"likeNum"];
    }
    return self;
}

- (void)dealloc
{
    [_topicId release];
    [_articleInfoArray release];
    [_topicImageUrl release];
    [_topicName release];
    [_topicLikeNumber release];
    [_topicIntroduction release];
    [_start release];
    [_limit release];

    [super dealloc];
}

@end
