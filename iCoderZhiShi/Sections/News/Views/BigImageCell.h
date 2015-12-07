//
//  BigImageCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
@interface BigImageCell : UITableViewCell
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UIImageView *imageTitle;
@property (nonatomic, retain) UILabel *lblReadCount;

@property (nonatomic, retain) NewsListModel *model;
@end
