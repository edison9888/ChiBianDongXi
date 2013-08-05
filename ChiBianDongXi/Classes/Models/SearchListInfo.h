//
//  SearchListInfo.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-22.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchListInfo : NSObject
@property (strong, nonatomic) NSMutableArray * searchInfoArray;
-(SearchListInfo *) initWithDictionary:(NSDictionary *)dic;
@end
