//
//  FavoriteCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/12.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "FavoriteCell.h"
#import "CommonMacros.h"


@implementation FavoriteCell
- (void)dealloc {
    [_lblTitle release];
    [_lblTag release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblTag];
    }
    return self;
}
- (UILabel *)lblTag {
    if (!_lblTag) {
        self.lblTag = [[[UILabel alloc] initWithFrame:CGRectMake(5, 7, 50, 30)] autorelease];
       _lblTag.font = [UIFont systemFontOfSize:16];
    }
    return [[_lblTag retain] autorelease];
}
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(55, 7, kScreenWidth - 70, 30)] autorelease];
        _lblTitle.font = [UIFont systemFontOfSize:16];
    }
    return [[_lblTitle retain] autorelease];
}

@end
