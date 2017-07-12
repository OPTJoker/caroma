//
//  XLToolBar.h
//  KEMA
//
//  Created by 张雷 on 2017/7/4.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol Delegate <NSObject>
@required
- (void)didSelectItemAtIndex:(short)idx;

@end

@interface XLToolBar : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgs:(NSArray *)imgs;

@property(nonatomic, assign) id<Delegate> delegate;

- (void)setImgAtIdx:(short)idx withImgName:(NSString *)imgName;

@end
