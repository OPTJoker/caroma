//
//  ShareView.h
//  ZOOM
//
//  Created by WeShape_Design01 on 16/6/7.
//  Copyright © 2016年 Weshape3D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@protocol CancleShareDelegate<NSObject>
- (void)cancleShared;//:(UIButton *)sender;
@end


@interface ShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;

@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;

@property (weak, nonatomic) IBOutlet UIButton *momentsBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (nonatomic,copy) NSString *shareURL;
@property (nonatomic,assign) short source;

@property (assign,nonatomic) id<CancleShareDelegate> cancleShareDelegate;

@property(nonatomic, strong) ShareModel *model;

@end
