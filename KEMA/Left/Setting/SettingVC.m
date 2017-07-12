//
//  SettingVC.m
//  KEMA
//
//  Created by 张雷 on 2017/7/8.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@property(nonatomic, strong) UILabel *loadNetWarningLab;
@property(nonatomic, strong) UISwitch *sw;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KTOPICCOLOR;
    self.navigationItem.title = @"设置";
    // Do any additional setup after loading the view.
    
    [self loadUI];
}

- (void)loadUI{
    self.loadNetWarningLab.text = @"仅通过Wi-Fi下载";
    NSNumber *wifi = [[NSUserDefaults standardUserDefaults] objectForKey:KLOADNWIFIWARNINGKEY];
    if ([wifi boolValue]) {
        [self.sw setOn:YES];
    }else{
        [self.sw setOn:NO];
    }
}


#pragma mark - 懒加载

- (UILabel *)loadNetWarningLab{
    if (nil == _loadNetWarningLab) {
        _loadNetWarningLab = [UILabel new];
        _loadNetWarningLab.font = [UIFont systemFontOfSize:16];
        _loadNetWarningLab.textColor = KWHITECOLOR;
        _loadNetWarningLab.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_loadNetWarningLab];
        [_loadNetWarningLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(16);
            make.top.equalTo(self.view).mas_offset(25);
        }];
    }
    return _loadNetWarningLab;
}

- (UISwitch *)sw{
    if (nil == _sw) {
        _sw = [[UISwitch alloc] init];
        [self.view addSubview:_sw];
        
        [_sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [_sw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.loadNetWarningLab);
            make.right.equalTo(self.view).mas_offset(-16);
            make.width.mas_equalTo(102/2);
            make.height.mas_equalTo(62/2);
        }];
    }
    return _sw;
}


- (void)switchValueChanged:(UISwitch *)sw{
    if (sw.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:KLOADNWIFIWARNINGKEY];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:KLOADNWIFIWARNINGKEY];
    }
    DLog(@"wi-fi Only: [%@] ",[[NSUserDefaults standardUserDefaults] objectForKey:KLOADNWIFIWARNINGKEY]);
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
