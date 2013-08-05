//
//  TopicInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleInfo.h"

@interface TopicInfo : NSObject

@property (strong, nonatomic) NSString * topicId;
@property (strong, nonatomic) NSString * topicName;
@property (strong, nonatomic) NSString * topicLikeNumber;
@property (strong, nonatomic) NSString * topicIntroduction;
@property (strong, nonatomic) NSString * topicImageUrl;
@property (assign, nonatomic) CGSize     topicImageSize;

@property (strong, nonatomic) NSMutableArray * articleInfoArray;

@property (strong, nonatomic) NSString * start;
@property (strong, nonatomic) NSString * limit;

-(TopicInfo *) initWithDictionary:(NSDictionary *)dic;

@end
