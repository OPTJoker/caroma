//
//  LoadStateManager.h
//  KEMA
//
//  Created by 张雷 on 2017/7/7.
//  Copyright © 2017年 Allen. All rights reserved.
//

typedef NS_ENUM(short, LoadState) {
    UnLoad = 1,
    ReLoad,
    Loading,
    Loaded
};

#import <Foundation/Foundation.h>
#import "PlayButton.h"


@interface LoadStateManager : NSObject

+ (void)setStateForCatID:(NSString *)catID itemID:(NSString *)itemID urlStrKey:(NSString *)urlStr state:(LoadState)state;
+ (LoadState)getStateForCatID:(NSString *)catID itemID:(NSString *)itemID;

+ (void)clearAllCache;
@end
