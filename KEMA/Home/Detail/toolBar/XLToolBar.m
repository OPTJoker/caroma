//
//  XLToolBar.m
//  KEMA
//
//  Created by 张雷 on 2017/7/4.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "XLToolBar.h"

@interface XLToolBar ()



@end

@implementation XLToolBar

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles imgs:(NSArray *)imgs{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUIWithTitles:titles imgs:imgs];
    }
    return self;
}

- (void)loadUIWithTitles:(NSArray *)titles imgs:(NSArray *)imgs{
    CGRect frame = CGRectMake(0, 0, KSCRWIDTH, 60);
    for (short i=0; i<titles.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [item setTitle:titles[i] forState:UIControlStateNormal];
        if (i<imgs.count) {
            [item setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        }
        item.tag = 10000+i;
        [self addSubview:item];
        [item addTarget:self action:@selector(didselectItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(80, frame.size.height));
            switch (i) {
                case 0:{
                    make.right.equalTo(self.mas_centerX).multipliedBy(0.5);
                }break;
                case 1:{
                    make.centerX.equalTo(self);
                }break;
                case 2:{
                    make.left.equalTo(self.mas_centerX).multipliedBy(1.5);
                }break;
                    
                default:
                    break;
            }
        }];
    }
}

- (void)didselectItemBtn:(UIButton *)item{
    DLog(@"idx:%d",(int)item);
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)]) {
        [self.delegate didSelectItemAtIndex:item.tag-10000];
    }
}

- (void)setImgAtIdx:(short)idx withImgName:(NSString *)imgName{
    id subV = [self viewWithTag:idx+10000];
    if ([subV isKindOfClass:[UIButton class]]) {
        UIButton *item = (UIButton *)subV;
        if (item) {
            [item setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
    }
}

@end
