//
//  DataHandle.m
//  Collect
//
//  Created by  lanou on 13-7-3.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import "DataHandle.h"
#import "DataBase.h"
#import "CollectInfo.h"
@implementation DataHandle
//获取所有的收藏信息
+(NSMutableArray *)getAllCollectInfo{
 
    sqlite3 *db = [DataBase openDB];

    sqlite3_stmt *stmt = nil;
 
    int result = sqlite3_prepare_v2(db, "select *from t_cbdx", -1, &stmt, nil);
   
    
    NSMutableArray *collectArray = [NSMutableArray arrayWithCapacity:1];
 
    if (result == SQLITE_OK)
    {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {

//            //取出 id
            int id = sqlite3_column_int(stmt, 0);
            //取出poiName
            const unsigned char *poiName = sqlite3_column_text(stmt, 1);
            //取出poi_per_capita
            float poiPerCapita = sqlite3_column_int(stmt, 2);
            //取出poi_address
            const unsigned char *poiAddress = sqlite3_column_text(stmt, 3);
            //取出poiPhone
            const unsigned char *poiPhone = sqlite3_column_text(stmt, 4);
            //取出poiImageurl
            const unsigned char *poiImageurl = sqlite3_column_text(stmt, 5);
            //取出poiId
            const unsigned char *poiId = sqlite3_column_text(stmt, 6);
            //取出poiCategory
            const unsigned char *poiCategory = sqlite3_column_text(stmt, 7);
            //取出poiScore
            const unsigned char *poiScore = sqlite3_column_text(stmt, 8);
            //取出articleId
            const unsigned char *articleId = sqlite3_column_text(stmt, 9);
            //取出articleContent
            const unsigned char *articleContent = sqlite3_column_text(stmt, 10);
            //取出articleImageurl
            const unsigned char *articleImageurl = sqlite3_column_text(stmt, 11);
            
            
            
//            float poiScore = sqlite3_column_int(stmt, 11);
            
            if (poiAddress == nil)
            {
                CollectInfo *collectInfo = [[CollectInfo alloc] initWithId:(int)id poiName:[NSString stringWithUTF8String:(const char *)poiName] poiCategory:nil poiScore:nil poiPerCapita:poiPerCapita poiAddress:nil poiPhone:nil poiImageurl:nil poiId:nil articleId:[NSString stringWithUTF8String:(const char *)articleId] articleContent:[NSString stringWithUTF8String:(const char *)articleContent] articleImageurl:[NSString stringWithUTF8String:(const char *)articleImageurl]];
                [collectArray addObject:collectInfo];
                [collectInfo release];
            }else
            {
              CollectInfo *collectInfo = [[CollectInfo alloc] initWithId:(int)id poiName:[NSString stringWithUTF8String:(const char *)poiName] poiCategory:[NSString stringWithUTF8String:(const char *)poiCategory] poiScore:[NSString stringWithUTF8String:(const char *)poiScore] poiPerCapita:poiPerCapita poiAddress:[NSString stringWithUTF8String:(const char *)poiAddress] poiPhone:[NSString stringWithUTF8String:(const char *)poiPhone] poiImageurl:[NSString stringWithUTF8String:(const char *)poiImageurl] poiId:[NSString stringWithUTF8String:(const char *)poiId] articleId:nil articleContent:nil articleImageurl:nil];
                [collectArray addObject:collectInfo];
                [collectInfo release];
            }

        }
    }
    //结束,释放资源
    sqlite3_finalize(stmt);
    //返回带有收藏信息数据数组
    return collectArray;
    
}

//往数据库中插入数据
+(BOOL)insertCollectInfoToDataBase:(CollectInfo *)aCollectInfo
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
        int result = sqlite3_prepare_v2(db, "insert into t_cbdx(poi_name,poi_per_capita,poi_address,poi_phone,poi_image_url,poi_id,article_id,article_content,article_image_url,poi_category,poi_score) values(?,?,?,?,?,?,?,?,?,?,?)", -1, &stmt, nil);
    if (result == SQLITE_OK) {   
        sqlite3_bind_text(stmt, 1, [aCollectInfo.poiName UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 2, aCollectInfo.poiPerCapita);
        sqlite3_bind_text(stmt, 3, [aCollectInfo.poiAddress UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 4, [aCollectInfo.poiPhone UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 5, [aCollectInfo.poiImageurl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 6, [aCollectInfo.poiId UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 7, [aCollectInfo.articleId UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 8, [aCollectInfo.articleContent UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 9, [aCollectInfo.articleImageurl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 10, [aCollectInfo.poiCategory UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 11, [aCollectInfo.poiScore UTF8String], -1, nil);
        //data
        //执行操作
        int flag = sqlite3_step(stmt);
        //如果操作完成
        if (flag == SQLITE_DONE) {
            //释放资源
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}
//根据ID删除数据
+ (BOOL)deleteCollectInfoWithArticleId:(NSString *)aArticleId
{
   sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete from t_cbdx where article_id = ?", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        //绑定问号
        sqlite3_bind_text(stmt, 1, [aArticleId UTF8String], -1, nil); 
        //执行
        sqlite3_step(stmt);
        
        int flag = sqlite3_step(stmt);
        if (flag == SQLITE_DONE)
        {
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}
//根据poiId删除数据
+ (BOOL)deleteCollectInfoWithPoiId:(NSString *)aPoiId
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, "delete from t_cbdx where poi_id = ? ", -1, &stmt, nil);
    if (result == SQLITE_OK)
    {
       sqlite3_bind_text(stmt, 1, [aPoiId UTF8String], -1, nil);        
        int flag = sqlite3_step(stmt);
        if (flag == SQLITE_DONE)
        {
            sqlite3_finalize(stmt);
            return YES;
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

@end
