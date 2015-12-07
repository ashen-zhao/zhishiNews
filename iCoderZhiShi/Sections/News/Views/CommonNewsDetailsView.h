//
//  CommonNewsDetailsView.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsDetailsModel;

@interface CommonNewsDetailsView : UIView
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) UILabel *lblSource; //来源
@property (nonatomic, retain) UILabel *lblDate;
@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic, retain) UIView *toolBar;//工具栏
@property (nonatomic, retain) UIButton *btnShare; //分享按钮
@property (nonatomic, retain) UIButton *btnSave;  //收藏
@property (nonatomic, retain) UIButton *btnComment; //评论按钮

@property (nonatomic, retain) NewsDetailsModel *model;
@end

