//
//  ShareModel.h
//  KEMA
//
//  Created by 张雷 on 2017/7/9.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *shareDescription;
@property(nonatomic, copy) NSString *webpageUrl;

@property (nonatomic,copy) NSString *shareIconUrl; // 分享图片

@end
