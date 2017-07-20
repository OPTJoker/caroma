//
//  GetURLFileLength.h
//  KEMA
//
//  Created by 张雷 on 2017/7/13.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetURLFileLength : NSObject<NSURLConnectionDataDelegate>

/**
 *  @brief 通过网络url获得文件的大小
 */

typedef void(^FileLength)(long long length, NSError *error);

@property (nonatomic, weak) FileLength block;

/**
 *  通过url获得网络的文件的大小 返回byte
 *
 *  @param urlStr 网络url
 *
 *  return 文件的大小 byte
 */
+ (void)getUrlFileLength:(NSString *)urlStr resultBlock:(FileLength)block;

@end
