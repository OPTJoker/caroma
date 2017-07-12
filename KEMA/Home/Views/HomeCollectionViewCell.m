//
//  HomeCollectionViewCell.m
//  KEMA
//
//  Created by 张雷 on 2017/6/30.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface HomeCollectionViewCell ()


@property(nonatomic, strong) UIImageView *imgView;

@end

@interface HomeCollectionViewCell ()
{
    float x;
    float y;
}
@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (UIImageView *)imgView{
    
    if (nil == _imgView) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        _imgView.layer.masksToBounds = NO;
//        _imgView.layer.shadowColor = KLIGHTGRAYCOLOR.CGColor;
//        _imgView.layer.shadowOffset = CGSizeMake(1, 2);
//        _imgView.layer.shadowRadius = 7;
//        _imgView.layer.shadowOpacity = 0.3;
    }
    return _imgView;
}

- (void)layoutSubviews {
    
    x = (KSCRWIDTH-560*KSCALE_W/2)/2.f;
    y = 150/2.f;
    
    [super layoutSubviews];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(y);
        make.left.equalTo(self.contentView).mas_offset(x);
        make.size.mas_equalTo(CGSizeMake(560*KSCALE_W/2, 930*KSCALE_H/2));
    }];
    
}

#pragma mark - ## set方法

- (void)setImgURL:(NSString *)imgURL{
    _imgURL = imgURL;
    UIImage *placeholderImg = [UIImage imageNamed:@"imgLoadFailed.png"];
    if (!IsStrEmpty(_imgURL)) {
        if ([_imgURL hasPrefix:@"http"]) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:_imgURL] placeholderImage:placeholderImg options:SDWebImageProgressiveDownload];
        }else{
            [self.imgView setImage:placeholderImg];
        }
    }else{
        [self.imgView setImage:placeholderImg];
    }
    
}

@end
