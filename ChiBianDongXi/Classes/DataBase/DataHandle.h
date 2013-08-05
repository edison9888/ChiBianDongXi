//
//  DataHandle.h
//  Collect
//
//  Created by  lanou on 13-7-3.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CollectInfo;
@interface DataHandle : NSObject
//@property (nonatomic,retain) CollectInfo *infoCollect;

//返回所有收藏信息
+(NSMutableArray *)getAllCollectInfo;
//返回文章详情信息
+(NSMutableArray *)getArticleCollectInfo;
//返回餐厅详情信息
+(NSMutableArray *)getPOIDetailCollectInfo;
//往收藏表里再插入一条数据
+(BOOL)insertCollectInfoToDataBase:(CollectInfo *)aCollectInfo;
//从数据库删除一个店铺数据
+ (BOOL)deleteCollectInfoWithArticleId:(NSString *)aArticleId;
+ (BOOL)deleteCollectInfoWithPoiId:(NSString *)aPoiId;
@end
