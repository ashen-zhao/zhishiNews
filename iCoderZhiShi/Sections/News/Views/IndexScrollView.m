//
//  IndexScrollView.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/15.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "IndexScrollView.h"

@implementation IndexScrollView


- (UIImageView *)imageV  {
    if (!_imageV) {
        self.imageV = [[[UIImageView alloc] initWithFrame:self.bounds] autorelease];
    }
    return [[_imageV retain] autorelease];
}

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.imageV];
    }
    return self;
}

- (void)dealloc {
    [_imageV release];
    [super dealloc];
}

@end
