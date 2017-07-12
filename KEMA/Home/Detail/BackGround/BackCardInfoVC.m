//
//  BackCardInfoVC.m
//  KEMA
//
//  Created by 张雷 on 2017/7/8.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "BackCardInfoVC.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface BackCardInfoVC ()

@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIButton *closeBtn;

@end

@implementation BackCardInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 懒加载
- (UIImageView *)imgView{
    if (nil == _imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.view addSubview:_imgView];
        self.closeBtn.hidden = NO;
        
        _imgView.backgroundColor = KGRAY(247);
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _imgView;
}

- (UIButton *)closeBtn{
    if (nil == _closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = KGRAY(247);
        [_closeBtn setImage:[UIImage imageNamed:@"backCardClose.png"] forState:UIControlStateNormal];
        [self.view addSubview:_closeBtn];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).mas_offset(-30);
            _closeBtn.layer.cornerRadius = 30;
        }];
    }
    return _closeBtn;
}


#pragma mark - # Set 方法重写
- (void)setImgURLStr:(NSString *)imgURLStr{
    _imgURLStr = imgURLStr;
    
    // options:SDWebImageProgressiveDownload
    NSURL *url = [NSURL URLWithString:_imgURLStr];
    [SVProgressHUD showWithStatus:@""];
    [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholderImgNameKey] options:SDWebImageProgressiveDownload completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];

}


#pragma mark - 私有犯法
- (void)close{
    [SVProgressHUD dismiss];

    [self dismissViewControllerAnimated:YES completion:^{}];
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
