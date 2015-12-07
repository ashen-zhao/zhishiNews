//
//  ReadListController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "ReadListController.h"
#import "LeftImageCell.h"
#import "LeftOneRightTwoImageCell.h"
#import "NoImageCell.h"
#import "ReadListModel.h"
#import "AFNetworking.h"
#import "CommonMacros.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "CommonNewsDetailsView.h"
#import "NewsDetailsController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "NetworkHelpers.h"

#define kReadAPI @"http://c.3g.163.com/recommend/getSubDocPic?passport=b949a6faa3469bad7e078629c196a3c3@tencent.163.com&devId=9479B6CD-C578-4931-A034-AA16A23E62AC&size=%ld&from=yuedu" //阅读链接

#define kLeftIdentifier @"Left"  //左边一个图
#define kThreeImageIdentifier @"LeftOneRightTwo"   //左1右2
#define kNoIdentifier @"noImage"  //没有图片
#define kUpIdentifier @"Up"                 //上边一个大图
@interface ReadListController ()
@property (nonatomic, assign) NSInteger count;  //动态加载的条数
@property (nonatomic, retain) NSMutableArray *dataSource;  //存储所有阅读界面的readModel

@end

@implementation ReadListController
#pragma mark - lazy loading
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return  [[_dataSource retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 6;
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default"]] autorelease];
    [self configureLeftButton];
    [self requestData];
    [self registerCell];
    [self downRefresh];
    [self upMoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if([self isViewLoaded] && !self.view.window) {
//        //安全移除掉根视图
//        self.view = nil;
//    }
}
//注册4套cell
- (void)registerCell {
    [self.tableView registerClass:[LeftImageCell class] forCellReuseIdentifier:kLeftIdentifier];
    [self.tableView registerClass:[LeftOneRightTwoImageCell class] forCellReuseIdentifier:kThreeImageIdentifier];
    [self.tableView registerClass:[NoImageCell class] forCellReuseIdentifier:kNoIdentifier];
}

//请求数据
- (void)requestData {
   
    
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kReadAPI, (long)_count] success:^(id data) {
        if (_count == 6) {
            if (self.dataSource) {
                [self.dataSource removeAllObjects];
            }
        }
        //用数组接收最外层大字典内key对象的value
        NSArray *results = data[@"推荐"];
        //遍历数组, 将数组中每个元素取出,加入到数组dataSource中
        for (NSDictionary *dic in results) {
            ReadListModel *readNews = [ReadListModel new];
            [readNews setValuesForKeysWithDictionary:dic];
            if (readNews.imgnewextra) {
                readNews.flag = 3;// 标记三个图的cell
            } else if (readNews.imgsrc) {
                readNews.flag = 1; // 标记一个图的cell
            } else {
                readNews.flag = 0;  //标记没有图片的cell
            }
            if ([NetworkHelpers okPass:readNews.title]) {
                [self.dataSource addObject:readNews];
            }

            [readNews release];
        }
        //刷新数据
        [self.tableView reloadData];
    } fail:^{
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"网络不给力呀";
        [mb hide:YES afterDelay:0.5];
    }];
}


- (void)downRefresh {
    [self.tableView addLegendHeaderWithRefreshingBlock:^{  //进入刷新后会自动那个调用这个block
        _count = 6;
        [self requestData];  //请求数据
        [self.tableView.header endRefreshing];
    }];
    [self.tableView.header beginRefreshing];
}

- (void)upMoreData {
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        _count += 6;
        [self requestData];
        [self.tableView.footer endRefreshing];
    }];
    [self.tableView.footer beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.dataSource.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadListModel *readNews = self.dataSource[indexPath.row];
    if (readNews.flag == 1) { //等于1 选择左边一个图的cell
        
        LeftImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftIdentifier forIndexPath:indexPath];
        //赋值
        [cell configureCellWithRead:readNews];
        
        return cell;
    } else if (readNews.flag == 0) {  //选择没有图的cell
        
        NoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoIdentifier forIndexPath:indexPath];
        [cell configureCellWithRead:readNews];
        return cell;
    } else  { //选择三个图片的cell
        
        LeftOneRightTwoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreeImageIdentifier forIndexPath:indexPath];
        [cell configureCellWithRead:readNews];
        return cell;

       
    }
}
#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReadListModel *readNews = self.dataSource[indexPath.row];
   
    if (readNews.flag ==1) {
        return [LeftImageCell heightForRowWithReadNews:readNews];
    } else if (readNews.flag == 3) {
        return [LeftOneRightTwoImageCell heightForRowWithReadNews:readNews];;
    } else {
        return [NoImageCell heightForRowWithReadNews:readNews];
    }
}
//cell选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadListModel *model = self.dataSource[indexPath.row];
    NewsDetailsController *detailsController = [[NewsDetailsController alloc] init];
    detailsController.flag = model.boardid;
    detailsController.docid = model.docid;
    detailsController.newsTitle = model.title;
    [self setHidesBottomBarWhenPushed:YES];//隐藏tabbar
    [self.navigationController pushViewController:detailsController animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
    [detailsController release];
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

- (void)dealloc {
    [_dataSource release];
    [super dealloc];
}

@end
