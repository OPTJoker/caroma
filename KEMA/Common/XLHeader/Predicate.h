//
//  Predicate.h
//  iUnis
//
//  Created by 张雷 on 16/10/10.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Predicate : CAShapeLayer

/**
 匹配员工号
 
 @param No 员工号
 @return YES or NO
 */
+ (BOOL) ValidateIFactoryNo:(NSString *)No;

/**
 匹配手机号

 @param mobile 手机号码

 @return YES or NO
 */
+ (BOOL) ValidateMobile:(NSString *)mobile;

/**
 匹配邮箱

 @param email 传入的邮箱String
 
 @return YES or NO
 */
+(BOOL)ValidateEmail:(NSString *)email;


@end
