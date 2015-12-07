//
//  MineController.m
//  UI-19-QiuBaiDemo
//
//  Created by lanouhn on 15/5/19.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "MineController.h"
#import "MineCell.h"
#import "MineModel.h"
#import "HeaderCell.h"
#import "FavoriteController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "MainListController.h"
#import "BaseTapBarController.h"
#import "CommonMacros.h"
#import "UIImageView+WebCache.h"
#import "SuggestController.h"
#import "MBProgressHUD.h"

@interface MineController ()<UITableViewDelegate, UITableViewDataSource> {
    CGFloat tmpSize;
}
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) UITableView *tableView;
@end

@implementation MineController
//记录选中的cell
static NSInteger stateCell;
- (void)dealloc {
    [_dataSource release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    frame.origin.y = (kScreenHeight - (50 * 6 + 40)) / 2;
    self.tableView.frame = frame;
    tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    stateCell = 1;
   
    self.view.backgroundColor = [UIColor colorWithRed:45 / 255.0 green:30 / 255.0 blue:76 / 255.0 alpha:1.0];
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - (50 * 6 + 60)) / 2, kScreenWidth, kScreenHeight) style:UITableViewStylePlain] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView  registerClass:[MineCell class] forCellReuseIdentifier:@"mine"];
     [self.tableView  registerClass:[HeaderCell class] forCellReuseIdentifier:@"header"];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self readDataByPlist];
    [self clipExtraCellLine];
}


- (void)readDataByPlist {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyselfList" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
        self.dataSource = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            MineModel *model = [MineModel mineModelWithDic:dic];
            [self.dataSource addObject:model];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:stateCell inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    if (indexPath.row == 0) {
        tableView.rowHeight = 60;
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        tableView.rowHeight = 50;
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mine" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell configureWithMineModel:self.dataSource[indexPath.row]];       
        if (indexPath.row == 3) {
            cell.lblCacheSize.text = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
            [cell addSubview:cell.lblCacheSize];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    stateCell = indexPath.row;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    BaseTapBarController *tab = [[[BaseTapBarController alloc] init] autorelease];
    [tab configureTapBarItem];
    UINavigationController *nav = nil;
    switch (indexPath.row) {
        case 0:
        case 1: {
            MainListController *fController = [[MainListController alloc] init];
            [self.navigationController pushViewController:fController animated:YES];
            [fController release];
            [menuC setRootController:tab animated:YES];
            break;
        }
        case 2: {
            FavoriteController *fController = [[FavoriteController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:fController];
            [self.navigationController pushViewController:fController animated:YES];
            [menuC setRootController:nav animated:YES];
            [fController release];
            [nav release];
            break;
        }
        case 3:
            [self clearCache];
            break;
        case 4: {
            SuggestController *sController = [[SuggestController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:sController];
            [menuC setRootController:nav animated:YES];
            [sController release];
            [nav release];
          break;
        }
        case 5: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"免责声明" message:@"本APP旨在技术分享，不涉及任何商业利益。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            break;
        }
        case 6: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于我们" message:@"我们是iCoder团队，专注开发iOS应用\n团队成员：赵阿申、吉冠坤、吕慧鹏\n邮   箱：zhaoashen@gmail.com" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            break;
        }
        default:

            break;
    }
  
    
}

#pragma mark -method
//清楚缓存
- (void)clearCache {
    
    if (tmpSize <= 0.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂无缓存" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真的要清除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [[[MBProgressHUD alloc] init] autorelease];
        [self.view addSubview:hud];
        //加载条上显示文本
        hud.labelText = @"急速清理中";
        //置当前的view为灰度
        hud.dimBackground = YES;
        //设置对话框样式
        hud.mode = MBProgressHUDModeDeterminate;
        [hud showAnimated:YES whileExecutingBlock:^{
            while (hud.progress < 1.0) {
                hud.progress += 0.01;
                [NSThread sleepForTimeInterval:0.02];
            }
            hud.labelText = @"清理完成";
        } completionBlock:^{
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            tmpSize = 0.0;
            [self.tableView reloadData];
            [hud removeFromSuperview];
        }];

       
    }
}
#pragma mark - 去处多余的分割线
- (void)clipExtraCellLine {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footerView;
    [footerView release];
}
@end
