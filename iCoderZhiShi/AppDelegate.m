//
//  AppDelegate.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTapBarController.h"
#import "MineController.h"
#import "AFNetworking.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc {
    [_menuController release];
    [_window release];
    [super dealloc];
}
- (DDMenuController *)menuController {
    if (!_menuController) {
        self.menuController = [[[DDMenuController alloc] init] autorelease];
    }
    return [[_menuController retain] autorelease];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BaseTapBarController *base = [[BaseTapBarController alloc] init];    
    MineController *mineController = [[MineController alloc] init];
    self.menuController.rootViewController = base;
    self.menuController.leftViewController = mineController;
    self.window.rootViewController = self.menuController;
    
    [mineController release];
    [base release];
    [_menuController release];
    //判断网络
    [self judgeNetworking];
    
    //加载分享
    [self shareInteface];
    
    return YES;
}

- (void)judgeNetworking {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (AFNetworkReachabilityStatusNotReachable == status) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络你别走"
                                                            message:@"木牛网络是多么痛的领悟!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"拜拜" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }];

}


//分享代码
- (void)shareInteface {
    [ShareSDK registerApp:@"80b376072348"];
    
    
    //添加新浪微博应用 注册网址 http://open.weibo.com  wdl@pmmq.com 此处需要替换成自己应用的
    [ShareSDK connectSinaWeiboWithAppKey:@"3756541386"
                               appSecret:@"9077d5b01d63d60dab0b70fe1d20fff2"
     
                             redirectUri:@"http://apps.weibo.com/yidutime"];
    
    //此参数为申请的微信AppID wdl@pmmq.com 此处需要替换成自己应用的
        [ShareSDK connectWeChatWithAppId:@"wx4502958faeb3989c" wechatCls:[WXApi class]];
    

}
#pragma mark - WX回调

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
// 
//}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
