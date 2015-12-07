//
//  CommentCell.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CommentCell.h"
#import "CommonMacros.h"
#import "UIImageView+WebCache.h"

#define kMarginLeft_Avator    10
#define kMarginTop_Avator     20
#define kWidth_Avator         30
#define kHeight_Avator        30

#define kMarginLeft_Name        (kMarginLeft_Avator + kWidth_Avator + 10)
#define kMarginTop_Name         kMarginTop_Avator + 5
#define kWidth_Name             200
#define kHeight_Name            20

#define kMarginLeft_Address     kMarginLeft_Name
#define kMarginTop_Address      (kMarginTop_Name + kHeight_Name)
#define kWidth_Address          140
#define kHeight_Address         20

#define kMarginLeft_Time        (kMarginLeft_Name + kWidth_Address)
#define kMarginTop_Time         kMarginTop_Address
#define kWidth_Time             50
#define kHeight_Time            20

//#define kMarginLeft_GoodCount   (kScreenWidth - 140)
//#define kMarginTop_GoodCount    kMarginTop_Name
//#define kWidth_GoodCount        100
//#define kHeight_GoodCount       20

#define kMarginLeft_btn         (kScreenWidth - 40)
#define kMarginTop_btn          (kMarginTop_Name - 5)
#define kWidth_btn              30
#define kHeight_btn             30

#define kMarginLeft_Content     kMarginLeft_Name
#define kMarginTop_Content      kMarginTop_Address +  kHeight_Address + 5
#define kWidth_Content          kScreenWidth - kMarginLeft_Content - 30

@implementation CommentCell
- (void)dealloc {
    [_model release];
    [_avator release];
    [_lblName release];
    [_lblAddress release];
//    [_lblGoodCount release];
    [_lblContent release];
//    [_btnGood release];
    [_lblTime release];
    [super dealloc];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.avator];
        [self.contentView addSubview:self.lblName];
        [self.contentView addSubview:self.lblAddress];
//        [self.contentView addSubview:self.lblGoodCount];
        [self.contentView addSubview:self.lblContent];
//        [self.contentView addSubview:self.btnGood];
        [self.contentView addSubview:self.lblTime];
    }
    return self;
}

#pragma mark -  计算高度

//计算文本宽度
+ (CGFloat)widthForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
}
//计算文本高度
+ (CGFloat)heightForText:(NSString *)text {
    return  [text boundingRectWithSize:CGSizeMake(kScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
}
//计算cell高度
+ (CGFloat)heightForRowWithDic:(CommentModel *)model {
    return [self heightForText:model.b] + kMarginTop_Address + kHeight_Address + 20; //
}

#pragma mark - 修改frame

- (void)configureFrame {
    //动态修改控件的位置
    CGRect aframe = self.lblAddress.frame;
    aframe.size.width = [CommentCell widthForText:self.lblAddress.text];
    self.lblAddress.frame = aframe;
    
    //修改
    CGRect bframe = self.lblTime.frame;
    bframe.origin.x = self.lblAddress.frame.origin.x + self.lblAddress.frame.size.width + 7;
    bframe.size.width = [CommentCell widthForText:self.lblTime.text];
    self.lblTime.frame = bframe;
    
    //修改内容frame
    CGRect frame = self.lblContent.frame;
    frame.size.height = [CommentCell heightForText:self.lblContent.text];
    self.lblContent.frame = frame;

}

- (void)setupTimeStyle {

    if (self.lblTime.text == nil) {
        self.lblTime.text = @"时间都去哪了";
        return;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];//转换器
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置格式
    NSDate *date = [format dateFromString:self.lblTime.text];//转换
    [format release];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
 
    if (timeInterval <= 60) {
        self.lblTime.text = @"刚刚";
    } else if (timeInterval <= 3600) {[[NSDate date] timeIntervalSinceDate:[NSDate date]];
        self.lblTime.text = [NSString stringWithFormat:@"%i分钟前", (int)timeInterval / 60];
    } else if (timeInterval <= 3600 * 24){
        self.lblTime.text = [NSString stringWithFormat:@"%i小时前", (int)timeInterval / 3600];
    } else {
        self.lblTime.text = [NSString stringWithFormat:@"%i天前", (int)timeInterval / 3600 * 24];
    }
}
#pragma mark - getter
- (UIImageView *)avator {
    if (!_avator) {
        self.avator = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_Avator, kMarginTop_Avator, kWidth_Avator, kHeight_Avator)] autorelease];
        self.avator.layer.cornerRadius = kWidth_Avator / 2;
        self.avator.layer.masksToBounds = YES;
    }
    return [[_avator retain] autorelease];
}
- (UILabel *)lblName {
    if (!_lblName) {
        self.lblName = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Name, kMarginTop_Name, kWidth_Name, kHeight_Name)] autorelease];
    }
    return [[_lblName retain] autorelease];
}
- (UILabel *)lblAddress {
    if (!_lblAddress) {
        self.lblAddress = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Address, kMarginTop_Address, kWidth_Address, kHeight_Address)] autorelease];
        self.lblAddress.font = [UIFont systemFontOfSize:12];
        self.lblAddress.textColor = [UIColor lightGrayColor];
    }
    return [[_lblAddress retain] autorelease];
}
- (UILabel *)lblTime {
    if (!_lblTime) {
        self.lblTime = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Time, kMarginTop_Time, kWidth_Time, kHeight_Time)] autorelease];
        self.lblTime.font = [UIFont systemFontOfSize:12];
        self.lblTime.textColor = [UIColor lightGrayColor];
    }
    return [[_lblTime retain] autorelease];
}
//- (UILabel *)lblGoodCount {
//    if (!_lblGoodCount) {
//        self.lblGoodCount = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_GoodCount, kMarginTop_GoodCount, kWidth_GoodCount, kHeight_GoodCount)] autorelease];
//        self.lblGoodCount.textColor = [UIColor lightGrayColor];
//        self.lblGoodCount.font = [UIFont systemFontOfSize:14];
//        self.lblGoodCount.textAlignment = NSTextAlignmentRight;
//        _lblGoodCount.hidden = YES;
//    }
//    return [[_lblGoodCount retain] autorelease];
//}
- (UILabel *)lblContent {
    if (!_lblContent) {
        self.lblContent = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft_Content, kMarginTop_Content, kWidth_Content, 0)] autorelease];
        self.lblContent.textAlignment = NSTextAlignmentLeft;
        self.lblContent.font = [UIFont systemFontOfSize:16];
        self.lblContent.lineBreakMode = NSLineBreakByCharWrapping;
        self.lblContent.numberOfLines = 0;
        
    }
    return [[_lblContent retain] autorelease];
}
//- (UIButton *)btnGood {
//    if (!_btnGood) {
//        self.btnGood = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnGood.frame = CGRectMake(kMarginLeft_btn, kMarginTop_btn, kWidth_btn, kHeight_btn);
//        _btnGood.hidden = YES;
//        [_btnGood setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"comment_support_hd" ofType:@"png"]] forState:UIControlStateNormal];
//        [_btnGood setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"comment_support_highlighted" ofType:@"png"]] forState:UIControlStateHighlighted];
//    }
//    return [[_btnGood retain] autorelease];
//}

#pragma mark setter
- (void)setModel:(CommentModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        [self.avator sd_setImageWithURL:[NSURL URLWithString:model.timg] placeholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultAvator" ofType:@"png"]]];
        self.lblName.text = [model.n isEqualToString:@""]|| model.n == nil ? @"火星人" : model.n;
        self.lblAddress.text = model.f;
//        self.lblGoodCount.text = model.v;
        self.lblContent.text = model.b;
 
        self.lblTime.text = model.t;
        //从地址字符串中，找出昵称
        if ([model.f containsString:@"&nbsp;"]) {
            self.lblName.text = [self.lblName.text isEqualToString:@"火星人"] ? [model.f componentsSeparatedByString:@"&nbsp"][1] : self.lblName.text;
        }
        self.lblName.text = [[self.lblName.text stringByReplacingOccurrencesOfString:@";" withString:@""] stringByReplacingOccurrencesOfString:@"：" withString:@""];
        self.lblAddress.text = [[model.f componentsSeparatedByString:@"网友"][0] stringByAppendingFormat:@"网友"];
        [self setupTimeStyle];
        [self configureFrame];
    }
}
@end
