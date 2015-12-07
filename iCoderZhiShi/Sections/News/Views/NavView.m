//
//  NavView.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NavView.h"
#import "CommonMacros.h"
#import "AppDelegate.h"
#import "NavTypeTitleModel.h"

@interface NavView()<UIScrollViewDelegate>
@property (nonatomic, retain) NavTypeTitleModel *model;
@property (nonatomic, retain) UIScrollView *scroll;
@end
@implementation NavView

- (void)dealloc  {
    [_model release];
    [_scroll release];
    [super dealloc];
}
//static NavView *navView;
- (instancetype)initWithFrame:(CGRect)frame {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        navView = [super initWithFrame:frame];
//        //加载类别model
//        navView.model = [NavTypeTitleModel typeTitleWithModel];
//        [navView configureNav];
//    });
    if (self = [super initWithFrame:frame]) {
        //加载类别model
        self.model = [NavTypeTitleModel typeTitleWithModel];
        [self configureNav];
    }
    return self;
}

//自定义导航条
- (void)configureNav {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0];
    self.tintColor = [UIColor whiteColor];
    [self configureScrollView];
    [self configureLeftButton];
}

//导航左侧按钮
- (void)configureLeftButton {
    UIButton *navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navLeftBtn setFrame:CGRectMake(16, 21, 44, 44)];
    [navLeftBtn setTag:1001];//1
    [navLeftBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qr_toolbar_more_hl"]]];
    [navLeftBtn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:navLeftBtn];

}

//配置导航类型滚动视图
- (void)configureScrollView {
    self.scroll = [[[UIScrollView alloc] initWithFrame:CGRectMake(100, 20, kScreenWidth - 200, 44)] autorelease];
    self.scroll.contentSize = CGSizeMake(self.model.typeName.count * 60, 44);
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scroll];
    for (int i = 0; i < self.model.typeName.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 101 + i;
    
        btn.frame = CGRectMake(50 * i, 0, 40, 40);
        btn.tintColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:self.model.typeName[i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
           [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scroll addSubview:btn];
    }
    [self addSubview:self.scroll];
}
#pragma mark - action 
//调出侧边栏
- (void)handleAction:(UIButton *)sender {
      [((AppDelegate *)[UIApplication sharedApplication].delegate).menuController showLeftController:YES];
}

- (void)handleActionRight:(UIButton *)sender {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).menuController showLeftController:YES];
}
//点击类型按钮事件
- (void)handleBtn:(UIButton *)sender {
    for (int i = 0; i < self.scroll.subviews.count;i++) {
        ((UIButton *)[self.scroll viewWithTag:100 + i]).titleLabel.font = [UIFont systemFontOfSize:14];
        [((UIButton *)[self.scroll viewWithTag:100 + i]) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if ([_delegate respondsToSelector:@selector(clickBtn:typeModel:navView:)]) {
        [self.delegate clickBtn:sender typeModel:self.model navView:self];
    }
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

#pragma mark - getter ,setter

@end
