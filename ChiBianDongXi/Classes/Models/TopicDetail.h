//
//  TopicDetail.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface TopicDetail : NSObject

@property (strong, nonatomic) NSMutableArray * articleInfoArray;
@property (strong, nonatomic) NSString * topicImageUrl;
@property (assign, nonatomic) CGSize topImageSize;
@property (strong, nonatomic) NSString * topicIntroduction;

@end
