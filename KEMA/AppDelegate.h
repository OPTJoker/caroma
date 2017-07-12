//
//  AppDelegate.h
//  KEMA
//
//  Created by 张雷 on 2017/6/29.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTTPServer.h>

#import <MMDrawerController.h>

#import <AFURLSessionManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - # 本地CocoaHttpServer服务器
@property (nonatomic, strong) HTTPServer *localHttpServer;
@property (nonatomic, copy) NSString *port;

- (void)configLocalHttpServer;
- (void)stopServer;

#pragma mark - # 抽屉

@property (nonatomic,strong) MMDrawerController * drawerController;

#pragma mark - ||下载相关

@end

