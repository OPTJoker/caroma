//
//  GetURLFileLength.m
//  KEMA
//
//  Created by 张雷 on 2017/7/13.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "GetURLFileLength.h"

@implementation GetURLFileLength

/**
 *  通过url获得网络的文件的大小 返回byte
 *
 *  @param urlStr 网络url
 *
 *  return 文件的大小 byte
 */


+ (void)getUrlFileLength:(NSString *)urlStr resultBlock:(FileLength)block{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"HEAD"];
    
    //    request
    
    //方法参数说明
    /*
     注意：该block是在子线程中调用的，如果拿到数据之后要做一些UI刷新操作，那么需要回到主线程刷新
     第一个参数：需要发送的请求对象
     block:当请求结束拿到服务器响应的数据时调用block
     block-NSData:该请求的响应体
     block-NSURLResponse:存放本次请求的响应信息，响应头，真实类型为NSHTTPURLResponse
     block-NSErroe:请求错误信息
     */
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        
        //拿到响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        //NSInteger contentLength = [[[res allHeaderFields] objectForKey:@"Content-Length"] intValue];
        
        if (block) {
            block(res.expectedContentLength,error);
        }
        //4.解析拿到的响应数据
        //DLog(@"%@\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
        //DLog(@"%lld",response.expectedContentLength);
    }];
    
    
    //    session da
    
    //3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
}

@end
