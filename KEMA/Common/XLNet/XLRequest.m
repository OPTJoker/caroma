//
//  XLRequest.m
//  iUnis
//
//  Created by 张雷 on 16/10/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLRequest.h"
#import "AppDelegate.h"
#import <SVProgressHUD.h>
#import <WXApi.h>

float   imageSize = 50*1024;    //50K

static float timeout = 9;  // 其实多一秒
@interface XLRequest(){
}

/**
 *  管理网络请求URL的数组 用于取消请求
 @  数组里存的是字典key:URL val:manager
 */
@property (nonatomic, strong)NSMutableDictionary *taskDic;

@end

@implementation XLRequest

static XLRequest *xlRequest = nil;

/**
 单利
 @return XLRquest
 */
+ (instancetype)ShareXLRquest{
    @synchronized(self){
        if (nil == xlRequest) {
            xlRequest = [[super allocWithZone:nil] init]; // 避免死循环
            xlRequest.taskDic = [NSMutableDictionary new];
        }
    }
    return xlRequest;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [XLRequest ShareXLRquest];
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


////////////////////////////////////////////////////////////////////////
////                    封装AF request 方法们                         ////
////////////////////////////////////////////////////////////////////////



/**
 GET data

 @param URLStr   GET 请求链接
 @param para     GET 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)GET:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock{
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:timeout];
    
    //[[XLRequest ShareXLRquest] addHeaderFromAppdToManager:manager];
    
    // DLog(@"managers:%@",[XLRequest ShareXLRquest].requestManagers);
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [manager GET:enURLStr parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //DLog(@"URL:\n%@",URLStr);
        sucBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSInteger errCode = error.code;
        DLog(@"NetErrCode:%ld",(long)errCode);
        
        faiBlock(error);
        
    }];
    // 添加进请求管理数组里
    [[XLRequest ShareXLRquest].taskDic setObject:task forKey:URLStr];
}


/**
 POST 普通post方法
 
 @param URLStr   POST 请求链接
 @param para     POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock{
    //DLog(@"\nURL: %@\nlog para:%@",URLStr,para);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:timeout];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/octet-stream"];
    
    //[[XLRequest ShareXLRquest] addHeaderFromAppdToManager:manager];
    
    // DLog(@"managers:%@",[XLRequest ShareXLRquest].requestManagers);
    
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [manager POST:enURLStr parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        sucBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faiBlock(error);
        
    }];
    // 添加进请求管理数组里
    [[XLRequest ShareXLRquest].taskDic setObject:task forKey:URLStr];
    
}


/**
 POST 参数为ID类型的para
 
 @param URLStr POST 请求链接
 @param para POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr IDPara:(id)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:timeout];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //[[XLRequest ShareXLRquest] addHeaderFromAppdToManager:manager];
    
    // DLog(@"managers:%@",[XLRequest ShareXLRquest].requestManagers);
    
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [manager POST:enURLStr parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        sucBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faiBlock(error);
        
    }];
    // 添加进请求管理数组里
    [[XLRequest ShareXLRquest].taskDic setObject:task forKey:URLStr];
}

/**
 AF3.0 POST小文件到服务器

 @param filePath 本地文件地址
 @param name 文件名
 @param fileName 带后缀的文件全名
 @param mimeType 文件类型   默认传@"image/jpeg";
 @param URLStr 要上传的服务器地址
 */
+(void)UPLoadFile:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType toURLStr:(NSString *)URLStr updateUploadProgress:(UPDateUpLoadProgressBlock)uploadBlock{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *type = mimeType;
        if (![type isKindOfClass:[NSString class]]) {
            type = @"image/jpeg";
        }
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:type error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          // 更新 上传进度的 UI
                          NSString *pro = [NSString stringWithFormat:@"%.2f%%",uploadProgress.fractionCompleted*100];
                          uploadBlock([pro doubleValue]);

                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          DLog(@"Error: %@", error);
                      } else {
                          DLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
}


#pragma mark - [上传图片]
/**
 上传单张图片
 
 @param URLStr UrlStr
 @param image 图片
 @param completionBlock 回调
 @return task
 */
+ (NSURLSessionUploadTask*)UPLoadTaskToURL:(NSString *)URLStr para:(NSDictionary *)para WithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:enURLStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 图片压缩50K
        NSData *temp = UIImageJPEGRepresentation(image, 1);
        CGFloat sca = temp.length>imageSize?imageSize/temp.length : 0.5;
        
        NSData* imageData = UIImageJPEGRepresentation(image, sca);
        NSString *dtStr = [XLTools StrFromDate:[NSDate date] fmt:@"yyyy-MM-dd HH:mm:ss"];
        [formData appendPartWithFileData:imageData name:@"img" fileName:[NSString stringWithFormat:@"%@.jpg",dtStr] mimeType:@"multipart/form-data"];
        
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

/**
 上传单或多张图片

 @param URLStr UrlStr
 @param imageArr 图片数组
 @param completionBlock 回调
 @return task
 */
+ (NSURLSessionUploadTask*)UPLoadTaskToURL:(NSString *)URLStr para:(NSDictionary *)para WithImageArr:(NSArray<UIImage*>*)imageArr completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    
    NSString *uStr = [URLStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    // 这段转换很重要，否则异常编码的URL会让AF crash
    NSString *enURLStr = [uStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:enURLStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        short i=0;
        for (UIImage *img in imageArr) {
            // 图片压缩50K
            NSData *temp = UIImageJPEGRepresentation(img, 1);
            CGFloat sca = temp.length>imageSize?imageSize/temp.length : 0.5;
            NSData* imageData = UIImageJPEGRepresentation(img, sca);
            NSString *dtStr = [XLTools StrFromDate:[NSDate date] fmt:@"yyyy-MM-dd HH:mm:ss"];
            [formData appendPartWithFileData:imageData name:@"img" fileName:[NSString stringWithFormat:@"%@%d.jpg",dtStr,i++] mimeType:@"multipart/form-data"];
        }
        
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

#pragma mark - [批量上传图片]

/**
 上传多张图片（方式：异步调用单张API上传）

 @param imageArr 图片数组
 @param URLStr 上传地址
 @param errBlock 单张失败回调
 @param sucBlock 单张成功回调
 @param allCompleteion 所有上传完成处理
 */
+ (void)UPLoadImgs:(NSArray<UIImage *>* const)imageArr toURLStr:(NSString *)URLStr para:(NSDictionary *)para errBlock:(void (^)(NSError *err, NSInteger idx))errBlock sucBlock:(void (^)(id responseObj, NSInteger idx))sucBlock allCompletion:(void (^)(NSArray *result))allCompleteion{
    // 需要上传的数据
    NSArray* images = imageArr;
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (short i=0;i<images.count;i++) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [XLRequest UPLoadTaskToURL:URLStr para:para WithImage:images[i] completion:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                DLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                errBlock(error, i);
                dispatch_group_leave(group);
            } else {
                DLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    result[i] = responseObject;
                }
                sucBlock(responseObject, i);
                dispatch_group_leave(group);
            }
        }];

        [uploadTask resume];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        allCompleteion(result);
    });
}

/**
 解析数据 (analyze)

 @param responsObject 带解析的数据

 @return 返回一定是字典格式
 */
+ (NSDictionary *)analyze:(id)responsObject{
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingMutableContainers error:&err];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }else{
        DLog(@"数据非字典格式:\n%@",err);
        return nil;
    }
}


/**
 取消网络请求

 @param URLStr 要取消的请求链接URLStr
 */
+ (void)cancleRequest:(NSString *)URLStr{
    NSURLSessionDataTask *task = (NSURLSessionDataTask *)[[XLRequest ShareXLRquest].taskDic objectForKey:URLStr];
    [task cancel];
    DLog(@"URL:[%@]已取消请求",URLStr);
}


/**
 网络请求失败的统一处理

 @param errData 错误信息
 */
+(void)dataRequestFailure:(NSError *)errData inView:(UIView *)aView{
    [MBProgressHUD hideHUDForView:aView animated:NO];
    DLog(@"error：%@",errData);
    NSInteger errCode = errData.code;
    DLog(@"NetErrCode:%ld",(long)errCode);
    
    if (errCode == -1001) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"请求超时" toView:aView];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (aView) {
                [MBProgressHUD showError:@"网络请求失败" toView:aView];
            }
            
        });
    }
}


/**
 格式错误

 @param obj 数据
 @param v 要取消HUD的view
 */
+ (void)fmtErr:(NSObject *)obj aView:(UIView *)v{
    [MBProgressHUD hideHUDForView:v animated:NO];
    [MBProgressHUD showError:@"出错啦~" toView:v];
    DLog(@"fmtErr:%@",obj);
};



#pragma mark - 分享
+ (void)shareWithShareModel:(ShareModel *)model source:(short)target{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOT_SHAREDSUCCESSKEY object:nil];
    
    switch (target) {
        case 1: //weibo
        {
            //功能开发中
            break;
        }break;
        default: // wechat
        {
            if (target<0||target>3) {
                
                [SVProgressHUD showErrorWithStatus:@"sorry, 分享功能出错啦"];
                return;
            }
            if ([WXApi isWXAppInstalled]) {
                if ([WXApi isWXAppSupportApi]) {
                    WXMediaMessage *msg = [WXMediaMessage message];
                    msg.title = model.title;
                    if (model.title.length>512/2) {
                        msg.title = [[model.title substringToIndex:512/2-2] stringByAppendingString:@"…"];
                    }
                    
                    msg.description = model.shareDescription;
                    if (model.description.length>512) {
                        msg.title = [[model.title substringToIndex:512-2] stringByAppendingString:@"…"];
                    }
                    WXWebpageObject *webObject = [WXWebpageObject object];
                    webObject.webpageUrl = model.webpageUrl;
                    msg.mediaObject = webObject;
                    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                    req.bText = NO;
                    if (target == 3) {
                        req.scene = WXSceneSession;
                    }
                    if (target == 3) {
                        req.scene = WXSceneTimeline;
                    }
                    req.message = msg;
                    
                    // 请求thum图片
                    NSString *iconUrlStr = model.shareIconUrl;                    
                    
                    [XLRequest GET:iconUrlStr para:nil success:^(id sucData) {
                        msg.thumbData = sucData;
                        [WXApi sendReq:req];
                    } failure:^(NSError *errData) {
                        DLog(@"分享icon获取失败:%@",errData);
                        [WXApi sendReq:req];
                    }];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"抱歉，您的微信不支持该功能"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"抱歉，您的手机未安装微信"];
            }
        }break;
    }

}
@end
