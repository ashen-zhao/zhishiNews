//
//  CommentController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/9.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "CommentController.h"
#import "CommentView.h"
#import "CommentCell.h"
#import "CommentModel.h"
#import "NetworkHelpers.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "DDMenuController.h"

#define kURLHot @"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/%ld/10/10/2/2"
#define kURLNew  @"http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/%ld/10/10/2/2"

@interface CommentController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _count;
}
@property (nonatomic, retain) CommentView *commentView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@end

@implementation CommentController

- (void)dealloc {
    [_docid release];
    [_flag release];
    [_dataSource release];
    [_commentView release];
    [super dealloc];
}

- (void)loadView {
    self.commentView = [[[CommentView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _commentView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavView];
    [self readDataByURL];
    _commentView.tableView.delegate = self;
    _commentView.tableView.dataSource = self;
    [_commentView.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"comment"];
    [self refreshDown];
    [self loadMoreUp];
    self.navigationController.automaticallyAdjustsScrollViewInsets  = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if([self isViewLoaded] && !self.view.window) {
//        //安全移除掉根视图
//        self.view = nil;
//    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
    //去掉cell的点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommentModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *model = self.dataSource[indexPath.row];
    return [CommentCell heightForRowWithDic:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - 视图配置
//配置导航栏
- (void)configureNavView {
    //将导航条显示出来
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个性评论区";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(handleLeft:)];
    self.navigationItem.leftBarButtonItem = leftItem;

}

#pragma mark - 数据配置
- (void)readDataByURL{    
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kURLNew,self.flag, self.docid, (long)_count] success:^(id data) {
        if (!_count) {
            [self.dataSource removeAllObjects];
        }
        NSMutableArray *dataArr = data[@"newPosts"];
        
        if (![dataArr isKindOfClass:[NSNull class]]) {
            for (NSDictionary *bigDict in dataArr) {
                NSDictionary *dict = bigDict[@"1"];
                CommentModel *model =[CommentModel new];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:model];
                [model release];
            }
            [_commentView.tableView reloadData];
        }
    } fail:^{
        
    }];
}

//下拉刷新
- (void)refreshDown {
    // 添加传统的下拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [_commentView.tableView addLegendHeaderWithRefreshingBlock:^{
        _count = 0;
        [self readDataByURL];
        [_commentView.tableView.header endRefreshing];
    }];
    // 马上进入刷新状态
    [_commentView.tableView.header beginRefreshing];
}
- (void)loadMoreUp {
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [_commentView.tableView addLegendFooterWithRefreshingBlock:^{
        _count += 11;
        [self readDataByURL];
        [_commentView.tableView.footer endRefreshing];
    }];
    
}
#pragma mark - action

//点击返回按钮
- (void)handleLeft:(UIBarButtonItem *)item {
    if ([self.flag isEqualToString:@"photoview_bbs"]) {
        self.navigationController.navigationBarHidden = YES; //判断是不是ImagesDisplayController push过来的，如果是，pop之前将导航条隐藏
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}

@end
