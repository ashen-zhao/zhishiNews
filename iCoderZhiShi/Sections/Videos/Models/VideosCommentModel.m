//
//  VideosCommentModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/20.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideosCommentModel.h"

@implementation VideosCommentModel
- (void)dealloc {
    [_content release];
    [_user release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
