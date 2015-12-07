//
//  NewsDetailsController.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  新闻详细界面视图控制器
 */
@interface NewsDetailsController : UIViewController
@property (nonatomic, copy) NSString *docid;   //唯一标识
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *flag; //标记是从阅读push，还是新闻push，为转到评论做唯一标识
@property (nonatomic, copy) NSString *url_3w;
@end
