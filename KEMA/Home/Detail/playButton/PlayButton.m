//
//  PlayButton.m
//  KEMA
//
//  Created by 张雷 on 2017/7/5.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "PlayButton.h"

@interface PlayButton ()
{
    CGFloat diameter;
}
@property(nonatomic, strong) CAShapeLayer *progressLayer;
@end

@implementation PlayButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    
    PlayButton *playBtn = [super buttonWithType:buttonType];
    playBtn->diameter = 60;
    playBtn.tag = 911;
    
    [playBtn setTitleColor:KTOPICCOLOR forState:UIControlStateNormal];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    return playBtn;
}

- (CAShapeLayer *)progressLayer{
    if (nil == _progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_progressLayer];
    }
    return _progressLayer;
}

#pragma mark - 下载进度UI和逻辑
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    BOOL finished = NO;
    if (_progress<0.f) {
        _progress = 0.f;
        DLog(@">>>>卧槽！下载进度 <0 了！！");
    }else if(_progress > 1.f){
        _progress = 1.0;
        finished = YES;
        DLog(@">>>>卧槽！下载进度 >1 了！！");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCircleProgress:_progress lineWidth:4 strokeColor:KBLUEMILKCOLOR finished:finished];
    });
}

- (void)setCircleProgress:(CGFloat)progress lineWidth:(CGFloat)width strokeColor:(UIColor *)color finished:(BOOL)finished{
    
    if (finished) {
        self.progressLayer.lineWidth = 0;
        self.progressLayer.strokeColor = KCLEARCOLOR.CGColor;
        self.progressLayer.hidden = YES;
        [self setProgress:0.0]; // 下载完进度条老是不消失，各种移除 隐藏和nil都不管用。 就这个管用。
    }
    
    self.progressLayer.hidden = NO;
    
    CGFloat begAng = -M_PI_2;
    CGFloat endAng = 2*M_PI*progress + begAng;

    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(diameter/2.f, diameter/2.f) radius:(diameter-width)/2.f startAngle:begAng endAngle:endAng clockwise:YES];
    
    self.progressLayer.path = bezier.CGPath;
    
    self.progressLayer.lineWidth = width;
    self.progressLayer.strokeColor = color.CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    
}

- (void)didFinishLoad{
    [self setCircleProgress:0 lineWidth:0 strokeColor:KWHITECOLOR finished:YES];
}

#pragma mark - 下载-状态 set
- (void)setLoadState:(LoadState)loadState{
    [self setLoadState:loadState progress:0.0];
}

- (void)setLoadState:(LoadState)loadState progress:(double)pro{
    
    short lastState = _loadState;
    _loadState = loadState;
    
    if (_loadState == UnLoad) {
        [self setImageWithName:@"UnLoad"];
        [self setCircleProgress:0. lineWidth:0 strokeColor:KCLEARCOLOR finished:YES];
        
    }else if (_loadState == ReLoad){
        [self setImageWithName:@"ReLoad"];
        [self setCircleProgress:0. lineWidth:0 strokeColor:KCLEARCOLOR finished:YES];
        
    }else if (_loadState == Loading){
        if (lastState != _loadState) {
            [self setContentEdgeInsets:UIEdgeInsetsZero];
            UIImage *loadingImg = [UIImage imageNamed:@"Loading"];
            [self setContentEdgeInsets:UIEdgeInsetsZero];
            [self setImageEdgeInsets:UIEdgeInsetsMake(5, 30-loadingImg.size.width/2., 10, 30-loadingImg.size.width/2.)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(loadingImg.size.height+5+5, -loadingImg.size.width, 0, 0)];
            [self setImage:loadingImg forState:UIControlStateNormal];
        }
        [self setTitle:[NSString stringWithFormat:@"%.2f%%",pro*100.] forState:UIControlStateNormal];
    }else if (_loadState == Loaded){
        [self setImageWithName:@"play.png"];
        [self didFinishLoad];
    }
    
    if (_loadState!=Loading) {
        [self setContentEdgeInsets:UIEdgeInsetsZero];
        [self setTitleEdgeInsets:UIEdgeInsetsZero];
        [self setImageEdgeInsets:UIEdgeInsetsZero];
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)setImageWithName:(NSString *)imgName{
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
@end
