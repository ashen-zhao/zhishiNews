//
//  CommentCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentCell : UITableViewCell
@property (nonatomic, retain) UIImageView *avator;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) UILabel *lblAddress;
//@property (nonatomic, retain) UILabel *lblGoodCount;
@property (nonatomic, retain) UILabel *lblContent;
//@property (nonatomic, retain) UIButton *btnGood;
@property (nonatomic, retain) UILabel *lblTime;

@property (nonatomic, retain) CommentModel *model;
+ (CGFloat)heightForRowWithDic:(CommentModel *)model;
@end
