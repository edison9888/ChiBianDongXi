//
//  Weekend.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "Weekend.h"

#import "ArticleInfo.h"
#import "TagInfo.h"
#import "TopicInfo.h"
#import "NSArray+ArrayToCGSize.h"

@implementation Weekend
@synthesize articleArray = _articleArray;
@synthesize topicArray = _topicArray;
@synthesize tagArray = _tagArray;

-(Weekend *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.articleArray = [NSMutableArray arrayWithCapacity:1];
        self.tagArray = [NSMutableArray arrayWithCapacity:1];
        self.topicArray = [NSMutableArray arrayWithCapacity:1];
        
        if ([dic objectForKey:@"articleArray"] != nil)
        {
            for (NSDictionary * articleDic in [dic objectForKey:@"articleArray"])
            {
                ArticleInfo * articleInfo = [[ArticleInfo alloc] init];
                
                articleInfo.articleId = [articleDic objectForKey:@"articleId"];
                
                UserInfo * userInfo = [[UserInfo alloc] init];
                userInfo.userImageUrl = [articleDic objectForKey:@"authorImage"];
                userInfo.userName = [articleDic objectForKey:@"authorName"];
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
                
                articleInfo.type = @"ArticleInfo";
                
                [self.articleArray addObject:articleInfo];
            }
        }
        
        if ([dic objectForKey:@"recommendArticleArray"] != nil)
        {
            for (NSDictionary * mDic in [dic objectForKey:@"recommendArticleArray"])
            {
                if ([[[mDic objectForKey:@"type"] stringValue] isEqual:@"0"])
                {
                    ArticleInfo * articleInfo = [[ArticleInfo alloc] init];
                    articleInfo.articleId = [mDic objectForKey:@"articleId"];
                    
                    UserInfo * userInfo = [[UserInfo alloc] init];
                    userInfo.userImageUrl = [mDic objectForKey:@"authorImage"];
                    userInfo.userName = [mDic objectForKey:@"authorName"];
                    articleInfo.userInfo = userInfo;
                    [userInfo release];

                    articleInfo.articleImageSize = [[mDic objectForKey:@"defaultImageSize"] fromArrayToCGSize];
                    articleInfo.articleImageUrl = [mDic objectForKey:@"defaultImageUrl"];
                    articleInfo.articleIntroduction = [mDic objectForKey:@"defaultText"];
                    articleInfo.articleFavoriteNum = [mDic objectForKey:@"favNum"];
                    
                    POIInfo * poiInfo = [[POIInfo alloc] init];
                    poiInfo.poiName = [mDic objectForKey:@"poiName"];
                    articleInfo.poiInfo = poiInfo;
                    [poiInfo release];
                    
                    articleInfo.type = @"RecommendArticleInfo";
                    
                    [self.articleArray addObject:articleInfo];
                }
                else if([[[mDic objectForKey:@"type"] stringValue] isEqual:@"1"])
                {
                    TagInfo * tagInfo = [[TagInfo alloc] init];
                    tagInfo.tagImageSize = [[mDic objectForKey:@"defaultImageSize"] fromArrayToCGSize];
                    tagInfo.tagImageUrl = [mDic objectForKey:@"defaultImageUrl"];
                    tagInfo.tagId = [mDic objectForKey:@"tagId"];
                    tagInfo.tagName = [mDic objectForKey:@"tagName"];
                    [self.tagArray addObject:tagInfo];
                }
            }
        }
        
        if ([dic objectForKey:@"recommendTopicArray"] != nil)
        {
            for (NSDictionary * topicDic in [dic objectForKey:@"recommendTopicArray"])
            {
                TopicInfo * topicInfo = [[TopicInfo alloc] init];
                topicInfo.topicImageSize = [[topicDic objectForKey:@"topicImageSize"] fromArrayToCGSize];
                topicInfo.topicImageUrl = [topicDic objectForKey:@"topicImageUrl"];
                topicInfo.topicId = [topicDic objectForKey:@"topicId"];
                topicInfo.topicName = [topicDic objectForKey:@"topicName"];
                [self.topicArray addObject:topicInfo];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_articleArray release];
    [_tagArray release];
    [_topicArray release];
    [super dealloc];
}


@end
