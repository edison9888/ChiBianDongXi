//
//  CommentList.m
//  ChiBianDongXi
//
//  Created by Andy Gu on 7/5/13.
//  Copyright (c) 2013 Andy Gu. All rights reserved.
//

#import "CommentList.h"
#import "CommentInfo.h"

@implementation CommentList


-(CommentList *) initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.commentInfoArray = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary * commentListDic in [dic objectForKey:@"shareList"])
        {
            CommentInfo * commentInfo = [[CommentInfo alloc] init];
            [commentInfo initWithDictionary:commentListDic];
            [self.commentInfoArray addObject:commentInfo];
        }
        
    }
    return self;
}

- (void)dealloc
{
    [_commentInfoArray release];
    [super dealloc];
}
@end
