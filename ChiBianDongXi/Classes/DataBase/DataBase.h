//
//  DataBase.h
//  Collect
//
//  Created by  lanou on 13-7-2.
//  Copyright (c) 2013年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBase : NSObject
//打开数据库
+(sqlite3 *)openDB;
//关闭数据库
+(void)closeDB;
@end
