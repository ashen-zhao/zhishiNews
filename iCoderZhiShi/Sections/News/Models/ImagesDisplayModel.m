//
//  ImagesDIsplayModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/6.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "ImagesDIsplayModel.h"

@implementation ImagesDisplayModel

- (void)dealloc {
    [_url release];
    [_postid release];
    [_creator release];
    [_createtime release];
    [_desc release];
    [_imgsum release];
    [_photos release];
    [_setname release];
    [_source release];
    [_settag release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
