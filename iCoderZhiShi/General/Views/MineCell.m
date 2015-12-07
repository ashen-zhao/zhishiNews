//
//  MineCell.m
//  UI-19-QiuBaiDemo
//
//  Created by lanouhn on 15/5/19.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (void)dealloc {
    [_iconImage release];
    [_lblTitle release];
    [super dealloc];
}
- (UIImageView *)iconImage {
    if (!_iconImage) {
        self.iconImage = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)] autorelease];
    }
    return [[_iconImage retain] autorelease];
}
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(65, 15, 80, 20)] autorelease];
        self.lblTitle.textColor = [UIColor colorWithRed:200 / 255.0 green:102 / 255.0 blue:12 / 255.0 alpha:1.0];
    }
    return [[_lblTitle retain] autorelease];
}

- (UILabel *)lblCacheSize {
    if (!_lblCacheSize) {
        self.lblCacheSize = [[[UILabel alloc] initWithFrame:CGRectMake(170, 15, 80, 20)] autorelease];
        self.lblCacheSize.textColor = [UIColor colorWithRed:200 / 255.0 green:102 / 255.0 blue:12 / 255.0 alpha:1.0];
    }
    return [[_lblCacheSize retain] autorelease];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];        
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.lblTitle];
    }
    return self;
}

- (void)configureWithMineModel:(MineModel *)mineModel {
    self.iconImage.image = [UIImage imageNamed:mineModel.imageName];
    self.lblTitle.text = mineModel.title;
    
  
}
@end
