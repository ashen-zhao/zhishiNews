//
//  CycleModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CycleModel.h"

@implementation CycleModel
- (void)dealloc {
    [_title release];
    [_tag release];
    [_subtitle release];
    [_imgsrc release];
    [_url release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
