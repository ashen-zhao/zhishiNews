//
//  Model.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

//{
//    "clientcover": "http://img3.cache.netease.com/photo/0096/2015-06-05/400x400_ARCB508T54GI0096.jpg",
//    "clientcover1": "http://img3.cache.netease.com/photo/0096/2015-06-05/580x300_ARCB508T54GI0096.jpg",
//    "cover": "http://img3.cache.netease.com/photo/0096/2015-06-05/ARCAR5PV54GI0096.jpg",
//    "createdate": "2015-06-05 19:11:00",
//    "datetime": "2015-06-05 19:16:42",
//    "desc": "美国洛杉矶艺术家Sarah Lee DeRemer利用photoshop软件把多种动物P在同一张图片上。远看这些照片上的动物都很寻常，但是近看会大吃一惊。其实图片都暗藏玄机。本来以为这是变色蜥蜴的图，没什么特别。但是近看，你会发现它居然有着吉娃娃小狗的脸。",
//    "imgsum": "17",
//    "pics": [
//             "http://img3.cache.netease.com/photo/0096/2015-06-05/ARCAR5PV54GI0096.jpg",
//             "http://img3.cache.netease.com/photo/0096/2015-06-05/ARCAR6FV54GI0096.jpg",
//             "http://img3.cache.netease.com/photo/0096/2015-06-05/ARCAR6UG54GI0096.jpg"
//             ],
//    "pvnum": "",
//    "replynum": "137",
//    "scover": "http://img3.cache.netease.com/photo/0096/2015-06-05/s_ARCAR5PV54GI0096.jpg",
//    "setid": "67442",
//    "setname": "美国艺术家用PS\"合成\"新动物",
//    "seturl": "http://help.3g.163.com/photoview/54GI0096/67442.html",
//    "tcover": "http://img3.cache.netease.com/photo/0096/2015-06-05/t_ARCAR5PV54GI0096.jpg",
//    "topicname": ""
//},

//接口网址:http://c.3g.163.com/photo/api/list/0096/54GI0096.json

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface PictureModel : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, copy) NSString *clientcover;//辅助图片
@property (nonatomic, copy) NSString *clientcover1;//辅助图片1
@property (nonatomic, copy) NSString *cover;//主图片
@property (nonatomic, copy) NSString *setname, *desc;//设置名字 或者简介
@property (nonatomic, copy) NSString *createdate;//创建日期
@property (nonatomic, copy) NSString *datetime;//更新日期
@property (nonatomic, assign) NSInteger imgsum;//图片总数
@property (nonatomic, assign) NSInteger replynum;//回复数量
@property (nonatomic, copy) NSString *seturl;//设置网址字符串对象
@property (nonatomic, copy) NSString *setid;//设置id


@end
