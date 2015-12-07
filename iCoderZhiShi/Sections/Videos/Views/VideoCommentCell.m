//
//  VideoCommentCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/20.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideoCommentCell.h"
#import "CommonMacros.h"
#import "VideosCommentModel.h"
#import "UIImageView+WebCache.h"

@implementation VideoCommentCell

- (void)dealloc {
    [_avotorImage release];
    [_lblName release];
    [_lblText release];
    [_model release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avotorImage];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblText];
    }
    return self;
}

+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
}
+ (CGFloat)heightCell:(VideosCommentModel *)model {
    return [VideoCommentCell heightForText:model.content] + 40;
}
//头像
- (UIImageView *)avotorImage {
    if (!_avotorImage) {
        self.avotorImage = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)] autorelease];
    }
    return [[_avotorImage retain] autorelease];
}
- (UILabel *)lblName {
    if (!_lblName) {
        self.lblName = [[[UILabel alloc] initWithFrame:CGRectMake(60, 10, kScreenWidth - 50, 15)] autorelease];
        self.lblName.font = [UIFont systemFontOfSize:14];
        self.lblName.textColor = [UIColor grayColor];
    }
    return [[_lblName retain] autorelease];
}
- (UILabel *)lblText {
    if (!_lblText) {
        self.lblText = [[[UILabel alloc] initWithFrame:CGRectMake(60, 30, kScreenWidth - 70, 60)] autorelease];
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByCharWrapping;
        self.lblText.font = [UIFont systemFontOfSize:14];
    }
    return [[_lblText retain] autorelease];
}


-(void)setModel:(VideosCommentModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        [self.avotorImage sd_setImageWithURL:[NSURL URLWithString:model.user[@"profile_image"]] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultAvator" ofType:@"png"]]];
        self.lblName.text = model.user[@"username"];
        self.lblText.text = model.content;
        
        CGRect frame = self.lblText.frame;
        frame.size.height = [VideoCommentCell heightForText:model.content];
        self.lblText.frame = frame;
    }
}

@end
