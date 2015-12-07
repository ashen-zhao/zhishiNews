//
//  NavTypeTitle.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  新闻类别类
 */
@interface NavTypeTitleModel : NSObject
@property (nonatomic, retain) NSMutableArray *typeName;   //类别名称，
@property (nonatomic, retain) NSMutableArray *typeLinkID;  //类别ID

- (id)initWithTypeTitleModel;
+ (id)typeTitleWithModel;

@end
