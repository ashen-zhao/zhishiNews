//
//  ThreeImagesCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "ThreeImagesCell.h"
#import "UIImageView+WebCache.h"
#import "CommonMacros.h"

#define kMG_L_Title  5
#define kMG_T_Title  0
#define kW_Title    kScreenWidth - kMG_L_Title * 2
#define kH_Title    30


#define kMG_L_Read      kScreenWidth -  80
#define kMG_T_Read      kMG_T_Title
#define kW_Read         75
#define kH_Read         kH_Title


#define kMG_L_Right     kMG_L_Title

#define kMG_T           kMG_T_Title + kH_Title + 5
#define kW              (kScreenWidth - 20) / 3
#define kH              75



#define kMG_L_Center   kMG_L_Right  +  kW + 5

#define kMG_L_Left      kMG_L_Center + kW + 5


@implementation ThreeImagesCell

- (void)dealloc {
    [_lblReadCount release];
    [_lblTitle release];
    [_imageCenter release];
    [_imageLeft release];
    [_imageRight release];
    [_model release];
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lblTitle];
        [self.contentView addSubview:self.lblReadCount];
        [self.contentView addSubview:self.imageRight];
        [self.contentView addSubview:self.imageCenter];
        [self.contentView addSubview:self.imageLeft];
    }
    return self;
}

#pragma mark lazy loading, getter, setter
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(kMG_L_Title, kMG_T_Title, kW_Title, kH_Title)] autorelease];
         self.lblTitle.font = [UIFont systemFontOfSize:15];
    }
    return [[_lblTitle retain] autorelease];
}
- (UILabel *)lblReadCount {
    if (!_lblReadCount) {
        self.lblReadCount = [[[UILabel alloc] initWithFrame:CGRectMake(kMG_L_Read, kMG_T_Read, kW_Read, kH_Read)] autorelease];
        self.lblReadCount.textColor = [UIColor lightGrayColor];
        self.lblReadCount.font = [UIFont systemFontOfSize:14];
        self.lblReadCount.textAlignment = NSTextAlignmentRight;
    }
    return [[_lblReadCount retain] autorelease];
}
- (UIImageView *)imageCenter {
    if (!_imageCenter) {
        self.imageCenter = [[[UIImageView alloc] initWithFrame:CGRectMake(kMG_L_Center, kMG_T, kW, kH)] autorelease];
    }
    return [[_imageCenter retain] autorelease];
}
- (UIImageView *)imageLeft {
    if (!_imageLeft) {
        self.imageLeft = [[[UIImageView alloc] initWithFrame:CGRectMake(kMG_L_Left, kMG_T, kW, kH)] autorelease];
    }
    return [[_imageLeft retain] autorelease];
}
- (UIImageView *)imageRight {
    if (!_imageRight) {
        self.imageRight = [[[UIImageView alloc] initWithFrame:CGRectMake(kMG_L_Right, kMG_T, kW, kH)] autorelease];
    }
    return [[_imageRight retain] autorelease];
}


- (void)setModel:(NewsListModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        self.lblTitle.text = model.title;
        if (model.replyCount > 10000) {
            NSInteger temp = model.replyCount / 10000;
            model.replyCount = model.replyCount % 10000 / 1000;
            self.lblReadCount.text = [NSString stringWithFormat:@"%li.%li万跟帖",(long)temp, (long)model.replyCount];
        } else if (model.replyCount == 0){
            
        } else {
            self.lblReadCount.text = [NSString stringWithFormat:@"%li跟帖",(long)model.replyCount];
        }
        [self.imageLeft sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]] ];
        [self.imageCenter sd_setImageWithURL:[NSURL URLWithString:model.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]  options:SDWebImageRetryFailed];
        [self.imageRight sd_setImageWithURL:[NSURL URLWithString:model.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]  options:SDWebImageRetryFailed];
        
    }
}


@end
