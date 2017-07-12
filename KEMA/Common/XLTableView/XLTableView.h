//
//  XLTableView.h
//  iUnis
//
//  Created by 张雷 on 16/9/9.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CYLTableViewPlaceHolder.h>
#import "XLTableViewCell.h"
#import "Header.h"

@protocol CtrlDelegate<NSObject>
@required
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@protocol RefreshDelegate <NSObject>

@required
- (void)xl_refreshing;

@end

@protocol LoadMoreDelegate <NSObject>

@required
- (void)xl_loadMoreData;

@end

@interface XLTableView : UITableView
<
UITableViewDelegate,
UITableViewDataSource
>

/*
 有些子类需要实现 |展开-折叠 效果|
 所以需要在VC控制器创建一个防复用导致cell.idExtend失效的数组
 来保存cell当前的状态
 */
@property (nonatomic, strong) NSMutableArray *extentFlagArr;

@property (assign) id<CtrlDelegate>ctrlDelegate;
@property (assign, nonatomic) id<RefreshDelegate>refreshDelegate;
@property (assign, nonatomic) id<LoadMoreDelegate>loadMoreDelegate;

// 控制初始化动画的标记
@property (assign) BOOL isInitTable;


@property (nonatomic, assign) BOOL isEmpty;
- (void)xl_endRefreshing;
- (void)xl_firstLoadData;
- (void)xl_header_endRefresh;
@end
