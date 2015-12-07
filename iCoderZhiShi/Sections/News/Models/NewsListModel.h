//
//  NewsListModel.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  说明：新闻列表model
 */
@interface NewsListModel : NSObject
@property (nonatomic, copy) NSString *digest;   //简介
@property (nonatomic, copy) NSString *skipID;    //跳转图片浏览模式id
@property (nonatomic, copy) NSString *skipType;  //代表图片集
@property (nonatomic, copy) NSString *docid;            //详细ID
@property (nonatomic, retain) NSMutableArray *imgextra; //其他图片
@property (nonatomic, assign) NSInteger priority; //
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *ptime;//发布时间
@property (nonatomic, copy) NSString *imgsrc;//图片地址
@property (nonatomic, assign) NSInteger *hasHead; //是否是第一行大图
@property (nonatomic, copy) NSString *boardid; //跳转评论的标识
@property (nonatomic, copy) NSString *url_3w;
@property (nonatomic, copy) NSString *editor; //讨论区

@property (nonatomic, copy) NSString *source; //来源
@property (nonatomic, assign) NSInteger votecount; //赞
@property (nonatomic, assign) NSInteger replyCount; //回复数
@property (nonatomic, copy) NSString *TAGS;//标签类型

@property (nonatomic, assign) NSInteger imgType; //独家标识，大图，还是小图

@property (nonatomic, assign) NSInteger flag; //标识，使用哪套cell
@property (nonatomic, assign) BOOL isPhotoset;


@end
