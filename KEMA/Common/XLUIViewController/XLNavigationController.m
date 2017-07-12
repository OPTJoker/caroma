//
//  XLNavigationController.m
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLNavigationController.h"
#import "Color.h"

@interface XLNavigationController ()

@end

@implementation XLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.25f;
//    transition.type = kCATransitionFade;
//    [self.view.layer addAnimation:transition forKey:nil];
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}


#pragma mark -初始化UI
- (void)setShowShadowLine:(BOOL)showShadowLine{
    _showShadowLine = showShadowLine;
    if (_showShadowLine) {
        self.navigationBar.shadowImage = [XLNavigationController drawShadowImg:KWHITECOLOR];
        //[self.navigationBar setNeedsDisplay];
    }
}
- (void)configUI{
    
    [self.navigationBar setTintColor:KWHITECOLOR];  // 前景色
    self.navigationBar.barTintColor = KTOPICCOLOR;
    
    //UIImage *shadowimg = [self drawShadowImg:KTOPICCOLOR];
    //self.navigationBar.shadowImage = [UIImage new]; //shadowimg;
    
    //UIImage *grdimg = [self drawGradientImg];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTranslucent:NO];         // 不半透明
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:KWHITECOLOR,
                                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-bold" size:20.0f]
                                                 }];    // 标题属性

}

+ (UIImage *)drawShadowImg:(UIColor *)color{
    //创建1像素区域并开始图片绘图
    CGRect rect = CGRectMake(0, 0, 1, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    
    //创建画板并填充颜色和区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    //从画板上获取图片并关闭图片绘图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)drawGradientImg{
    //创建1像素区域并开始图片绘图
    CGRect rect = CGRectMake(0, 0, 3, 64);
    UIGraphicsBeginImageContext(rect.size);
    
    //创建画板并填充颜色和区域
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = {
        83/255.0,83/255.0,83/255.0,1.0,
        //50/255.0,50/255.0,50/255.0,1.0,
        50/255.0,50/255.0,50/255.0,1.0
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x, 64), 0);
    CGGradientRelease(gradient);
    
    
    
    //CGContextFillRect(context, rect);
    
    //从画板上获取图片并关闭图片绘图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
