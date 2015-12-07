//
//  NavView.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavView;
@class NavTypeTitleModel;
@protocol NavViewDelegate <NSObject>
@optional
- (void)clickBtn:(UIButton *)btn typeModel:(NavTypeTitleModel *)typemodel  navView:(NavView *)navView;
@end

@interface NavView : UIView
@property (nonatomic, assign) id<NavViewDelegate> delegate;
@end
