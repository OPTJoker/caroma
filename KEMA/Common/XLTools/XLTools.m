//
//  XLTools.m
//  iFactory
//
//  Created by 张雷 on 16/11/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLTools.h"

@implementation XLTools

+ (void)ResetBtnFrame:(UIButton *)btn Withtitle:(NSString *)title{
    CGPoint center = btn.center;
    CGSize btnSize = btn.frame.size;
    NSString *content = title;
    UIFont *font = btn.titleLabel.font;
    CGSize size = CGSizeMake(MAXFLOAT, btnSize.height);
    CGSize buttonSize = [content boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    btn.frame = CGRectMake(0, 0, buttonSize.width+10, btnSize.height);
    btn.center = center;
}

#pragma mark ## 日期类
/**
 将字符串转成NSDate类型

 @param dateString 时间字符串
 @return date类型时间
 */
+ (NSDate *)DateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


/**
 date转日期字符串

 @param date 传入date
 @param dateFmt 想要的日期字符串格式
 @return 返回字符串格式的日期
 */
+ (NSString *)StrFromDate:(NSDate *)date fmt:(NSString *)dateFmt{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (IsStrEmpty(dateFmt))  dateFmt = @"yyyy-MM-dd";
    [df setDateFormat:dateFmt];
    return [df stringFromDate:date];
}
/**
 传入今天的时间，返回明天的时间

 @param aDate 今天时间
 @return 明天时间
 */
+ (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

/**
 根据日期 得到星期几

 @param inputDate 要求星期几的日期
 @return 星期几
 */
+ (NSString*)WeekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


/**
 传入 秒  得到 xx:xx:xx

 @param totalTime 传入的秒数
 @return xx:xx:xx
 */
+(NSString *)GetMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(long)(seconds/3600)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)((seconds%3600)/60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)(seconds%60)];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}


/**
 传入 秒  得到 xx-xx-xx 格式字符串

 @param totalTime 秒数
 @param fmtStr 自定义格式 hh:MM:ss
 @return 自定义格式的时间
 */
+ (NSString *)GetMMSSFromSS:(NSString *)totalTime withFmtStr:(NSString *)fmtStr{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%ld",(long)(seconds/3600)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(long)((seconds%3600)/60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",(long)(seconds%60)];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    NSArray *timeArr = [format_time componentsSeparatedByString:@":"];
    
    if (timeArr.count==3) {
        fmtStr = [fmtStr stringByReplacingOccurrencesOfString:@"hh" withString:timeArr[0]];
        fmtStr = [fmtStr stringByReplacingOccurrencesOfString:@"MM" withString:timeArr[1]];
        fmtStr = [fmtStr stringByReplacingOccurrencesOfString:@"ss" withString:timeArr[2]];
    }
    if ([fmtStr hasPrefix:@"0h"]){
        fmtStr = [fmtStr substringFromIndex:3];
    }
    if ([fmtStr hasSuffix:@" 0s"]){
        fmtStr = [fmtStr stringByReplacingOccurrencesOfString:@" 0s" withString:@""];
    }
        
    return fmtStr;
}


#pragma mark # View类
/**
 计算字符串占用的size

 @param string 目标字符串
 @param font 字符字体
 @param width 指定宽度
 @param height 指定高度
 @return 占用size
 */
+ (CGSize)GetSizeOfString:(NSString *)string withFont:(UIFont *)font limitWidth:(CGFloat)width limitHeight:(CGFloat)height{
    NSDictionary * dict = @{NSFontAttributeName : font};
    
    if (IsStrEmpty(string)) {
        string = @"";
    }
    //计算label的文字宽高
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (UIViewController *)GetCurrentViewController:(UIView *) currentView
{
    for (UIView* next = [currentView superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



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
                                      selector:(nullable SEL)sel{
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:sel];
    btnItem.image = [UIImage imageNamed:imageName];
    
    return btnItem;
}


#pragma mark - # Control类

/**
 为一个View添加点击事件

 @param aView 目标view
 @param target target
 @param method 响应事件
 */
+ (void)addTapGestureToView:(UIView *)aView target:(nullable id)target method:(SEL)method{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:method];
    aView.userInteractionEnabled = YES;
    [aView addGestureRecognizer:tap];
}

+ (void)addReFreshGestureToView:(UIView *)aView target:(nullable)target method:(SEL)method{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:method];
    swipe.numberOfTouchesRequired = 1;
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [aView addGestureRecognizer:swipe];
}

#pragma mark # String类

/**
 字符串去白格

 @param str 目标string
 @return 无白格string
 */
+ (NSString *)RemoveSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


#pragma mark *** 算法 - 排序
/**
 字典按照key值排序
 
 @param mutArr 待排数组
 @param aKey 排序的关键字
 @param ascending 是否升序
 */
+ (void)SortMutDicArr:(NSMutableArray *)mutArr withKey:(NSString *)aKey byAscending:(BOOL)ascending{
    
    for (short i=0; i<mutArr.count; i++) {
        for (short j=0; j<mutArr.count-1-i; j++) {
            NSDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:mutArr[j]];
            id num1 = [dic1 objectForKey:aKey];
            
            NSDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:mutArr[j+1]];
            id num2 = [dic2 objectForKey:aKey];
            
            if (ascending) {
                if (num1>num2) {
                    NSDictionary *tempDic = dic1;
                    mutArr[j] = mutArr[j+1];
                    mutArr[j+1] = tempDic;
                }
            }else{
                if (num1<num2) {
                    NSDictionary *tempDic = dic1;
                    mutArr[j] = mutArr[j+1];
                    mutArr[j+1] = tempDic;
                }
            }
        }
    }
}


/**
 给字典元素数组 按照给定key值 排序

 @param anDicArr 待排字典数组
 @param aKey 排序的关键字
 @param ascending 是否升序（从小到大）
 @return 排好序的数组
 */
+ (NSArray *)SortDictionArr:(NSArray *)anDicArr withKey:(NSString *)aKey byAscending:(BOOL)ascending{
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:anDicArr];
    for (short i=0; i<mutArr.count; i++) {
        for (short j=0; j<mutArr.count-1-i; j++) {
            NSDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:mutArr[j]];
            id num1 = [dic1 objectForKey:aKey];
            
            NSDictionary *dic2 = [NSMutableDictionary dictionaryWithDictionary:mutArr[j+1]];
            id num2 = [dic2 objectForKey:aKey];
            
            if (ascending) {
                if (num1>num2) {
                    NSDictionary *tempDic = dic1;
                    mutArr[j] = mutArr[j+1];
                    mutArr[j+1] = tempDic;
                }
            }else{
                if (num1<num2) {
                    NSDictionary *tempDic = dic1;
                    mutArr[j] = mutArr[j+1];
                    mutArr[j+1] = tempDic;
                }
            }
        }
    }
    return mutArr;
}

#pragma mark #二维码
/**
 iOS8之后生成二维码

 @param content 字符串内容
 @param size 图片尺寸
 @return 二维码图片
 */
+ (UIImage *)EncodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = KColor(31, 31, 31);
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

/*
 获取Window当前显示的ViewController
 */
+ (UIViewController*)CurrentViewController{
    UIViewController* vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}


#pragma mark - 文件管理

/**
 获取或创建item包的路径

 @param catID catID
 @param itemID itemID
 @return path
 */
+(NSString *)KWebGLItemZipPathWithCatID:(NSString *)catID itemID:(NSString *)itemID{
    
    NSString *path = [[[XLTools WebGLCacheDirectory] stringByAppendingPathComponent:catID] stringByAppendingPathComponent:itemID];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        NSError *error;
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            DLog(@"Create WebGL Cache Directory Error:%@",error);
            return nil;
        }
    }
    return path;
}


/**
 获取webGL包 root地址

 @return webGL root Path
 */
+ (NSString *)WebGLCacheDirectory{
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:KWebGLCacheDirectory]){
        
        NSError *error;
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:KWebGLCacheDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            DLog(@"Create WebGL Cache Directory Error:%@",error);
            return nil;
        }
    }
    NSString *path = KWebGLCacheDirectory;
    return path;
}


+ (BOOL)ISWebGLItemZipExitByCatID:(NSString *)catID itemID:(NSString *)itemID{
    
    NSString *itemPath = [[[XLTools WebGLCacheDirectory] stringByAppendingPathComponent:catID] stringByAppendingPathComponent:itemID];
    if(![[NSFileManager defaultManager] fileExistsAtPath:itemPath]){
        return NO;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[itemPath stringByAppendingPathComponent:@"zoom.zip"]]) {
        return NO;
    }
    return YES;
}


+ (NSString *)WebGLItemPathWithCatID:(NSString *)catID itemID:(NSString *)itemID{
    
    NSString *itemPath = [[[XLTools WebGLCacheDirectory] stringByAppendingPathComponent:catID] stringByAppendingPathComponent:itemID];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:itemPath]){
        
        NSError *error;
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:itemPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            
            DLog(@"Create Item Directory Path Error:%@",error);
            
            return nil;
        }
    }
    
    return itemPath;
}

/// 删除zip包 by catID itemID
+ (BOOL)DeleteWebGLZipByCatID:(NSString *)catID itemID:(NSString *)itemID{
    
    NSString *itemPath = [[[XLTools WebGLCacheDirectory] stringByAppendingPathComponent:catID] stringByAppendingPathComponent:itemID];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:itemPath]){
        return YES;
    }
    
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtPath:itemPath error:&error]) {
        return YES;
    }else{
        DLog(@"删除[%@]失败！！！%@", [NSString stringWithFormat:@"%@%@",catID, itemID], error);
        return NO;
    }
    
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [XLTools fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


#pragma mark - BOM 问题解决方案
+ (BOOL)rewriteUTF8file:(NSString *)filePath fileName:(NSString *)fileName{
    
    NSData *fileData = [NSData dataWithContentsOfFile:[filePath stringByAppendingPathComponent:fileName]];
    
    char *buff = malloc(sizeof(char) * 3);
    [fileData getBytes:buff length:3];
    
    
    
    char bom16[3] = {0xef,0xbb,0xbf};//"\xef\xbb\xbf";
    char *p = bom16;
    char *q = buff;
    
    short cnt = 0;
    for (short i=0; i<3; i++) {
        if (*p++ == *q++) {
            cnt++;
        }
    }
    free(buff);
    
    // Match BOM fmt
    NSData *newData;
    
    if (cnt == 3) {
        DLog(@"Matched BOM!");
        newData = [fileData subdataWithRange:NSMakeRange(3, fileData.length-3)];
        NSError *rewriteErr;
        BOOL res = [newData writeToFile:[filePath stringByAppendingPathComponent:fileName] options:NSDataWritingAtomic error:&rewriteErr];
        if (res) {
            return YES;
        }else{
            DLog(@"rewrite file Err:%@",rewriteErr);
            return NO;
        }
    }else{
        DLog(@">>>Safe:No BOM");
        return YES;
    }
}
@end
