//
//  AboutUSVC.m
//  KEMA
//
//  Created by 张雷 on 2017/7/8.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "AboutUSVC.h"
#import "UILabel+LineSpaceAndWordSpace.h"
#import "DutyWebVC.h"


@interface AboutUSVC ()

@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *ctxView;
@property(nonatomic, strong) UILabel *copyRLabe;

@property(nonatomic, strong) UIButton *dutyBtn;

@end

@implementation AboutUSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KTOPICCOLOR;
    self.navigationItem.title = @"关于";
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutme" ofType:@"txt"];
    NSError *error;
    
    self.titleLab.text = @"科马卫浴";
    
    NSString *ctx = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        [self.ctxView setText:ctx];
        [UILabel changeLineSpaceForLabel:_ctxView WithSpace:5];
    }else{
        [MBProgressHUD showError:@"读取文件失败！" toView:self.ctxView];
    }
    
    self.dutyBtn.hidden = NO;
}


#pragma mark - 懒加载

- (UILabel *)titleLab{
    if (nil == _titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:22];
        _titleLab.textColor = KWHITECOLOR;
        _titleLab.textAlignment = NSTextAlignmentJustified;
        [self.view addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(40);
            make.top.equalTo(self.view).mas_offset(22);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(23);
        }];
    }
    return _titleLab;
}

- (UILabel *)ctxView{
    if (_ctxView == nil) {
        _ctxView = [[UILabel alloc] init];
        _ctxView.numberOfLines = 0;
        _ctxView.font = [UIFont systemFontOfSize:13];
        _ctxView.backgroundColor = self.view.backgroundColor;
        _ctxView.textColor = KWHITECOLOR;
        [self.view addSubview:_ctxView];
        
        [_ctxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(40);
            make.right.lessThanOrEqualTo(self.view).mas_offset(-40);
            make.top.equalTo(self.titleLab.mas_bottom).offset(18);
            
        }];
    }
    return _ctxView;
}


- (UIButton *)dutyBtn{
    if (nil == _dutyBtn) {
        _dutyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"《\"科马ZOOM\"软件用户协议》"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:KGRAY(217) range:strRange];
        
        [_dutyBtn setAttributedTitle:str forState:UIControlStateNormal];
        
        [self.view addSubview:_dutyBtn];
        _dutyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [_dutyBtn addTarget:self action:@selector(jumpToDutyWeb) forControlEvents:UIControlEventTouchUpInside];
        [_dutyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.copyRLabe.mas_top).mas_offset(-(-13+7));
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@36);
        }];
        
    }
    return _dutyBtn;
}

- (UILabel *)copyRLabe{
    if (nil == _copyRLabe) {
        _copyRLabe = [UILabel new];
        _copyRLabe.font = [UIFont systemFontOfSize:9.5];
        _copyRLabe.textColor = KGRAY(153);
        _copyRLabe.textAlignment = NSTextAlignmentCenter;
        _copyRLabe.text = @"Copyright © 2017-WESHAPE";
        [self.view addSubview:_copyRLabe];
        [_copyRLabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).mas_offset(-8);
        }];
    }
    return _copyRLabe;
}



#pragma mark - 私有方法
- (void)jumpToDutyWeb{
    DutyWebVC *dutyVC = [[DutyWebVC alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"duty" ofType:@"html"];
    dutyVC.htmlPath = path;
    [self.navigationController pushViewController:dutyVC animated:YES];
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
