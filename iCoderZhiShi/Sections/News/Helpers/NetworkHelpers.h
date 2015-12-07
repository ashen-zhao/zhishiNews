//
//  NetworkHelpers.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求助手类
 */
@interface NetworkHelpers : NSObject
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id data))success fail:(void (^)())fail;

+ (BOOL)okPass:(NSString *)text;
@end
