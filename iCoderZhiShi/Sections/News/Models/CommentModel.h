//
//  CommentModel.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
*   评论model
*http://comment.api.163.com/api/json/post/list/new/hot/3g_bbs/ARLVG8NU00963VRO/0/10/10/2/2
 http://comment.api.163.com/api/json/post/list/new/normal/3g_bbs/ARLVG8NU00963VRO/desc/0/10/10/2/2
*/
@interface CommentModel : NSObject
@property (nonatomic, retain) NSString *timg, *f, *v, *t, *b, *n; //图片，地方，赞，时间，内容，昵称
@property (nonatomic, retain) NSString *ut; //昵称
@property (nonatomic, assign) NSInteger votecount; //评论数


@end
