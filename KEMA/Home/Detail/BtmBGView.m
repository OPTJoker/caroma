//
//  BtmBGView.m
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "BtmBGView.h"

@implementation BtmBGView

//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view == nil) {
    
        for (UIView *subView in self.subviews) {
         
            CGPoint tp = [subView convertPoint:point fromView:self];
            
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

@end
