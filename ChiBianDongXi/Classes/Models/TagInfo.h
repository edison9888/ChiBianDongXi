//
//  TagInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TagList;
@interface TagInfo : NSObject
@property (strong, nonatomic) NSString * tagId;
@property (strong, nonatomic) NSString * tagName;
@property (strong, nonatomic) NSString * tagImageUrl;
@property (assign, nonatomic) CGSize     tagImageSize;



-(TagInfo *) initWithDictionary:(NSDictionary *)dic;

@end
