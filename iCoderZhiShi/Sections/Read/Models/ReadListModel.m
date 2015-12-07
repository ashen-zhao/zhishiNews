//
//  ReadListModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "ReadListModel.h"

@implementation ReadListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
- (void)dealloc {
    [_boardid release];
    [_source release];
    [_imgnewextra release];
    [_imgsrc release];
    [_digest release];
    [_title release];
    [_docid release];
    [super dealloc];
}
@end
