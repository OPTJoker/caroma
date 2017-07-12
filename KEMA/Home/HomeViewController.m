//
//  ViewController.m
//  KEMA
//
//  Created by 张雷 on 2017/6/29.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "HomeViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "HomeCollectionViewCell.h"
#import "DetailViewController.h"
#import "XLRequest.h"

#import "CategoryModel.h"
#import "ItemModel.h"
#import "LoadStateManager.h"

@interface HomeViewController ()
<UICollectionViewDelegateFlowLayout
,UICollectionViewDataSource
>
{
    BOOL isLoading;
}
// 数据源
@property(nonatomic, strong) NSMutableArray *dataArr;

// UI控件
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UICollectionView *collectionV;
@property(nonatomic, strong) UILabel *curPageLab;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = KTOPICCOLOR;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self setupLeftMenuButton];
    
    [self requestJsonData];
    
    [XLTools addReFreshGestureToView:self.view target:self method:@selector(requestJsonData)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - >>懒加载
- (UILabel *)titleLab{
    if (nil == _titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:25];
        _titleLab.textColor = KWHITECOLOR;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_titleLab];
    }
    [self.view bringSubviewToFront:_titleLab];
    return _titleLab;
}

- (UICollectionView *)collectionV{
    if (nil == _collectionV) {
        
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        fl.minimumLineSpacing = 0;
        fl.minimumInteritemSpacing = 0;
        fl.itemSize = CGSizeMake(KSCRWIDTH, self.view.bounds.size.height);
        if (iOS9_OR_LATER) {
            fl.sectionHeadersPinToVisibleBounds = YES;
        }
        
        _collectionV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fl];
        _collectionV.backgroundColor = self.view.backgroundColor;
        _collectionV.showsHorizontalScrollIndicator = NO;
        _collectionV.pagingEnabled = YES;
        _collectionV.translatesAutoresizingMaskIntoConstraints = NO;
        
        _collectionV.dataSource = self;
        _collectionV.delegate = self;
        
        _collectionV.layer.masksToBounds = YES;
        
        
        [self.view addSubview:_collectionV];
        
        [_collectionV registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithCString:IDEForHomeCell encoding:NSUTF8StringEncoding]];

    }
    return _collectionV;
}

- (UILabel *)curPageLab{
    if (nil == _curPageLab) {
        _curPageLab = [UILabel new];
        _curPageLab.font = [UIFont boldSystemFontOfSize:17];
        _curPageLab.textColor = KWHITECOLOR;
        _curPageLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_curPageLab];
        _curPageLab.text = @"1 / 3";
        [_curPageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            float b = (self.view.bounds.size.height-150/2-930/2*KSCALE_H)/2.f;
            make.bottom.mas_equalTo(-b+16/2);
        }];
    }
    return _curPageLab;
}
#pragma mark - configUI
/// topNAV;
-(void)setupLeftMenuButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置图片
    UIImage *imageForButton = [MMDrawerBarButtonItem drawerButtonItemImage];
    [button setImage:imageForButton forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    //设置文字
    NSString *buttonTitleStr = @"科马";
    [button setTitle:buttonTitleStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGSize buttonTitleLabelSize = [buttonTitleStr sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}]; //文本尺寸
    CGSize buttonImageSize = imageForButton.size;   //图片尺寸
    button.frame = CGRectMake(0,0,
                              buttonImageSize.width + buttonTitleLabelSize.width,
                              buttonImageSize.height);
    
    UIBarButtonItem *leftDrawerButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
}

- (void)viewWillLayoutSubviews{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        float x = (KSCRWIDTH-560*KSCALE_W/2)/2.f;
        make.left.equalTo(self.view).mas_offset(x);
        make.top.equalTo(self.view).mas_offset(25);
    }];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self scrollViewDidEndDecelerating:self.collectionV];
}


#pragma mark - [collectionView 代理]
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    if (indexPath.item<self.dataArr.count) {
        CategoryModel *catModel = self.dataArr[indexPath.item];
        detailVC.catID = catModel.CatID;
        if (!IsArrEmpty(catModel.items)) {
            detailVC.items = catModel.items;
        }
        
    }
    
    [self.navigationController pushViewController:detailVC animated:NO];
}
#pragma mark - [collectionView 数据源]
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

static char *IDEForHomeCell = "IDEForHomeCellKey";

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithCString:IDEForHomeCell encoding:NSUTF8StringEncoding] forIndexPath:indexPath];
    
    
    if (indexPath.item<self.dataArr.count) {
        CategoryModel *model = self.dataArr[indexPath.item];
        cell.imgURL = KCATIMGURL(model.CatID);
    }
    
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    short idx = scrollView.contentOffset.x/KSCRWIDTH;
    if (idx<self.dataArr.count) {
        CategoryModel *model = [self.dataArr objectAtIndex:idx];
        if (model) {
            self.titleLab.text = model.CateName;
        }
    }
    self.curPageLab.text = [NSString stringWithFormat:@"%d / %d",idx+1,(short)self.dataArr.count];
}


#pragma mark - # ##网络请求
- (NSMutableArray *)dataArr{
    (nil==_dataArr)?_dataArr = [NSMutableArray new] : _dataArr;
    return _dataArr;
}

- (void)requestJsonData{
    
    if (isLoading) {
        isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self requestJsonData];
    }
    
    [MBProgressHUD showMessage:@"loading.." toView:self.view];
    isLoading = YES;
    
    DLog(@"JSONURL:%@",KJSONURL);
    
    [XLRequest GET:KJSONURL para:nil success:^(id sucData) {
        isLoading = NO;
        NSDictionary *dic = [XLRequest analyze:sucData];
        if ([dic isKindOfClass:[NSDictionary class]]){
            NSArray *categorys = [dic objectForKey:@"Category"];
            if (!IsArrEmpty(categorys)) {
                
                [self.dataArr removeAllObjects];
                for (NSDictionary *cat in categorys) {
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:cat];
                    
                    CategoryModel *catModel = [CategoryModel new];
                    catModel.CatID = [cat objectForKey:@"CatID"];
                    // 大类model里面有个item模型数组，所以先加载小数组，然后替换请求的dic[@"items"]数组，给大数组赋值
                    NSString *itemsKey = @"items";
                    NSArray *items = [cat objectForKey:itemsKey];
                    NSMutableArray *itemsModelArr = [NSMutableArray new];
                    for (NSDictionary *item in items) {
                        ItemModel *model = [ItemModel new];
                        [model setValuesForKeysWithDictionary:item];
                        [itemsModelArr addObject:model];
                        
                        /*  此段代码为同步下载状态用的，事实证明没必要。
                        if ([XLTools ISWebGLItemZipExitByCatID:catModel.CatID itemID:model.itemID]) {
                            [LoadStateManager setStateForCatID:catModel.CatID itemID:model.itemID urlStrKey:KWEBGLURL(model.itemPkg) state:Loaded];
                        }else{
                            [LoadStateManager setStateForCatID:catModel.CatID itemID:model.itemID urlStrKey:KWEBGLURL(model.itemPkg) state:UnLoad];
                        }
                         */
                    }
                    
                    [mutDic setObject:itemsModelArr forKey:itemsKey];
                    
                    
                    [catModel setValuesForKeysWithDictionary:mutDic];
                    [self.dataArr addObject:catModel];
                }
                
                // 刷新数据
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.collectionV.contentOffset = CGPointZero;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self.collectionV reloadData];
                }];
                
                CategoryModel *model = [self.dataArr firstObject];
                if (model) {
                    self.titleLab.text = model.CateName;
                }
                
            }else{
                [XLRequest fmtErr:dic aView:self.view];
            }
        }else{
            [XLRequest fmtErr:dic aView:self.view];
        }
    } failure:^(NSError *errData) {
        isLoading = NO;
        [XLRequest dataRequestFailure:errData inView:self.view];
    }];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
