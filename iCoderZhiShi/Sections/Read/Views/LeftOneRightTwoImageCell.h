//
//  LeftOneRightTwoImageCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ReadListModel.h"

//左边一个大图,右边两个小图的cell
@interface LeftOneRightTwoImageCell : UITableViewCell
@property (nonatomic, retain) UIImageView *leftImage; //左单一的一个图
@property (nonatomic, retain) UILabel *titleLabel;  //标题
@property (nonatomic, retain) UILabel *digestLabel; //简介
@property (nonatomic, retain) UILabel *sourceLabel;  //左下角来源
@property (nonatomic, retain) UILabel *replyCountLabel;  //跟帖Label
@property (nonatomic, retain) UIImageView *rightImageUp;  //右上图片
@property (nonatomic, retain) UIImageView *rightImageDown;  //右下图片

//赋值
- (void)configureCellWithRead:(ReadListModel *)readModel;

+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews;
@end
