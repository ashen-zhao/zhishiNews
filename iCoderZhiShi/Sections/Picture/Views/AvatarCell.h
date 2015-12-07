//
//  AvatarCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureModel.h"
@interface AvatarCell : UICollectionViewCell
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *labelDigest;

//给cell子控件赋值
- (void)configureSubviews:(PictureModel *)model;
//计算cell高度
+ (CGFloat)heightForRowWithDic:(PictureModel *)dic;
@end
