//
//  MineModel.m
//  UI-19-QiuBaiDemo
//
//  Created by lanouhn on 15/5/19.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel
- (void)dealloc {
    [_title release];
    [_imageName release];
    [super dealloc];
}
- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (id)mineModelWithDic:(NSDictionary *)dic {
    return  [[[self alloc] initWithDic:dic] autorelease];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
