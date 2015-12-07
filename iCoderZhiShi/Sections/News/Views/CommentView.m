//
//  CommentView.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView


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
