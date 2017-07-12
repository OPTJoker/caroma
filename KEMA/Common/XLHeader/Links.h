//
//  Links.h
//  iUnis
//
//  Created by 张雷 on 16/10/9.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "NotificationNames.h"
#import <UIKit/UIKit.h>

#ifndef Links_h
#define Links_h


#endif /* Links_h */

///////////////////////////////////////////////////////////////////////
///////////                    主机头配置                    ///////////
///////////////////////////////////////////////////////////////////////

static NSString *placeholderImgNameKey = @"imgLoadFailed";

static NSString *KSERVER    = @"http://shell.weshape3d.com/";   //UI及相关配置文件主机头

static NSString *KWEBGLSERVER    = @"http://cdn.weshape3d.com/";    //WebGL包下载主机头

/// ****  设置类  **** ///
#define KLOADNWIFIWARNINGKEY @"LOADNONLYWIFIWARNING"



/// 根据配置文件 获取app名称（壳名）
#define KAPPNAME [[[[[ [NSBundle mainBundle] bundleIdentifier] componentsSeparatedByString:@"."] lastObject] lowercaseString] stringByReplacingOccurrencesOfString:@"shell" withString:@""]

/** 按照拼接路径 获取UI里面的图片 **/

/// 目录卡片图片路径拼接逻辑:
#define KCATIMGURL(CatID) [NSString stringWithFormat:@"%@%@/%@/cate.png",KSERVER,KAPPNAME,CatID] // @"%@%@/cate.png"  //%@%@: CatID
/// 卡片正面图片路径拼接逻辑:
#define KFRONTIMGURL(catID,itemID) [NSString stringWithFormat:@"%@%@/%@/%@/front.png",KSERVER,KAPPNAME,catID,itemID] //para: %@/%@ CatID/itemID
/// 卡片背面图片路径拼接逻辑:
#define KFBackIMGURL(catID,itemID) [NSString stringWithFormat:@"%@%@/%@/%@/back.png",KSERVER,KAPPNAME,catID,itemID]  //para: %@/%@ CatID/itemID

/// JSON路径
#define KJSONURL [NSString stringWithFormat:@"%@%@/package.json",KSERVER,KAPPNAME]

/// WEBGL路径
#define KWEBGLURL(path) [NSString stringWithFormat:@"%@%@",KWEBGLSERVER,path]

// 分享icon路径
#define KSHAREICONURL(catID, itemID) [NSString stringWithFormat:@"%@%@/%@/%@/weixin.png",KSERVER,KAPPNAME,catID,itemID]

#define webPath [[NSBundle mainBundle] pathForResource:@"Web" ofType:nil]
#define KTEMPDIR NSTemporaryDirectory()

#define KLOCALWEBDIR [KTEMPDIR stringByAppendingPathComponent:@"localhost"]     // 解压zip文件 Local web path
#define K3DWEBPath @"http://localhost:%@/index.html"

// 包名命名规则为: com.weshape3d.[壳名]shell 壳名 = app名


///////////////////////////////////////////////////////////////////////
///////////                    消息 队列                     ///////////
///////////////////////////////////////////////////////////////////////
