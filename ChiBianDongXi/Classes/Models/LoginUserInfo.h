//
//  LoginUserInfo.h
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUserInfo : NSObject

@property (strong, nonatomic) NSString * userWeiboId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * userImageUrl;

- (LoginUserInfo *)initWithDic:(NSDictionary *)dic;
@end
