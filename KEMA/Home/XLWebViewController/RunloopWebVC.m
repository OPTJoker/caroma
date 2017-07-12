//
//  RunloopWebVC.m
//  iFactory
//
//  Created by 张雷 on 2017/5/31.
//  Copyright © 2017年 ImanZhang. All rights reserved.
//

#import "RunloopWebVC.h"
#import "XLWKWebView.h"
#import <SSZipArchive.h>
#import "AppDelegate.h"

@interface WKNavigationBar : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UILabel *titleLab;
@end

@implementation WKNavigationBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = KWHITECOLOR;
    }
    return self;
}
- (UILabel *)titleLab{
    if (nil == _titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _titleLab.textColor = KWHITECOLOR;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).mas_offset(20/2);
        }];
    }
    return _titleLab;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    
    [self.titleLab setText:_title];
}

@end

#pragma mark - Nav结束 WKWeb开始 -




@interface RunloopWebVC ()
<SSZipArchiveDelegate>
{
    
}
@property(nonatomic, strong) WKNavigationBar *navgationBar;
@property(nonatomic, strong) UIButton *backItemBtn;
@property(nonatomic, strong) XLWKWebView *webV;
@property(nonatomic, strong) UIProgressView *progressV;
@property(nonatomic, strong) UILabel *progressLab;
@property(nonatomic, strong) UILabel *msgLab;

@end

@implementation RunloopWebVC

#pragma mark - <懒加载>
- (UIView *)navgationBar{
    if (nil == _navgationBar) {
        _navgationBar = [[WKNavigationBar alloc] init];
        [self.view addSubview:_navgationBar];
        [_navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(64);
        }];
    }
    return _navgationBar;
}

- (XLWKWebView *)webV{
    if (nil== _webV) {
        _webV = [[XLWKWebView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 1)];
        [self.view addSubview:_webV];
        [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _webV;
}

- (UIProgressView *)progressV{
    if (nil == _progressV) {
        _progressV = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.webV addSubview:_progressV];
        _progressV.tintColor = KWECHATGREEN;
        _progressV.trackTintColor = KGRAY(247);
        [_progressV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.webV);
            make.centerY.equalTo(self.webV);
            make.width.equalTo(self.webV).multipliedBy(0.7);
            make.height.mas_equalTo(10);
        }];
    }
    return _progressV;
}

- (UILabel *)progressLab{
    if (nil == _progressLab) {
        _progressLab = [UILabel new];
        _progressLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _progressLab.textColor = KGRAYCOLOR;
        _progressLab.textAlignment = NSTextAlignmentCenter;
        [self.webV addSubview:_progressLab];
        [_progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.webV);
            make.bottom.equalTo(self.progressV.mas_top).mas_offset(-4);
        }];
    }
    return _progressLab;
}
- (UILabel *)msgLab{
    if (nil == _msgLab) {
        _msgLab = [UILabel new];
        _msgLab.text = @"正在解压模型文件，加载过程中不消耗流量";
        _msgLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _msgLab.textColor = KGRAYCOLOR;
        _msgLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_msgLab];
        [_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.webV);
            make.bottom.equalTo(self.progressLab.mas_top).mas_offset(-6);
        }];
    }
    return _msgLab;
}

- (UIButton *)backItemBtn{
    if (nil == _backItemBtn) {
        _backItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backItemBtn setTitle:@"" forState:UIControlStateNormal];
        UIImage *img = [UIImage imageNamed:@"back_white.png"];
        [_backItemBtn setImage:img forState:UIControlStateNormal];
        double vsp = (44-img.size.height)/2;
        double hsp = ((44-img.size.width)/2);

        [_backItemBtn setImageEdgeInsets:UIEdgeInsetsMake(vsp, hsp, vsp, hsp)];
        [_backItemBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navgationBar addSubview:_backItemBtn];
    }
    return _backItemBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webV.backgroundColor = KTOPICCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.navgationBar.backgroundColor = KTOPICCOLOR;
    [self.navgationBar setTitle:@"科马"];
    [self.backItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navgationBar).mas_offset(0);
        make.top.equalTo(self.navgationBar).mas_offset(20);
        make.size.with.mas_equalTo(44);
        make.size.height.mas_equalTo(44);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)setWebUrl:(NSString *)webUrl{
    _webUrl = webUrl;
    self.webV.urlStr = _webUrl;
}


- (void)playWithCatID:(NSString *)catID itemID:(NSString *)itemID{
    
    [[NSFileManager defaultManager] removeItemAtPath:KLOCALWEBDIR error:nil];
    
    NSString *unzipPath = [[XLTools KWebGLItemZipPathWithCatID:catID itemID:itemID] stringByAppendingPathComponent:@"zoom.zip"];
    NSString *destPath = KLOCALWEBDIR;
    
    //[MBProgressHUD showMessage:@"模型加载中" toView:self.webV];
    
    NSError *error;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL res = [SSZipArchive unzipFileAtPath:unzipPath toDestination:destPath overwrite:YES password:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            float p = 1.f*entryNumber/total;
            //DLog(@"progress:%.0f",p);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressV.hidden = NO;
                self.progressLab.hidden = self.progressV.hidden;
                self.msgLab.hidden = self.progressV.hidden;
                [self.progressV setProgress:p];
                self.progressLab.text = [NSString stringWithFormat:@"%.1f%%",p*100.f];
            });
            
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressV.hidden = YES;
                self.progressLab.hidden = self.progressV.hidden;
                self.msgLab.hidden = self.progressV.hidden;
                //[MBProgressHUD hideHUDForView:self.webV animated:YES];
                [self loadWebGL];
            });
        } ];
        
        if (!res) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressV.hidden = YES;
                //[MBProgressHUD hideHUDForView:self.webV animated:NO];
                [MBProgressHUD showError:@"解压失败！请尝试重新下载该文件" toView:self.webV];
                AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
                self.webV.urlStr = [NSString stringWithFormat:K3DWEBPath,appd.port];
            });
            DLog(@"Error:%@",error);
        }
    });
    
}

- (void)loadWebGL{
    NSString *webP = [KLOCALWEBDIR stringByAppendingPathComponent:@"web"];
    DLog(@"cocoaHttpWebPath:%@",webP);
    BOOL res = [XLTools rewriteUTF8file:webP fileName:@"index.html"];
    if (res) {
        AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd.localHttpServer setDocumentRoot:webP];
        self.webV.urlStr = [NSString stringWithFormat:K3DWEBPath,appd.port];

    }else{
        [MBProgressHUD showError:@"模型html文件有问题" toView:self.webV];
    }
    return;
}

#pragma mark - UnZip 代理


#pragma mark - <私有方法
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)back{
    
    // 退出之前 先清空webGL缓存包
    [[NSFileManager defaultManager] removeItemAtPath:KLOCALWEBDIR error:nil];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
