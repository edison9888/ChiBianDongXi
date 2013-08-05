//
//  POIShareList.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-13.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIShareList : NSObject
@property (strong, nonatomic) NSMutableArray * poiShareInfoArray;


-(POIShareList *) initWithDictionary:(NSDictionary *)dic;

@end
