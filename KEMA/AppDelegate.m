//
//  AppDelegate.m
//  KEMA
//
//  Created by 张雷 on 2017/6/29.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "AppDelegate.h"
#import "XLNavigationController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"

#import "MMExampleDrawerVisualStateManager.h"

#import "XLTools.h"
#import <SVProgressHUD.h>
#import <WXApi.h>

#define KWXAPPKEY @"wx7cfb1fcc3ed552cd"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController *v = [[HomeViewController alloc] init];
    XLNavigationController *cnav = [[XLNavigationController alloc] initWithRootViewController:v];
    
    LeftViewController *l = [[LeftViewController alloc] init];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:cnav leftDrawerViewController:l];
    
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:450/2.f];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        
        [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];

        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
    self.window.rootViewController = self.drawerController;
    
    [self.window makeKeyAndVisible];
    
    [XLDebug Debug];
    
    
    //// ******* SVHUD
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:KGRAY(53)];
    [SVProgressHUD setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15]];
    [SVProgressHUD setBackgroundColor:[KWHITECOLOR colorWithAlphaComponent:0.9]];
    
    
    // 网络控制
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    BOOL res = [WXApi registerApp:KWXAPPKEY];
    DLog(@"registWX:%d",res);
    
    return YES;
}

#pragma mark - OPENURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    // 从微信跳回来
    return [WXApi handleOpenURL:url delegate:self];
}
-(void) onReq:(BaseReq*)req{
    DLog(@"[WXreq]:%@",req);
}
-(void) onResp:(BaseResp*)resp{
    if (resp.errCode == -2) {
        // 取消分享
        [SVProgressHUD showInfoWithStatus:@"您取消了分享"];
    }else if (resp.errCode == 0){
        // 分享成功
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    }
    
    DLog(@"[WXresp]:%@",resp);
    // 从微信跳回来
}

#pragma mark - <私有方法>

/// TODO: 开机检查未完成任务  看来不需要了
- (void)checkUnFinishedLoadTask{
    id list = [[NSUserDefaults standardUserDefaults] objectForKey:KUnFinishedLoadTaskListKey];
    if ([list isKindOfClass:[NSArray class]]) {
    }
}

#pragma mark - ## 本地手机服务器

#pragma mark # 搭建本地服务器

- (void)configLocalHttpServer{
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http.tcp"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //DLog(@"%@",webPath);
    
    
    if (![fileManager fileExistsAtPath:webPath]){
        DLog(@">>>>File path error!");
    }else{
        NSString *webLocalPath = webPath;
        [_localHttpServer setDocumentRoot:webLocalPath];
        //DLog(@"webLocalPath:%@",webLocalPath);
        [self startServer];
    }
}
- (void)startServer
{
    
    NSError *error;
    BOOL suc = [_localHttpServer start:&error];
    if(suc){
        DLog(@">>>>Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
        self.port = [NSString stringWithFormat:@"%hu",[_localHttpServer listeningPort]];
    }
    else{
        DLog(@">>>>Error starting HTTP Server: %@", error);
        [MBProgressHUD showError:@"本地服务器启动失败" toView:[XLTools CurrentViewController].view];
    }
}
- (void)stopServer{
    [_localHttpServer stop];
    DLog(@">>>stop Server");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
