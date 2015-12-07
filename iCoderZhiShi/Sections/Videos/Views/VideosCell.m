//
//  VideosCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/16.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideosCell.h"
#import "VideosModel.h"
#import "UIImageView+WebCache.h"
#import "CommonMacros.h"
#import "AFNetworking.h"
#import "NSTimer+Control.h"
#import "MBProgressHUD.h"


@interface VideosCell() {
    UIView *tempView;
}
@end
@implementation VideosCell

- (void)dealloc {
    [_tempImage release];
    Block_release(_btnMoreBlock);
    Block_release(_TapBlock);
    [_btnMore release];
    [_animationTimer release];
    [_avotorImage release];
    [_lblName release];
    [_lblText release];
    [_player release];
    [_model release];
    [_lblCreateTime release];
    [_lblTime release];
    [_lblCount release];
    [_btnState release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avotorImage];
        [self.contentView addSubview:self.lblText];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.btnMore];
        [self.contentView addSubview:self.lblCreateTime];
        [self.contentView addSubview:self.player.view];
        
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
        NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
        [noti addObserver:self selector:@selector(moviePlayerState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    }
    return self;
}
//监听播放状态
- (void)moviePlayerState:(NSNotification *)noti {
    if (_player.playbackState == MPMoviePlaybackStatePlaying) {
        _btnState.hidden = YES;
         self.tempImage.hidden = YES;
        [self.animationTimer resumeTimerAfterTimeInterval:1];
    } else if(_player.playbackState == MPMoviePlaybackStateSeekingBackward ) {
        _btnState.hidden = NO;
        self.tempImage.hidden = NO;
        [self.animationTimer pauseTimer];
    } else if (_player.playbackState == MPMoviePlaybackStatePaused) {
        _btnState.hidden = NO;
    }
}
- (void)animationTimerDidFired:(NSTimer *)timer {
    [self setTimeStype:[NSString stringWithFormat:@"%.2f",_player.duration - _player.currentPlaybackTime]];
}
+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}

+ (CGFloat)widthForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + 30;
}

+ (CGFloat)heightCell:(VideosModel *)model {
    NSInteger width = kScreenWidth - 10;
    if ([model.height integerValue] > [model.width integerValue]) {
        width =  kScreenWidth - 150;
    }
    return  60 + [VideosCell heightForText:model.text] + (width * [model.height integerValue]) / [model.width integerValue] + 10;
}

//设置时间格式
- (void)setTimeStype:(NSString *)time{
    NSInteger timeInterval = [time integerValue];
    if (timeInterval < 60) {
        self.lblTime.text = timeInterval > 9 ? [NSString stringWithFormat:@"00:%ld", (long)timeInterval] : [NSString stringWithFormat:@"00:0%ld", (long)timeInterval];
    } else if (timeInterval < 3600) {
        [[NSDate date] timeIntervalSinceDate:[NSDate date]];       
        self.lblTime.text = (timeInterval / 60) > 9 ? [NSString stringWithFormat:@"%ld:%@", (long)timeInterval / 60,  timeInterval % 60 > 9 ? [NSString stringWithFormat:@"%ld", (long)timeInterval % 60] : [NSString stringWithFormat:@"0%ld", (long)timeInterval % 60]] : [NSString stringWithFormat:@"0%ld:%@", (long)timeInterval / 60, timeInterval % 60 > 9 ? [NSString stringWithFormat:@"%ld", (long)timeInterval % 60] : [NSString stringWithFormat:@"0%ld", (long)timeInterval % 60]];
        
    }
    
}
#pragma mark - action 
- (void)handleTap:(UITapGestureRecognizer *)tap {
     _btnState.hidden = _btnState.hidden ? NO : YES;
    if (_btnState.hidden) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status != AFNetworkReachabilityStatusReachableViaWiFi) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"当前网络2G或3G网络，是否继续观看?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                [alert show];
                [alert release];
            } else {
                [_player play];
            }
        }];        
    } else {
        [self.animationTimer pauseTimer];
        [_player pause];
    }
    //
    if (self.TapBlock) {
        self.TapBlock(self);
    }
}

//弹出层事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
      _btnState.hidden = _btnState.hidden ? NO : YES;
    if (buttonIndex == 1) {
        [_player play];
    } else {
       [self.animationTimer pauseTimer];
        [_player pause];
    }
}

- (void)handleMore:(UIButton *)sender {
    if (self.btnMoreBlock) {
        self.btnMoreBlock(self);
    }
}
#pragma mark - lazy loading
//头像
- (UIImageView *)avotorImage {
    if (!_avotorImage) {
        self.avotorImage = [[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)] autorelease];
    }
    return [[_avotorImage retain] autorelease];
}
- (UILabel *)lblName {
    if (!_lblName) {
        self.lblName = [[[UILabel alloc] initWithFrame:CGRectMake(40, 5, kScreenWidth - 100, 15)] autorelease];
        self.lblName.font = [UIFont systemFontOfSize:14];
    }
    return [[_lblName retain] autorelease];
}

- (UIButton *)btnMore {
    if (!_btnMore) {
        self.btnMore = [ UIButton buttonWithType:UIButtonTypeCustom];
        _btnMore.frame = CGRectMake(kScreenWidth - 40, 10, 40, 20);
        _btnMore.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_btnMore setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_btnMore setImage:[UIImage imageNamed:@"morehigh"] forState:UIControlStateHighlighted];
         [_btnMore addTarget:self action:@selector(handleMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[_btnMore retain] autorelease];
}

- (UILabel *)lblCreateTime {
    if (!_lblCreateTime) {
        self.lblCreateTime = [[[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenWidth - 50, 15)] autorelease];
        self.lblCreateTime.font = [UIFont systemFontOfSize:12];
        self.lblCreateTime.textColor = [UIColor grayColor];
    }
    return [[_lblCreateTime retain] autorelease];
}
- (UILabel *)lblText {
    if (!_lblText) {
        self.lblText = [[[UILabel alloc] initWithFrame:CGRectMake(5, 40, kScreenWidth - 20, 60)] autorelease];
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByCharWrapping;
        self.lblText.font = [UIFont systemFontOfSize:16];
    }
    return [[_lblText retain] autorelease];
}

- (MPMoviePlayerController *)player {
    if (!_player) {
        self.player = [[[MPMoviePlayerController alloc] init] autorelease];
        _player.repeatMode = MPMovieRepeatModeOne;
        _player.controlStyle = MPMovieControlStyleNone;
        _player.scalingMode = MPMovieScalingModeAspectFit;
        _player.backgroundView.backgroundColor = [UIColor lightGrayColor];
    }
    return [[_player retain] autorelease];
}

- (UIButton *)btnState {
    if (!_btnState) {
        self.btnState = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return [[_btnState retain] autorelease];
}
- (UILabel *)lblTime {
    if (!_lblTime) {
        self.lblTime = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease];
        _lblTime.backgroundColor = [UIColor blackColor];
        _lblTime.textAlignment = NSTextAlignmentRight;
        _lblTime.font = [UIFont boldSystemFontOfSize:15];
        _lblTime.alpha = 0.6;
        _lblTime.textColor = [UIColor whiteColor];
    }
    return [[_lblTime retain] autorelease];
}

- (UILabel *)lblCount {
    if (!_lblCount) {
        self.lblCount = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        _lblCount.backgroundColor = [UIColor blackColor];
        _lblCount.textAlignment = NSTextAlignmentRight;
        _lblCount.font = [UIFont boldSystemFontOfSize:15];
        _lblCount.alpha = 0.6;
        _lblCount.textColor = [UIColor whiteColor];
    }
    return [[_lblCount retain] autorelease];
}
- (void)setModel:(VideosModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        //配置控件信息
        [self.avotorImage sd_setImageWithURL:[NSURL URLWithString:model.profile_image] placeholderImage:[UIImage imageNamed:@"defaultAvator"]];
        self.lblName.text = model.name;
        self.lblText.text = model.text;
        self.lblCreateTime.text = model.created_at;
        NSString *playCount = [NSString stringWithFormat:@"%@", model.playcount];
        self.lblCount.text = [playCount stringByAppendingString:@"播放"];
        [self setTimeStype:model.videotime];
        
        CGRect frame = self.lblText.frame;
        frame.size.height = [VideosCell heightForText:model.text];
        self.lblText.frame = frame;
        
        [_player setContentURL:[NSURL URLWithString:model.videouri]];
        //动态修改控件frame
        NSInteger width = kScreenWidth - 10;
        _player.view.frame = CGRectMake(5, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);
        //当高过宽时，处理结果
        if ([model.height integerValue] > [model.width integerValue]) {
            width =  kScreenWidth - 150;
            _player.view.frame = CGRectMake(75, 40 + frame.size.height + 10, width , (width * [model.height integerValue]) / [model.width integerValue]);

        }
        //没有播放时的背景图
        self.tempImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width , (width * [model.height integerValue]) / [model.width integerValue])] autorelease];
        [self.tempImage sd_setImageWithURL:[NSURL URLWithString:model.image_small] placeholderImage:[UIImage imageNamed:@"defaultCycle"]];
        
        
        [_player.view addSubview:self.tempImage];
        //开始按钮
        [_player.view addSubview:self.btnState];
        //时间
        _lblTime.frame = CGRectMake(width - 41,(width * [model.height integerValue]) / [model.width integerValue] - 20, 40, 20);
        [_player.view addSubview:_lblTime];
        
        //播放次数
        _lblCount.frame = CGRectMake(width - [VideosCell widthForText:playCount], 2, [VideosCell widthForText:playCount], 20);
        [_player.view addSubview:_lblCount];
        //播放窗口的点击层
        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width , (width * [model.height integerValue]) / [model.width integerValue])];
        [_player.view addSubview:tempView];
        
        
        //手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tempView addGestureRecognizer:tap];
        [tempView release];
        [tap release];
        self.btnState.frame = CGRectMake(0, 0, 50 , 50);
        self.btnState.center = self.tempImage.center;
        [self.btnState setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"start" ofType:@"png"]] forState:UIControlStateNormal];
        
    }
}

@end
