//
//  LeftImageCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "LeftImageCell.h"
#import "CommonMacros.h"
#import "UIImageView+WebCache.h"

#define kMarginLeft_PhotoView    5
#define kMarginTop_PhotoView     10
#define kWidth_PhotoView           kScreenWidth / 3
#define kHeight_PhotoView         kScreenWidth / 3

#define kMarginLeft_TitleLabel  (kWidth_PhotoView + kMarginLeft_PhotoView + 10)
#define kMarginTop_TitleLabel   kMarginTop_PhotoView
#define kWidth_TitleLabel            (kScreenWidth - kMarginLeft_TitleLabel - 10)
#define kHeight_TitleLabel           kHeight_PhotoView * 0.4

#define kMarginLeft_DigestLabel     kMarginLeft_TitleLabel
#define kMarginTop_DigestLabel     (kMarginTop_TitleLabel + kHeight_TitleLabel)
#define kWidth_DigestLabel               kWidth_TitleLabel
#define kHeight_DigestLabel             (kHeight_PhotoView - kHeight_TitleLabel)

#define kHeightDown                         (kHeight_PhotoView + kMarginTop_PhotoView)




@implementation LeftImageCell

#pragma mark - lazy loading
- (UIImageView *)photoView {
    if (!_photoView) {
        self.photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_PhotoView, kMarginTop_PhotoView, kWidth_PhotoView, kHeight_PhotoView)] autorelease];
        self.photoView.backgroundColor = [UIColor whiteColor];
    }
    return [[_photoView retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_TitleLabel, kMarginTop_TitleLabel - 10, kWidth_TitleLabel, kHeight_TitleLabel)] autorelease];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)digestLabel {
    if (!_digestLabel) {
        self.digestLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_DigestLabel, kMarginTop_DigestLabel, kWidth_DigestLabel, kHeight_DigestLabel)] autorelease];
        _digestLabel.numberOfLines = 0; //简介无行数限制
        _digestLabel.font = [UIFont systemFontOfSize:14];
        _digestLabel.textColor = [UIColor lightGrayColor];
        self.digestLabel.backgroundColor = [UIColor whiteColor];
    }
    return [[_digestLabel retain] autorelease];
}

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        self.sourceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_PhotoView, kHeightDown , 80, 40)] autorelease];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = [UIColor lightGrayColor];
        _sourceLabel.backgroundColor = [UIColor whiteColor];
    }
    return [[_sourceLabel retain] autorelease];
}

- (UILabel *)replyCountLabel {
    if (!_replyCountLabel) {
        self.replyCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, kHeightDown, 70, 40)] autorelease];
        self.replyCountLabel.textAlignment = NSTextAlignmentRight;
        self.replyCountLabel.font = [UIFont systemFontOfSize:12];
        self.replyCountLabel.textColor = [UIColor lightGrayColor];
    }
    return [[_replyCountLabel retain] autorelease];
}



//自定义
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加上面的子控件
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.digestLabel];
        [self.contentView addSubview:self.sourceLabel];
        [self.contentView addSubview:self.replyCountLabel];
    }
    return self;
}
//赋值给read里面存储一条信息
- (void)configureCellWithRead:(ReadListModel *)readNews {
    
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:readNews.imgsrc] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]];
    self.titleLabel.text = readNews.title;
    self.digestLabel.text = readNews.digest;
    self.sourceLabel.text = readNews.source;
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld跟帖", (long)readNews.replyCount];
    
}

+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews {      
    return kHeight_PhotoView + 40;
}


- (void)dealloc {
    [_sourceLabel release];
    [_replyCountLabel release];
    [_photoView release];
    [_digestLabel release];
    [_titleLabel release];
    [super dealloc];
}

@end
