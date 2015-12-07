//
//  RootViewController.m
//  WaterFallTest
//
//  Created by 侯文富 on 14-2-15.
//  Copyright (c) 2014年 侯文富. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterfallLayout;
@protocol UICollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>
//每个cell高度指定代理
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewWaterfallLayout : UICollectionViewLayout
@property (nonatomic, weak) id<UICollectionViewDelegateWaterfallLayout> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // 列数
@property (nonatomic, assign) CGFloat itemWidth; // item的宽度
@property (nonatomic, assign) UIEdgeInsets sectionInset; // 每个section的边框间距
@property (nonatomic, assign) CGFloat minLineSpacing;  //每行每列的间隔

@end
