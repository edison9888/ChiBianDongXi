//
//  UserInfo.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/4/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userName = _userName;
@synthesize userImageUrl = _userImageUrl;
@synthesize userComment = _userComment;



- (void)dealloc
{
    [_userName release];
    [_userImageUrl release];
    [_userComment release];
    [super dealloc];
}

@end
