//
//  LeftViewController.m
//  KEMA
//
//  Created by 张雷 on 2017/6/29.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "LeftViewController.h"
#import "XLTableView.h"
#import "LeftConfigCell.h"
#import "AppDelegate.h"
#import "XLDownLoad.h"
#import <SVProgressHUD.h>
#import "SettingVC.h"
#import "AboutUSVC.h"
#import "XLNavigationController.h"

@interface LeftViewController ()
<UITableViewDelegate
,UITableViewDataSource
>
{
    NSArray *titles;
    NSArray *imgNames;
}
@property(nonatomic, strong) XLTableView *listView;
@property(nonatomic, strong) UIImageView *topView;

@end

@implementation LeftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KTOPICCOLOR;
    [self dataConfig];
    [self configUI];
}

- (void)dataConfig{
    titles = @[@"浏览", @"清除缓存", @"设置", @"关于"];
    imgNames = @[@"eye.png", @"clear.png", @"setting.png", @"about.png"];
}
#pragma mark - >>懒加载
- (UIImageView *)topView{
    if (nil == _topView) {
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
        UIImage *img = [UIImage imageNamed:@"KEMALOGO.png"];//[UIImage imageWithContentsOfFile:path];
        _topView = [[UIImageView alloc] initWithImage:img];
        _topView.contentMode = UIViewContentModeScaleToFill;
        _topView.layer.masksToBounds = YES;
        [self.view addSubview:_topView];
    }
    return _topView;
}
- (XLTableView *)listView{
    if (_listView == nil) {
        _listView = [[XLTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        [self.view addSubview:_listView];
        _listView.backgroundColor = KTOPICCOLOR;
    }
    return _listView;
}


#pragma mark - configUI
- (void)configUI{
    self.listView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView reloadData];
}

- (void)viewWillLayoutSubviews{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(370/2);
    }];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - [tableview 代理]
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (indexPath.row) {
        case 0:{
            [appd.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            }];
        }break;
        case 1:{
            
            float size = [XLTools folderSizeAtPath:KWebGLCacheDirectory];
            if (size <= 0.f) {
                [SVProgressHUD showErrorWithStatus:@"没有缓存"];
                return;
            }
            
            NSMutableDictionary *tasks = [XLDownLoad unFinishedLoadTaskList];
            if (IsArrEmpty([tasks allKeys])) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除?" message:@"该操作将清空全部已下载模型包" preferredStyle: UIAlertControllerStyleAlert];
                
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [SVProgressHUD showWithStatus:@"清除缓存中.."];
                    
                    NSError *error = [self clearAllCache];
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:@"缓存清除失败"];
                        DLog(@"Clear Cache Err:%@",error);
                    }else{
                        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:1 inSection:0];
                        [self.listView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationNone];
                        [SVProgressHUD dismiss];
                    }
                }];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                
                [alertController addAction:yesAction];
                [alertController addAction:cancleAction];
                
                [self presentViewController:alertController animated:yesAction completion:^{
                }];
            }else{
                [MBProgressHUD showMessage:[NSString stringWithFormat:@"抱歉，有%d个文件正在下载，请先取消下载",(short)[tasks allKeys].count] view:appd.drawerController.view];
                DLog(@"unFinishedDic:%@",[XLDownLoad unFinishedLoadTaskList]);
            }
        }break;
        case 2:{
            SettingVC *setVC = [[SettingVC alloc] init];
            [appd.drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                XLNavigationController *cNav = (XLNavigationController *)appd.drawerController.centerViewController;
                [cNav pushViewController:setVC animated:YES];
                
            }];
        }break;
        case 3:{
            AboutUSVC *aboutVC = [[AboutUSVC alloc] init];
            [appd.drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
                XLNavigationController *cNav = (XLNavigationController *)appd.drawerController.centerViewController;
                [cNav pushViewController:aboutVC animated:YES];
                
            }];
        }break;
        default:
            break;
    }
}
- (NSError *)clearAllCache{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:KWebGLCacheDirectory error:&error];
    [XLDownLoad clearAllCache];
    /// TODO: 删除磁盘保存的下载记录
    return error;
}
#pragma mark - [tableview 数据源]
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDEForLeftSettingCell = @"IDEForLeftSettingCellKEY";
    LeftConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:IDEForLeftSettingCell];
    if (nil == cell) {
        cell = [[LeftConfigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDEForLeftSettingCell];
        cell.backgroundColor = self.view.backgroundColor;
    }
    
    NSString *str = titles[indexPath.row];
    if (indexPath.row == 1) {
        float size = [XLTools folderSizeAtPath:KWebGLCacheDirectory];
        NSString *cacheSize = [NSString stringWithFormat:@"（%.1fM）",size];
        if (size <= 0.f) {
            cacheSize = @"";
        }
        str = [str stringByAppendingString:cacheSize];
    }
    cell.title = str;
    cell.imgName = imgNames[indexPath.row];
    
    return cell;
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
