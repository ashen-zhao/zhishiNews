//
//  VideoCommentCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/20.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideosCommentModel;
@interface VideoCommentCell : UITableViewCell
@property (nonatomic, retain) UIImageView *avotorImage;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) UILabel *lblText;

@property (nonatomic, retain) VideosCommentModel *model;

+ (CGFloat)heightCell:(VideosCommentModel *)model;
@end
