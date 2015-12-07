//
//  NewsDetailsModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NewsDetailsModel.h"

@implementation NewsDetailsModel

- (void)dealloc {
    [_body release];
    [_source_url release];
    [_img release];
    [_digest release];
    [_docid release];
    [_source release];
    [_ptime release];
    [_title release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
