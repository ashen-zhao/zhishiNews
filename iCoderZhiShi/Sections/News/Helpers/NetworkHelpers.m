//
//  NetworkHelpers.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NetworkHelpers.h"
#import "AFNetworking.h"

@implementation NetworkHelpers

+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                if (success) {
                    success(responseObject);
                }
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];    
}
+ (BOOL)okPass:(NSString *)text {
    if ([text containsString:@"苹果"] || [text containsString:@"iPhone"] ||[text containsString:@"iPad"] || [text containsString:@"Swift"] ||
        [text containsString:@"swift"]||[text containsString:@"三星"] || [text containsString:@"Apple"] || [text containsString:@"apple"] || [text containsString:@"安卓"] || [text containsString:@"Android"] || [text containsString:@"手机"] || [text containsString:@"电脑"] || [text containsString:@"美"] || [text containsString:@"纽"]|| [text containsString:@"平板"]) {
        return NO;
    } else {
        return YES;
    }
}
@end
