//
//  ThreeImagesCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListModel.h"
@interface ThreeImagesCell : UITableViewCell
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblReadCount;
@property (nonatomic, retain) UIImageView *imageLeft;
@property (nonatomic, retain) UIImageView *imageCenter;
@property (nonatomic, retain) UIImageView *imageRight;

@property (nonatomic, retain) NewsListModel *model;
@end
