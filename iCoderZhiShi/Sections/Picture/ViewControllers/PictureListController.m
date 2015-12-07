//
//  PictureListController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/4.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "PictureListController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "AvatarCell.h"
#import "PictureModel.h"
#import "NetworkHelpers.h"
#import "CommonMacros.h"

#import "AppDelegate.h"
#import "DDMenuController.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "ImagesDisplayController.h"


#define kURL_Start @"http://c.3g.163.com/photo/api/list/0096/54GI0096.json"
#define kURL_More  @"http://c.m.163.com/photo/api/morelist/0096/54GI0096/%@.json"


@interface PictureListController () <UICollectionViewDelegateWaterfallLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataSource;//存储所有PictureModel对象.
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *setid;
@end

@implementation PictureListController

- (void)dealloc {
    [_setid release];
    [_dataSource release];
    [_collectionView release];
    [super dealloc];
}

#pragma mark - lazy loading
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}

- (void)layoutWaterfall {
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    //1.设置item的宽度
    layout.itemWidth = (kScreenWidth - 15) / 2;
    //2.设置每个分区的缩进量
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    //3.设置代理, 用来动态返回每一个item的高度
    layout.delegate = self;
    //4.设置最小行间距
    layout.minLineSpacing = 15;
    //5.列数
    layout.columnCount = 2;
    
    self.collectionView = [[[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout] autorelease];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[AvatarCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    [layout release];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default"]];
    [self configureLeftButton];
    [self layoutWaterfall];
    [self readData:kURL_Start];
    [self refreshDown];
    [self loadMoreUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if([self isViewLoaded] && !self.view.window) {
//        //安全移除掉根视图
//        self.view = nil;
//    }
}


#pragma mark -method
- (void)readData:(NSString *)strUrl{
    
    [NetworkHelpers JSONDataWithUrl:strUrl success:^(id data) {
        //换类型之前，移除上一次的数据
        if ([strUrl isEqualToString:kURL_Start]) {
            [self.dataSource removeAllObjects];
        }
        NSArray *arr = [NSArray arrayWithArray:data];
        for (NSDictionary *dict in arr) {
            PictureModel *model = [PictureModel new];
            [model setValuesForKeysWithDictionary:dict];
            
            if ([NetworkHelpers okPass:model.desc]) {
                [self.dataSource addObject:model];
            }

            self.setid = model.setid;
            [model release];
        }
        [self.collectionView reloadData];
    } fail:^{
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"网络不给力呀";
        [mb hide:YES afterDelay:0.5];
    }];
}

//下拉刷新
- (void)refreshDown {    
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        [self readData:kURL_Start];
        [self.collectionView.header endRefreshing];
    }];
    // 马上进入刷新状态
    [self.collectionView.header beginRefreshing];
}
- (void)loadMoreUp {    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [self readData:[NSString stringWithFormat:kURL_More, self.setid]];
        [self.collectionView.footer endRefreshing];
    }];
    [self.collectionView.footer beginRefreshing];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//设置分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//针对于每个item返回cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    PictureModel *model = self.dataSource[indexPath.item];
    [cell configureSubviews:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate
//item选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImagesDisplayController *iamgesDisplayVC = [[ImagesDisplayController alloc] init];
    PictureModel *model = self.dataSource[indexPath.row];
    iamgesDisplayVC.skipID = model.setid;
    self.navigationController.navigationBarHidden = YES;
    [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
    [self.navigationController pushViewController:iamgesDisplayVC animated:YES];
    [self setHidesBottomBarWhenPushed:NO];//显示tabbar
    [iamgesDisplayVC release];
}
#pragma mark - UICollectionViewDelegateWaterfallLayout
//动态返回每个item的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据对应的Model对象, 动态计算出每个item的高度,
    //按比例进行缩放,得到最终缩放之后的高度,返回
    PictureModel *model = self.dataSource[indexPath.item];
    return [AvatarCell heightForRowWithDic:(PictureModel *)model];
}
#pragma mark - 界面配置类
- (void)configureLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
    
}

- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}




@end
