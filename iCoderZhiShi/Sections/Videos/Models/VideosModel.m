//
//  VideosModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/16.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideosModel.h"

@implementation VideosModel
- (void)dealloc {
    [_text release];
    [_videouri release];
    [_height release];
    [_width release];
    [_name release];
    [_profile_image release];
    [_image_small release];
    [_videotime release];
    [_created_at release];
    [_playcount release];
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}
@end
