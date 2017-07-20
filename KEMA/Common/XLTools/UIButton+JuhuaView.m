//
//  UIButton+JuhuaView.m
//  KEMA
//
//  Created by 张雷 on 2017/7/18.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "UIButton+JuhuaView.h"

#import <objc/runtime.h>
static char activityViewKey;

@implementation UIButton (JuhuaView)



- (void)appendActivityView:(UIColor *)color{
    //1.添加菊花
    if (!self.appendActivity) {
        self.userInteractionEnabled = NO;
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        CGRect f = self.bounds;
        CGSize s = f.size;
        s.width = s.width*0.5;
        s.height = s.height*0.5;
        f.size = s;
        activityIndicator.frame = f;
        
        activityIndicator.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f);
        activityIndicator.color = color;
        [activityIndicator startAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        
        self.appendActivity = activityIndicator;
        
        // 1.隐藏其它子视图
        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
        
        [self addSubview:activityIndicator];
        [self layoutIfNeeded];
    }
    
    [self bringSubviewToFront:self.appendActivity];
    
}

- (void)removeActivityView{
    
    //2.去掉菊花
    if (self.appendActivity) {
        [self.appendActivity stopAnimating]; // 结束旋转
        self.appendActivity.hidden = YES;
        [self.appendActivity removeFromSuperview];
        self.appendActivity = nil;
        
        // 1.恢复显示
        for (UIView *view in self.subviews) {
            view.hidden = NO;
        }
        
        // 2.开启交互
        self.userInteractionEnabled = YES;
    }
}


#pragma mark - 运行时添加属性
- (UIActivityIndicatorView *)appendActivity{
    return objc_getAssociatedObject(self, &activityViewKey);
}

- (void)setAppendActivity:(UIActivityIndicatorView *)appendActivity{
    objc_setAssociatedObject(self, &activityViewKey, appendActivity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
