//
//  ImagesDisplayView.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/6.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesDisplayModel.h"

@interface ImagesDisplayView : UIView
@property (nonatomic, retain) UILabel *lblTitle;         //显示标题
@property (nonatomic, retain) UIScrollView *imagesScrollView; //图片滚动视图
@property (nonatomic, retain) UITextView *note;//图片简介

@property (nonatomic, retain) UIView *toolBar;//工具栏
@property (nonatomic, retain) UILabel *lblPage; //当前页
@property (nonatomic, retain) UIButton *btnShare; //分享按钮
@property (nonatomic, retain) UIButton *btnComment;  //评论
@property (nonatomic, retain) UIButton *btnSave;  //收藏
@property (nonatomic, retain) UIButton *btnBack;  //返回

//渐变层，用与显示背景渐变的标题，和内容
@property (nonatomic, retain) UIView *layerView, *layerViewNote;

@property (nonatomic, retain) ImagesDisplayModel *model;

@end
