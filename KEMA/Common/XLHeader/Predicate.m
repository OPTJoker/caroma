//
//  Predicate.m
//  iUnis
//
//  Created by 张雷 on 16/10/10.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "Predicate.h"

@implementation Predicate

+ (BOOL) ValidateIFactoryNo:(NSString *)No
{
    NSString *phoneRegex = @"^\\d{7,9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:No];
}

+ (BOOL) ValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+(BOOL)ValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
