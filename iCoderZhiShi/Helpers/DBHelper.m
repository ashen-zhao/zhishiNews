//
//  DBHelper.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "DBHelper.h"
#import "FMDB.h"
#import "FavoriteModel.h"

@implementation DBHelper

FMDatabase *db = nil;
//打开数据库
+ (void)openDataBase {
    db = [FMDatabase databaseWithPath:[self getHomePath:@"ZhiShiDB.sqlite"]];
    if (![db open]) {
        return;
    }
    //为数据库设置缓存，提高性能
    [db setShouldCacheStatements:YES];
}

//创建收藏表
+ (void)createTable {
    //判断表是否创建
    [self openDataBase];
    [db executeUpdate:@"create table if not exists t_favorite(fid integer primary key autoincrement, ftitle text, furl text, fdocid text, fboardid text, flag text)"];
    [db close];
}
//插入一条收藏信息
+ (BOOL)insertData:(FavoriteModel *)model {
    [self createTable];
    [self openDataBase];
    //处理为空
    if ([model.ftitle isEqualToString:@""] || !model.ftitle) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:@"select * from t_favorite where ftitle=?", model.ftitle];
    //已经存在
    if ([rs next]) {
        [rs close];
        [db close];
        return NO;
    } else {
        [db executeUpdate:@"insert into t_favorite(ftitle, furl, fdocid, fboardid, flag) values(?, ?, ?, ?, ?)", model.ftitle, model.furl, model.fdocid, model.fboardid, model.flag];
        [db close];
        return YES;
    }
    
}
//删除一条收藏信息
+ (void)deleteData:(NSInteger)fid {
    [self openDataBase];
    [db executeUpdate:@"delete from t_favorite where fid=?",[NSString stringWithFormat:@"%ld", (long)fid]];
    [db close];
}
//返回查询数据结果
+ (NSMutableArray *)getListData {
    [self createTable];
    [self openDataBase];
    NSMutableArray *listArr = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:@"select * from t_favorite"];
    while ([rs next]) {
        FavoriteModel *model = [[FavoriteModel alloc] init];
        model.fid = [rs intForColumn:@"fid"];
        model.ftitle = [rs stringForColumn:@"ftitle"];
        model.furl = [rs stringForColumn:@"furl"];
        model.fboardid =  [rs stringForColumn:@"fboardid"];
        model.fdocid = [rs stringForColumn:@"fdocid"];
        model.flag = [rs stringForColumn:@"flag"];
        [listArr addObject:model];
        [model release];
    }
    [rs close];
    [db close];
    return listArr;
}

+ (NSString *)getHomePath:(NSString *)databaseName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:databaseName];
}

@end
