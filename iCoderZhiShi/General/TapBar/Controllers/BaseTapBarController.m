//
//  BaseTapBarController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "BaseTapBarController.h"
#import "ReadListController.h"
#import "PictureListController.h"
#import "MainListController.h"
#import "VideosController.h"
@interface BaseTapBarController ()

@end

@implementation BaseTapBarController
- (void)dealloc {
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置所有导航条的颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:35 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //设置所有标签栏的颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置导航条字体样式
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self configureTapBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - method
//配置标签项
- (void)configureTapBarItem {
    MainListController *newsController = [[MainListController alloc] init];
    newsController.title = @"知事";
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsController];
    newsNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_news_normal"];
//    newsNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_icon_news_highlight"];
    
    ReadListController *readController = [[ReadListController alloc] initWithStyle:UITableViewStylePlain];
    readController.title = @"随读";
    UINavigationController *readNav = [[UINavigationController alloc] initWithRootViewController:readController];
    readNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_reader_normal"];
//    readNav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_icon_reader_highlight"];
    
    PictureListController *pictureController = [[PictureListController alloc] init];
    pictureController.title = @"流图";
    UINavigationController *pictureNav = [[UINavigationController alloc] initWithRootViewController:pictureController];
    pictureNav.tabBarItem.image = [UIImage imageNamed:@"cell_tag_photo"];
    
    
    VideosController *videoController = [[VideosController alloc] init];
    videoController.title = @"微视";
    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:videoController];
    videoNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_icon_media_normal"];
    
    self.viewControllers = @[newsNav, readNav, pictureNav, videoNav];
    
    [newsNav release];
    [newsController release];
    
    [readNav release];
    [readController release];
    
    [pictureNav release];
    [pictureController release];
    
    [videoNav release];
    [videoController release];
}



@end
