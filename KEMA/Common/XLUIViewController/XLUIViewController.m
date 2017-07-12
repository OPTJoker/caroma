//
//  XLUIViewController.m
//  iFactory
//
//  Created by 张雷 on 16/11/15.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLUIViewController.h"
#import "Color.h"

@interface XLUIViewController ()

@end

@implementation XLUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWHITECOLOR;
    if (![self.navigationItem.backBarButtonItem.title isEqualToString:@""]) {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] init];
        back.title = @"";
        self.navigationItem.backBarButtonItem = back;
    }
}

- (void)viewWillLayoutSubviews{
    //DLog(@"viewWillLayOutSuvViews");
    
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
