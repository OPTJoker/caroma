//
//  XLWKWebView.h
//  iUnis
//
//  Created by 张雷 on 16/9/17.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <WebKit/WebKit.h>
#define KLOCALHTTP @"http://localhost:"


@interface XLWKWebView : WKWebView
//@interface XLWKWebView : UIWebView
@property(nonatomic, copy) NSString *urlStr;

@property(nonatomic, copy) NSString *htmlPath;
/**
 重启服务器
 */
//- (void)reStartServer;
- (void)stopServer; //关闭服务器


@end
