//
//  LoadStateManager.m
//  KEMA
//
//  Created by 张雷 on 2017/7/7.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "LoadStateManager.h"
#import "XLDownLoad.h"

@interface LoadStateManager ()
@property(nonatomic, strong) NSMutableDictionary *loadManagerDic;

@property(nonatomic, strong) NSMutableDictionary *fileSizeDic;
@end

@implementation LoadStateManager


#pragma mark - 懒加载
- (NSMutableDictionary *)loadManagerDic{
    if (nil == _loadManagerDic) {
        _loadManagerDic = [NSMutableDictionary new];
    }
    return _loadManagerDic;
}
- (NSMutableDictionary *)fileSizeDic{
    if (nil == _fileSizeDic) {
        _fileSizeDic = [NSMutableDictionary new];
    }
    return _fileSizeDic;
}
#pragma mark - 单利
static LoadStateManager *instance = nil;
/**
 单利
 @return xldownload
 */
+ (instancetype)ShareInstance{
    
    @synchronized(self){
        if (nil == instance) {
            instance = [[super allocWithZone:nil] init]; // 避免死循环
            [instance.loadManagerDic removeAllObjects];
            [instance.fileSizeDic removeAllObjects];
        }
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [LoadStateManager ShareInstance];
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

#pragma mark - 方法集合
+ (void)setStateForCatID:(NSString *)catID itemID:(NSString *)itemID urlStrKey:(NSString *)urlStr state:(LoadState)state{
    NSDictionary *dic = @{@"urlStr":urlStr,
                          @"catID":catID,
                          @"itemID":itemID,
                          @"state":[NSNumber numberWithShort:state]
                          };
    NSString *key = [NSString stringWithFormat:@"%@/%@",catID,itemID];
    
    [[LoadStateManager ShareInstance].loadManagerDic setObject:dic forKey:key];
    
    
    if (state == Loaded || state == UnLoad || state == ReLoad) {
        // 内存记录移除
        [XLDownLoad removeLoadProgressFotKey:urlStr];
        [XLDownLoad removeUnFinishedLoadTaskForKey:urlStr];
        
        if (state == ReLoad) {
            /// 下载失败！要删除包
            [XLTools DeleteWebGLZipByCatID:catID itemID:itemID];
        }
    }
}

+ (LoadState)getStateForCatID:(NSString *)catID itemID:(NSString *)itemID{
    if ([XLTools ISWebGLItemZipExitByCatID:catID itemID:itemID]) {
        return Loaded;
    }else{
        NSString *key = [NSString stringWithFormat:@"%@/%@",catID,itemID];
        NSDictionary *dic = [[LoadStateManager ShareInstance].loadManagerDic objectForKey:key];
        if (dic) {
            NSNumber *state = [dic objectForKey:@"state"];
            return [state shortValue];
        }else{
            return UnLoad;
        }
    }
}

+ (void)clearAllCache{
    for (NSString *key in [[[LoadStateManager ShareInstance] loadManagerDic] allKeys]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[[LoadStateManager ShareInstance] loadManagerDic] objectForKey:key]];
        [dic setObject:[NSNumber numberWithShort:UnLoad] forKey:@"state"];
        [[[LoadStateManager ShareInstance] loadManagerDic] setObject:dic forKey:key];
    }
}

+ (void)setFileSize:(CGFloat)size ForCatID:(NSString *)catID itemID:(NSString *)itemID{
    NSString *key = [NSString stringWithFormat:@"%@/%@",catID,itemID];
    [[[LoadStateManager ShareInstance] fileSizeDic] setObject:[NSNumber numberWithDouble:size] forKey:key];
}
+ (CGFloat)getFileSizeWithCatID:(NSString *)catID itemID:(NSString *)itemID{
    NSString *key = [NSString stringWithFormat:@"%@/%@",catID,itemID];
    NSNumber *num = [[[LoadStateManager ShareInstance] fileSizeDic] objectForKey:key];
    if ([num isKindOfClass:[NSNumber class]]) {
        return [num doubleValue];
    }else{
        return 0.f;
    }
    
    
}


@end
