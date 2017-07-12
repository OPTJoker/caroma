//
//  XLTableView.m
//  iUnis
//
//  Created by 张雷 on 16/9/9.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLTableView.h"
#import "XTNetReloader.h"
#import <MJRefresh.h>

#define dur .6

@interface XLTableView()
<
CYLTableViewPlaceHolderDelegate
>
{
    
    ScrollDirection direc;
    
    float lastContentOffset;
    
    BOOL dragFlag;
    
    BOOL isScrolll;
    
    UIButton *emptyBtn;
}
@end

@implementation XLTableView

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
}

- (UIView *)makePlaceHolderView{
    UIView *taobaoStyle = [self taoBaoStylePlaceHolder];
    return taobaoStyle;
}
- (UIView *)taoBaoStylePlaceHolder {
    __block XTNetReloader *netReloader = [[XTNetReloader alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                  reloadBlock:^{
                                                                      [self xl_reloadData];
                                                                  }];
    return netReloader;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configData];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = KBGGRAYCOLOR;
        [self configData];
        
    }
    return self;
}

- (void)setRefreshDelegate:(id<RefreshDelegate>)refreshDelegate{
    
    _refreshDelegate = refreshDelegate;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xl_reloadData)];
    
}

- (void)setLoadMoreDelegate:(id<LoadMoreDelegate>)loadMoreDelegate{
    _loadMoreDelegate = loadMoreDelegate;
    // 下拉加载
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(xl_loadMoreData)];

}


- (void)configData{
    _isInitTable = YES;
    direc = 1;
    isScrolll = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bounces = YES;
    self.delegate = self;
    self.dataSource = self;
}


#pragma mark -reload data

/**
 第一次加载数据 初始化UI
 */
- (void)xl_firstLoadData{
    [self.mj_header beginRefreshing];
}

- (void)xl_reloadData{
    if ([_refreshDelegate respondsToSelector:@selector(xl_refreshing)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_refreshDelegate xl_refreshing];
        });
    }
}
- (void)xl_loadMoreData{
    if ([_loadMoreDelegate respondsToSelector:@selector(xl_loadMoreData)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadMoreDelegate xl_loadMoreData];
        });
    }
}

- (void)xl_header_endRefresh{
    [self.mj_header endRefreshing];
    _isInitTable = NO;
}

- (void)xl_endRefreshing{
    if (nil!=self.mj_header) {
        [self.mj_header endRefreshing];
    }
    if (nil!= self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
    [self cyl_reloadData];
    _isInitTable = NO;
}

#pragma mark -cell动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(XLTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( ![cell isKindOfClass:[XLTableViewCell class]] || (cell.superclass != [XLTableViewCell class])) return;
    
    if (_isInitTable) {
        direc = 1;
        BOOL isExt = NO;
        if (_extentFlagArr.count > indexPath.section) {
            isExt = [_extentFlagArr[indexPath.section] integerValue];
        }
        [cell animationForIndexPath:indexPath direction:direc duration:dur isExtend:isExt isInit:_isInitTable count:indexPath.section];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isInitTable = NO;
        });
    }else{
        if (isScrolll) {
            BOOL isExt = NO;
            if (_extentFlagArr.count > indexPath.section) {
                isExt = [_extentFlagArr[indexPath.section] integerValue];
            }
            [cell animationForIndexPath:indexPath direction:direc duration:dur isExtend:isExt];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self tableView:tableView heightForFooterInSection:section]==0.0) {
        return nil;
    }else{
        if ([_ctrlDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
            return [_ctrlDelegate tableView:tableView viewForFooterInSection:section];
        }else{
            UIView *aView = [[UIView alloc] init];
            return aView;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self tableView:tableView heightForHeaderInSection:section]==0.0) {
        return nil;
    }else{
        if ([_ctrlDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            return [_ctrlDelegate tableView:tableView viewForHeaderInSection:section];
        }else{
            UIView *aView = [[UIView alloc] init];
            return aView;
        }
    }
}


#pragma mark -滚动方向判断
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dragFlag = YES;
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dragFlag = NO;
    if (!decelerate) {
        isScrolll = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    isScrolll = YES;
    _isInitTable = NO;
    if (dragFlag) {
        if (lastContentOffset < scrollView.contentOffset.y) {
            direc = ScrollUP;
        }else{
            direc = ScrollDown;
        }
    }
    
    if ([_ctrlDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_ctrlDelegate scrollViewDidScroll:scrollView];
    }
    
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    direc = ScrollDown;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    isScrolll = NO;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    isScrolll = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrolll = NO;
}

#pragma mark -delegate 统一管理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isInitTable) {
        return;
    }
    if ([_ctrlDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        isScrolll = NO;
        [_ctrlDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    if (!_ctrlDelegate) {
        DLog(@"子类需要重写 Did select row 方法！");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_ctrlDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [_ctrlDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        if (_ctrlDelegate) {
            DLog(@"子类需要重写 height for row 方法！");
        }
        return 158;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([_ctrlDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_ctrlDelegate tableView:tableView heightForHeaderInSection:section];
    }else{
        if (_ctrlDelegate) {
            DLog(@"子类需要重写 height for Header 方法！");
        }
        return CGFLOAT_MIN;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([_ctrlDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_ctrlDelegate tableView:tableView heightForFooterInSection:section];
    }else{
        if (_ctrlDelegate) {
            DLog(@"子类需要重写 height for fotter 方法！");
        }
        return 10;
    }
    
}



#pragma mark -Data Source 需要重写的都是
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DLog(@"子类需要重写该方法 cell for row");
    static NSString *IDE_cell = @"order_in_pro";
    
    XLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDE_cell];
    
    if (nil == cell) {
        cell = [[XLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDE_cell];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:(rand()%256)/255.f green:(rand()%256)/255.f blue:(rand()%256)/255.f alpha:0.7];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![_ctrlDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        DLog(@"子类需要重写该方法 num of sec");
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"子类需要重写该方法 num of row");
    return 20;
}

- (void)setIsEmpty:(BOOL)isEmpty{
    _isEmpty = isEmpty;
    if (!emptyBtn) {
        emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emptyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [emptyBtn setTitleColor:KTOPICCOLOR forState:UIControlStateNormal];
        [emptyBtn setTitle:@"没有数据" forState:UIControlStateNormal];
        [self addSubview:emptyBtn];
    }
    if (isEmpty) {
        self.frame = CGRectMake(0, 0, KSCRWIDTH, KSCRHEIGHT-64);
        emptyBtn.frame = self.frame;
        emptyBtn.hidden = NO;
        
    }else{
        emptyBtn.hidden = YES;
    }
}

@end
