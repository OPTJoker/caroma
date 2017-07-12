//
//  TestTableViewCell.h
//  CellFly
//
//  Created by 张雷 on 16/9/8.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollUP    = 1,
    ScrollDown,
    ScrollLeft,
    ScrollRight
};

@interface XLTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isExtend;
@property (nonatomic, assign) BOOL forbidAnim;  // 禁止动画

- (void)animationForIndexPath:(NSIndexPath *)indexPath direction:(ScrollDirection)direc duration:(NSTimeInterval)dur isExtend:(BOOL)isExtend;
- (void)animationForIndexPath:(NSIndexPath *)indexPath direction:(ScrollDirection)direc duration:(NSTimeInterval)dur isExtend:(BOOL)isExtend isInit:(BOOL)init count:(NSInteger)count;

// 选中效果
- (void)setSelect;
- (void)setDeSelect;

@end
