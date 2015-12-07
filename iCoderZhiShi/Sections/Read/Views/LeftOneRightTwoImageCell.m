//
//  LeftOneRightTwoImageCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "LeftOneRightTwoImageCell.h"
#import "CommonMacros.h"

#define kMarginLeft_LeftImage    5
#define kMarginTop_LeftImage     10
#define kWidth_LeftImage            (kScreenWidth - 15) / 3 * 2
#define kHeight_LeftImage           [UIScreen mainScreen].bounds.size.height / 3.5

#define kMarginLeft_rightUpImage         (kWidth_LeftImage + 10)
#define kMargintop_rightUpImage         kMarginTop_LeftImage
#define kWidth_rightUpImage                   ( kScreenWidth - kMarginLeft_rightUpImage - 5)
#define kHeight_rightUpImage                  (kHeight_LeftImage - 4) / 2

#define kMarginLeft_rightDownImage          kMarginLeft_rightUpImage
#define kMargintop_rightDownImage          (kMarginTop_LeftImage + kHeight_rightUpImage + 4)
#define kWidth_rightDownImage                   kWidth_rightUpImage
#define kHeight_rightDownImage                  kHeight_rightUpImage

#define kMarginLeft_titleLabel      kMarginLeft_LeftImage
#define kMarginTop_titleLabel       kMarginTop_LeftImage + kHeight_LeftImage + 5
#define kWidth_titleLabel               (kScreenWidth - 20)
#define kHeight_titleLabel             kHeight_LeftImage / 3

#define kMarginLeft_digestLabel      kMarginLeft_LeftImage
#define kMarginTop_digestLabel       kMarginTop_titleLabel + kHeight_titleLabel + 5
#define kWidth_digestLabel               kWidth_titleLabel
#define kHeight_digestLabel              kHeight_LeftImage / 3

#define kMarginLastRowHeightLabel    kMarginTop_digestLabel + kHeight_digestLabel + 5


@implementation LeftOneRightTwoImageCell
#pragma mark - lazy loading
//左边的图片
- (UIImageView *)leftImage {
    if (!_leftImage) {
        self.leftImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_LeftImage, kMarginTop_LeftImage, kWidth_LeftImage, kHeight_LeftImage)] autorelease];
        
    }
    return [[_leftImage retain] autorelease];
}
//右上
- (UIImageView *)rightImageUp {
    if (!_rightImageUp) {
        self.rightImageUp = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_rightUpImage, kMargintop_rightUpImage, kWidth_rightUpImage, kHeight_rightUpImage)] autorelease];
    }
    return [[_rightImageUp retain] autorelease];
}
//右下
- (UIImageView *)rightImageDown {
    if (!_rightImageDown) {
        self.rightImageDown = [[[UIImageView  alloc] initWithFrame:CGRectMake(kMarginLeft_rightDownImage, kMargintop_rightDownImage, kWidth_rightDownImage, kHeight_rightDownImage)] autorelease];
    }
    return [[_rightImageDown retain] autorelease];
}
//标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_titleLabel, kMarginTop_titleLabel, kWidth_titleLabel, kHeight_titleLabel)] autorelease];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    return [[_titleLabel retain] autorelease];
}
//简介
- (UILabel *)digestLabel {
    if (!_digestLabel) {
        self.digestLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_digestLabel, kMarginTop_digestLabel, kWidth_digestLabel, kHeight_digestLabel)] autorelease];
        _digestLabel.font = [UIFont systemFontOfSize:14];
        _digestLabel.textColor = [UIColor lightGrayColor];
        _digestLabel.numberOfLines = 3;
        _digestLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return [[_digestLabel retain] autorelease];
}
//来源
- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        self.sourceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_LeftImage, kMarginLastRowHeightLabel, 80, 40)] autorelease];
        
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = [UIColor lightGrayColor];
        
    }
    return [[_sourceLabel retain] autorelease];
}
//跟帖数
- (UILabel *)replyCountLabel {
    if (!_replyCountLabel) {
        self.replyCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, kMarginLastRowHeightLabel, 70, 40)] autorelease];
        self.replyCountLabel.textAlignment = NSTextAlignmentRight;
        self.replyCountLabel.font = [UIFont systemFontOfSize:12];
        self.replyCountLabel.textColor = [UIColor lightGrayColor];
        
    }
    return [[_replyCountLabel retain] autorelease];
}
//自定义初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.digestLabel];
        [self.contentView addSubview:self.sourceLabel];
        [self.contentView addSubview:self.leftImage];
        [self.contentView addSubview:self.rightImageUp];
        [self.contentView addSubview:self.rightImageDown];
        [self.contentView addSubview:self.replyCountLabel];
    }
    return self;
}

//给数据赋值
- (void)configureCellWithRead:(ReadListModel *)readNews {
    self.titleLabel.text = readNews.title;
    self.digestLabel.text = readNews.digest;
    self.sourceLabel.text = readNews.source;
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld跟帖", (long)readNews.replyCount];
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:readNews.imgsrc] placeholderImage:[UIImage imageNamed:@"defaultCycle"]];

    if (readNews.imgnewextra.count > 0) {
        [self.rightImageUp sd_setImageWithURL:[NSURL URLWithString:readNews.imgnewextra[0][@"imgsrc"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]];
        [self.rightImageDown sd_setImageWithURL:[NSURL URLWithString:readNews.imgnewextra[1][@"imgsrc"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]];
    }
    //动态调整cell高度
    CGRect frame = self.titleLabel.frame;

    frame.size.height = [[self class] heightForTitleText:readNews.title fontSize:17];
    self.titleLabel.frame = frame;
    

    //调整digest高度
    CGRect digestFrame = self.digestLabel.frame;
    digestFrame.size.height = [[self class] heightForTitleText:readNews.digest fontSize:14];
    digestFrame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;

    self.digestLabel.frame = digestFrame;
    
    
    CGFloat btnHeight = [[self class] heightForRowWithReadNews:readNews] - 40;
    self.replyCountLabel.frame = CGRectMake( self.replyCountLabel.frame.origin.x,  btnHeight, self.replyCountLabel.frame.size.width, self.replyCountLabel.frame.size.height);
    
    self.sourceLabel.frame = CGRectMake(self.sourceLabel.frame.origin.x, btnHeight, self.sourceLabel.frame.size.width, self.sourceLabel.frame.size.height);
}

+ (CGFloat)heightForTitleText:(NSString *)text fontSize:(CGFloat)size {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWidth_titleLabel, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]} context:nil];
   
    return rect.size.height;
}

+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews {
    
    CGFloat titleHeight = [self heightForTitleText:readNews.title fontSize:17];
    CGFloat digestHeight = [self heightForTitleText:readNews.digest fontSize:14];
    
    return kMarginTop_titleLabel + titleHeight + digestHeight + 40;
}


- (void)dealloc {
    [_rightImageDown release];
    [_rightImageUp release];
    [_replyCountLabel release];
    [_leftImage release];
    [_digestLabel release];
    [_titleLabel release];
    [_sourceLabel release];
    [super dealloc];
}

@end



