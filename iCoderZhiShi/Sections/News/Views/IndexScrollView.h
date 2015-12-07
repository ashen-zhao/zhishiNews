//
//  IndexScrollView.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/15.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  重用UIScrollView机制的小的UIScrollView
 */
@interface IndexScrollView : UIScrollView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIImageView *imageV;
@end
