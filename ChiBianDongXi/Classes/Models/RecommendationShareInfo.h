//
//  RecommendationShareInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "POIShareInfo.h"

@interface RecommendationShareInfo : NSObject

@property (strong, nonatomic) NSString * matchRecommondation;
@property (strong, nonatomic) POIShareInfo * poiShareInfo;

-(RecommendationShareInfo *) initWithDictionary:(NSDictionary *)dic;

@end
