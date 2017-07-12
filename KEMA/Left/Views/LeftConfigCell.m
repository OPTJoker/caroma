//
//  LeftConfigCell.m
//  KEMA
//
//  Created by 张雷 on 2017/7/5.
//  Copyright © 2017年 Allen. All rights reserved.
//

#import "LeftConfigCell.h"

@interface LeftConfigCell ()

@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIImageView *iconV;

@end

@implementation LeftConfigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *bgV = [UIView new];
        bgV.backgroundColor = KGRAY(70);
        self.selectedBackgroundView = bgV;
    }
    return self;
}

- (UILabel *)titleLab{
    if (nil == _titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _titleLab.textColor = KWHITECOLOR;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconV.mas_right).mas_offset(8);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLab;
}

- (UIImageView *)iconV{
    if (nil == _iconV) {
        _iconV = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconV];
        _iconV.contentMode = UIViewContentModeCenter;
        [_iconV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(72/2);
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(self.contentView);
        }];
    }
    
    return _iconV;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = _title;
}

- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self.iconV setImage:[UIImage imageNamed:_imgName]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
