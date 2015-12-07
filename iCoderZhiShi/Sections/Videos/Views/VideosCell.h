//
//  VideosCell.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/16.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class VideosModel;
@class VideosCell;



@interface VideosCell : UITableViewCell
@property (nonatomic, retain) UIImageView *avotorImage;
@property (nonatomic, retain) UILabel *lblName;
@property (nonatomic, retain) UILabel *lblText;
@property (nonatomic, retain) MPMoviePlayerController *player;
@property (nonatomic, retain) UIButton *btnState;
@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UILabel *lblCreateTime;
@property (nonatomic, retain) UILabel *lblCount;
@property (nonatomic, retain) NSTimer *animationTimer;
@property (nonatomic, retain) UIButton *btnMore;
@property (nonatomic, retain) VideosModel *model;
@property (nonatomic, retain)     UIImageView *tempImage;
@property (nonatomic, copy) void(^btnMoreBlock)(VideosCell *cell);
@property (nonatomic, copy) void(^TapBlock)(VideosCell *cell);
+ (CGFloat)heightCell:(VideosModel *)model;

@end
