//
//  XLTools.h
//  iFactory
//
//  Created by 张雷 on 16/11/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTools : NSObject


#pragma mark - 文件管理
+ (BOOL)rewriteUTF8file:(NSString *)filePath fileName:(NSString *)fileName;
/**
 获取webGL包 root地址
 
 @return webGL root Path
 */
+ (NSString *)WebGLCacheDirectory;

/**
 获取或创建item包的路径
 */
+(NSString *)KWebGLItemZipPathWithCatID:(NSString *)catID itemID:(NSString *)itemID;
+ (BOOL)ISWebGLItemZipExitByCatID:(NSString *)catID itemID:(NSString *)itemID;
+ (NSString *)WebGLItemPathWithCatID:(NSString *)catID itemID:(NSString *)itemID;

/// 删除zip包 by catID itemID
+ (BOOL)DeleteWebGLZipByCatID:(NSString *)catID itemID:(NSString *)itemID;
/// 统计文件夹大小 返回M
+ (float ) folderSizeAtPath:(NSString*) folderPath;
/// 统计单个文件大小 返回字节
+ (long long) fileSizeAtPath:(NSString*) filePath;
#pragma mark - # control类
/**
 为一个View添加点击事件
 
 @param aView 目标view
 @param target target
 @param method 响应事件
 */
+ (void)addTapGestureToView:(UIView *_Nullable)aView target:(nullable id)target method:(SEL _Nullable )method;
+ (void)addReFreshGestureToView:(UIView *)aView target:(nullable)target method:(SEL)method;

#pragma mark - # view 类
/**
 初始化buttonItem 给nav常用
 
 @param title title
 @param imageName iconName
 @param target target
 @param sel 方法
 @return buttonItem
 */
+ (nullable UIBarButtonItem *)setNavButtonItemWithTitle:(nullable NSString *)title
                                     imageName:(nullable NSString *)imageName
                                        target:(nullable id)target
                                      selector:(nullable SEL)sel;



+ (void)ResetBtnFrame:(nullable UIButton *)btn Withtitle:(NSString *_Nullable)title;

/**
 获取周几
 @param inputDate NSDate类型的日期
 @return 星期几
 */
+ (NSString*)WeekdayStringFromDate:(NSDate*)inputDate;


/**
 传入 秒  得到 xx:xx:xx
 
 @param totalTime 传入的秒数
 @return xx:xx:xx
 */
+(NSString *)GetMMSSFromSS:(NSString *)totalTime;
/**
 格式字符串
 
 @param totalTime 秒数
 @param fmtStr 自定义格式 hh:MM:ss
 @return 自定义格式的时间
 */
+ (NSString *)GetMMSSFromSS:(NSString *)totalTime withFmtStr:(NSString *)fmtStr;

/**
 将字符串转成NSDate类型
 
 @param dateString 时间字符串
 @return date类型时间
 */
+ (NSDate *)DateFromString:(NSString *)dateString;
/**
 date转日期字符串
 
 @param date 传入date
 @param dateFmt 想要的日期字符串格式
 @return 返回字符串格式的日期
 */
+ (NSString *)StrFromDate:(NSDate *)date fmt:(NSString *)dateFmt;

/**
 传入今天的时间，返回明天的时间
 
 @param aDate 今天时间
 @return 明天时间
 */
+ (NSString *)GetTomorrowDay:(NSDate *)aDate;

/**
 计算字符串占用的size
 
 @param string 目标字符串
 @param font 字符字体
 @param width 指定宽度
 @param height 指定高度
 @return 占用size
 */
+ (CGSize)GetSizeOfString:(NSString *)string withFont:(UIFont *)font limitWidth:(CGFloat)width limitHeight:(CGFloat)height;

/**
 字符串去白格
 
 @param str 目标string
 @return 无白格string
 */
+ (NSString *)RemoveSpaceAndNewline:(NSString *)str;

/**
 字典按照key值排序
 
 @param mutArr 待排数组
 @param aKey 排序的关键字
 @param ascending 是否升序
 */
+ (void)SortMutDicArr:(NSMutableArray *)mutArr withKey:(NSString *)aKey byAscending:(BOOL)ascending;

/**
 给字典元素数组 按照给定key值 排序
 
 @param anDicArr 待排字典数组
 @param aKey 排序的关键字
 @param ascending 是否升序（从小到大）
 @return 排好序的数组
 */
+ (NSArray *)SortDictionArr:(NSArray *)anDicArr withKey:(NSString *)aKey byAscending:(BOOL)ascending;


/**
 iOS8之后生成二维码
 
 @param content 字符串内容
 @param size 图片尺寸
 @return 二维码图片
 */
+ (UIImage *)EncodeQRImageWithContent:(NSString *)content size:(CGSize)size;

/* 
 获取Window当前显示的ViewController
 */
+ (UIViewController*)CurrentViewController;

@end
