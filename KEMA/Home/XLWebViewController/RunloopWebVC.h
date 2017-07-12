//
//  RunloopWebVC.h
//  iFactory
//
//  Created by 张雷 on 2017/5/31.
//  Copyright © 2017年 ImanZhang. All rights reserved.
//

#define KLOCALHTTP @"http://localhost:"

#import "XLUIViewController.h"

@interface RunloopWebVC : XLUIViewController

@property(nonatomic, copy) NSString *webUrl;

- (void)playWithCatID:(NSString *)catID itemID:(NSString *)itemID;


@end
