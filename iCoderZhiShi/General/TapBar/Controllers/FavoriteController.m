//
//  FavoriteController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/11.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "FavoriteController.h"
#import "AppDelegate.h"
#import "FavoriteView.h"
#import "FavoriteModel.h"
#import "DBHelper.h"
#import "NewsDetailsController.h"
#import "ImagesDisplayController.h"
#import "CommonMacros.h"
#import "FavoriteCell.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "VideosDetailsController.h"
#import "VideosModel.h"


@interface FavoriteController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) FavoriteView *rootView;
@property (nonatomic, retain) NSMutableArray *dataSource;
@end

@implementation FavoriteController

- (void)dealloc {
    [_rootView release];
    [super dealloc];
}
- (void)loadView {
    self.rootView = [[[FavoriteView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _rootView;
}

//在视图将要出现的时候，将平移手势去掉
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_rootView.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    [self configureLeftButton];
    [self readDataByDB];
    _rootView.tableView.dataSource = self;
    _rootView.tableView.delegate = self;
    [_rootView.tableView registerClass:[FavoriteCell class] forCellReuseIdentifier:@"favorite"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorite" forIndexPath:indexPath];
    FavoriteModel *model = self.dataSource[indexPath.row];
    
 
    if ([model.flag  isEqualToString:@"NEWS"]) {
        cell.lblTag.text = @"【文】";
        cell.lblTag.textColor = [UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0];
    } else if ([model.flag isEqualToString:@"VIDEOS"]) {
        cell.lblTag.text = @"【视】";
        cell.lblTag.textColor = [UIColor greenColor];
    } else {
        cell.lblTag.text = @"【图】";
        cell.lblTag.textColor = [UIColor redColor];
    }
    cell.lblTitle.text = model.ftitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

//提交编辑操作， 处理点击删除按钮之后的事件。
//删除收藏
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除对应的单元格的数据
    FavoriteModel *model = self.dataSource[indexPath.row];
    [DBHelper deleteData:model.fid];
    [self.dataSource removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
//修改cell默认删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath :( NSIndexPath *)indexPath{
    return @"删除";
}
//选中后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavoriteModel *model = self.dataSource[indexPath.row];
    if ([model.flag  isEqualToString:@"NEWS"]) {
        NewsDetailsController *newsDetailsController= [[NewsDetailsController alloc] init];
        newsDetailsController.docid = model.fdocid;
        newsDetailsController.newsTitle = model.ftitle;
        newsDetailsController.flag = model.fboardid;
        [self.navigationController pushViewController:newsDetailsController animated:YES];
        [newsDetailsController release];
    } else if ([model.flag isEqualToString:@"VIDEOS"]) {
        VideosDetailsController *vdc = [[VideosDetailsController alloc] init];
        VideosModel *vmodel = [[VideosModel alloc] init];
        vmodel.text = model.ftitle;
        vmodel.videouri = model.furl;

        NSArray  *temp = [model.fboardid componentsSeparatedByString:@"@$%"];
        vmodel.image_small = temp[0];
        vmodel.width = temp[1];
        vmodel.height = temp[2];
        vmodel.name = temp[3];
        vmodel.profile_image = temp[4];
        vmodel.videotime = temp[5];
        vmodel.playcount = temp[6];
        vmodel.ID = [temp[7] integerValue];
        
        vdc.model = vmodel;
        
        [self.navigationController pushViewController:vdc animated:YES];
        
        [vmodel release];
        [vdc release];
    } else {
        ImagesDisplayController *imageController = [[ImagesDisplayController alloc] init];
        imageController.skipID = model.fdocid;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:imageController animated:YES];
        [imageController release];
    }
    
  
}

#pragma mark - 界面配置类
- (void)configureLeftButton {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr_toolbar_more_hl"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
}

#pragma  mark - 数据类
- (void)readDataByDB {
    self.dataSource = [DBHelper getListData];
}



#pragma mark -action

- (void)handleBack:(UIBarButtonItem *)item {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC showLeftController:YES];
}


#pragma  mark - lazying load
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}

@end
