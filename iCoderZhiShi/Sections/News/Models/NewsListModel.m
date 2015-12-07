//
//  NewsListModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel
- (void)dealloc {
    [_editor release];
    [_boardid  release];
    [_digest release];
    [_skipID release];
    [_skipType release];
    [_docid release];
    [_imgextra release];
    [_title release];
    [_ptime release];
    [_imgsrc release];
    [_source release];
    [_TAGS release];
    [_url_3w release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
