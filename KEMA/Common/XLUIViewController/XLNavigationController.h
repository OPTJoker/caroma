//
//  XLNavigationController.h
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLNavigationController : UINavigationController

@property (nonatomic, assign) BOOL showShadowLine;

+ (UIImage *)drawShadowImg:(UIColor *)color;

@end
