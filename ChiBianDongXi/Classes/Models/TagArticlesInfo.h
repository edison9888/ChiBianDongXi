//
//  TagArticlesInfo.h
//  ChiBianDongXi 2.0
//
//  Created by  lanou on 13-7-19.
//  Copyright (c) 2013年 Andy Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class POIShareInfo;
@interface TagArticlesInfo : NSObject
@property (nonatomic,retain) POIShareInfo *poiShareInfo;
@property (nonatomic,retain) NSString *articleId;
@property (nonatomic,retain) NSString *authorImage;
@property (nonatomic,retain) NSString *authorName;
@property (nonatomic,retain) NSString *defaultImageUrl;
@property (nonatomic,retain) NSString *defaultText;
@property (nonatomic,retain) NSString *poiName;
@property (nonatomic,assign) CGSize defaultImageSize;
@property (nonatomic,assign) NSInteger favNum;
@property (nonatomic,retain) NSMutableArray *tagArticlesInfoArray;
-(TagArticlesInfo *)initWithDictionary:(NSDictionary *)dic;
@end
