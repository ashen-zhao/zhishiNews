//
//  VideosCommentModel.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/20.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VideosCommentModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) NSDictionary *user;//username, profile_image
@end
