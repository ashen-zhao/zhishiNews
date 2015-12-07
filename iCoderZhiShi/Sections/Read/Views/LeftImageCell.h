//
//  LeftImageCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadListModel.h"
#import "UIImageView+WebCache.h"

//左边一个图的cell
@interface LeftImageCell : UITableViewCell

@property (nonatomic, retain) UIImageView *photoView; //左单一的一个图
@property (nonatomic, retain) UILabel *titleLabel;  //标题
@property (nonatomic, retain) UILabel *digestLabel; //简介
@property (nonatomic, retain) UILabel *sourceLabel;  //左下角来源
@property (nonatomic, retain) UILabel *replyCountLabel;  //分享按钮


//赋值,让readListModel对象中存储一条阅读信息
- (void)configureCellWithRead:(ReadListModel *)readNews;
//自适应cell
+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews;
@end
