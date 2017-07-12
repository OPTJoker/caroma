//
//  Control.h
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#ifndef Control_h
#define Control_h

#endif /* Control_h */

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define DDLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#else
#define DLog( s, ... )
#endif

#define KSCRWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCRHEIGHT [UIScreen mainScreen].bounds.size.height
#define KSCALE_W (([UIScreen mainScreen].bounds.size.width)/375.0)
#define KSCALE_H (([UIScreen mainScreen].bounds.size.height)/667.0)

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
//#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
#define IsStrEmpty(_ref)    !([_ref isKindOfClass:[NSString class]] && _ref.length>0)
//数组是否为空
//#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
#define IsArrEmpty(_ref)    !([_ref isKindOfClass:[NSArray class]] && _ref.count>0)

#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]
#define FmtStr(str) [NSString stringWithFormat:@"%@", str]

// 版本判断
#define iOS8_OR_LATER [[UIDevice currentDevice].systemVersion floatValue]>=8.f
#define iOS9_OR_LATER [[UIDevice currentDevice].systemVersion floatValue]>=9.f


// NSUserdefaults


///     *********   文件管理    ********
/// 未完成下载任务 要清除旧文件  很重要！ 也就是下载中的任务
#define KUnFinishedLoadTaskListKey @"UnFinishedLoadTaskList"


/// 文件目录
/// Library/Caches
#define KLibraryCache NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define KWebGLCacheDirectory [NSString stringWithFormat:@"%@/WebGLCacheDirectory/",KLibraryCache]
