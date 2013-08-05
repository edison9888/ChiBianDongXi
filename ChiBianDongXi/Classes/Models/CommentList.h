//
//  CommentList.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class POIInfo;
@class POIShareInfo;
@interface CommentList : NSObject


@property (strong, nonatomic) NSMutableArray * commentInfoArray;


-(CommentList *) initWithDictionary:(NSDictionary *)dic;
@end
