//
//  CommentModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
- (void)dealloc {
    [_timg release];
    [_f release];
    [_v release];
    [_t release];
    [_b release];
    [_n release];
    [_ut release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
