//
//  NoImageCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ReadListModel.h"
//没有图的cell
@interface NoImageCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;  //主题
@property (nonatomic, retain) UILabel *digestLabel;  //简介
@property (nonatomic, retain) UILabel *sourceLabel;  //文章来源
@property (nonatomic, retain) UILabel *replyCountLabel;  //分享按钮

//赋值,让readListModel对象中存储一条阅读信息
- (void)configureCellWithRead:(ReadListModel *)readNews;

+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews;
@end
