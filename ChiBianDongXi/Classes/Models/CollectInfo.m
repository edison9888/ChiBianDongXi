//
//  CollectInfo.m
//  Collect
//
//  Created by  lanou on 13-7-3.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import "CollectInfo.h"

@implementation CollectInfo

-(id)initWithId:(int)aId poiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl
{
    self = [super init];
    if (self) {
        self.id = aId;
        self.poiCategory = aPoiCategory;
        self.poiScore = aPoiScore;
        self.poiName = aPoiName;
        self.poiPerCapita = aPoiPerCapita;
        self.poiAddress = aPoiAddress;
        self.poiPhone = aPoiPhone;
        self.poiImageurl = aPoiImageurl;
        self.poiId = aPoiId;
        self.articleId = aArticelId;
        self.articleContent = aArticelContent;
        self.articleImageurl = aArticleImageurl;
    }
    return self;
}

-(id)initWithPoiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl
{
    self = [super init];
    if (self) {
        self.poiCategory = aPoiCategory;
        self.poiScore = aPoiScore;
        self.poiName = aPoiName;
        self.poiPerCapita = aPoiPerCapita;
        self.poiAddress = aPoiAddress;
        self.poiPhone = aPoiPhone;
        self.poiImageurl = aPoiImageurl;
        self.poiId = aPoiId;
        self.articleId = aArticelId;
        self.articleContent = aArticelContent;
        self.articleImageurl = aArticleImageurl;
    }
    return self;
}

-(id)initWithPoiName:(NSString *)aPoiName articleId:(NSString *)aArticelId articleContent:(NSString *)aArticelContent articleImageurl:(NSString *)aArticleImageurl
{
    self = [super init];
    if (self) {
        self.poiName = aPoiName;
        self.articleId = aArticelId;
        self.articleContent = aArticelContent;
        self.articleImageurl = aArticleImageurl;
    }
    return self;
}

-(id)initWithPoiName:(NSString *)aPoiName poiCategory:(NSString *)aPoiCategory poiScore:(NSString *)aPoiScore poiPerCapita:(float)aPoiPerCapita poiAddress:(NSString *)aPoiAddress poiPhone:(NSString *)aPoiPhone poiImageurl:(NSString *)aPoiImageurl poiId:(NSString *)aPoiId
{
    self = [super init];
    if (self) {
        self.poiCategory = aPoiCategory;
        self.poiScore = aPoiScore;
        self.poiName = aPoiName;
        self.poiPerCapita = aPoiPerCapita;
        self.poiAddress = aPoiAddress;
        self.poiPhone = aPoiPhone;
        self.poiImageurl = aPoiImageurl;
        self.poiId = aPoiId;
      
    }
    return self;
}

- (void)dealloc
{
    self.poiCategory = nil;
    self.poiName = nil;
    self.poiAddress = nil;
    self.poiImageurl = nil;
    self.articleContent = nil;
    self.articleImageurl = nil;
    [super dealloc];
}
@end
