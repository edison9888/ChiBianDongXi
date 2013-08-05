//
//  DataBase.m
//  Collect
//
//  Created by  lanou on 13-7-2.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import "DataBase.h"
#define FILE_NAME @"db_cbdx.sqlite"//方便使用
static sqlite3 *db = nil;
@implementation DataBase

+ (sqlite3 *)openDB
{
    if (db == nil)
    {
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
        NSString * filePath = [documentPath stringByAppendingPathComponent:FILE_NAME];
        
        NSString * bundleFilePath = [[NSBundle mainBundle] pathForResource:@"db_cbdx" ofType:@"sqlite"];
        NSFileManager * fm = [NSFileManager defaultManager];
        //如果本地没有数据库文件，拷入documents下面
        if ([fm fileExistsAtPath:filePath] == NO) {
            [fm copyItemAtPath:bundleFilePath toPath:filePath error:nil];
        }
        //打开数据库
        sqlite3_open([filePath UTF8String], &db);
    }
    return db;
}

//关闭数据库
+ (void)closeDB
{
    //关闭
    sqlite3_close(db);
    db = nil;
}
@end
