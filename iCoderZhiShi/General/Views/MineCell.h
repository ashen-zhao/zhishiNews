//
//  MineCell.h
//  UI-19-QiuBaiDemo
//
//  Created by lanouhn on 15/5/19.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"

@interface MineCell : UITableViewCell
@property (nonatomic, retain) UIImageView *iconImage;
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblCacheSize;

- (void)configureWithMineModel:(MineModel *)mineModel;
@end
