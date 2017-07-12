//
//  DutyWebVC.m
//  KEMA
//
//  Created by 张雷 on 2017/7/10.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "DutyWebVC.h"
#import "XLWKWebView.h"

@interface DutyWebVC ()
@property(nonatomic, strong) XLWKWebView *webV;
@end

@implementation DutyWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KTOPICCOLOR;
    self.navigationItem.title = @"免责声明";
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (XLWKWebView *)webV{
    if (nil== _webV) {
        _webV = [[XLWKWebView alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 1)];
        _webV.backgroundColor = KTOPICCOLOR;
        [self.view addSubview:_webV];
        [_webV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _webV;
}

- (void)setHtmlPath:(NSString *)htmlPath{
    _htmlPath = htmlPath;
    self.webV.htmlPath = _htmlPath;    
    self.webV.scrollView.backgroundColor = KTOPICCOLOR;
}


- (void)dealloc{
    // 退出页面清除temp/www/缓存文件
    NSString *temURLDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"www"];
    [[NSFileManager defaultManager] removeItemAtPath:temURLDir error:nil];
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

@end
