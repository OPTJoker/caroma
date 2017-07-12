//
//  UILabel+LineSpaceAndWordSpace.h
//  KEMA
//
//  Created by 张雷 on 2017/7/5.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineSpaceAndWordSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
