//
//  FavoriteModel.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, copy) NSString *ftitle;
@property (nonatomic, copy) NSString *furl;
@property (nonatomic, copy) NSString *fdocid;
@property (nonatomic, copy) NSString *fboardid;
@property (nonatomic, copy) NSString *flag;
@end
