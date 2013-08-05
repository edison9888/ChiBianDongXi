//
//  Weekend.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weekend : NSObject


@property (strong, nonatomic) NSMutableArray * articleArray;
@property (strong, nonatomic) NSMutableArray * tagArray;
@property (strong, nonatomic) NSMutableArray * topicArray;

@property (strong, nonatomic) NSString    * start;
@property (strong, nonatomic) NSString    * limit;

-(Weekend *) initWithDictionary:(NSDictionary *)dic;

@end
