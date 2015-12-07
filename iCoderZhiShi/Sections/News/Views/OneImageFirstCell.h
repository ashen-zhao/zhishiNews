//
//  OneImageFirstCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
/**
 *  除头条外，第一行是一张图片的cell
 */
@interface OneImageFirstCell : UITableViewCell
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UIImageView *imageTitle;
@property (nonatomic, retain) NewsListModel *model;
@end
