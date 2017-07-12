//
//  XLDebug.m
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "XLDebug.h"

@implementation XLDebug

static XLDebug *intance = nil;
/**
 单利
 @return xldownload
 */
+ (instancetype)ShareInstance{
    
    @synchronized(self){
        if (nil == intance) {
            intance = [[super allocWithZone:nil] init]; // 避免死循环
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:intance action:@selector(tap:)];
            tap.numberOfTouchesRequired = 2;
            [[UIApplication sharedApplication].delegate.window addGestureRecognizer:tap];
        }
    }
    return intance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [XLDebug ShareInstance];
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    [XLDebug LogWebGLCachePath];
}

+ (void)Debug{
    [XLDebug ShareInstance];
}

+ (void)LogWebGLCachePath{
    DLog(@"WebCachePath:%@",KWebGLCacheDirectory);
}

@end
