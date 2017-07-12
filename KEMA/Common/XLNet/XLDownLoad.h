//
//  XLDownLoad.h
//  KEMA
//
//  Created by 张雷 on 2017/7/6.
//  Copyright © 2017年 Allen. All rights reserved.
//

#define KDownloadUrlKey @"DownloadUrlString"
#define KDownloadTaskKey @"DownloadTask"

#import <Foundation/Foundation.h>

#import <AFURLSessionManager.h>

@interface XLDownLoad : NSObject

typedef void (^DownloadProBlock)(double progress);
typedef void (^DownloadFinishBlock)(NSError *error);
+ (void)downloadURL:(NSString *)urlStr destPath:(NSString *)destPath progress:(DownloadProBlock)progressBlock finish:(DownloadFinishBlock)finishBlock;


/**
 单利
 @return xldownload
 */
+ (instancetype)ShareInstance;

/// 下载进度数据条
@property(nonatomic, strong) NSMutableDictionary *loadProgressDic;

/// 下载中任务管理
+ (void)clearAllCache;
+(void)AddUnFinishedLoadTask:(NSURLSessionDownloadTask *)task withUrlStr:(NSString *)urlStr;
+ (void)removeUnFinishedLoadTaskForKey:(NSString *)urlStr;
+ (NSMutableDictionary *)unFinishedLoadTaskList;

+ (void)removeLoadProgressFotKey:(NSString *)urlStr;
+ (void)setProgress:(double)progress forKey:(NSString *)urlStr;
@end
