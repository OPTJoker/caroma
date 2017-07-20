//
//  DetailViewController.m
//  KEMA
//
//  Created by 张雷 on 2017/6/30.
//  Copyright © 2017年 Allen. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MoveInFromDirection) {
    MoveInFromTop,
    MoveInFromBottom,
    MoveInFromLeft,
    MoveInFromRight
};

typedef NS_ENUM(NSUInteger, WiFiMode) {
    NetOK = 0,
    WifiOnly_NotMatch = 1,
    AllNet_NoNet = 2
};

#import "DetailViewController.h"
#import <MMDrawerBarButtonItem.h>
#import "XLToolBar.h"
#import "UILabel+LineSpaceAndWordSpace.h"
#import "PlayButton.h"
#import <UIImageView+WebCache.h>
#import "XLTools.h"
#import "XLDownLoad.h"
#import "BtmBGView.h"
#import "RunloopWebVC.h"
#import <SVProgressHUD.h>
#import "BackCardInfoVC.h"
#import "ShareView.h"
#import <WXApi.h>
#import "GetURLFileLength.h"

@interface DetailViewController ()
<
Delegate
,CancleShareDelegate
>
{
    UIButton *backItemBtn;
    NSArray *toolBarTitles;
    NSArray *toolBarImgs;
    
    CGFloat btmBGHeight;
    CGPoint btmBGCenter;    // 常规位置
    CGPoint btmBGTopCenter; // 靠上位置
    CGPoint btmBGBtmCenter; // 靠下位置
    
    short currentIndex;     // 当前卡片index
    
    BOOL isInfoShow;        // 是否点击了详情按钮
    
    ItemModel *curItem;       // 当前itemID;
}

/// =================  数据
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *shortDesc;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, strong) ShareView *shareV;
@property(nonatomic, strong) UIView *shareBGView;


/// =================  UI
@property(nonatomic, strong) UIView *topBGView;
@property(nonatomic, strong) UIImageView *bigImgV;
@property(nonatomic, strong) BtmBGView *btmBGView;
@property(nonatomic, strong) PlayButton *playBtn;

@property(nonatomic, strong) UILabel *nameLab;
@property(nonatomic, strong) UILabel *shorDescLab;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UILabel *descLab;

@property(nonatomic, strong) XLToolBar *toolBar;


/// ================= 网络
@property(nonatomic, copy) NSTimer *t;

@end

@implementation DetailViewController


#pragma mark - # load View & view appear
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWHITECOLOR;
    
    backItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backItemBtn setTitle:@"" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"back.png"];
    [backItemBtn setImage:img forState:UIControlStateNormal];
    // +3 是UI视觉偏移效果
    //[backItemBtn setContentEdgeInsets:UIEdgeInsetsZero];
    //[backItemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (60-img.size.width)/2.f+10, 0, 0)];
    [backItemBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backItemBtn];
    
    
    toolBarTitles = @[@"",@"",@""];
    toolBarImgs = @[@"share.png",
                    @"info.png",
                    @"toolBarSave.png"];
    
    btmBGHeight =  950/2.f;
    btmBGCenter = CGPointMake(KSCRWIDTH/2.f, (KSCRHEIGHT-650/2*KSCALE_H)+btmBGHeight/2.f*KSCALE_H );
    btmBGTopCenter = CGPointMake(KSCRWIDTH/2.f, (KSCRHEIGHT-btmBGHeight/2.f*KSCALE_H) );
    btmBGBtmCenter = CGPointMake(KSCRWIDTH/2.f, (950/2*KSCALE_H)+btmBGHeight/2.f*KSCALE_H);
    
    currentIndex = 0;
    
    [self loadUI];

}


- (void)viewWillLayoutSubviews{
    
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backItemBtn];
    [backItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(12);
        make.top.equalTo(self.view).mas_offset(20+6);
        make.size.with.mas_equalTo(30);
        make.size.height.mas_equalTo(30);
    }];
    
    self.playBtn.hidden = NO;
    self.toolBar.delegate = self;
    
}

- (NSTimer *)t{
    if (nil == _t) {
        _t = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self refreshLoadProgress];
        }];
    }
    return _t;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    //self.navigationController.navigationBar.hidden = NO;
    
    [self.t invalidate];
    self.t = nil;
}

#pragma mark - #导航 header设置

-(void)NavigationBarClear:(UINavigationBar *)navigationBar hidden:(BOOL) hidden
{
    if ([navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list = navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = (UIImageView *)obj;
                imageView.hidden = hidden;
                navigationBar.translucent = hidden;
            }
        }
    }
}

#pragma mark - 懒加载

- (UIView *)topBGView{
    if (nil == _topBGView) {
        _topBGView = [UIView new];
        _topBGView.backgroundColor = KGRAY(247);
        [self.view addSubview:_topBGView];
        [self.view sendSubviewToBack:_topBGView];
        
        [_topBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(950/2*KSCALE_H);
        }];
    }
    
    return _topBGView;
}
/// 顶部View的图片控件
- (UIImageView *)bigImgV{
    if (nil == _bigImgV) {
        _bigImgV = [[UIImageView alloc] init];
        _bigImgV.backgroundColor = self.topBGView.backgroundColor;
        [self.topBGView addSubview:_bigImgV];
        [self.bigImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.topBGView);
        }];
    }
    return _bigImgV;
}

// 切换大图
- (void)setAnimationToImgV:(UIImageView *)imgV direction:(MoveInFromDirection)direction{
    static NSString *animKey = @"changeImgFadeAnim";
    [imgV.layer removeAnimationForKey:animKey];
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setFillMode:kCATransitionMoveIn];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    NSString *type = kCATransitionMoveIn;
    //type = @"rippleEffect";
    if ([type isEqualToString:@"rippleEffect"]) {
        [animation setDuration:2.0];
        animation.startProgress = 0.46;
        animation.endProgress = 0.87;
    }
    
    [animation setType:type];
    
    NSString *subType = kCATransitionFromBottom;
    switch (direction) {
        case MoveInFromTop:{
            subType = kCATransitionFromTop;
        }break;
        case MoveInFromBottom:{
            subType = kCATransitionFromBottom;
        }break;
        case MoveInFromLeft:{
            subType = kCATransitionFromLeft;
        }break;
        case MoveInFromRight:{
            subType = kCATransitionFromRight;
        }break;
        default:
            break;
    }
    [animation setSubtype:subType];
    [imgV.layer addAnimation:animation forKey:animKey];
}

- (PlayButton *)playBtn{
    if (nil == _playBtn) {
        _playBtn = [PlayButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = KWHITECOLOR;
        [_playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btmBGView addSubview:_playBtn];
        
        [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.btmBGView.mas_top);
            make.centerX.equalTo(self.btmBGView.mas_right).mas_offset(-60-10);
            make.size.mas_equalTo(60);
            _playBtn.layer.cornerRadius = 30;
            _playBtn.layer.shadowColor = KTOPICCOLOR.CGColor;
            _playBtn.layer.shadowOpacity = 0.5;
            _playBtn.layer.shadowOffset = CGSizeMake(0, 3);
        }];
    }
    
    return _playBtn;
}

- (UILabel *)nameLab{
    if (nil == _nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:84/2];
        _nameLab.textColor = UIColorFromRGB(0x3D372F);
        _nameLab.textAlignment = NSTextAlignmentLeft;
        [self.btmBGView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btmBGView).mas_offset(23);
            make.top.equalTo(self.btmBGView).mas_offset(26-6);
        }];
    }
    return _nameLab;
}

- (UILabel *)shorDescLab{
    if (nil == _shorDescLab) {
        _shorDescLab = [UILabel new];
        _shorDescLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:38/2];
        _shorDescLab.textColor = UIColorFromRGB(0x61523E);
        _shorDescLab.textAlignment = NSTextAlignmentLeft;
        [self.btmBGView addSubview:_shorDescLab];
        [_shorDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLab);
            make.top.equalTo(self.nameLab.mas_bottom).mas_offset(6-6);
            make.right.equalTo(self.nameLab).mas_offset(-36);
        }];
    }
    return _shorDescLab;
}
- (UIView *)line{
    if (nil == _line) {
        _line = [UIView new];
        _line.backgroundColor = UIColorFromRGB(0x979797);
        [self.btmBGView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btmBGView);
            make.right.equalTo(self.btmBGView);
            make.height.mas_equalTo(0.5);
            make.top.equalTo(self.shorDescLab.mas_bottom).mas_offset(36/2);
        }];
    }
    return _line;
}
- (UILabel *)descLab{
    if (nil == _descLab) {
        _descLab = [UILabel new];
        _descLab.font = [UIFont systemFontOfSize:15];
        _descLab.textColor = UIColorFromRGB(0x61523E);
        _descLab.textAlignment = NSTextAlignmentLeft;
        _descLab.numberOfLines = 0;
        [self.btmBGView addSubview:_descLab];
        [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLab);
            make.top.equalTo(self.line).mas_offset(18);
            make.right.lessThanOrEqualTo(self.btmBGView).mas_offset(-38);
        }];
    }
    return _descLab;
}

- (XLToolBar *)toolBar{
    if (nil == _toolBar) {
        _toolBar = [[XLToolBar alloc] initWithFrame:CGRectMake(0, KSCRHEIGHT-60, KSCRWIDTH, 60) titles:toolBarTitles imgs:toolBarImgs];
        _toolBar.backgroundColor = UIColorFromRGB(0xfafafa);
        [self.view addSubview:_toolBar];
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@60);
        }];
    }
    return _toolBar;
}

- (ShareView *)shareV{
    if (!_shareV) {
        _shareV = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil] firstObject];
        _shareV.cancleShareDelegate = self;
        [self AddDarkBlur:_shareV alpha:1];
        [self.view addSubview:_shareV];
        _shareV.frame = CGRectMake(0, KSCRHEIGHT, KSCRWIDTH, 100);
        self.shareBGView.center = CGPointMake(KSCRWIDTH/2.f, KSCRHEIGHT/2.f);
    }
    self.shareBGView.hidden = NO;
    return _shareV;
}

- (void)addTapGestToView:(UIView *)v{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [v addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [v addGestureRecognizer:pan];
}
- (void)tap:(UIGestureRecognizer *)ges{
    
    if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
        return;
    }else if ([ges isKindOfClass:[UITapGestureRecognizer class]]){
        if (ges.view == self.shareBGView) {
            [self cancleShared];
        }
    }
}
- (void)cancleShared{ //:(UIButton *)sender
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _shareV.center = CGPointMake(KSCRWIDTH/2.f, KSCRHEIGHT+50);
                         self.shareBGView.alpha = 0;
                     } completion:^(BOOL finished) {
                         self.shareBGView.hidden = YES;
                     }];
}

- (UIView *)shareBGView{
    if (nil == _shareBGView) {
        _shareBGView = [[UIView alloc] initWithFrame:CGRectMake(0, KSCRHEIGHT, KSCRWIDTH, KSCRHEIGHT)];
        _shareBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _shareBGView.hidden = YES;
        _shareBGView.userInteractionEnabled = YES;
        [self addTapGestToView:_shareBGView];
        [self.view addSubview:_shareBGView];
        [self.view bringSubviewToFront:self.shareV];
    }
    return _shareBGView;
}
- (void)AddDarkBlur:(UIView *)v alpha:(CGFloat)al{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = al;
    effectView.frame = v.bounds;
    [v addSubview:effectView];
    [v sendSubviewToBack:effectView];
}
#pragma mark - #底部白色卡片的手势等
- (UIView *)btmBGView{
    if (nil == _btmBGView) {
        _btmBGView = [BtmBGView new];
        _btmBGView.backgroundColor = KWHITECOLOR;
        [self.view addSubview:_btmBGView];
        _btmBGView.frame = CGRectMake(0, 0, KSCRWIDTH, btmBGHeight);
        _btmBGView.center = btmBGCenter;
        /*
         [_btmBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).mas_offset(-650/2.f*KSCALE_H);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.mas_equalTo(btmBGHeight*KSCALE_H);
        }];
         */
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnBottomBGView:)];
        [_btmBGView addGestureRecognizer:pan];
    }
    
    return _btmBGView;
}

- (void)panOnBottomBGView:(UIPanGestureRecognizer *)pan{
    if (pan.view!=self.btmBGView) {
        return;
    }
    
    //CGPoint c = self.btmBGView.center;
    //CGPoint p = [pan translationInView:self.btmBGView];
    
    CGPoint v = [pan velocityInView:self.btmBGView];
    BOOL hor = YES;
    
    if (fabs(v.x)<fabs(v.y)) {
        hor = NO;
    }
    
    // 非hor 也就是ver(垂直滑动)
    if (!hor) {
        // 不大不小的区间内移动
        return;
        /*  背面信息用图片表示，所以 暂时禁止了上滑动功能
        if (btmBGTopCenter.y<=c.y && c.y<=btmBGBtmCenter.y) {
            if (p.y<0&&btmBGTopCenter.y==c.y) {
                
            }else if (p.y>0 && c.y==btmBGBtmCenter.y){
                
            }else{
                if (c.y>btmBGCenter.y) {
                    
                    c.y += p.y>0?1:-1*pow(fabs(p.y), 0.5);
                }else{
                    c.y+=p.y;
                }
            }
            
            self.btmBGView.center = c;
            [pan setTranslation:CGPointZero inView:self.btmBGView];
            c = self.btmBGView.center;
        }
        
        //DLog(@"c.y:%f oc.y:%f",c.y, btmBGCenter.y);
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
            
            // 上滑就上
            if (v.y>0) {
                [self moveBtmBGDown];
            }else if (v.y<0){
                [self moveBtmBGUP];
            }else{
                if (self.btmBGView.center.y >= btmBGCenter.y) {
                    [self moveBtmBGDown];
                }else{
                    [self moveBtmBGUP];
                }
            }
        }
         */
    }else{// 横向滑动
        if (self.btmBGView.center.y!=btmBGCenter.y) {
            [self moveBtmBGDown];
        }
        [self panHorizontal:pan];
    }
}

- (void)moveBtmBGUP{
    [UIView animateWithDuration:0.2 animations:^{
        self.btmBGView.center = btmBGTopCenter;
    }];
    isInfoShow = YES;
}

- (void)moveBtmBGDown{
    [UIView animateWithDuration:0.2 animations:^{
        //[self.view layoutIfNeeded];
        self.btmBGView.center = btmBGCenter;
    }];
    isInfoShow = NO;
}

- (void)panHorizontal:(UIPanGestureRecognizer *)pan{
    CGPoint v = [pan velocityInView:self.btmBGView];
    CGPoint p = [pan translationInView:self.btmBGView];
    
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        
        if (fabs(v.x)>=fabs(v.y)) {
            if (v.x == 0) {
                [self swipeFromLeft:p.x>0?YES:NO];
            }else{
                [self swipeFromLeft:v.x>0?YES:NO];
            }
        }
    }
    
}

- (void)swipeFromLeft:(BOOL)isLeft{
    if (isLeft) {
        if (currentIndex-1<0){
            currentIndex = 0;
            [MBProgressHUD showMessage:@"已经是第一页啦" view:self.view];
            return;
        }else{
            currentIndex -= 1;
        }
        [self changeDataWithDirection:MoveInFromLeft];
    }else{
        if (currentIndex+1 >= self.items.count){
            currentIndex = self.items.count-1;
            [MBProgressHUD showMessage:@"已经是最后一页啦" view:self.view];
            return;
        }else{
            currentIndex += 1;
        }
        [self changeDataWithDirection:MoveInFromRight];
    }
}



#pragma mark - UI 模块设置
- (void)loadUI{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHorizontal:)];
    [self.view addGestureRecognizer:pan];
}

#pragma mark - ##

/// 下载完成
- (void)finishedLoadWithCatID:(NSString *)catID itemID:(NSString *)itemID{
    DLog(@"finishLoad!");
    NSString *urlStr = KWEBGLURL(curItem.itemPkg);
    
    [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:urlStr state:Loaded];
    
    [self checkAndRefreshState];
    
    [self.t invalidate];
    self.t = nil;
}

/// 跟新下载进度
- (void)refreshLoadProgress{
    NSString *catID = self.catID;
    NSString *itemID = curItem.itemID;
    NSString *urlStr = KWEBGLURL(curItem.itemPkg);
    
    NSNumber *proNumber = [[XLDownLoad ShareInstance].loadProgressDic objectForKey:urlStr];
    
    if ([proNumber isKindOfClass:[NSNumber class]]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([proNumber doubleValue] <1.0) {
                [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:urlStr state:Loading];
                [self.playBtn setProgress:[proNumber doubleValue]];
                
                [self.playBtn setLoadState:Loading progress:[proNumber doubleValue]];
                [self.toolBar setImgAtIdx:2 withImgName:@"delete.png"];
            }else if([proNumber doubleValue]>=1.0){
                [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:urlStr state:Loaded];
                [self.playBtn setLoadState:Loaded];
                [self.toolBar setImgAtIdx:2 withImgName:@"delete.png"];
            }
            
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([XLTools ISWebGLItemZipExitByCatID:catID itemID:itemID]) {
                [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:urlStr state:Loaded];
                [self finishedLoadWithCatID:catID itemID:itemID];
            }else{
                [self.playBtn setLoadState:UnLoad];
                [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:urlStr state:UnLoad];
                [self.toolBar setImgAtIdx:2 withImgName:@"toolBarSave.png"];
            }
        });
    }
}

/**
 带渐变动画的切换数据
 */
- (void)changeDataWithDirection:(MoveInFromDirection)direction{
    
    ItemModel *model = [self setItemModelWithIndex:currentIndex];
    curItem = model;
    
    DLog(@"itemID:%@ State:%d",curItem.itemID,[LoadStateManager getStateForCatID:self.catID itemID:curItem.itemID]);
    
    LoadState st = [self checkAndRefreshState];
    if (st == Loading) {
        if (!self.t) {
            [self.t fire];
        }
        
    }else if (st == Loaded){
        [self finishedLoadWithCatID:self.catID itemID:curItem.itemID];
    }
    
    // change Data
    NSURL *url = [NSURL URLWithString:KFRONTIMGURL(self.catID, model.itemID)];
    [self.bigImgV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholderImgNameKey] options:SDWebImageProgressiveDownload];
    
    
    if (st == UnLoad || st == ReLoad) {
        [self.playBtn setFileSizeForCatID:self.catID itemID:curItem.itemID];
    }
    
    // 开始动画
    [self setAnimationToImgV:self.bigImgV direction:direction];
        // 控件文字透明动画
    [UIView animateWithDuration:0.25 animations:^{
        self.nameLab.alpha = 0;
        self.shorDescLab.alpha = 0;
        self.descLab.alpha = 0;
    } completion:^(BOOL finished) {
        
        // 结束动画
        [UIView animateWithDuration:0.25 animations:^{
            self.nameLab.alpha = 1;
            self.shorDescLab.alpha = 1;
            self.descLab.alpha = 1;
        }];
        
    }];
    
}

#pragma mark - >> 重写set方法
- (ItemModel *)setItemModelWithIndex:(short)idx{
    if (self.items.count>idx) {
        ItemModel *model = _items[idx];        
        
        self.name = model.itemName;
        self.shortDesc = model.itemBrief;
        self.desc = model.itemDes;
        return model;
    }
    return nil;
}

- (void)setItems:(NSArray<ItemModel *> *)items{
    _items = items;
    currentIndex = 0;
    curItem = [_items firstObject];
    [self changeDataWithDirection:MoveInFromTop];
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLab.text = _name;
}
- (void)setShortDesc:(NSString *)shortDesc{
    _shortDesc = shortDesc;
    self.shorDescLab.text = _shortDesc;
}
- (void)setDesc:(NSString *)desc{
    _desc = desc;
    self.descLab.text = _desc;
    [UILabel changeLineSpaceForLabel:_descLab WithSpace:6];    // 一定要放在text赋值之后 不然nil
}


#pragma mark - ### 网络请求
- (void)playBtnClicked:(UIButton *)playBtn{
    
    LoadState st = [self checkAndRefreshState];
    
    if (st == Loaded) {
        
        [self playWebGL];
        
    }else{
        [self didSelectItemAtIndex:2];
    }
}



- (WiFiMode)checkNotWifiModOrNoNet{
    // 没网情况
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        return AllNet_NoNet;
    }
    
    // 仅wifi 却没wi-fi情况
    if (![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:KLOADNWIFIWARNINGKEY];
        if ([num boolValue]) {
            return WifiOnly_NotMatch;
        }
    }
    
    return NetOK;
}

- (void)downloadWEBGLZIPItemID:(NSString *)path CatID:(NSString *)catID itemID:(NSString *)itemID{
    WiFiMode net = [self checkNotWifiModOrNoNet];
    if (net != NetOK) {
        NSString *errMsg = @"网络有问题 请检查网络";
        switch (net) {
            case WifiOnly_NotMatch:{
                errMsg = @"您开启了仅Wi-Fi下载模式,不过wifi好像有点问题";
            }break;
            case AllNet_NoNet:{
                errMsg = @"您的网络好像有点问题";
            }break;
            default:
                break;
        }
        [SVProgressHUD showErrorWithStatus:errMsg];
        return;
    }
    NSString *webGLZipURL = KWEBGLURL(path);
    DLog(@"webGLZipURL:%@",webGLZipURL);
    
    if (![XLTools ISWebGLItemZipExitByCatID:catID itemID:itemID]) {
        // 下载
        NSString *itemPath = [XLTools WebGLItemPathWithCatID:catID itemID:itemID];
        DLog(@"itemZipPath:%@",itemPath);

        [self.playBtn setLoadState:Loading progress:0.0];
        [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:webGLZipURL state:Loading];
        self.playBtn.userInteractionEnabled = NO;
        
        [XLDownLoad downloadURL:webGLZipURL destPath:itemPath progress:^(double progress) {
            //DLog(@"progress:%.2f",progress);
            self.playBtn.userInteractionEnabled = YES;
            
            [XLDownLoad setProgress:progress forKey:webGLZipURL];            
            [self refreshLoadProgress];
            
        } finish:^(NSError *error) {
            if (nil == error) {
                [self finishedLoadWithCatID:catID itemID:itemID];
            }else{
                DLog(@"Download Error:%@",error);
                
                [LoadStateManager setStateForCatID:catID itemID:itemID urlStrKey:webGLZipURL state:ReLoad];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self checkAndRefreshState];
                });
                
                // 下载失败警告 其中-999 是取消下载
                if (error.code == -999) {
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@取消下载",itemID]];
                }else{
                    NSString *itemName = itemID;
                    for (ItemModel *model in self.items) {
                        if (model.itemID == model.itemID) {
                            itemName = model.itemName;
                        }
                    }
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"模型%@下载失败",itemName] message:[NSString stringWithFormat:@"错误码：%ld",(long)error.code] preferredStyle: UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertController addAction:yesAction];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                }
                
            }
            
        }];
        
    }else{
        [MBProgressHUD showMessage:@"包存在" view:self.view];
    }
}


#pragma mark - ToolBar 点击
- (void)didSelectItemAtIndex:(short)idx{
    //DLog(@"%@",toolBarImgs[idx]);
    switch (idx) {
        case 0:{
            [self theFirstItem];
        }break;
            
        case 1:{
            [self theSecondItem];
        }break;
            
        case 2:{
            [self theThirdItem];
        }break;
            
        default:
            break;
    }
}

#pragma mark - 第一个按钮

- (void)theFirstItem{
    
    ShareModel *model = [ShareModel new];
    model.title = curItem.itemName;
    model.shareDescription = curItem.itemBrief;
    model.webpageUrl = KWEBGLURL(curItem.itemLink);
    model.shareIconUrl = KSHAREICONURL(self.catID, curItem.itemID);
    
    self.shareV.model = model;
    CGRect rect = self.shareV.frame;
    rect.size.height = 100;
    self.shareV.frame = rect;
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shareV.center = CGPointMake(KSCRWIDTH/2.f, KSCRHEIGHT-50);
                         self.shareBGView.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];

}
#pragma mark - 第二个按钮
- (void)theSecondItem{
    /*
     isInfoShow = !isInfoShow;
     
     if (!self) { return; }
     SEL selector = isInfoShow?NSSelectorFromString(@"moveBtmBGUP"):NSSelectorFromString(@"moveBtmBGDown");
     IMP imp = [self methodForSelector:selector];
     void (*func)(id, SEL) = (void *)imp;
     func(self, selector);
     */
    BackCardInfoVC *back = [[BackCardInfoVC alloc] init];
    back.imgURLStr = KFBackIMGURL(self.catID, curItem.itemID);
    
    back.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    back.modalPresentationStyle = UIModalPresentationPopover;
    
    
    [self presentViewController:back animated:YES completion:^{
    }];
}
#pragma mark - 第三个按钮
- (void)theThirdItem{
    LoadState state = [LoadStateManager getStateForCatID:self.catID itemID:curItem.itemID];
    switch (state) {
        case UnLoad:
        case ReLoad:{
            [self.playBtn setLoadState:state progress:0.0];
            [self downloadWEBGLZIPItemID:curItem.itemPkg CatID:self.catID itemID:curItem.itemID];
        }break;
        case Loading:
        case Loaded:{
            if (!self.playBtn.userInteractionEnabled) {
                return;
            }
            NSString *msg = @"删除后不可恢复，您确定删除缓存?";
            if (state == Loading) {
                msg = @"正在下载中，您确定取消下载并删除？";
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除？" message:msg preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deletePkgAndTask];
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:yesAction];
            [alertController addAction:cancleAction];
            
            [self presentViewController:alertController animated:yesAction completion:^{
            }];
            
        }break;
            
        default:
            break;
    }
}

- (void)deletePkgAndTask{
    NSString *urlStr = KWEBGLURL(curItem.itemPkg);
    NSURLSessionDownloadTask *task = [[XLDownLoad unFinishedLoadTaskList] objectForKey:urlStr];
    if (task) {
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        }];
        task = nil;
    }    
    
    [LoadStateManager setStateForCatID:self.catID itemID:curItem.itemID urlStrKey:urlStr state:UnLoad];
    
    if ([XLTools DeleteWebGLZipByCatID:self.catID itemID:curItem.itemID]) {
        // 删除后的UI
        [self refreshLoadProgress];
    }else{
        [MBProgressHUD showError:@"抱歉,删除失败.." toView:self.view];
    }
}


#pragma mark - 播放3D
- (void)playWebGL{
    
    RunloopWebVC *webVC = [[RunloopWebVC alloc] init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    DLog(@"wkURL:%@",webVC.webUrl);
    
    [webVC playWithCatID:self.catID itemID:curItem.itemID];
    
    [self.navigationController pushViewController:webVC animated:NO];

}

- (LoadState)checkAndRefreshState{
    
    LoadState st = [LoadStateManager getStateForCatID:self.catID itemID:curItem.itemID];
    DLog(@"state:%d",st);
    [self.playBtn setLoadState:st];
    
    switch (st) {
        case UnLoad:
        case ReLoad:{
            [self.toolBar setImgAtIdx:2 withImgName:@"toolBarSave.png"];
        }break;
        case Loading:{
            [self refreshLoadProgress];
            [self.toolBar setImgAtIdx:2 withImgName:@"delete.png"];
        }break;
        case Loaded:{
            [self.toolBar setImgAtIdx:2 withImgName:@"delete.png"];
        }break;
            
        default:
            break;
    }
    
    return st;
}


- (BOOL)isWebGLZipExit{
    if ( (!IsStrEmpty(self.catID)) && (!IsStrEmpty(curItem.itemID)) ) {
        return [XLTools ISWebGLItemZipExitByCatID:self.catID itemID:curItem.itemID];
    }
     return NO;
}

#pragma mark - << 返航！ >>

- (void)back{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
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
