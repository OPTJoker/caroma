//
//  UIButton+JuhuaView.h
//  KEMA
//
//  Created by 张雷 on 2017/7/18.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JuhuaView)

- (void)appendActivityView:(UIColor *)color;
- (void)removeActivityView;
@property (nonatomic,strong) UIActivityIndicatorView *appendActivity;/**< 附加菊花图 */

@end
