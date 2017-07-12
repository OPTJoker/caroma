//
//  XLDownLoad.m
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "XLDownLoad.h"
#import "AppDelegate.h"
#import "LoadStateManager.h"

@interface XLDownLoad ()

@property(nonatomic, strong) NSMutableDictionary *unFinishedLoadTaskList;

@end

@implementation XLDownLoad



static XLDownLoad *xlDownload = nil;
/**
 单利
 @return xldownload
 */
+ (instancetype)ShareInstance{
    
    @synchronized(self){
        if (nil == xlDownload) {
            xlDownload = [[super allocWithZone:nil] init]; // 避免死循环
        }
    }
    return xlDownload;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [XLDownLoad ShareInstance];
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

#pragma mark - 下载任务管理
- (NSMutableDictionary *)unFinishedLoadTaskList{
    if (nil == _unFinishedLoadTaskList) {
        _unFinishedLoadTaskList = [NSMutableDictionary new];
    }
    return _unFinishedLoadTaskList;
}


+ (NSMutableDictionary *)unFinishedLoadTaskList{
    return [[XLDownLoad ShareInstance] unFinishedLoadTaskList];
}


+(void)AddUnFinishedLoadTask:(NSURLSessionDownloadTask *)task withUrlStr:(NSString *)urlStr{
    
    if (!IsStrEmpty(urlStr)) {
        [[XLDownLoad unFinishedLoadTaskList] setObject:task forKey:urlStr];
    }
}

+ (void)removeUnFinishedLoadTaskForKey:(NSString *)urlStr{
    [[XLDownLoad unFinishedLoadTaskList] removeObjectForKey:urlStr];
}

+ (void)clearAllCache{
    [[[XLDownLoad ShareInstance] loadProgressDic] removeAllObjects];
    [[[XLDownLoad ShareInstance] unFinishedLoadTaskList] removeAllObjects];
    [LoadStateManager clearAllCache];
}

- (NSMutableDictionary *)loadProgressDic{
    if (nil == _loadProgressDic) {
        _loadProgressDic = [NSMutableDictionary new];
    }
    return _loadProgressDic;
}

+ (void)removeLoadProgressFotKey:(NSString *)urlStr{
    [[[XLDownLoad ShareInstance] loadProgressDic] removeObjectForKey:urlStr];
}

+ (void)setProgress:(double)progress forKey:(NSString *)urlStr{
    [[[XLDownLoad ShareInstance] loadProgressDic] setObject:[NSNumber numberWithDouble:progress] forKey:urlStr];
}

#pragma mark - 下载操作
+ (void)downloadURL:(NSString *)urlStr destPath:(NSString *)destPath progress:(DownloadProBlock)progressBlock finish:(DownloadFinishBlock)finishBlock{
    
    DLog(@"destPath%@",destPath);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        double pro = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        
        progressBlock(pro);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //下载到哪个文件夹
        // response.suggestedFilename 文件名
        NSString *fileName=[destPath stringByAppendingPathComponent:@"zoom.zip"];
        
        return [NSURL fileURLWithPath:fileName];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //NSLog(@"File downloaded to: %@", filePath);
        
        finishBlock(error);
        [XLDownLoad removeUnFinishedLoadTaskForKey:urlStr];
        
    }];
    
    [XLDownLoad AddUnFinishedLoadTask:downloadTask withUrlStr:urlStr];
    [downloadTask resume];
    
}


@end
