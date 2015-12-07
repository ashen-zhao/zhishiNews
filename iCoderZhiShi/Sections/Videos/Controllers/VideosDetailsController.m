//
//  VideosDetailsController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/20.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "VideosDetailsController.h"
#import "NetworkHelpers.h"
#import "VideosCommentModel.h"
#import "VideosCell.h"
#import "VideoCommentCell.h"
#import "MJRefresh.h"
#import "FavoriteModel.h"
#import "MBProgressHUD.h"
#import "DBHelper.h"

#define kURL_Comment @"http://api.budejie.com/api/api_open.php?a=dataList&c=comment&data_id=%ld&page=1&per=%ld"

@interface VideosDetailsController ()<UIActionSheetDelegate> {
    NSInteger _count;
    NSInteger _total; //总的评论数
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) VideosCell *tempCell;
@property (nonatomic, retain) VideosCell *tempCurrentCell;
@end

@implementation VideosDetailsController


- (void)dealloc {
    [_tempCurrentCell release];
    [_tempCell release];
    [_dataSource release];
    [_model release];
    [super dealloc];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tempCurrentCell.player stop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 20;
    [self readVideoComment];
    self.navigationItem.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 1 : self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *iden = @"vidoes";
        VideosCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[[VideosCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden] autorelease];
        }
  
        
        VideosModel *model = self.model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        
        cell.btnMoreBlock = ^(VideosCell *c) {
            self.tempCell = c;
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"分享", nil];
            [sheet showInView:self.view];
            [sheet release];
        };
        
        cell.TapBlock = ^(VideosCell *vc) {
            self.tempCurrentCell = vc;
        };
        return cell;
    } else  {
        static NSString *iden2 = @"vcomment";
        VideoCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[[VideoCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden2] autorelease];
        }
        VideosCommentModel *model = self.dataSource[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VideosModel *model =  self.model;
        return [VideosCell heightCell:model];
    } else {
        VideosCommentModel *model = self.dataSource[indexPath.row];
        return [VideoCommentCell heightCell:model];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataSource.count - 1) {
        
        [self.tableView addLegendFooterWithRefreshingBlock:^{
            _count += 20;
            
            [self readVideoComment];
            if (_count >= _total) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView.footer noticeNoMoreData];
                });
            }
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"" : @"最新评论";
}
#pragma sheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self saveFavorite];
    } else if (buttonIndex == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"暂不支持视频分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
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
    
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
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
    [hud release];
    [fmodel release];
}
#pragma mark - 数据类
- (void)readVideoComment {
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kURL_Comment, (long)self.model.ID, (long)_count] success:^(id data) {
        if (self.dataSource) {
            [self.dataSource removeAllObjects];
        }
        NSArray *dataArr = data[@"data"];
        _total = [data[@"total"] integerValue];
        for (NSDictionary *dict in dataArr) {
            VideosCommentModel *model = [[VideosCommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataSource addObject:model];
            [model release];
        }
        [self.tableView reloadData];

    } fail:^{
        
    }];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain] autorelease];
}

@end
