//
//  Model.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//


#import "PictureModel.h"

@implementation PictureModel
- (void)dealloc {
    [_setname release];
    [_setid release];
    [_seturl release];
    [_clientcover release];
    [_clientcover1 release];
    [_cover release];
    [_desc release];
    [_createdate release];
    [_datetime release];
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
