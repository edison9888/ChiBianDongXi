//
//  NSArray+ArrayToCGSize.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/9/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "NSArray+ArrayToCGSize.h"

@implementation NSArray (ArrayToCGSize)

-(CGSize) fromArrayToCGSize
{
    CGSize size = CGSizeMake([[self objectAtIndex:0] intValue], [[self objectAtIndex:1] intValue]);
    return size;
}

@end
