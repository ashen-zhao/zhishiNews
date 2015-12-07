//
//  NewsDetailsController.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/5.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NewsDetailsController.h"
#import "CommonNewsDetailsView.h"
#import "CommonMacros.h"
#import "NetworkHelpers.h"
#import "NewsDetailsModel.h"
#import "CommentController.h"
#import "DBHelper.h"
#import "FavoriteModel.h"
#import "MBProgressHUD.h"
#import  <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "DDMenuController.h"

#define kUrlNewsDetails @"http://c.3g.163.com/nc/article/%@/full.html"


@interface NewsDetailsController ()
@property (nonatomic, retain) CommonNewsDetailsView *rootView;
@end

@implementation NewsDetailsController
- (void)dealloc {
    [_url_3w release];
    [_flag release];
    [_newsTitle release];
    [_docid release];
    [_rootView release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    self.rootView = [[[CommonNewsDetailsView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _rootView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DDMenuController *menuC  = delegate.menuController;
    [menuC setEnableGesture:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self configureNavView];
    [self requestDetails];
    [_rootView.btnComment addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rootView.btnSave addTarget:self action:@selector(handleSave:) forControlEvents:UIControlEventTouchUpInside];
     [_rootView.btnShare addTarget:self action:@selector(handleShare:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    if([self isViewLoaded] && !self.view.window) {
//        //安全移除掉根视图
//        self.view = nil;
//    }

}


#pragma mark - 私有方法
//请求数据
- (void)requestDetails {
    [NetworkHelpers JSONDataWithUrl:[NSString stringWithFormat:kUrlNewsDetails, self.docid] success:^(id data) {
        NSDictionary *dataDict = [data objectForKey:self.docid];
        NewsDetailsModel *model= [NewsDetailsModel new];
        [model setValuesForKeysWithDictionary:dataDict];
        _rootView.model = model;
        [model release];
    } fail:^{
        
    }];
}

//配置导航栏
- (void)configureNavView { 
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(handleLeft:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = self.newsTitle;
    [self.tabBarController removeFromParentViewController];
  
}

#pragma mark - action

//点击返回按钮
- (void)handleLeft:(UIBarButtonItem *)item {
    //将tabbar显示出来
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//点击评论按钮
- (void)handleClick:(UIButton *)sender {
    CommentController *commentController = [[CommentController alloc] init];
    commentController.docid = self.docid;
    commentController.flag = self.flag; //评论标识
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentController animated:YES];
    [commentController release];
}
//点击收藏按钮
- (void)handleSave:(UIButton *)sender {    
    FavoriteModel *fmodel = [[FavoriteModel alloc] init];
    fmodel.ftitle = self.newsTitle;
    fmodel.furl = [NSString stringWithFormat:kUrlNewsDetails, self.docid];
    fmodel.fdocid = self.docid;
    fmodel.fboardid = self.flag;
    fmodel.flag = @"NEWS";
    MBProgressHUD *hud= [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    if ([DBHelper insertData:fmodel]) {
        //加载条上显示文本
        hud.labelText = @"收藏成功";
    } else {
          hud.labelText =  [fmodel.ftitle isEqualToString:@""] || !fmodel.ftitle ? @"加载完成才能收藏哦？" : @"已经收藏";
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
//分享
- (void)handleShare:(UIButton *)sender {
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content: self.newsTitle
                                       defaultContent:@"有事没事，点一下"
                                                image:nil
                                                title:@"pmmq"
                                                  url:self.url_3w
                                          description:@"知事在线，有事没事，逛一下"
                                            mediaType:SSPublishContentMediaTypeNews];
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                MBProgressHUD *hud= [[MBProgressHUD alloc] init];
                                [self.view addSubview:hud];
                                if (state == SSResponseStateSuccess)
                                {
                                    hud.labelText = @"分享成功";
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    hud.labelText = @"分享失败";
                                }
                                hud.mode = MBProgressHUDModeText;
                                [hud showAnimated:YES whileExecutingBlock:^{
                                    sleep(1);
                                } completionBlock:^{
                                    [hud removeFromSuperview];
                                }];
                                [hud release];
                            }];
}
@end
