//
//  LoginUserInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "LoginUserInfo.h"

@implementation LoginUserInfo
- (LoginUserInfo *)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.userWeiboId = [dic objectForKey:@"id"];
        self.userName = [dic objectForKey:@"name"];
        self.userImageUrl = [dic objectForKey:@"avatar"];
    }
    return self;
}

- (void)dealloc
{
    [_userWeiboId release];
    [_userName release];
    [_userImageUrl release];
    [super dealloc];
}
@end
