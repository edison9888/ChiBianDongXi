//
//  POIGrade.m
//  ChiBianDongXi 2.0
//
//  Created by Andy Gu on 7/17/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "POIGrade.h"

@implementation POIGrade

-(id) initWithImage:(UIImageView *)aImageView
{
    if (self = [super init])
    {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@""];
    }
    return self;
}


@end
