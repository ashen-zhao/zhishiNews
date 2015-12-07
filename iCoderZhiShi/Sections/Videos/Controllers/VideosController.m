//
//  VideosController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/16.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideosController.h"
#import "CommonMacros.h"
#import "NetworkHelpers.h"
#include "VideosModel.h"
#import "VideosCell.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "AFNetworking.h"
#import "NSTimer+Control.h"
#import "VideosDetailsController.h"
#import "DBHelper.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD.h"
#import "FavoriteModel.h"

#define kURL_Video @"http://api.budejie.com/api/api_open.php?a=list&c=video&page=0&per=%ld"

@interface VideosController ()<UIActionSheetDelegate> {
    NSInteger index;
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) VideosCell *tempCell;
@property (nonatomic, retain) VideosCell *tempCurrentCell;
@property (nonatomic, retain) NSIndexPath *selectIndexPath;
@end

@implementation VideosController

- (void)dealloc {
    [_selectIndexPath release];
    [_tempCurrentCell release];
    [_tempCell release];
    [_dataSource release];
    [super dealloc];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tempCurrentCell.player pause];
    self.tempCurrentCell.btnState.hidden = NO;
    //    [self.tableView reloadData]; //让剩余时间复位
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLeftButton];
    [self readVidesData];
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        index = 20;
        [self readVidesData];
        [self.tableView.header endRefreshing];
    }];
    [self.tableView.header beginRefreshing];
    
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        index += 20;
        [self readVidesData];
        [self.tableView.footer endRefreshing];
    }];
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
    static NSString *iden = @"vidoes";
    VideosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videos"];
    if (!cell) {
        cell = [[[VideosCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden] autorelease];
    }
    else {
        //貌似没执行
        //解决cell重叠的问题
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    VideosModel *model = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.btnMoreBlock = ^(VideosCell *c) {
        self.tempCell = c;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", nil];
        [sheet showInView:self.view];
        [sheet release];
    };
    
    cell.TapBlock = ^(VideosCell *vc) {
        //上一个播放的
        if (self.tempCurrentCell) {
            self.tempCurrentCell.btnState.hidden = NO;
        }
        self.tempCurrentCell = vc;
        self.selectIndexPath = indexPath;
    };
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideosDetailsController *vdc = [[VideosDetailsController alloc] init];
    vdc.model = self.dataSource[indexPath.row];
    [self.tempCurrentCell.player pause];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vdc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    [vdc release];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideosModel *model = self.dataSource[indexPath.row];
    return [VideosCell heightCell:model];
}

#pragma sheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self saveFavorite];
    }
//    } else if (buttonIndex == 1) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂不支持视频分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
    else if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
}

//停掉不在可视范围内的视频
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //判断是否有播放的视频
    if (self.tempCurrentCell) {
        if ([self.tempCurrentCell.player isPreparedToPlay]) {
            VideosModel *model = self.dataSource[self.selectIndexPath.row];
            CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.selectIndexPath];
            CGRect rectInWindow = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
            //判断是否超出屏幕范围
            if (rectInWindow.origin.y <= -[VideosCell heightCell:model] || rectInWindow.origin.y >=  kScreenHeight) {
                [self.tempCurrentCell.player stop];
            }
        }
    }
}
#pragma mark - 收藏
- (void)saveFavorite {
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.tempCell.model.text;
    fmodel.flag = @"VIDEOS";
    fmodel.furl = self.tempCell.model.videouri;
    
    //存假值，用的时候，在取出来
    NSMutableArray *array = [NSMutableArray arrayWithObjects:self.tempCell.model.image_small, self.tempCell.model.width, self.tempCell.model.height, self.tempCell.model.name, self.tempCell.model.profile_image, self.tempCell.model.videotime, self.tempCell.model.playcount, @(self.tempCell.model.ID) , nil];
    fmodel.fboardid = [array componentsJoinedByString:@"@$%"];
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([DBHelper insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
        hud.labelText = @"已经收藏";
    }
    //置当前的view为灰度
    hud.dimBackground = YES;
    //设置对话框样式
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
    [fmodel release];
}
#pragma mark - 数据类
//读取数据

- (void)readVidesData {
    
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kURL_Video, (long)index] success:^(id data) {
        if (self.dataSource) {
            [self.dataSource removeAllObjects];
        }
        NSArray *arr = data[@"list"];
        for (NSDictionary *dict in arr) {
            VideosModel *model = [VideosModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataSource addObject:model];
            [model release];
        }
        //刷新数据之前，把正在播放的视频停掉
        if (self.tempCurrentCell) {
            [self.tempCurrentCell.player stop];
        }
        [self.tableView reloadData];

    } fail:^{
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"网络不给力呀";
        [mb hide:YES afterDelay:0.5];
    }];
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
