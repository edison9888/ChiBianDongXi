//
//  ArticleInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIInfo.h"
#import "UserInfo.h"

@interface ArticleInfo : NSObject

@property (strong, nonatomic) POIInfo  * poiInfo;
@property (strong, nonatomic) UserInfo * userInfo;
@property (strong, nonatomic) NSString * articleId;
@property (strong, nonatomic) NSString * articleName;
@property (strong, nonatomic) NSString * articleContentType;
@property (strong, nonatomic) NSString * articleContent;
@property (strong, nonatomic) NSString * articleFavoriteNum;
@property (strong, nonatomic) NSString * articleTag;
@property (strong, nonatomic) NSString * articleIntroduction;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * articleTime;

@property (strong, nonatomic) NSString * articleImageId;
@property (strong, nonatomic) NSString * articleImageUrl;
@property (assign, nonatomic) CGSize     articleImageSize;
@property (strong, nonatomic) NSMutableArray * textArray;
@property (strong, nonatomic) NSMutableArray * articleTagArray;

-(ArticleInfo *) initWithDictionary:(NSDictionary *)dic;

@end
