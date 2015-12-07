//
//  FavoriteModel.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "FavoriteModel.h"

@implementation FavoriteModel
- (void)dealloc {
    [_fboardid release];
    [_fdocid release];
    [_ftitle release];
    [_furl release];
    [_flag release];
    [super dealloc];
}
@end
