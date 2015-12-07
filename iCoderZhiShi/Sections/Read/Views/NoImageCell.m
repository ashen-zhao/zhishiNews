//
//  NoImageCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NoImageCell.h"
#import "CommonMacros.h"
@implementation NoImageCell
#pragma mark - lazy loading
//标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)] autorelease];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    return [[_titleLabel retain] autorelease];
}
//简介
- (UILabel *)digestLabel {
    if (!_digestLabel) {
        self.digestLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 60)] autorelease];
        
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
        self.sourceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 130, 80, 40)] autorelease];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
        _sourceLabel.textColor = [UIColor lightGrayColor];
    }
    return [[_sourceLabel retain] autorelease];
}
//跟帖

- (UILabel *)replyCountLabel {
    if (!_replyCountLabel) {
        self.replyCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 110, 70, 40)] autorelease];
       
        self.replyCountLabel.textAlignment = NSTextAlignmentRight;
        self.replyCountLabel.font = [UIFont systemFontOfSize:12];
        self.replyCountLabel.textColor = [UIColor lightGrayColor];
    }
    return [[_replyCountLabel retain] autorelease];
}
//自定义
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.digestLabel];
        [self.contentView addSubview:self.sourceLabel];
        [self.contentView addSubview:self.replyCountLabel];
    }
    return self;
}

//赋值
- (void)configureCellWithRead:(ReadListModel *)readNews {
    self.titleLabel.text = readNews.title;
    self.digestLabel.text = readNews.digest;
    self.sourceLabel.text = readNews.source;
    self.replyCountLabel.text = [NSString stringWithFormat:@"%ld跟帖",(long) readNews.replyCount];
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height = [[self class] heightForText:readNews.title fontSize:17];
    titleFrame.origin.x = 10;
    titleFrame.origin.y = 10;
    self.titleLabel.frame = titleFrame;
    
    //调整digest高度
    CGRect digestFrame = self.digestLabel.frame;
    digestFrame.size.height = [[self class] heightForText:readNews.digest fontSize:14];
    digestFrame.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10;
    
    self.digestLabel.frame = digestFrame;
    
    
    CGFloat btnHeight = [[self class] heightForRowWithReadNews:readNews] - 40;
    self.replyCountLabel.frame = CGRectMake( self.replyCountLabel.frame.origin.x,  btnHeight, self.replyCountLabel.frame.size.width, self.replyCountLabel.frame.size.height);
    
    self.sourceLabel.frame = CGRectMake(self.sourceLabel.frame.origin.x, btnHeight, self.sourceLabel.frame.size.width, self.sourceLabel.frame.size.height);
    
}
+ (CGFloat)heightForText:(NSString *)text fontSize:(CGFloat)fontSize {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
}

+ (CGFloat)heightForRowWithReadNews:(ReadListModel *)readNews {
      CGFloat titleHeight =  [self heightForText:readNews.title fontSize:17];
    CGFloat digestHeight = [self heightForText:readNews.digest fontSize:14];
    
    
    return titleHeight + digestHeight + 60;
}

- (void)dealloc {
    [_replyCountLabel release];
    [_sourceLabel release];
    [_digestLabel release];
    [_titleLabel release];
    [super dealloc];
}

@end
