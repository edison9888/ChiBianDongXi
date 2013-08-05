//
//  TagList.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-15.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagList : NSObject

@property (strong, nonatomic) NSMutableArray * tagInfoArray;
-(TagList *) initWithDictionary:(NSDictionary *)dic;

@end
