//
//  DBHelper.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FavoriteModel;
@interface DBHelper : NSObject
//插入收藏数据
+ (BOOL)insertData:(FavoriteModel *)model;
//删除收藏数据
+ (void)deleteData:(NSInteger)fid;
//获取列表
+ (NSMutableArray *)getListData;

@end
