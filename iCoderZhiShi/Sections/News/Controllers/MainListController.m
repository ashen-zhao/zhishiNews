//
//  MainListController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "MainListController.h"
#import "CommonMacros.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "CycleModel.h"
#import "CycleScrollView.h"
#import "CommonCell.h"
#import "ThreeImagesCell.h"
#import "BigImageCell.h"
#import "NewsListModel.h"
#import "NavView.h"
#import "NavTypeTitleModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "OneImageFirstCell.h"
#import "NetworkHelpers.h"
#import "NewsDetailsController.h"
#import "MainTableView.h"
#import "ImagesDisplayController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


#define kURL_CYCLE    @"http://c.3g.163.com/nc/ad/headline/0-%d.html"
#define kURL_NEWSLIST @"http://c.3g.163.com/nc/article/headline/T1348647853363/%ld-20.html"
#define kURL_String @"http://c.3g.163.com/nc/article/list/%@/%ld-20.html"


@interface MainListController ()<NavViewDelegate,UITableViewDataSource, UITableViewDelegate> {

    NSInteger _count;//当前加载开始位置
}
@property (nonatomic, retain) NSMutableArray *dataSource; //存储数据
@property (nonatomic, retain) CycleScrollView *cycleView; //轮播图cell
@property (nonatomic, retain) MainTableView *tableView;
@property (nonatomic, retain) NavView *navView;
@property (nonatomic, retain) NSString *typeKey;
@end

@implementation MainListController



- (void)dealloc {
    [_dataSource release];
    [_navView release];
    [_tableView release];
    [_cycleView release];
    [_typeKey release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNav];
    [self.tableView reloadData];
}
//在这个方法中可以修改tableView的frame
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.origin.y = 10;
    self.tableView.frame = frame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self configureTableView];
    self.view.backgroundColor = [UIColor clearColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.typeKey = @"T1348647853363";
    [self configureCycleView];
    [self registerCell];
    [self refreshDown];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if([self isViewLoaded] && !self.view.window) {
//        //安全移除掉根视图
//        self.view = nil;
//    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NewsListModel *model = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        if (![self.typeKey isEqualToString:@"T1348647853363"]) {
            OneImageFirstCell *cell = [[[OneImageFirstCell alloc] init] autorelease];
            cell.model = model;
             tableView.rowHeight = 180;
            return cell;
        } else {            
             tableView.rowHeight = 200;
            return self.cycleView;
        }
    } else {
        //如果是首页，需要将行减去1， 即除去轮播图
      if ([self.typeKey isEqualToString:@"T1348647853363"]) {
          model = self.dataSource[indexPath.row - 1];
      }
        if (model.flag == 1) {
            ThreeImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"images" forIndexPath:indexPath];
            tableView.rowHeight = 120;
            cell.model = model;
            return cell;
        } else if(model.flag == 2) {
            BigImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bigImage" forIndexPath:indexPath];
            tableView.rowHeight = 195;
            cell.model = model;
            return cell;
        }
        else{
            CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"common" forIndexPath:indexPath];
            tableView.rowHeight = 90;
            cell.model = model;
            return cell;
        }
      }
}

#pragma mark - UITableViewDeletage
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListModel *model = self.dataSource[indexPath.row];
       //如果是首页，需要将行减去1
    if ([self.typeKey isEqualToString:@"T1348647853363"]) {
        model = self.dataSource[indexPath.row - 1];
    }
    //imgextra和photoset
    if (model.isPhotoset) {
        [self pushImagesDisplayController:model key:0];
    } else {
        NewsDetailsController *detailsController = [[NewsDetailsController alloc] init];
        detailsController.docid = model.docid;
        detailsController.newsTitle = model.title;
        detailsController.flag = model.boardid;
        detailsController.url_3w = model.url_3w;
         self.navView.hidden = YES;//隐藏自定义导航
        [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
        [self.navigationController pushViewController:detailsController animated:YES];
        [self setHidesBottomBarWhenPushed:NO];
        [detailsController release];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count - 1 == indexPath.row) {
        [self loadMoreUp];
    }
}
#pragma mark - NavViewDelegate action
//点击导航标题后的action
- (void)clickBtn:(UIButton *)btn typeModel:(NavTypeTitleModel *)typemodel navView:(NavView *)navView {
    _count = 0;
    //换类型之前，移除上一次的数据
    [self.dataSource removeAllObjects];
    self.typeKey = typemodel.typeLinkID[btn.tag - 101];
    [self requestData:[NSString stringWithFormat:kURL_String, typemodel.typeLinkID[btn.tag - 101], (long)_count] key:self.typeKey];
    [self.tableView reloadData];
}

#pragma mark - method 私有方法

//配置tableView
- (void)configureTableView {
    self.tableView =[[[MainTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped] autorelease];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]] autorelease];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

//自定义导航
- (void)configureNav {    
    //如果存在，则不需要重新创建
    if (!_navView) {
        self.navView = [[[NavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)] autorelease];
    }
    _navView.hidden = NO;
    _navView.delegate = self;
    [self.view addSubview:_navView]; //添加到视图上
}

//配置轮播图
- (void)configureCycleView {
    NSMutableArray *dataArray = [@[] mutableCopy];
    self.cycleView = [[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) animationDuration:2] autorelease];
    
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kURL_CYCLE, 5] success:^(id data) {
        NSArray *tempArr = [data objectForKey:@"headline_ad"];
        for (NSDictionary *dict in tempArr) {
            CycleModel *model = [CycleModel new];
            [model setValuesForKeysWithDictionary:dict];
            if ([model.url containsString:@"|"]) {
                [dataArray addObject:model];
            }
            [model release];
        }
        [self.cycleView setValueWithDataArr:dataArray];
        self.cycleView.TapActionBlock = ^(NSInteger pageIndex){
            CycleModel *model = (CycleModel *)dataArray[pageIndex];
            [self pushImagesDisplayController:model key:1];
        };

    } fail:^{
        
    }];
}
//注册cell
- (void)registerCell {
    [self.tableView registerClass:[CommonCell class] forCellReuseIdentifier:@"common"];
    [self.tableView registerClass:[ThreeImagesCell class] forCellReuseIdentifier:@"images"];
    [self.tableView registerClass:[BigImageCell class] forCellReuseIdentifier:@"bigImage"];
}


- (void)pushImagesDisplayController:(id)model key:(NSInteger)key {
    ImagesDisplayController *imagesController = [[ImagesDisplayController alloc] init];
    if (key == 0) {
        NewsListModel  *nModel = (NewsListModel *)model;
         //接口数据，有的带有 | 符号，在这处理一下
        if ([nModel.skipID containsString:@"|"]) {
            NSArray *IDs = [nModel.skipID componentsSeparatedByString:@"|"];
            if (IDs) {
                nModel.skipID = IDs[1];
                imagesController.skipTypeID = IDs[0];
            }
        }
        imagesController.skipID = nModel.skipID;
    } else  {
        CycleModel *cModel = (CycleModel *)model;
        if ([cModel.url containsString:@"|"]) {
            NSArray *IDs = [cModel.url componentsSeparatedByString:@"|"];
            if (IDs) {
                cModel.url = IDs[1];
                imagesController.skipTypeID = IDs[0];
            }
        }
        imagesController.skipID = cModel.url;
    }
    self.navView.hidden = YES;
    [self setHidesBottomBarWhenPushed:YES]; 
    [self.navigationController pushViewController:imagesController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [imagesController release];

}



#pragma mark - 数据类
//请求数据
- (void)requestData:(NSString *)urlString key:(NSString *)key {
    if ([key isEqualToString: @"T1348647853363"]) {
        urlString = [NSString stringWithFormat:kURL_NEWSLIST, (long)_count];
    }
    [NetworkHelpers JSONDataWithUrl:urlString success:^(id data) {
        if (!_count) {
            [self.dataSource removeAllObjects];
        }
        NSArray *tempArr = [data objectForKey:key];
        for (NSDictionary *dict in tempArr) {
            NewsListModel *model = [NewsListModel new];
            [model setValuesForKeysWithDictionary:dict];
            if (model.imgextra) {
                model.flag = 1; //三张图片cell, //三张图片又是图片集
            }
            if (model.imgType == 1) {
                model.flag = 2; //一张大图cell
            }
            
            //图片集
            if (model.skipID && [model.skipType isEqualToString:@"photoset"]) {
                model.isPhotoset = YES;
            }
            //过滤掉的类别
            if (![model.TAGS isEqualToString:@"LIVE"] && ![model.TAGS isEqualToString:@"画报"] && !(model.editor && ![model.TAGS isEqualToString:@"独家"])) {
                
                if ([NetworkHelpers okPass:model.title]) {
                    [self.dataSource addObject:model];
                }                
            }
            [model release];
        }
        //需要重写加载数据
        [self.tableView reloadData];
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
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _count = 0;
        [self requestData:[NSString stringWithFormat:kURL_String, self.typeKey, (long)_count] key:self.typeKey];
        [self.tableView.header endRefreshing];
    }];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}
- (void)loadMoreUp {
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _count += 20;
        [self requestData:[NSString stringWithFormat:kURL_String, self.typeKey, (long)_count] key:self.typeKey];
    }];
}
#pragma mark lazy Loading
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}


@end
