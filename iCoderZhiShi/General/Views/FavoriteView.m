//
//  FavoriteView.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "FavoriteView.h"

@implementation FavoriteView
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped] autorelease];
    }
    return [[_tableView retain] autorelease];
}
@end
