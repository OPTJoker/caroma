//
//  ShareView.m
//  ZOOM
//
//  Created by WeShape_Design01 on 16/6/7.
//  Copyright © 2016年 Weshape3D. All rights reserved.
//

#import "ShareView.h"
#import "XLRequest.h"
#import "SVProgressHUD.h"

@implementation ShareView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [_weiboBtn addTarget:self action:@selector(weiboBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_weChatBtn addTarget:self action:@selector(wechatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_momentsBtn addTarget:self action:@selector(momentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancleBtnClicked:(UIButton *)sender{
    if ([_cancleShareDelegate respondsToSelector:@selector(cancleShared)]){
        [_cancleShareDelegate cancleShared];
    }
}

- (void)setHidden:(BOOL)hidden{
    if (!hidden) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenSharedSuccessOrCancle) name:KNOT_SHAREDSUCCESSKEY object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOT_SHAREDSUCCESSKEY object:nil];
    }
}

- (void)listenSharedSuccessOrCancle{
    if ([self.cancleShareDelegate respondsToSelector:@selector(cancleShared)]) {
        [self.cancleShareDelegate cancleShared];
    }
}

- (void)weiboBtnClicked:(UIButton *)sender{
    [SVProgressHUD showInfoWithStatus:@"暂未开启微博分享"];
}
- (void)wechatBtnClicked:(UIButton *)sender{
    [XLRequest shareWithShareModel:_model source:2];
    //[SVProgressHUD showInfoWithStatus:@"分享到微信好友"];
}
- (void)momentBtnClicked:(UIButton *)sender{
    [XLRequest shareWithShareModel:_model source:3];
    //[SVProgressHUD showInfoWithStatus:@"分享到微信朋友圈"];
}

@end
