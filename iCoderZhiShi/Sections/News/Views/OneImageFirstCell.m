//
//  OneImageFirstCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "OneImageFirstCell.h"
#import "CommonMacros.h"
#import "UIImageView+WebCache.h"

@implementation OneImageFirstCell

- (void)dealloc {
    [_imageTitle release];
    [_lblTitle release];
    [_model release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1.0];
        [self.contentView addSubview:self.imageTitle];
        [self.contentView addSubview:self.lblTitle];
    }
    return self;
}

#pragma mark - getter, setter
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 150, kScreenWidth - 20, 30)] autorelease];
        self.lblTitle.font = [UIFont systemFontOfSize:16];
    }
    return [[_lblTitle retain] autorelease];
}

- (UIImageView *)imageTitle {
    if (!_imageTitle) {
        self.imageTitle = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)] autorelease];
    }
    return [[_imageTitle retain] autorelease];
}



- (void)setModel:(NewsListModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        self.lblTitle.text = model.title;
        [self.imageTitle sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]] options:SDWebImageRetryFailed];
    }
}
@end
