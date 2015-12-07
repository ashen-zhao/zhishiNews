//
//  AvatarCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "AvatarCell.h"
#import "UIImageView+WebCache.h"
#import "PictureModel.h"
#import "CommonMacros.h"
@implementation AvatarCell

- (void)dealloc {
    
    [_labelDigest release];
    [_icon release];
    [super dealloc];
}
//lazy loading
- (UIImageView *)icon {
    if (!_icon) {
        self.icon = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 15) / 2, 220)] autorelease];
    }
    //在getter方法中,千万不要写self.icon取值,会形成死循环.
    return [[_icon retain] autorelease];
}

- (UILabel *)labelDigest {
    if (!_labelDigest) {
        self.labelDigest = [[[UILabel alloc] initWithFrame:CGRectMake(0, 230, (kScreenWidth - 15) / 2, 30)] autorelease];
        self.labelDigest.lineBreakMode = NSLineBreakByCharWrapping;//通过字符截取.
        self.labelDigest.numberOfLines = 0;//显示多行显示,默认的不单行.
        self.labelDigest.textAlignment = NSTextAlignmentLeft;//文本的对齐方式
        self.labelDigest.font = [UIFont systemFontOfSize:15];//设置字体大小.
    }
    return [[_labelDigest retain] autorelease];
}

//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.labelDigest];
    }
    return self;
}


//给cell子控件赋值
- (void)configureSubviews:(PictureModel *)model {
    //给icon赋值
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.clientcover] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCycle" ofType:@"png"]]];
    if ([model.desc isEqualToString:@""]) {
        model.desc = model.setname;
    }
    //等比例缩放
    CGRect iframe = self.icon.frame;
    iframe.size.height = (kScreenWidth - 15) / 2; //(self.icon.image.size.height * (kScreenWidth - 15) / 2) / self.icon.image.size.width;
    self.icon.frame = iframe;
    //获取文本简介
    self.labelDigest .text = model.desc;
    //动态修改文本frame
    CGFloat txtheight = [AvatarCell heightForText:model.desc];
    CGRect frame = self.labelDigest.frame;
    frame.size.height = txtheight;
    frame.origin.y = (kScreenWidth - 15) / 2 + 10;
    self.labelDigest.frame = frame;
}

#pragma mark - 私有方法
//计算文本高度
+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake((kScreenWidth - 15) / 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
}

////计算图片的宽高
//+ (CGSize)getImageHeight:(PictureModel *)model {
//    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.clientcover]];
//    return imageView.image.size;
//}

//计算item高度
+ (CGFloat)heightForRowWithDic:(PictureModel *)model {
    return [self heightForText:model.desc] + (kScreenWidth - 15) / 2;
}


@end
