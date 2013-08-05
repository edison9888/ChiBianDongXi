//
//  LocalImage.m
//  ChiBianDongXi 2.0
//
//  Created by lanou on 13-7-12.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import "LocalImage.h"

@implementation LocalImage
- (id)initWithMyImage:(NSString *)myImage
{
    self = [super init];
    if (self) {
        self.myImage = myImage;
    }
    return self;
}

- (void)dealloc
{
    [_myImage release];
    [super dealloc];
}

@end
