//
//  MineModel.h
//  UI-19-QiuBaiDemo
//
//  Created by lanouhn on 15/5/19.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  	
 <array>
 <dict>
 <key>imageName</key>
 <string>icon_myfriends</string>
 <key>title</key>
 <string>我的糗友</string>
 </dict>
	</array>
 */
@interface MineModel : NSObject
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

- (id)initWithDic:(NSDictionary *)dic;
+ (id)mineModelWithDic:(NSDictionary *)dic;

@end
