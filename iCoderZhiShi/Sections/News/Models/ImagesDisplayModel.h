//
//  ImagesDIsplayModel.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/6.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  图片集合展示model
 */
@interface ImagesDisplayModel : NSObject
@property (nonatomic, copy) NSString *postid;//唯一标识
@property (nonatomic, copy) NSString *creator; //作者
@property (nonatomic, copy) NSString *createtime; //时间
@property (nonatomic, copy) NSString *desc; //描述
@property (nonatomic, copy) NSString *imgsum;// 图片数量
@property (nonatomic, copy) NSMutableArray *photos; //图片集合
@property (nonatomic, copy) NSString *url;
//集合中：imgurl, note, photoid, simgurl, squareimgurl, timgurl, imgtitle
@property (nonatomic, copy) NSString *setname; //标题
@property (nonatomic, copy) NSString *source; //来源
@property (nonatomic, copy) NSString *settag; //湖泊


@end
