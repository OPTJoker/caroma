//
//  XLWKWebView.m
//  iUnis
//
//  Created by 张雷 on 16/9/17.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLWKWebView.h"
#import "Control.h"
//#import <SVProgressHUD.h>
#import "AppDelegate.h"
#import <Masonry.h>

const float LoacalWebVTimeOut = 6;

@interface XLWKWebView()
<
WKNavigationDelegate
//UIWebViewDelegate
>
{
    UIProgressView *progressV;
    NSTimer *timer;
    CGFloat timerCount;
}
@end

@implementation XLWKWebView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        //self.layer.masksToBounds = NO;
        self.navigationDelegate = self;
        self.backgroundColor = KTOPICCOLOR;
        
        AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd configLocalHttpServer];
        
        //[self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KLOCALHTTP,appd.port]]]];
        [self addProgressView];
    }
    return self;
}



- (void)addProgressView{
    progressV = [[UIProgressView alloc] init];
    progressV.translatesAutoresizingMaskIntoConstraints = NO;
    progressV.backgroundColor = self.scrollView.backgroundColor;
    progressV.layer.zPosition = 100;
    progressV.progressTintColor = KWECHATGREEN;
    
    [self addSubview:progressV];
    
    NSString *Hvfl = @"H:|[progressV]|";
    NSString *Vvfl = @"V:|-0-[progressV(2)]";
    
    
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(progressV);
    
    NSArray *Hconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Hvfl options:0 metrics:nil views:viewDic];
    NSArray *Vconstraints = [NSLayoutConstraint constraintsWithVisualFormat:Vvfl options:0 metrics:nil views:viewDic];
    
    [self addConstraints:Hconstraints];
    [self addConstraints:Vconstraints];
    
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float newProgress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        //[progressV setProgress:self.estimatedProgress animated:YES];
        if (newProgress == 1.0) {
            progressV.hidden = YES;
            [progressV setProgress:0 animated:NO];
        }else{
            progressV.hidden = NO;
            [progressV setProgress:newProgress animated:YES];
        }
    }
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}



- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"web start!");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DLog(@"Web load Finished");
    
    // ### 本地playcanvas包 ###
//    if ([_urlStr hasPrefix:KLOCALHTTP]) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            __block BOOL rst;
//            [self evaluateJavaScript:@"gbl.isLoaded" completionHandler:^(id res, NSError * _Nullable error) {
//                rst = [res boolValue];
//                if (rst) {
//                    return ;
//                }else{
//                    if (!timer){
//                        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runloop) userInfo:nil repeats:YES];
//                        timerCount = 0.;
//                        [timer fire];
//                    }
//                }
//            }];
//        });
//        
//    }
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    DLog(@"web faild!\n%@",error);
    if ([_urlStr hasPrefix:KLOCALHTTP]) {
        [MBProgressHUD showError:@"模型加载失败" toView:self];
    }
}

#pragma mark - 服务器
- (void)stopServer{
    
    [timer invalidate];
    
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appd stopServer];
}
//- (void)reStartServer{
//    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appd.localHttpServer stop];
//    NSError *error;
//    BOOL suc = [appd.localHttpServer start:&error];
//    if(suc){
//        DLog(@"Started HTTP Server on port %hu", [appd.localHttpServer listeningPort]);
//        appd.port = [NSString stringWithFormat:@"%d",[appd.localHttpServer listeningPort]];
//        [MBProgressHUD hideAllHUDsForView:self animated:NO];
//        [MBProgressHUD showSuccess:@"模型重加载成功, 刷新项目中..." toView:self];
//        if ([_urlStr hasPrefix:KLOCALHTTP]) {
//            self.urlStr = [NSString stringWithFormat:@"%@%@",KLOCALHTTP,appd.port];
////            if (!timer)
////                timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runloop) userInfo:nil repeats:YES];
////            timerCount = 0.;
////            [timer fire];
//        }
//    }else{
//        DLog(@"Error starting HTTP Server: %@", error);
//        [MBProgressHUD hideAllHUDsForView:self animated:NO];
//        [MBProgressHUD showError:@"模型重加载失败" toView:self];
//    }
//}

///**
// 轮询监测项目是否加载完成
// */
- (void)runloop{
    timerCount += timer.timeInterval;
    if (timerCount>=LoacalWebVTimeOut) {
        [MBProgressHUD hideAllHUDsForView:self animated:NO];
        [MBProgressHUD showError:@"项目加载失败! 请退出重试" toView:self];
        
        [timer invalidate];
        timer = nil;

        return;
    }
    
    if (timer) {
        __block BOOL rst;
        [self evaluateJavaScript:@"gbl.isLoaded" completionHandler:^(id res, NSError * _Nullable error) {
            rst = [res boolValue];
            if (rst) {
                [timer invalidate];
                timer = nil;
            }
        }];
    }
}


- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self reload];
}

- (void)setHtmlPath:(NSString *)htmlPath{
    _htmlPath = htmlPath;
    
    if(_htmlPath){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.f) {
            // iOS9. One year later things are OK.
            NSURL *fileURL = [NSURL fileURLWithPath:_htmlPath];
            [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            // iOS8. Things can be workaround-ed
            //   Brave people can do just this
            //   fileURL = try! pathForBuggyWKWebView8(fileURL)
            //   webView.loadRequest(NSURLRequest(URL: fileURL))
            
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:_htmlPath]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self loadRequest:request];
        }
    }else{
        [MBProgressHUD showError:@"协议文件读取失败" toView:self];
    }
}


//将文件copy到tmp目录
- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    NSString *temURLDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
    
    NSURL *temDirURL = [NSURL URLWithString:temURLDir];
    
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}



/*
- (void)stopServer{
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appd.localHttpServer stop];
}
 */


@end
