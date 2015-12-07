//
//  CommonNewsDetailsView.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CommonNewsDetailsView.h"
#import "NewsDetailsModel.h"
#import "CommonMacros.h"

@interface CommonNewsDetailsView()

@end
@implementation CommonNewsDetailsView
- (void)dealloc {
    [_toolBar release];
    [_btnSave release];
    [_btnShare release];
    [_btnComment release];
    [_webView release];
    [_lblDate release];
    [_lblSource release];
    [_lblTitle release];
    [_model release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lblTitle];
        [self addSubview:self.webView];
        [self addSubview:self.lblSource];
        [self addSubview:self.lblDate];
        [self addSubview:self.toolBar];
        [self configureLine];
    }
    return self;
}


#pragma mark - method
+ (CGFloat)getTextWidth:(NSString *)text {
  return  [text boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |
           NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.width;
}

//计算webView的高度
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//    self.contentSize = CGSizeMake(kScreenWidth, height);
//}

#pragma mark - lazy loading
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 66, kScreenWidth, 30)] autorelease];
        self.lblTitle.numberOfLines = 0;
        self.lblTitle.font = [UIFont systemFontOfSize:16 weight:3];
        self.lblTitle.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return [[_lblTitle retain] autorelease];
}

- (UILabel *)lblSource {
    if (!_lblSource) {
        self.lblSource = [[[UILabel alloc] initWithFrame:CGRectMake(15, 96, 80, 15)] autorelease];
        self.lblSource.font = [UIFont systemFontOfSize:14];
        self.lblSource.textColor = [UIColor grayColor];
    }
    return [[_lblSource retain] autorelease];
}

- (UILabel *)lblDate {
    if (!_lblDate) {
        self.lblDate = [[[UILabel alloc] initWithFrame:CGRectMake(15 + 80, 96, kScreenWidth - 150 - 25, 15)] autorelease];
        self.lblDate.font = [UIFont systemFontOfSize:14];
        self.lblDate.textColor = [UIColor grayColor];
    }
    return [[_lblDate retain] autorelease];
}
- (UIWebView *)webView {
    if (!_webView) {
        self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 115, kScreenWidth, [UIScreen mainScreen].bounds.size.height - 160)] autorelease];
        _webView.backgroundColor = [UIColor clearColor];
        //        _webView.scrollView.scrollEnabled = NO;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        
    }
    return [[_webView retain] autorelease];
}


- (UIButton *)btnShare {
    if (!_btnShare) {
        self.btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(kScreenWidth - 40 - 20, 3, 20, 20);
        [_btnShare setImage:[UIImage imageNamed:@"btn.content.share"] forState:UIControlStateNormal];
    }
    return [[_btnShare retain] autorelease];
}
- (UIButton *)btnSave {
    if (!_btnSave) {
        self.btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(kScreenWidth - 23 - 100, 0, 23, 23);
        [_btnSave setImage:[UIImage imageNamed:@"icon.more.enjoy"] forState:UIControlStateNormal];
    }
    return [[_btnSave retain] autorelease];
}

- (UIButton *)btnComment {
    if (!_btnComment) {
        self.btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectMake(kScreenWidth - 20 - 160, 3, 20, 20);
        [_btnComment setImage:[UIImage imageNamed:@"btn.common.comment"] forState:UIControlStateNormal];
    }
    return [[_btnComment retain] autorelease];
}
- (UIView *)toolBar {
    if (!_toolBar) {
        self.toolBar = [[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44, kScreenWidth, 44)] autorelease];
        self.toolBar.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0  blue:245 / 255.0 alpha:0.3];
        [self.toolBar  addSubview:self.btnSave];
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 23 - 100, 23, 20, 20)];
        lbl1.text = @"收藏";
        lbl1.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl1];
        [lbl1 release];
        
        [self.toolBar  addSubview:self.btnShare];
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 40 - 20, 23, 20, 20)];
        lbl2.text = @"分享";
        lbl2.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl2];
        [lbl2 release];
        
        [self.toolBar addSubview:self.btnComment];
        UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - 160, 23, 20, 20)];
        lbl3.text = @"评论";
        lbl3.font = [UIFont systemFontOfSize:10];
        [self.toolBar addSubview:lbl3];
        [lbl3 release];
    }
    return [[_toolBar retain] autorelease];
}

#pragma mark - setter 方法
- (void)configureLine {
    //标题分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 96 + 18, kScreenWidth - 10, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    [line release];
}

- (void)setModel:(NewsDetailsModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
        self.lblTitle.text = model.title;
        self.lblDate.text = model.ptime;
        self.lblSource.text = model.source;
        //获取图片集信息
        for (int i = 0; i < model.img.count; i++) {
            NSArray *pixArr = [model.img[i][@"pixel"]  componentsSeparatedByString:@"*"];
            if (!pixArr) {
                pixArr = @[[NSString stringWithFormat:@"%f", kScreenWidth - 20], [NSString stringWithFormat:@"%f", (kScreenWidth - 20) * 2.0 / 3]];
            }
            if ([pixArr[0] floatValue] > kScreenWidth) {
                pixArr = @[[NSString stringWithFormat:@"%f", kScreenWidth - 20],[NSString stringWithFormat:@"%f",[pixArr[1] floatValue]  * kScreenWidth / [pixArr[0] floatValue]]];

            }
            NSString *imgTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"> <img style=\" width:%@; height:%@;\" src=\"%@\"><span>%@</span></div>",pixArr[0], pixArr[1], model.img[i][@"src"], model.img[i][@"alt"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--IMG#%d-->", i] withString:imgTag];
        }
        for (int i = 0; i < model.video.count; i++) {
            NSString *videoTag = [NSString stringWithFormat:@"<div style=\"border:1px font-size:14; text-align:center; solid #ccc;\"><video id=\"player\" width=\"300\" height=\"250\" controls webkit-playsinline controls='controls' autoplay='autoplay'> <source src=\"%@\" type=\"video/mp4\" /> </video></div>", model.video[i][@"url_mp4"]];
            model.body = [model.body stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<!--VIDEO#%d-->", i] withString:videoTag];
        }
        [self.webView loadHTMLString:model.body baseURL:nil];
        
        CGRect frame = self.lblSource.frame;
        frame.size.width = [CommonNewsDetailsView getTextWidth:self.lblSource.text];
        self.lblSource.frame = frame;
        
        CGRect frame2 = self.lblDate.frame;
        frame2.origin.x = 15 + frame.size.width + 5;
        self.lblDate.frame = frame2;
    }
}
@end
