//
//  PlayButton.h
//  KEMA
//
//  Created by 张雷 on 2017/7/5.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadStateManager.h"

@interface PlayButton : UIButton

@property(nonatomic, assign) LoadState loadState;

@property(nonatomic, assign) CGFloat progress;

- (void)setLoadState:(LoadState)loadState;
- (void)setLoadState:(LoadState)loadState progress:(double)pro;

@end
