//
//  XLRequest.h
//  iUnis
//
//  Created by 张雷 on 16/10/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <AFNetworking.h>
#import "Control.h"
#import "Links.h"
#import "ShareModel.h"

typedef void(^AFNSucBlock)(id sucData);
typedef void(^AFNFaiBlock)(NSError *errData);

@interface XLRequest : NSObject



/**
 GET data
 
 @param URLStr   GET 请求链接
 @param para     GET 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)GET:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock;

/**
 POST data
 
 @param URLStr   POST 请求链接
 @param para     POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr para:(NSDictionary *)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock;

/**
 POST 参数为ID类型的para
 
 @param URLStr POST 请求链接
 @param para POST 参数
 @param sucBlock 成功回调
 @param faiBlock 失败回调
 */
+(void)POST:(NSString *)URLStr IDPara:(id)para success:(AFNSucBlock)sucBlock failure:(AFNFaiBlock)faiBlock;

/**
 解析数据 (analyze)
 
 @param responsObject 带解析的数据
 
 @return 返回一定是字典格式
 */
+ (NSDictionary *)analyze:(id)responsObject;

typedef void (^UPDateUpLoadProgressBlock)(CGFloat progress);
/**
 AF3.0 POST小文件到服务器
 
 @param filePath 本地文件地址
 @param name 文件名
 @param fileName 带后缀的文件全名
 @param mimeType 文件类型
 @param URLStr 要上传的服务器地址
 */
+(void)UPLoadFile:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType toURLStr:(NSString *)URLStr updateUploadProgress:(UPDateUpLoadProgressBlock)uploadBlock;

/**
 上传单或多张图片(form表单直接add方式)
 
 @param URLStr UrlStr
 @param imageArr 图片数组
 @param completionBlock 回调
 @return task
 */
+ (NSURLSessionUploadTask*)UPLoadTaskToURL:(NSString *)URLStr para:(NSDictionary *)para WithImageArr:(NSArray<UIImage*>*)imageArr completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock;
/**
 上传多张图片（方式：异步调用单张API上传）
 
 @param imageArr 图片数组
 @param URLStr 上传地址
 @param errBlock 单张失败回调
 @param sucBlock 单张成功回调
 @param allCompleteion 所有上传完成处理
 */
+ (void)UPLoadImgs:(NSArray<UIImage *>* const)imageArr toURLStr:(NSString *)URLStr para:(NSDictionary *)para errBlock:(void (^)(NSError *err, NSInteger idx))errBlock sucBlock:(void (^)(id responseObj, NSInteger idx))sucBlock allCompletion:(void (^)(NSArray *result))allCompleteion;


/**
 取消网络请求
 
 @param URLStr 要取消的请求链接URLStr
 */
+ (void)cancleRequest:(NSString *)URLStr;

/**
 网络请求失败的统一处理
 
 @param errData 错误信息
 */
+(void)dataRequestFailure:(NSError *)errData inView:(UIView *)aView;

/**
 格式错误
 
 @param obj 数据
 @param v 要取消HUD的view
 */
+ (void)fmtErr:(NSObject *)obj aView:(UIView *)v;

#pragma mark - 分享
+ (void)shareWithShareModel:(ShareModel *)model source:(short)target;

@end
